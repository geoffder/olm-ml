open! Core
open! Olm
open! Helpers.ResultInfix

let%test "creation" =
  begin
    Account.create ()
    >>= Account.identity_keys
    >>| Map.length
  end |> function
  | Ok 2 -> true
  | _    -> false

let%test "pickle" =
  begin
    Account.create ()          >>= fun chad ->
    Account.identity_keys chad >>= fun keys ->
    Account.pickle chad        >>=
    Account.from_pickle        >>=
    Account.identity_keys      >>| fun unpickled_keys ->
    Map.equal String.equal keys unpickled_keys
  end |> function
  | Ok true -> true
  | _       -> false

let%test "invalid pickle" =
  Account.from_pickle ""
  |> Result.error
  |> function
  | Some "Pickle can't be empty." -> true
  | _                             -> false

let%test "passphrase pickle" =
  let pass = "password" in
  begin
    Account.create ()          >>= fun chad ->
    Account.identity_keys chad >>= fun keys ->
    Account.pickle chad ~pass  >>=
    Account.from_pickle ~pass  >>=
    Account.identity_keys      >>| fun unpickled_keys ->
    Map.equal String.equal keys unpickled_keys
  end |> function
  | Ok true -> true
  | _       -> false

let%test "wrong passphrase pickle" =
  begin
    Account.create ()
    >>= Account.pickle ~pass:"foo"
    >>= Account.from_pickle ~pass:"bar"
  end |> function
  | Error "BAD_ACCOUNT_KEY" -> true
  | _                       -> false

let%test "get identity keys" =
  begin
    Account.create ()
    >>= Account.identity_keys
    >>| Map.keys
  end |> function
  | Ok [ "curve25519"; "ed25519" ] -> true
  | _                              -> false

let%test "generate one-time keys" =
  begin
    Account.create ()                    >>= fun bob ->
    Account.generate_one_time_keys bob 2 >>= fun _ ->
    Account.one_time_keys bob            >>| fun keys ->
    Map.find keys "curve25519"
    |> Option.value_map ~f:Map.length ~default:0
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
    Map.find keys "ed25519"
    |> Result.of_option ~error:"Missing key." >>= fun signing_key ->
    Utility.ed25519_verify utility signing_key message signature
  end |> Result.is_ok

let%test "invalid signature" =
  let message = "It was me, Dio!" in
  let utility = Utility.create () in
  begin
    Account.create ()         >>= fun dio ->
    Account.create ()         >>= fun jojo ->
    Account.sign jojo message  >>= fun signature ->
    Account.identity_keys dio >>= fun keys ->
    Map.find keys "ed25519"
    |> Result.of_option ~error:"Missing key." >>= fun signing_key ->
    Utility.ed25519_verify utility signing_key message signature
  end |> function
  | Error "BAD_MESSAGE_MAC" -> true
  | _                       -> false

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
      | _                                  -> Result.fail "Signature mismatch"
    in
    Map.find keys "ed25519"
    |> Result.of_option ~error:"Missing key." >>= fun signing_key ->
    Utility.ed25519_verify utility signing_key message signature >>= fun _ ->
    repeat_sign () >>= fun _ ->
    Utility.ed25519_verify utility signing_key message signature >>= fun _ ->
    repeat_sign ()
  end |> Result.is_ok
