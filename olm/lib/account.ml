open! Core

let size = C.Functions.account_size () |> Unsigned.Size_t.to_int

let clear = C.Functions.clear_account

type t = C.Types.Account.t Ctypes.ptr

let check_error t ret =
  Helpers.size_to_result ret
  |> Result.map_error ~f:(fun _ -> C.Functions.account_last_error t
                                   |> Helpers.string_of_null_term_ptr)
  |> Result.map ~f:(fun _ -> t)

let random_bytes len =
  let open Ctypes in
  Cryptokit.Random.(string secure_rng) len
  |> CArray.of_string
  |> allocate (array len char)
  |> to_voidp

let create () =
  let account       = Helpers.allocate_bytes_void size |> C.Functions.account in
  let random_length = C.Functions.create_account_random_length account in
  let random        = random_bytes (Unsigned.Size_t.to_int random_length) in
  C.Functions.create_account account random random_length
  |> check_error account
