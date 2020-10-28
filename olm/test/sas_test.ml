open! Core
open! Olm
open! Helpers.ResultInfix

let message = "Test message"
let extra_info = "extra_info"

let%test "creation" =
  begin
    Sas.create ()
    >>= Sas.pubkey
  end |> function
  | Ok key when String.length key > 0 -> true
  | _                                 -> false

let%test "clear" =
  begin
    Sas.create () >>= fun sas ->
    Sas.clear sas.sas
  end |> Result.is_ok

let%test "other_key_setting" =
  begin
    Sas.create () >>= fun chad ->
    Sas.create () >>= fun gaston ->
    not (Sas.other_key_set chad) |> Result.ok_if_true ~error:"Key already set." >>= fun _ ->
    Sas.pubkey gaston >>= Sas.set_their_pubkey chad >>= fun _ ->
    Sas.other_key_set chad |> Result.ok_if_true ~error:"Key not set."
  end |> Result.is_ok

let%test "bytes_generating" =
  begin
    Sas.create ()   >>= fun chad ->
    Sas.pubkey chad >>= fun chads_key ->
    Sas.create ~other_users_pubkey:chads_key () >>= fun gaston ->
    Sas.other_key_set gaston |> Result.ok_if_true ~error:"Key not set." >>= fun _ ->
    Sas.generate_bytes chad extra_info 5 |> begin function
      | Error "OLM_SAS_THEIR_KEY_NOT_SET" -> Result.return ()
      | _                                 -> Result.fail "Should have failed."
    end >>= fun () ->
    Sas.pubkey gaston >>= Sas.set_their_pubkey chad >>= fun _ ->
    Sas.generate_bytes chad extra_info 0 |> begin function
      | Error _ -> Result.return ()
      | _       -> Result.fail "Should fail on non-positive length."
    end >>= fun () ->
    Sas.generate_bytes chad extra_info 5   >>= fun chad_bytes ->
    Sas.generate_bytes gaston extra_info 5 >>= fun gaston_bytes ->
    String.equal chad_bytes gaston_bytes |> Result.ok_if_true ~error:"Wrong."
  end |> Result.is_ok

let%test "mac_generating" =
  begin
    Sas.create () >>= fun chad ->
    Sas.create () >>= fun gaston ->
    Sas.calculate_mac chad message extra_info |> begin function
      | Error "OLM_SAS_THEIR_KEY_NOT_SET" -> Result.return ()
      | _                                 -> Result.fail "Should have failed."
    end >>= fun () ->
    Sas.pubkey gaston >>= Sas.set_their_pubkey chad   >>= fun _ ->
    Sas.pubkey chad   >>= Sas.set_their_pubkey gaston >>= fun _ ->
    Sas.calculate_mac chad message extra_info   >>= fun chad_mac ->
    Sas.calculate_mac gaston message extra_info >>= fun gaston_mac ->
    String.equal chad_mac gaston_mac |> Result.ok_if_true ~error:"Wrong."
  end |> Result.is_ok

let%test "cross_language_mac" =
  (** Test MAC generating with a predefined key pair.
   *  This test imports a private and public key from the C test and checks
   *  if we are getting the same MAC that the C code calculated.
   *  Using C.Funcs.create_sas directly, as this shouldn't be done normally. *)
  let bob_key      = "3p7bfXt9wbTTW2HC7OQ1Nz+DQ8hbeGdNrfx+FG+IK08" in
  let message      = "Hello world!" in
  let extra_info   = "MAC" in
  let expected_mac = "2nSMTXM+TStTU3RUVTNSVVZUTlNWVlpVVGxOV1ZscFY" in
  let alice_private = [ 0x77; 0x07; 0x6D; 0x0A; 0x73; 0x18; 0xA5; 0x7D;
                        0x3C; 0x16; 0xC1; 0x72; 0x51; 0xB2; 0x66; 0x45;
                        0xDF; 0x4C; 0x2F; 0x87; 0xEB; 0xC0; 0x99; 0x2A;
                        0xB1; 0x77; 0xFB; 0xA5; 0x1D; 0xB9; 0x2C; 0x2A ]
                      |> List.map ~f:Char.of_int_exn
                      |> Bytes.of_char_list
                      |> Bytes.to_string
                      |> Helpers.string_to_ptr Ctypes.void
  in
  let alice = Sas.alloc () in
  begin
    C.Funcs.create_sas alice.sas alice_private (Helpers.size_of_int 32)
    |> Sas.check_error alice                   >>= fun _ ->
    Sas.set_their_pubkey alice bob_key         >>= fun _ ->
    Sas.calculate_mac alice message extra_info >>= fun alice_mac ->
    String.equal alice_mac expected_mac |> Result.ok_if_true ~error:"Wrong."
  end |> Result.is_ok
