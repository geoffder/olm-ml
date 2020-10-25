open! Core
open Helpers

module Message : sig
  type t = private PreKey of string | Message of string
  val to_size    : t -> Unsigned.size_t
  val ciphertext : t -> string
  val create     : string -> int -> (t, string) result
end = struct
  type t = PreKey of string | Message of string

  let message_type_pre_key = size_of_int 0
  let message_type_message = size_of_int 1

  let to_size = function
    | PreKey  _ -> message_type_pre_key
    | Message _ -> message_type_message

  let ciphertext = function
    | PreKey c  -> c
    | Message c -> c

  let create txt message_type_int =
    if String.length txt > 0 then
      match message_type_int with
      | 0 -> Result.return (PreKey txt)
      | 1 -> Result.return (Message txt)
      | _ -> Result.fail "Invalid message type (not size_t = 0 | 1)."
    else Result.fail "Ciphertext can't be empty."
end

type t = C.Types.Session.t Ctypes_static.ptr

let size = C.Funcs.session_size () |> size_to_int

let clear = C.Funcs.clear_session

let check_error t ret =
  size_to_result ret
  |> Result.map_error
    ~f:(fun _ -> C.Funcs.session_last_error t |> string_of_nullterm_char_ptr)

let create_inbound ?identity_key account = function
  | Message.Message _ -> Result.fail "PreKey message is required."
  | PreKey ciphertext ->
    let cipher_buf = string_to_ptr Ctypes.void ciphertext in
    let cipher_len = String.length ciphertext + 1 |> size_of_int in
    let t          = allocate_bytes_void size |> C.Funcs.session in
    begin
      match identity_key with
      | Some key when String.length key > 0 ->
        let key_buf = string_to_ptr Ctypes.void key in
        let key_len = String.length key + 1 |> size_of_int in
        C.Funcs.create_inbound_session_from t account key_buf key_len cipher_buf cipher_len
      | _ -> C.Funcs.create_inbound_session t account cipher_buf cipher_len
    end |> check_error t >>| fun _ ->
    t

let create_outbound account identity_key one_time_key =
  non_empty_string ~label:"Identity key" identity_key >>|
  string_to_ptr Ctypes.void >>= fun id_buf ->
  non_empty_string ~label:"One time key" one_time_key >>|
  string_to_ptr Ctypes.void >>= fun one_buf ->
  let t          = allocate_bytes_void size |> C.Funcs.session in
  let id_len     = String.length identity_key + 1 |> size_of_int in
  let one_len    = String.length one_time_key + 1 |> size_of_int in
  let random_len = C.Funcs.create_outbound_session_random_length t in
  let random_buf = random_void (size_to_int random_len) in
  C.Funcs.create_outbound_session t account id_buf id_len one_buf one_len random_buf random_len
  |> check_error t >>| fun _ ->
  t

(* NOTE: Bother zero-ing key array, or leave it to the GC? *)
let pickle ?(pass="") t =
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass + 1 |> size_of_int in
  let pickle_len = C.Funcs.pickle_session_length t in
  let pickle_buf = allocate_bytes_void (size_to_int pickle_len) in
  C.Funcs.pickle_session t key_buf key_len pickle_buf pickle_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

(* NOTE: Bother zero-ing key array, or leave it to the GC? *)
let from_pickle ?(pass="") pickle =
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass + 1 |> size_of_int in
  let pickle_len = String.length pickle + 1 |> size_of_int in
  non_empty_string ~label:"Pickle" pickle >>| string_to_ptr Ctypes.void >>= fun pickle_buf ->
  let t = allocate_bytes_void size |> C.Funcs.session in
  C.Funcs.unpickle_session t key_buf key_len pickle_buf pickle_len
  |> check_error t >>| fun _ ->
  t

(* NOTE: Bother zero-ing plaintext array, or leave it to the GC? *)
let encrypt t plaintext =
  let txt_buf    = string_to_ptr Ctypes.void plaintext in
  let txt_len    = String.length plaintext + 1 |> size_of_int in
  let random_len = C.Funcs.encrypt_random_length t in
  let random_buf = random_void (size_to_int random_len) in
  C.Funcs.encrypt_message_type t |> check_error t >>= fun msg_type ->
  let cipher_len = C.Funcs.encrypt_message_length t txt_len in
  let cipher_buf = allocate_bytes_void (size_to_int cipher_len) in
  C.Funcs.encrypt t txt_buf txt_len random_buf random_len cipher_buf cipher_len
  |> check_error t >>= fun _ ->
  let ciphertext = string_of_ptr Ctypes.void ~length:(size_to_int cipher_len) cipher_buf in
  Message.create ciphertext msg_type

(* NOTE: Bother zero-ing plaintext array, or leave it to the GC? *)
let decrypt t msg =
  let ciphertext    = Message.ciphertext msg in
  let msg_type      = Message.to_size msg in
  let cipher_buf () = string_to_ptr Ctypes.void ciphertext in (* max len fun destroys *)
  let cipher_len    = String.length ciphertext + 1 |> size_of_int in
  C.Funcs.decrypt_max_plaintext_length t msg_type (cipher_buf ()) cipher_len
  |> check_error t >>= fun max_txt_len ->
  let txt_buf = allocate_bytes_void max_txt_len in
  C.Funcs.decrypt t msg_type (cipher_buf ()) cipher_len txt_buf (size_of_int max_txt_len)
  |> check_error t >>| fun txt_len ->
  string_of_ptr Ctypes.void ~length:txt_len txt_buf (* TODO: to unicode? *)

let id t =
  let id_len = C.Funcs.session_id_length t in
  let id_buf = allocate_bytes_void (size_to_int id_len) in
  C.Funcs.session_id t id_buf id_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int id_len) id_buf

let matches ?identity_key t = function
  | Message.Message _ -> Result.fail "Matches can only be called on pre-key messages."
  | PreKey ciphertext ->
    let cipher_buf () = string_to_ptr Ctypes.void ciphertext in
    let cipher_len    = String.length ciphertext + 1 |> size_of_int in
    begin
      match identity_key with
      | Some key when String.length key > 0 ->
        let key_buf = string_to_ptr Ctypes.void key in
        let key_len = String.length key + 1 |> size_of_int in
        C.Funcs.matches_inbound_session_from t key_buf key_len (cipher_buf ()) cipher_len
      | _ -> C.Funcs.matches_inbound_session t (cipher_buf ()) cipher_len
    end |> check_error t >>| fun matched ->
    if matched = 0 then false else true
