open Core
open Helpers

type t = { buf : unit Ctypes.ptr
         ; sas : C.Types.SAS.t Ctypes_static.ptr
         }

let size = C.Funcs.sas_size () |> size_to_int

let clear = C.Funcs.clear_sas

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.sas_last_error t.sas
    |> string_of_nullterm_char_ptr
  end

let set_their_pubkey t key =
  let key_buf = string_to_ptr Ctypes.void key in
  let key_len = String.length key |> size_of_int in
  C.Funcs.sas_set_their_key t.sas key_buf key_len
  |> check_error t

let alloc () =
  let buf = allocate_bytes_void size in
  { buf; sas = C.Funcs.sas buf }

let create ?other_users_pubkey () =
  let t          = alloc () in
  let random_len = C.Funcs.create_sas_random_length t.sas in
  let random_buf = random_void (size_to_int random_len) in
  C.Funcs.create_sas t.sas random_buf random_len
  |> check_error t >>= fun r ->
  match other_users_pubkey with
  | None        -> Result.return r
  | Some pubkey -> set_their_pubkey t pubkey

let pubkey t =
  let key_len = C.Funcs.sas_pubkey_length t.sas in
  let key_buf = allocate_bytes_void (size_to_int key_len) in
  C.Funcs.sas_get_pubkey t.sas key_buf key_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int key_len) key_buf

let other_key_set t = C.Funcs.sas_is_their_key_set t > 0

let generate_bytes t extra_info length =
  if length < 1 then
    let info_buf = string_to_ptr Ctypes.void extra_info in
    let info_len = String.length extra_info |> size_of_int in
    let out_buf  = allocate_bytes_void length in
    C.Funcs.sas_generate_bytes t.sas info_buf info_len out_buf (size_of_int length)
    |> check_error t >>| fun _ ->
    string_of_ptr Ctypes.void ~length out_buf
  else Result.fail "The length needs to be a positive integer value."

let calculate_mac t msg extra_info =
  let msg_buf  = string_to_ptr Ctypes.void msg in
  let msg_len  = String.length msg |> size_of_int in
  let info_buf = string_to_ptr Ctypes.void extra_info in
  let info_len = String.length extra_info |> size_of_int in
  let mac_len  = C.Funcs.sas_mac_length t.sas in
  let mac_buf  = allocate_bytes_void (size_to_int mac_len) in
  C.Funcs.sas_calculate_mac t.sas msg_buf msg_len info_buf info_len mac_buf mac_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int mac_len) mac_buf
