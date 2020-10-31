open! Core
open! Olm
open! Helpers.ResultInfix

let plaintext = "It's a secret to everybody"

let create_session () =
  Account.create ()                      >>= fun alice ->
  Account.create ()                      >>= fun bob ->
  Account.identity_keys bob              >>= fun id_keys ->
  Account.generate_one_time_keys bob 1   >>= fun _ ->
  Account.one_time_keys bob              >>= fun keys ->
  List.hd (Map.data keys.curve25519)
  |> Result.of_option ~error:`MissingKey >>= fun one_time ->
  Session.create_outbound alice id_keys.curve25519 one_time  >>= fun session ->
  Result.return (alice, bob, session)

let%test "creation" =
  begin
    create_session () >>= fun (_, _, sess_1) ->
    create_session () >>= fun (_, _, sess_2) ->
    Session.id sess_1 >>= fun id_1 ->
    Session.id sess_2 >>= fun id_2 ->
    not (String.equal id_1 id_2)
    |> Result.ok_if_true ~error:`IDCollision
  end |> Result.is_ok

let%test "clear" =
  begin
    create_session () >>= fun (_, _, sess_1) ->
    Session.clear sess_1.ses
  end |> Result.is_ok

let%test "pickle" =
  begin
    create_session ()          >>= fun (_, _, session) ->
    Session.pickle session     >>= fun pickle ->
    Session.id session         >>= fun session_id ->
    Session.from_pickle pickle >>= fun unpickled ->
    Session.id unpickled       >>= fun unpickled_id ->
    String.equal session_id unpickled_id |> Result.ok_if_true ~error:`WrongID
  end |> Result.is_ok

let%test "invalid pickle" =
  match Session.from_pickle "" with
  | Error (`ValueError _) -> true
  | _                     -> false

(* NOTE: In the python tests, they pickle an account, then use session unpickle.
 * This still would lead to a "BAD_ACCOUNT_KEY" error but I suspect that it is
 * not intentional. Bring to their attention. *)
let%test "wrong passphrase pickle" =
  begin
    create_session ()          >>= fun (_, _, session) ->
    Session.pickle session ~pass:"admin" >>=
    Session.from_pickle ~pass:""
  end |> function
  | Error `BadAccountKey -> true
  | _                    -> false

let%test "encrypt" =
  begin
    create_session ()                 >>= fun (_, bob, session) ->
    Session.encrypt session plaintext >>= fun msg -> begin msg |> function
      | Session.Message.PreKey _ -> Result.return ()
      | _                        -> Result.fail `ShouldBePreKey
    end >>= fun () ->
    Session.create_inbound bob msg  >>= fun bob_session ->
    Session.decrypt bob_session msg >>= fun decrypted ->
    String.equal plaintext decrypted |> Result.ok_if_true ~error:`WrongDecrypt
  end |> Result.is_ok

let%test "empty message" =
  (** Only way to create Message.t is through the create function, which requires
   ** that the suplied ciphertext is empty. *)
  Session.Message.create "" 0 |> Result.is_error

let%test "inbound with id" =
  begin
    create_session ()                                            >>= fun (alice, bob, session) ->
    Session.encrypt session plaintext                            >>= fun msg ->
    Account.identity_keys alice                                  >>= fun keys ->
    Session.create_inbound ~identity_key:keys.curve25519 bob msg >>= fun bob_session ->
    Session.decrypt bob_session msg                              >>= fun decrypted ->
    String.equal plaintext decrypted |> Result.ok_if_true ~error:`WrongDecrypt
  end |> Result.is_ok

let%test "two messages" =
  let bob_plaintext = "Grumble, Grumble" in
  begin
    create_session ()                                            >>= fun (alice, bob, session) ->
    Session.encrypt session plaintext                            >>= fun msg ->
    Account.identity_keys alice                                  >>= fun keys ->
    Session.create_inbound ~identity_key:keys.curve25519 bob msg >>= fun bob_session ->
    Session.remove_one_time_keys bob_session bob                 >>= fun _ ->
    Session.decrypt bob_session msg                              >>= fun decrypted ->
    String.equal plaintext decrypted
    |> Result.ok_if_true ~error:`WrongDecrypt                    >>= fun _ ->
    Session.encrypt bob_session bob_plaintext                    >>= fun bob_msg ->
    not (Session.Message.is_pre_key bob_msg)
    |> Result.ok_if_true ~error:`ShouldBeMessage                 >>= fun _ ->
    Session.decrypt session bob_msg                              >>= fun bob_decrypted ->
    String.equal bob_plaintext bob_decrypted
    |> Result.ok_if_true ~error:`WrongDecrypt
  end |> Result.is_ok

let%test "invalid" =
  begin
    create_session ()            >>= fun (alice, _, session) ->
    Session.Message.create "x" 1 >>= fun msg ->
    Session.matches session msg |> begin function
      | Error (`ValueError _) -> Result.return ()
      | _                     -> Result.fail `MessageShouldFail
    end >>= fun _ ->
    Session.create_outbound alice "" "x" |> begin function
      | Error (`ValueError _) -> Result.return ()
      | _                     -> Result.fail `EmptyIdShouldFail
    end >>= fun _ ->
    Session.create_outbound alice "x" "" |> begin function
      | Error (`ValueError _) -> Result.return ()
      | _                     -> Result.fail `EmptyKeyShouldFail
    end
  end |> Result.is_ok

let%test "doesn't match" =
  begin
    create_session ()                                            >>= fun (alice, bob, session) ->
    Session.encrypt session plaintext                            >>= fun msg ->
    Account.identity_keys alice                                  >>= fun keys ->
    Session.create_inbound ~identity_key:keys.curve25519 bob msg >>= fun bob_session ->
    create_session ()                                            >>= fun (_, _, new_session) ->
    Session.encrypt new_session plaintext                        >>= fun new_msg ->
    Session.matches bob_session new_msg
  end |> function
  | Ok false -> true
  | _        -> false

(* TODO: Not sure what I need to do to test invalid unicode decrypt as they
 * do in the python bindings. I also have not determined what my equivalent
 * course is when unicode handling is done in the API. This example passes,
 * which is not the same as the python test, where b"\xed" becomes u"�".
 * I'm not sure what the equivalent check for ocaml should be yet. *)
(* let%test "unicode decrypt" =
 *   begin
 *     create_session ()                                            >>= fun (alice, bob, session) ->
 *     Session.encrypt session "\xed"                               >>= fun msg ->
 *     Account.identity_keys alice                                  >>= fun keys ->
 *     Session.create_inbound ~identity_key:keys.curve25519 bob msg >>= fun bob_session ->
 *     Session.decrypt bob_session msg
 *   end |> function
 *   | Ok "í" -> true
 *   | _      -> false *)
