open Core
open Helpers

type t = { buf : unit Ctypes.ptr
         ; igs : C.Types.InboundGroupSession.t Ctypes_static.ptr
         }

let size = C.Funcs.inbound_group_session_size () |> size_to_int

let clear = C.Funcs.clear_inbound_group_session

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.inbound_group_session_last_error t.igs
    |> string_of_nullterm_char_ptr
  end

let alloc () =
  let buf = allocate_bytes_void size in
  { buf; igs = C.Funcs.inbound_group_session buf }

let create outbound_session_key =
  let t       = alloc () in
  let key_buf = string_to_ptr Ctypes.uint8_t outbound_session_key in
  let key_len = String.length outbound_session_key |> size_of_int in
  let ret = C.Funcs.init_inbound_group_session t.igs key_buf key_len in
  let ()  = zero_mem Ctypes.uint8_t ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  t

let pickle ?(pass="") t =
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass |> size_of_int in
  let pickle_len = C.Funcs.pickle_inbound_group_session_length t.igs in
  let pickle_buf = allocate_bytes_void (size_to_int pickle_len) in
  let ret = C.Funcs.pickle_inbound_group_session t.igs key_buf key_len pickle_buf pickle_len in
  let ()  = zero_mem Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

let from_pickle ?(pass="") pickle =
  non_empty_string ~label:"Pickle" pickle >>| string_to_ptr Ctypes.void >>= fun pickle_buf ->
  let pickle_len = String.length pickle |> size_of_int in
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass |> size_of_int in
  let t          = alloc () in
  let ret = C.Funcs.unpickle_inbound_group_session t.igs
      key_buf key_len
      pickle_buf pickle_len
  in
  let ()  = zero_mem Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  t

let decrypt t ciphertext =
  let cipher_buf () = string_to_ptr Ctypes.uint8_t ciphertext in (* max len destroys *)
  let cipher_len = String.length ciphertext |> size_of_int in
  C.Funcs.group_decrypt_max_plaintext_length t.igs (cipher_buf ()) cipher_len
  |> check_error t >>= fun max_txt_len ->
  let txt_buf = Ctypes.(allocate_n uint8_t ~count:max_txt_len) in
  let idx_buf = Ctypes.(allocate_n uint32_t ~count:1) in
  C.Funcs.group_decrypt t.igs
    (cipher_buf ()) cipher_len
    txt_buf         (size_of_int max_txt_len)
    idx_buf
  |> check_error t >>| fun txt_len ->
  let plaintext = string_of_ptr_clr Ctypes.uint8_t ~length:txt_len txt_buf in (* TODO: to unicode? *)
  plaintext, Ctypes.(!@ idx_buf |> Unsigned.UInt32.to_int)

let id t =
  let id_len = C.Funcs.inbound_group_session_id_length t.igs in
  let id_buf = Ctypes.(allocate_n uint8_t ~count:(size_to_int id_len)) in
  C.Funcs.inbound_group_session_id t.igs id_buf id_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.uint8_t ~length:(size_to_int id_len) id_buf

let first_known_index t =
  C.Funcs.inbound_group_session_first_known_index t.igs |> Unsigned.UInt32.to_int

let export_session t message_index =
  let expo_len = C.Funcs.export_inbound_group_session_length t.igs in
  let expo_buf = Ctypes.(allocate_n uint8_t ~count:(size_to_int expo_len)) in
  let idx      = Unsigned.UInt32.of_int message_index in
  C.Funcs.export_inbound_group_session t.igs expo_buf expo_len idx
  |> check_error t >>| fun _ -> (* python-olm ignores returned ratchet length *)
  string_of_ptr_clr Ctypes.uint8_t ~length:(size_to_int expo_len) expo_buf

let import_session exported_key =
  let t       = alloc () in
  let key_buf = string_to_ptr Ctypes.uint8_t exported_key in
  let key_len = String.length exported_key |> size_of_int in
  let ret = C.Funcs.import_inbound_group_session t.igs key_buf key_len in
  let ()  = zero_mem Ctypes.uint8_t ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  t

let is_verified t = C.Funcs.inbound_group_session_is_verified t.igs > 0
