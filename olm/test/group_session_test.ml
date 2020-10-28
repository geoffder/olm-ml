open! Core
open! Olm
open! Helpers.ResultInfix

let%test "outbound create" =
  OutboundGroupSession.create () |> Result.is_ok

let%test "session id" =
  begin
    OutboundGroupSession.create () >>=
    OutboundGroupSession.id
  end |> Result.is_ok

let%test "session index" =
  begin
    OutboundGroupSession.create () >>|
    OutboundGroupSession.message_index
  end |> function
  | Ok 0 -> true
  | _    -> false

let%test "invalid unpickle" =
  begin
    OutboundGroupSession.create ()       >>= fun outbound ->
    OutboundGroupSession.id outbound     >>= fun outbound_id ->
    OutboundGroupSession.pickle outbound >>=
    OutboundGroupSession.from_pickle     >>=
    OutboundGroupSession.id >>= fun unpickled_id ->
    Result.return (outbound_id, unpickled_id)
  end |> function
  | Ok (id_1, id_2) when String.equal id_1 id_2 -> true
  | _                                           -> false

let%test "inbound create" =
  begin
    OutboundGroupSession.create () >>=
    OutboundGroupSession.session_key >>=
    InboundGroupSession.create
  end |> Result.is_ok

let%test "invalid decrypt" =
  begin
    OutboundGroupSession.create ()   >>=
    OutboundGroupSession.session_key >>=
    InboundGroupSession.create       >>= fun inbound ->
    InboundGroupSession.decrypt inbound ""
  end |> function
  | Error (`ValueError _) -> true
  | _                     -> false

let%test "inbound pickle" =
  begin
    OutboundGroupSession.create ()   >>=
    OutboundGroupSession.session_key >>=
    InboundGroupSession.create       >>=
    InboundGroupSession.pickle       >>=
    InboundGroupSession.from_pickle
  end |> Result.is_ok

let%test "first index" =
  begin
    OutboundGroupSession.create ()   >>=
    OutboundGroupSession.session_key >>=
    InboundGroupSession.create       >>|
    InboundGroupSession.first_known_index
  end |> function
  | Ok 0 -> true
  | _    -> false

let%test "encrypt / decrypt" =
  begin
    OutboundGroupSession.create ()            >>= fun outbound ->
    OutboundGroupSession.session_key outbound >>=
    InboundGroupSession.create                >>= fun inbound ->
    OutboundGroupSession.encrypt outbound "Test" >>=
    InboundGroupSession.decrypt inbound
  end |> function
  | Ok ("Test", 0) -> true
  | _              -> false

let%test "inbound export" =
  begin
    OutboundGroupSession.create ()            >>= fun outbound ->
    OutboundGroupSession.session_key outbound >>=
    InboundGroupSession.create                >>= fun inbound ->
    InboundGroupSession.first_known_index inbound
    |> InboundGroupSession.export_session inbound
    >>= InboundGroupSession.import_session >>= fun imported ->
    OutboundGroupSession.encrypt outbound "Test" >>=
    InboundGroupSession.decrypt imported
  end |> function
  | Ok ("Test", 0) -> true
  | _              -> false

let%test "encrypt twice, decrypt once" =
  begin
    OutboundGroupSession.create ()            >>= fun outbound ->
    OutboundGroupSession.session_key outbound >>=
    InboundGroupSession.create                >>= fun inbound ->
    OutboundGroupSession.encrypt outbound "Test 1" >>= fun _ ->
    OutboundGroupSession.encrypt outbound "Test 2" >>=
    InboundGroupSession.decrypt inbound
  end |> function
  | Ok ("Test 2", 1) -> true
  | _                -> false

let%test "decrypt failure" =
  begin
    OutboundGroupSession.create ()            >>= fun outbound ->
    OutboundGroupSession.session_key outbound >>=
    InboundGroupSession.create                >>= fun inbound ->
    OutboundGroupSession.create ()            >>= fun eve_outbound ->
    OutboundGroupSession.encrypt eve_outbound "Test" >>=
    InboundGroupSession.decrypt inbound
  end |> function
  | Error `BadSignature -> true
  | _                   -> false

let%test "id" =
  begin
    OutboundGroupSession.create ()            >>= fun outbound ->
    OutboundGroupSession.session_key outbound >>=
    InboundGroupSession.create                >>= fun inbound ->
    OutboundGroupSession.id outbound          >>= fun out_id ->
    InboundGroupSession.id inbound            >>| fun in_id ->
    String.equal out_id in_id
  end |> function
  | Ok true -> true
  | _       -> false

let%test "incorrect outbound pickle password" =
  begin
    OutboundGroupSession.create ()            >>=
    OutboundGroupSession.pickle ~pass:"admin" >>=
    OutboundGroupSession.from_pickle
  end |> function
  | Error `BadAccountKey -> true
  | _                    -> false

let%test "outbound clear" =
  begin
    OutboundGroupSession.create () >>| fun outbound ->
    OutboundGroupSession.clear outbound.ogs
  end |> Result.is_ok

let%test "inbound clear" =
  begin
    OutboundGroupSession.create ()   >>=
    OutboundGroupSession.session_key >>=
    InboundGroupSession.create       >>= fun inbound ->
    InboundGroupSession.clear inbound.igs
  end |> Result.is_ok

(* TODO: Not sure what I need to do to test invalid unicode decrypt as they
 * do in the python bindings. I also have not determined what my equivalent
 * course is when unicode handling is done in the API. This example passes,
 * which is not the same as the python test, where b"\xed" becomes u"�".
 * I'm not sure what the equivalent check for ocaml should be yet.
 * Unicode string encoding can be done with "\u{code}", but putting a unicode
 * character within is illegal. *)
(* let%test "invalid unicode decrypt" = false *)
