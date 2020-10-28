open! Core
open! Olm
open! Helpers.ResultInfix

let%test "creation" =
  Account.create () |> Result.is_ok

let%test "pickle" =
  begin
    Account.create ()          >>= fun chad ->
    Account.identity_keys chad >>= fun keys ->
    Account.pickle chad        >>=
    Account.from_pickle        >>=
    Account.identity_keys      >>| fun unpickled_keys ->
    Account.IdentityKeys.equal keys unpickled_keys
  end |> function
  | Ok true -> true
  | _       -> false

let%test "invalid pickle" =
  match Account.from_pickle "" with
  | Error (`ValueError _) -> true
  | _                     -> false

let%test "passphrase pickle" =
  let pass = "password" in
  begin
    Account.create ()          >>= fun chad ->
    Account.identity_keys chad >>= fun keys ->
    Account.pickle chad ~pass  >>=
    Account.from_pickle ~pass  >>=
    Account.identity_keys      >>| fun unpickled_keys ->
    Account.IdentityKeys.equal keys unpickled_keys
  end |> function
  | Ok true -> true
  | _       -> false

let%test "wrong passphrase pickle" =
  begin
    Account.create ()
    >>= Account.pickle ~pass:"foo"
    >>= Account.from_pickle ~pass:"bar"
  end |> function
  | Error `BadAccountKey -> true
  | _                       -> false

let%test "get identity keys" =
  begin
    Account.create () >>= Account.identity_keys
  end |> Result.is_ok

let%test "generate one-time keys" =
  begin
    Account.create ()                    >>= fun bob ->
    Account.generate_one_time_keys bob 2 >>= fun _ ->
    Account.one_time_keys bob            >>| fun keys ->
    Map.length keys.curve25519
  end |> function
  | Ok num_keys when num_keys = 2 -> true
  | _                             -> false

let%test "max one-time keys" =
  begin
    Account.create ()
    >>= Account.max_one_time_keys
  end |> function
  | Ok n when n > 0 -> true
  | _               -> false

let%test "valid signature" =
  let message = "It was me, Dio!" in
  let utility = Utility.create () in
  begin
    Account.create ()         >>= fun dio ->
    Account.sign dio message  >>= fun signature ->
    Account.identity_keys dio >>= fun keys ->
    Utility.ed25519_verify utility keys.ed25519 message signature
  end |> Result.is_ok

let%test "invalid signature" =
  let message = "It was me, Dio!" in
  let utility = Utility.create () in
  begin
    Account.create ()         >>= fun dio ->
    Account.create ()         >>= fun jojo ->
    Account.sign jojo message >>= fun signature ->
    Account.identity_keys dio >>= fun keys ->
    Utility.ed25519_verify utility keys.ed25519 message signature
  end |> function
  | Error `BadMessageMac -> true
  | _                    -> false

let%test "signature verification twice" =
  let message = "It was me, Dio!" in
  let utility = Utility.create () in
  begin
    Account.create ()         >>= fun dio ->
    Account.sign dio message  >>= fun signature ->
    Account.identity_keys dio >>= fun keys ->
    let repeat_sign () =
      Account.sign dio message |> function
      | Ok s when String.equal s signature -> Result.return ()
      | _                                  -> Result.fail `SignatureMismatch
    in
    Utility.ed25519_verify utility keys.ed25519 message signature >>= fun _ ->
    repeat_sign () >>= fun _ ->
    Utility.ed25519_verify utility keys.ed25519 message signature >>= fun _ ->
    repeat_sign ()
  end |> Result.is_ok
