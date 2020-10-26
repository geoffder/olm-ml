open Core
open Helpers

type t = { buf : unit Ctypes.ptr
         ; acc : C.Types.Account.t Ctypes_static.ptr
         }

let size = C.Funcs.account_size () |> size_to_int

let clear = C.Funcs.clear_account

let check_error t ret =
  size_to_result ret
  |> Result.map_error
    ~f:(fun _ -> C.Funcs.account_last_error t.acc |> string_of_nullterm_char_ptr)

let alloc () =
  let buf = allocate_bytes_void size in
  { buf; acc = C.Funcs.account buf }

let create () =
  let t          = alloc () in
  let random_len = C.Funcs.create_account_random_length t.acc in
  let random_buf = random_void (size_to_int random_len) in
  C.Funcs.create_account t.acc random_buf random_len
  |> check_error t >>| fun _ ->
  t

let pickle ?(pass="") t =
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass |> size_of_int in
  let pickle_len = C.Funcs.pickle_account_length t.acc in
  let pickle_buf = allocate_bytes_void (size_to_int pickle_len) in
  let ret = C.Funcs.pickle_account t.acc key_buf key_len pickle_buf pickle_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

let from_pickle ?(pass="") pickle =
  non_empty_string ~label:"Pickle" pickle >>| string_to_ptr Ctypes.void >>= fun pickle_buf ->
  let pickle_len = String.length pickle |> size_of_int in
  let key_buf    = string_to_ptr Ctypes.void pass in
  let key_len    = String.length pass |> size_of_int in
  let t          = alloc () in
  let ret = C.Funcs.unpickle_account t.acc key_buf key_len pickle_buf pickle_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  t

let identity_keys t =
  let out_len = C.Funcs.account_identity_keys_length t.acc in
  let out_buf = allocate_bytes_void (size_to_int out_len) in
  C.Funcs.account_identity_keys t.acc out_buf out_len
  |> check_error t >>= fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int out_len) out_buf
  |> Yojson.Safe.from_string
  |> YoJs.StringMap.of_yojson YoJs.string_of_yojson

let sign t msg =
  let msg_buf = string_to_ptr Ctypes.void msg in
  let msg_len = String.length msg |> size_of_int in
  let out_len = C.Funcs.account_signature_length t.acc in
  let out_buf = allocate_bytes_void (size_to_int out_len) in
  let ret = C.Funcs.account_sign t.acc msg_buf msg_len out_buf out_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int msg_len) msg_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int out_len) out_buf

let max_one_time_keys t =
  C.Funcs.account_max_number_of_one_time_keys t.acc
  |> check_error t

let mark_keys_as_published t =
  C.Funcs.account_mark_keys_as_published t.acc
  |> check_error t

let generate_one_time_keys t count =
  let n = size_of_int count in
  let random_len = C.Funcs.account_generate_one_time_keys_random_length t.acc n in
  let random_buf = random_void (size_to_int random_len) in
  C.Funcs.account_generate_one_time_keys t.acc n random_buf random_len
  |> check_error t

let one_time_keys t =
  let out_len = C.Funcs.account_one_time_keys_length t.acc in
  let out_buf = allocate_bytes_void (size_to_int out_len) in
  C.Funcs.account_one_time_keys t.acc out_buf out_len
  |> check_error t >>= fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int out_len) out_buf
  |> Yojson.Safe.from_string
  |> YoJs.StringMap.of_yojson YoJs.(StringMap.of_yojson string_of_yojson)

let remove_one_time_keys t session =
  C.Funcs.remove_one_time_keys t.acc session
  |> check_error t
