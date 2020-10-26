open! Core
open! Olm
open! Olm.Helpers

let bob = Account.create () |> Result.ok_or_failwith

let%test "get identity keys" =
  let identity_keys = Account.identity_keys bob |> Result.ok_or_failwith in
  let algos         = Map.keys identity_keys in
  List.equal String.equal algos ["curve25519"; "ed25519"]

let%test "get identity keys" =
  let res =
    Account.generate_one_time_keys bob 2 >>= fun _ ->
    Account.one_time_keys bob            >>| fun keys ->
    Map.find_exn keys "curve25519" |> Map.length
  in
  Result.ok_or_failwith res
  |> ( = ) 2
