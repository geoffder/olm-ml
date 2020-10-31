open! Core
open! Olm
open! Helpers.ResultInfix

let%test "clear ecryption / decryption" =
  begin
    Pk.Decryption.create ()         >>= fun dec ->
    Pk.Encryption.create dec.pubkey >>= fun enc ->
    Pk.Decryption.clear dec.pk_dec  >>= fun _ ->
    Pk.Encryption.clear enc.pk_enc
  end |> Result.is_ok

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
  | Error `BadMessageMac -> true
  | _                    -> false

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
  | Error `BadAccountKey -> true
  | _                    -> false

let%test "signature verification" =
  let seed      = Pk.Signing.generate_seed () in
  let plaintext = "Hello there!" in
  let util      = Utility.create () in
  begin
    Pk.Signing.create seed >>= fun signing ->
    Pk.Signing.sign signing plaintext >>=
    Utility.ed25519_verify util signing.pubkey plaintext
  end |> Result.is_ok

let%test "clear signing" =
  begin
    Pk.Signing.create (Pk.Signing.generate_seed ()) >>= fun signing ->
    Pk.Signing.clear signing.pk_sgn
  end |> Result.is_ok

let%test "unicode decrypt" =
  let unicode = "😀" in
  begin
    Pk.Decryption.create ()           >>= fun dec ->
    Pk.Encryption.create dec.pubkey   >>= fun enc ->
    Pk.Encryption.encrypt enc unicode >>=
    Pk.Decryption.decrypt dec
  end |> function
  | Ok "😀" -> true
  | _       -> false

let%test "invalid unicode decrypt" =
  let unicode = "\xed" in
  begin
    Pk.Decryption.create ()           >>= fun dec ->
    Pk.Encryption.create dec.pubkey   >>= fun enc ->
    Pk.Encryption.encrypt enc unicode >>=
    Pk.Decryption.decrypt dec
  end |> function
  | Ok "�" -> true
  | _      -> false
