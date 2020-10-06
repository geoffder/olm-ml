open Ctypes
open Foreign

module Megolm = struct
  type t
  let t : t structure typ = structure "Megolm"
  let data                = field t "data" (array 4 (array 32 uint8_t))
  let counter             = field t "counter" uint32_t
  let ()                  = seal t
end

module OlmED25519PublicKey = struct
  type t = unit ptr
  let t : t typ = ptr void
end

module OlmErrorCode = struct
  type t = unit ptr
  let t : t typ = ptr void
end

module OlmInboundGroupSession = struct
  type t
  let t : t structure typ  = structure "OlmInboundGroupSession"
  let initial_ratchet      = field t "initial_ratchet" Megolm.t
  let latest_ratchet       = field t "latest_ratchet" Megolm.t
  let signing_key          = field t "signing_key" OlmED25519PublicKey.t
  let signing_key_verified = field t "signing_key_verified" int
  let last_error           = field t "last_error" OlmErrorCode.t
  let ()                   = seal t
end

(* NOTE: These are basically all approximations based on the rust bindings,
 * as I learn more about how to properly do this, I'll sweep through an fix them.
 * The fudged boilerplate will serve as a convenient skeleton though. *)

let olm_inbound_group_session_size =
  foreign "olm_inbound_group_session_size"
    (void @-> returning size_t)

let olm_inbound_group_session =
  foreign "olm_inbound_group_session"
    (void @-> returning OlmInboundGroupSession.t)

let olm_inbound_group_session_last_error =
  foreign "olm_inbound_group_session_last_error"
    (ptr OlmInboundGroupSession.t @-> returning (ptr char))

let olm_clear_inbound_group_session =
  foreign "olm_clear_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> returning size_t)        (* olm_error *)

let olm_pickle_inbound_group_session_length =
  foreign "olm_pickle_inbound_group_session_length"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> returning size_t)        (* olm_error *)

let olm_pickle_inbound_group_session =
  foreign "olm_pickle_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr void                 (* key *)
     @-> int                      (* key_length *)
     @-> ptr void                 (* pickled *)
     @-> int                      (* pickled_length *)
     @-> returning size_t)        (* olm_error *)

let olm_init_inbound_group_session =
  foreign "olm_init_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> int                      (* session_key *)
     @-> int                      (* session_key_length *)
     @-> returning size_t)        (* olm_error *)

let olm_import_inbound_group_session =
  foreign "olm_import_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> int                      (* session_key *)
     @-> int                      (* session_key_length *)
     @-> returning size_t)        (* olm_error *)

let olm_group_decrypt_max_plaintext_length =
  foreign "olm_group_decrypt_max_plaintext_length"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr int                  (* message *)
     @-> int                      (* message_length *)
     @-> returning size_t)        (* olm_error *)

let olm_group_decrypt =
  foreign "olm_group_decrypt"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr int                  (* message *)
     @-> int                      (* message_length *)
     @-> ptr int                  (* plaintext *)
     @-> int                      (* max_plaintext_length *)
     @-> ptr int                  (* message_index *)
     @-> returning size_t)        (* length of decrpyted plain-text or olm_error *)

let olm_inbound_group_session_id_length =
  foreign "olm_inbound_group_session_id_length"
    (ptr OlmInboundGroupSession.t @-> returning size_t)

let olm_inbound_group_session_id =
  foreign "olm_inbound_group_session_id"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr int                  (* id *)
     @-> int                      (* id_length *)
     @-> returning size_t)        (* length of session id or olm_error *)
