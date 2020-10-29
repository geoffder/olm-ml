open Core
open Helpers
open Helpers.ResultInfix

module IdentityKeys : sig
  type t = private { curve25519 : string
                   ; ed25519    : string
                   }
  val equal     : t -> t -> bool
  val of_yojson : Yojson.Safe.t -> (t, [> `YojsonError of string ]) result
  val to_yojson : t -> Yojson.Safe.t
  val of_string : string -> (t, [> `YojsonError of string ]) result
  val to_string : t -> string
end = struct
  type t = { curve25519 : string
           ; ed25519    : string
           }

  let equal a b = String.equal a.curve25519 b.curve25519
                  && String.equal a.ed25519 b.ed25519

  let of_yojson j =
    YoJs.U.member "curve25519" j |> YoJs.string_of_yojson >>= fun curve25519 ->
    YoJs.U.member "ed25519" j    |> YoJs.string_of_yojson >>= fun ed25519 ->
    Result.return { curve25519; ed25519 }

  let to_yojson { curve25519; ed25519 } =
    `Assoc [ ("curve25519", `String curve25519)
           ; ("ed25519", `String ed25519)
           ]

  let of_string s = Yojson.Safe.from_string s |> of_yojson
  let to_string t = to_yojson t |> Yojson.Safe.to_string
end

module OneTimeKeys : sig
  type t = private { curve25519 : (string, string, String.comparator_witness) Map.t }
  val equal     : t -> t -> bool
  val of_yojson : Yojson.Safe.t -> (t, [> `YojsonError of string ]) result
  val to_yojson : t -> Yojson.Safe.t
  val of_string : string -> (t, [> `YojsonError of string ]) result
  val to_string : t -> string
end = struct
  type t = { curve25519 : (string, string, String.comparator_witness) Map.t }

  let equal a b = Map.equal String.equal a.curve25519 b.curve25519

  let of_yojson j =
    YoJs.U.member "curve25519" j
    |> YoJs.StringMap.of_yojson YoJs.string_of_yojson
    >>| fun curve25519 -> { curve25519 }

  let to_yojson { curve25519 } =
    `Assoc [ ("curve25519", YoJs.(StringMap.to_yojson yo_string curve25519)) ]

  let of_string s = Yojson.Safe.from_string s |> of_yojson
  let to_string t = to_yojson t |> Yojson.Safe.to_string
end

type t = { buf : char Ctypes_static.ptr
         ; acc : C.Types.Account.t Ctypes_static.ptr
         }

let size = C.Funcs.account_size () |> size_to_int

let clear acc = C.Funcs.clear_account acc |> size_to_result

let check_error t ret =
  size_to_result ret
  |> Result.map_error ~f:begin fun _ ->
    C.Funcs.account_last_error t.acc
    |> OlmError.of_last_error
  end

let alloc () =
  let finalise = finaliser C.Types.Account.t clear in
  let buf = allocate_buf ~finalise size in
  { buf; acc = C.Funcs.account (Ctypes.to_voidp buf) }

let create () =
  let t          = alloc () in
  let random_len = C.Funcs.create_account_random_length t.acc in
  let random_buf = random_void (size_to_int random_len) in
  C.Funcs.create_account t.acc random_buf random_len
  |> check_error t >>| fun _ ->
  t

let pickle ?(pass="") t =
  let key_buf, key_len = string_to_sized_buff Ctypes.void pass in
  let pickle_len       = C.Funcs.pickle_account_length t.acc in
  let pickle_buf       = allocate_bytes_void (size_to_int pickle_len) in
  let ret = C.Funcs.pickle_account t.acc key_buf key_len pickle_buf pickle_len in
  let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
  check_error t ret >>| fun _ ->
  string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

let from_pickle ?(pass="") pickle =
  non_empty_string ~label:"Pickle" pickle >>|
  string_to_sized_buff Ctypes.void >>= fun (pickle_buf, pickle_len) ->
  let key_buf, key_len = string_to_sized_buff Ctypes.void pass in
  let t   = alloc () in
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
  |> IdentityKeys.of_string

let sign t msg =
  let msg_buf, msg_len = string_to_sized_buff Ctypes.void msg in
  let out_len          = C.Funcs.account_signature_length t.acc in
  let out_buf          = allocate_bytes_void (size_to_int out_len) in
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
  |> OneTimeKeys.of_string
