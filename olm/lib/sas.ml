open Core
open Helpers
open Helpers.ResultInfix

type t = { buf : char Ctypes.ptr
         ; sas : C.Types.SAS.t Ctypes_static.ptr
         }

let size = C.Funcs.sas_size () |> size_to_int

let clear sas = C.Funcs.clear_sas sas |> size_to_result

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.sas_last_error t.sas
    |> OlmError.of_last_error
  end

let set_their_pubkey t key =
  let key_buf, key_len = string_to_sized_buff Ctypes.void key in
  C.Funcs.sas_set_their_key t.sas key_buf key_len
  |> check_error t

let alloc () =
  let finalise = finaliser C.Types.SAS.t clear in
  let buf = allocate_buf ~finalise size in
  { buf; sas = C.Funcs.sas (Ctypes.to_voidp buf) }

let create ?other_users_pubkey () =
  let t          = alloc () in
  let random_len = C.Funcs.create_sas_random_length t.sas in
  let random_buf = Rng.void_buf (size_to_int random_len) in
  C.Funcs.create_sas t.sas random_buf random_len
  |> check_error t >>= fun r ->
  Option.value_map ~default:(Ok r) ~f:(set_their_pubkey t) other_users_pubkey
  >>| fun _ -> t

let pubkey t =
  let key_len = C.Funcs.sas_pubkey_length t.sas in
  let key_buf = allocate_bytes_void (size_to_int key_len) in
  C.Funcs.sas_get_pubkey t.sas key_buf key_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int key_len) key_buf

let other_key_set t = C.Funcs.sas_is_their_key_set t.sas > 0

let generate_bytes t extra_info length =
  if length > 0 then
    let info_buf, info_len = string_to_sized_buff Ctypes.void extra_info in
    let out_buf            = allocate_bytes_void length in
    C.Funcs.sas_generate_bytes t.sas info_buf info_len out_buf (size_of_int length)
    |> check_error t >>| fun _ ->
    string_of_ptr Ctypes.void ~length out_buf
  else Result.fail (`ValueError "The length needs to be a positive integer value.")

let calculate_mac t msg extra_info =
  let msg_buf, msg_len   = string_to_sized_buff Ctypes.void msg in
  let info_buf, info_len = string_to_sized_buff Ctypes.void extra_info in
  let mac_len  = C.Funcs.sas_mac_length t.sas in
  let mac_buf  = allocate_bytes_void (size_to_int mac_len) in
  C.Funcs.sas_calculate_mac t.sas msg_buf msg_len info_buf info_len mac_buf mac_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int mac_len) mac_buf

let calculate_mac_long_kdf t msg extra_info =
  let msg_buf, msg_len   = string_to_sized_buff Ctypes.void msg in
  let info_buf, info_len = string_to_sized_buff Ctypes.void extra_info in
  let mac_len  = C.Funcs.sas_mac_length t.sas in
  let mac_buf  = allocate_bytes_void (size_to_int mac_len) in
  C.Funcs.sas_calculate_mac_long_kdf t.sas msg_buf msg_len info_buf info_len mac_buf mac_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int mac_len) mac_buf
