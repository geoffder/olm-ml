open! Core
open Helpers

type t = C.Types.OutboundGroupSession.t Ctypes_static.ptr

let size = C.Funcs.outbound_group_session_size () |> size_to_int

let clear = C.Funcs.clear_outbound_group_session

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.outbound_group_session_last_error t
    |> string_of_nullterm_char_ptr
  end

let create () =
  let t = allocate_bytes_void size |> C.Funcs.outbound_group_session in
  let random_len = C.Funcs.init_outbound_group_session_random_length t in
  let random_buf = random_uint8 (size_to_int random_len) in
  C.Funcs.init_outbound_group_session t random_buf random_len
  |> check_error t >>| fun _ ->
  t

let pickle ?(pass="") t =
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass |> size_of_int in
  let pickle_len = C.Funcs.pickle_outbound_group_session_length t in
  let pickle_buf = allocate_bytes_void (size_to_int pickle_len) in
  let ret = C.Funcs.pickle_outbound_group_session t key_buf key_len pickle_buf pickle_len in
  let ()  = zero_mem Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

let from_pickle ?(pass="") pickle =
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass |> size_of_int in
  let pickle_len = String.length pickle |> size_of_int in
  non_empty_string ~label:"Pickle" pickle >>| string_to_ptr Ctypes.void >>= fun pickle_buf ->
  let t = allocate_bytes_void size |> C.Funcs.outbound_group_session in
  let ret = C.Funcs.unpickle_outbound_group_session t key_buf key_len pickle_buf pickle_len in
  let ()  = zero_mem Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  t

let encrypt t plaintext =
  let txt_buf = string_to_ptr Ctypes.uint8_t plaintext in
  let txt_len = String.length plaintext |> size_of_int in
  let msg_len = C.Funcs.group_encrypt_message_length t txt_len in
  let msg_buf = Ctypes.(allocate_n uint8_t ~count:(size_to_int msg_len)) in
  let ret = C.Funcs.group_encrypt t txt_buf txt_len msg_buf msg_len in
  let ()  = zero_mem Ctypes.uint8_t ~length:(size_to_int txt_len) txt_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.uint8_t ~length:(size_to_int msg_len) msg_buf

let id t =
  let id_len = C.Funcs.outbound_group_session_id_length t in
  let id_buf = Ctypes.(allocate_n uint8_t ~count:(size_to_int id_len)) in
  C.Funcs.outbound_group_session_id t id_buf id_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.uint8_t ~length:(size_to_int id_len) id_buf

let message_index t =
  C.Funcs.outbound_group_session_message_index t |> Unsigned.UInt32.to_int

let session_key t =
  let key_len = C.Funcs.outbound_group_session_key_length t in
  let key_buf = Ctypes.(allocate_n uint8_t ~count:(size_to_int key_len)) in
  C.Funcs.outbound_group_session_key t key_buf key_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.uint8_t ~length:(size_to_int key_len) key_buf
