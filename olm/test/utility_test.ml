open! Core
open! Olm
open! Helpers.ResultInfix

let%test "clear" =
  begin
    let util = Utility.create () in
    Utility.clear util.util
  end |> Result.is_ok

let%test "sha256" =
  let input1 = "It's a secret to everybody." in
  let input2 = "It's a secret to nobody." in
  let util   = Utility.create () in
  let nocrypto_hash =
    Cstruct.of_string input1
    |> Nocrypto.Hash.SHA256.digest
    |> Nocrypto.Base64.encode
    |> Cstruct.to_string
    |> String.rstrip ~drop:(Char.equal '=')  (* remove padding from encode *)
  in
  begin
    Utility.sha256 util input1 >>= fun first_hash ->
    Utility.sha256 util input2 >>= fun second_hash ->
    Result.return (first_hash, second_hash)
  end |> function
  | Ok (h1, h2) -> not (String.equal h1 h2) && String.equal h1 nocrypto_hash
  | _ -> false
