open! Core
open! Olm
open! Helpers.ResultInfix

let message = "Hello."
let utility = Utility.create ()
let alice   = Account.create () |> Result.ok_or_failwith

let%test "verify account signature" =
  let res =
    Account.sign alice message                 >>= fun signature ->
    Account.identity_keys alice                >>= fun identity_keys ->
    Map.find_or_error identity_keys "ed25519"
    |> Result.map_error ~f:Error.to_string_hum >>= fun signing_key ->
    Utility.ed25519_verify utility signing_key message signature
  in
  Result.is_ok res
