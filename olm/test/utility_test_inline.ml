open! Core
open! Olm
open! Helpers.ResultInfix

let%test "verify account signature" =
  let message = "Hello." in
  let utility = Utility.create () in
  begin
    Account.create ()                          >>= fun alice ->
    Account.sign alice message                 >>= fun signature ->
    Account.identity_keys alice                >>= fun identity_keys ->
    Map.find_or_error identity_keys "ed25519"
    |> Result.map_error ~f:Error.to_string_hum >>= fun signing_key ->
    Utility.ed25519_verify utility signing_key message signature
  end |> Result.is_ok
