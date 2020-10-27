open! Core
open! Olm
open! Helpers.ResultInfix

let%test "sha256" =
  let input1 = "It's a secret to everybody." in
  let input2 = "It's a secret to nobody." in
  let util   = Utility.create () in
  let cryptokit_hash =
    let open Cryptokit in
    hash_string (Hash.sha256 ()) input1
    |> transform_string (Base64.encode_compact ())
  in
  begin
    Utility.sha256 util input1 >>= fun first_hash ->
    Utility.sha256 util input2 >>= fun second_hash ->
    Result.return (first_hash, second_hash)
  end |> function
  | Ok (h1, h2) -> not (String.equal h1 h2) && String.equal h1 cryptokit_hash
  | _ -> false
