open! Core
open Helpers
open Helpers.ResultInfix

type t = { buf : char Ctypes.ptr
         ; ogs : C.Types.OutboundGroupSession.t Ctypes_static.ptr
         }

let size = C.Funcs.outbound_group_session_size () |> size_to_int

let clear ogs = C.Funcs.clear_outbound_group_session ogs |> size_to_result

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.outbound_group_session_last_error t.ogs
    |> OlmError.of_last_error
  end

let alloc () =
  let finalise = finaliser C.Types.OutboundGroupSession.t clear in
  let buf = allocate_buf ~finalise size in
  { buf; ogs = C.Funcs.outbound_group_session (Ctypes.to_voidp buf) }

let create () =
  let t          = alloc () in
  let random_len = C.Funcs.init_outbound_group_session_random_length t.ogs in
  let random_buf = Rng.uint8_buf (size_to_int random_len) in
  C.Funcs.init_outbound_group_session t.ogs random_buf random_len
  |> check_error t >>| fun _ ->
  t

let pickle ?(pass="") t =
  let key_buf, key_len = string_to_sized_buff Ctypes.void pass in
  let pickle_len       = C.Funcs.pickle_outbound_group_session_length t.ogs in
  let pickle_buf       = allocate_bytes_void (size_to_int pickle_len) in
  let ret = C.Funcs.pickle_outbound_group_session t.ogs key_buf key_len pickle_buf pickle_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

let from_pickle ?(pass="") pickle =
  non_empty_string ~label:"Pickle" pickle >>|
  string_to_sized_buff Ctypes.void >>= fun (pickle_buf, pickle_len) ->
  let key_buf, key_len = string_to_sized_buff Ctypes.void pass in
  let t   = alloc () in
  let ret = C.Funcs.unpickle_outbound_group_session t.ogs key_buf key_len pickle_buf pickle_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  t

let encrypt t plaintext =
  let txt_buf, txt_len = string_to_sized_buff Ctypes.uint8_t plaintext in
  let msg_len          = C.Funcs.group_encrypt_message_length t.ogs txt_len in
  let msg_buf          = Ctypes.(allocate_n uint8_t ~count:(size_to_int msg_len)) in
  let ret = C.Funcs.group_encrypt t.ogs txt_buf txt_len msg_buf msg_len in
  let ()  = zero_bytes Ctypes.uint8_t ~length:(size_to_int txt_len) txt_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.uint8_t ~length:(size_to_int msg_len) msg_buf

let id t =
  let id_len = C.Funcs.outbound_group_session_id_length t.ogs in
  let id_buf = Ctypes.(allocate_n uint8_t ~count:(size_to_int id_len)) in
  C.Funcs.outbound_group_session_id t.ogs id_buf id_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.uint8_t ~length:(size_to_int id_len) id_buf

let message_index t =
  C.Funcs.outbound_group_session_message_index t.ogs |> Unsigned.UInt32.to_int

let session_key t =
  let key_len = C.Funcs.outbound_group_session_key_length t.ogs in
  let key_buf = Ctypes.(allocate_n uint8_t ~count:(size_to_int key_len)) in
  C.Funcs.outbound_group_session_key t.ogs key_buf key_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.uint8_t ~length:(size_to_int key_len) key_buf
