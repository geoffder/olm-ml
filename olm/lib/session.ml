open Core
open Helpers
open Helpers.ResultInfix

module Message : sig
  type t = private PreKey of string | Message of string
  val ciphertext : t -> string
  val is_pre_key : t -> bool
  val to_size    : t -> Unsigned.size_t
  val to_string  : t -> string
  val create     : string -> int -> (t, [> `ValueError of string ]) result
end = struct
  type t = PreKey of string | Message of string

  let message_type_pre_key = size_of_int 0
  let message_type_message = size_of_int 1

  let ciphertext = function
    | PreKey c  -> c
    | Message c -> c

  let is_pre_key = function
    | PreKey _ -> true
    | _        -> false

  let to_size = function
    | PreKey  _ -> message_type_pre_key
    | Message _ -> message_type_message

  let to_string = function
    | PreKey c  -> sprintf "PreKey ( %s )" c
    | Message c -> sprintf "Message ( %s )" c

  let create txt message_type_int =
    if String.length txt > 0 then
      match message_type_int with
      | 0 -> Result.return (PreKey txt)
      | 1 -> Result.return (Message txt)
      | _ -> Result.fail (`ValueError "Invalid message type (not 0 or 1).")
    else Result.fail (`ValueError "Ciphertext can't be empty.")
end

type t = { buf : char Ctypes.ptr
         ; ses : C.Types.Session.t Ctypes_static.ptr
         }

let size = C.Funcs.session_size () |> size_to_int

let clear ses = C.Funcs.clear_session ses |> size_to_result

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.session_last_error t.ses
    |> OlmError.of_last_error
  end

let alloc () =
  let finalise = finaliser C.Types.Session.t clear in
  let buf = allocate_buf ~finalise size in
  { buf; ses = C.Funcs.session (Ctypes.to_voidp buf) }

let create_inbound ?identity_key (acc : Account.t) = function
  | Message.Message _ -> Result.fail (`ValueError "PreKey message is required.")
  | PreKey ciphertext ->
    let cipher_buf = string_to_ptr Ctypes.void ciphertext in
    let cipher_len = String.length ciphertext |> size_of_int in
    let t          = alloc () in
    begin
      match identity_key with
      | Some key when String.length key > 0 ->
        let key_buf = string_to_ptr Ctypes.void key in
        let key_len = String.length key |> size_of_int in
        C.Funcs.create_inbound_session_from
          t.ses      acc.acc
          key_buf    key_len
          cipher_buf cipher_len
      | _ -> C.Funcs.create_inbound_session t.ses acc.acc cipher_buf cipher_len
    end |> check_error t >>| fun _ ->
    t

let create_outbound (acc: Account.t) identity_key one_time_key =
  non_empty_string ~label:"Identity key" identity_key >>|
  string_to_sized_buff Ctypes.void >>= fun (id_buf, id_len) ->
  non_empty_string ~label:"One time key" one_time_key >>|
  string_to_sized_buff Ctypes.void >>= fun (one_buf, one_len) ->
  let t          = alloc () in
  let random_len = C.Funcs.create_outbound_session_random_length t.ses in
  let random_buf = random_void (size_to_int random_len) in
  C.Funcs.create_outbound_session
    t.ses      acc.acc
    id_buf     id_len
    one_buf    one_len
    random_buf random_len
  |> check_error t >>| fun _ ->
  t

let pickle ?(pass="") t =
  let key_buf, key_len = string_to_sized_buff Ctypes.void pass in
  let pickle_len       = C.Funcs.pickle_session_length t.ses in
  let pickle_buf       = allocate_bytes_void (size_to_int pickle_len) in
  let ret = C.Funcs.pickle_session t.ses key_buf key_len pickle_buf pickle_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr_clr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

let from_pickle ?(pass="") pickle =
  non_empty_string ~label:"Pickle" pickle >>|
  string_to_sized_buff Ctypes.void >>= fun (pickle_buf, pickle_len) ->
  let key_buf, key_len = string_to_sized_buff Ctypes.void pass in
  let t   = alloc () in
  let ret = C.Funcs.unpickle_session t.ses key_buf key_len pickle_buf pickle_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  t

let encrypt t plaintext =
  C.Funcs.encrypt_message_type t.ses |> check_error t >>= fun msg_type ->
  let txt_buf, txt_len = string_to_sized_buff Ctypes.void plaintext in
  let random_len = C.Funcs.encrypt_random_length t.ses in
  let random_buf = random_void (size_to_int random_len) in
  let cipher_len = C.Funcs.encrypt_message_length t.ses txt_len in
  let cipher_buf = allocate_bytes_void (size_to_int cipher_len) in
  let ret = C.Funcs.encrypt t.ses txt_buf txt_len random_buf random_len cipher_buf cipher_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int txt_len) txt_buf in
  check_error t ret >>= fun _ ->
  let ciphertext = string_of_ptr Ctypes.void ~length:(size_to_int cipher_len) cipher_buf in
  Message.create ciphertext msg_type

let decrypt t msg =
  let ciphertext    = Message.ciphertext msg in
  let msg_type      = Message.to_size msg in
  let cipher_buf () = string_to_ptr Ctypes.void ciphertext in (* max len fun destroys *)
  let cipher_len    = String.length ciphertext |> size_of_int in
  C.Funcs.decrypt_max_plaintext_length t.ses msg_type (cipher_buf ()) cipher_len
  |> check_error t >>= fun max_txt_len ->
  let txt_buf = allocate_bytes_void max_txt_len in
  C.Funcs.decrypt t.ses msg_type (cipher_buf ()) cipher_len txt_buf (size_of_int max_txt_len)
  |> check_error t >>| fun txt_len ->
  string_of_ptr_clr Ctypes.void ~length:txt_len txt_buf (* TODO: to unicode? *)

let id t =
  let id_len = C.Funcs.session_id_length t.ses in
  let id_buf = allocate_bytes_void (size_to_int id_len) in
  C.Funcs.session_id t.ses id_buf id_len
  |> check_error t >>| fun _ ->
  string_of_ptr_clr Ctypes.void ~length:(size_to_int id_len) id_buf

let matches ?identity_key t = function
  | Message.Message _ -> Result.fail (`ValueError "PreKey message is required.")
  | PreKey ciphertext ->
    let cipher_buf () = string_to_ptr Ctypes.void ciphertext in
    let cipher_len    = String.length ciphertext |> size_of_int in
    begin
      match identity_key with
      | Some key when String.length key > 0 ->
        let key_buf, key_len = string_to_sized_buff Ctypes.void key in
        C.Funcs.matches_inbound_session_from t.ses key_buf key_len (cipher_buf ()) cipher_len
      | _ -> C.Funcs.matches_inbound_session t.ses (cipher_buf ()) cipher_len
    end |> check_error t >>| fun matched ->
    matched > 0

(* This lives in Account in the official API example, but that would be a cyclic
 * dependency, so I have moved it here. *)
let remove_one_time_keys t (acc : Account.t) =
  C.Funcs.remove_one_time_keys acc.acc t.ses
  |> Account.check_error acc
