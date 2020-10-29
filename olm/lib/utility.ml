open! Core
open Helpers
open Helpers.ResultInfix

type t = { buf  : char Ctypes.ptr
         ; util : C.Types.Utility.t Ctypes_static.ptr
         }

let size = C.Funcs.utility_size () |> size_to_int

let clear util = C.Funcs.clear_utility util |> size_to_result

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.utility_last_error t.util
    |> OlmError.of_last_error
  end

let alloc () =
  let finalise = finaliser C.Types.Utility.t clear in
  let buf = allocate_buf ~finalise size in
  { buf; util = C.Funcs.utility (Ctypes.to_voidp buf) }

let create = alloc

let ed25519_verify t key message signature =
  let key_buf, key_len = string_to_sized_buff Ctypes.void key in
  let msg_buf, msg_len = string_to_sized_buff Ctypes.void message in
  let sig_buf, sig_len = string_to_sized_buff Ctypes.void signature in
  let ret = C.Funcs.ed25519_verify t.util key_buf key_len msg_buf msg_len sig_buf sig_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int msg_len) msg_buf in
  check_error t ret

let sha256 t input =
  let in_buf, in_len = string_to_sized_buff Ctypes.void input in
  let hash_len       = C.Funcs.sha256_length t.util in
  let hash_buf       = allocate_bytes_void (size_to_int hash_len) in
  C.Funcs.sha256 t.util in_buf in_len hash_buf hash_len
  |> check_error t >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int hash_len) hash_buf
