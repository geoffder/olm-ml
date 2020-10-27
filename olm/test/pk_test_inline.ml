open! Core
open! Olm
open! Helpers.ResultInfix

let%test "invalid encryption" =
  Pk.Encryption.create "" |> Result.is_error

let%test "decryption" =
  let plaintext = "I've got a secret." in
  begin
    Pk.Decryption.create ()             >>= fun dec ->
    Pk.Encryption.create dec.pubkey     >>= fun enc ->
    Pk.Encryption.encrypt enc plaintext >>=
    Pk.Decryption.decrypt dec
  end |> function
  | Ok s when String.equal s plaintext -> true
  | _                                  -> false

let%test "invalid decryption" =
  let plaintext = "I've got a secret." in
  begin
    Pk.Decryption.create ()             >>= fun dec ->
    Pk.Encryption.create dec.pubkey     >>= fun enc ->
    Pk.Encryption.encrypt enc plaintext >>= fun msg ->
    { msg with ephemeral_key ="?" }
    |> Pk.Decryption.decrypt dec
  end |> function
  | Error "BAD_MESSAGE_MAC" -> true
  | _                       -> false

let%test "pickle" =
  let plaintext = "I've got a secret." in
  begin
    Pk.Decryption.create ()             >>= fun dec ->
    Pk.Encryption.create dec.pubkey     >>= fun enc ->
    Pk.Encryption.encrypt enc plaintext >>= fun msg ->
    Pk.Decryption.pickle dec            >>=
    Pk.Decryption.from_pickle           >>= fun unpickled ->
    Pk.Decryption.decrypt unpickled msg
  end |> function
  | Ok s when String.equal s plaintext -> true
  | _                                  -> false

let%test "invalid unpickle" =
  Pk.Decryption.from_pickle "" |> Result.is_error

let%test "invalid pass pickling" =
  begin
    Pk.Decryption.create () >>=
    Pk.Decryption.pickle ~pass:"foo" >>=
    Pk.Decryption.from_pickle ~pass:"bar"
  end |> function
  | Error "BAD_ACCOUNT_KEY" -> true
  | _                       -> false

let%test "signature verification" =
  let seed      = Pk.Signing.generate_seed () in
  let plaintext = "Hello there!" in
  let util      = Utility.create () in
  begin
    Pk.Signing.create seed >>= fun signing ->
    Pk.Signing.sign signing plaintext >>=
    Utility.ed25519_verify util signing.pubkey plaintext
  end |> Result.is_ok

(* TODO: actually test, and figure out unicode situation. *)
let%test "invalid unicode decrypt" =
  let unicode = "" in
  begin
    Pk.Decryption.create ()           >>= fun dec ->
    Pk.Encryption.create dec.pubkey   >>= fun enc ->
    Pk.Encryption.encrypt enc unicode >>=
    Pk.Decryption.decrypt dec
  end |> function
  | Ok "" -> true
  | _     -> false
