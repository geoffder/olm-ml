open Ctypes
open Foreign

open Dynamic
open Crypto
open Megolm
open Error

module OlmInboundGroupSession = struct
  type t
  let t : t structure typ  = structure "OlmInboundGroupSession"
  let initial_ratchet      = field t "initial_ratchet" Megolm.t
  let latest_ratchet       = field t "latest_ratchet" Megolm.t
  let signing_key          = field t "signing_key" OlmED25519PublicKey.t
  let signing_key_verified = field t "signing_key_verified" int
  let last_error           = field t "last_error" OlmErrorCode.t
  let ()                   = seal t

  let allocate_void () : unit ptr =
    allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
end

let olm_inbound_group_session_size =
  foreign ~from:libolm "olm_inbound_group_session_size"
    (void @-> returning size_t)

let olm_inbound_group_session =
  foreign ~from:libolm "olm_inbound_group_session"
    (ptr void @-> returning (ptr OlmInboundGroupSession.t))

let olm_inbound_group_session_last_error =
  foreign ~from:libolm "olm_inbound_group_session_last_error"
    (ptr OlmInboundGroupSession.t @-> returning (ptr char))

let olm_clear_inbound_group_session =
  foreign ~from:libolm "olm_clear_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> returning size_t)        (* olm_error *)

let olm_pickle_inbound_group_session_length =
  foreign ~from:libolm "olm_pickle_inbound_group_session_length"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> returning size_t)        (* olm_error *)

let olm_pickle_inbound_group_session =
  foreign ~from:libolm "olm_pickle_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr void                 (* key *)
     @-> size_t                   (* key_length *)
     @-> ptr void                 (* pickled *)
     @-> size_t                   (* pickled_length *)
     @-> returning size_t)        (* olm_error *)

let olm_unpickle_inbound_group_session =
  foreign ~from:libolm "olm_unpickle_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr void                 (* key *)
     @-> size_t                   (* key_length *)
     @-> ptr void                 (* pickled *)
     @-> size_t                   (* pickled_length *)
     @-> returning size_t)        (* olm_error *)

let olm_init_inbound_group_session =
  foreign ~from:libolm "olm_init_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> uint8_t                  (* session_key *)
     @-> size_t                   (* session_key_length *)
     @-> returning size_t)        (* olm_error *)

let olm_import_inbound_group_session =
  foreign ~from:libolm "olm_import_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> uint8_t                  (* session_key *)
     @-> size_t                   (* session_key_length *)
     @-> returning size_t)        (* olm_error *)

let olm_group_decrypt_max_plaintext_length =
  foreign ~from:libolm "olm_group_decrypt_max_plaintext_length"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* message *)
     @-> size_t                   (* message_length *)
     @-> returning size_t)        (* olm_error *)

let olm_group_decrypt =
  foreign ~from:libolm "olm_group_decrypt"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* message *)
     @-> size_t                   (* message_length *)
     @-> ptr uint8_t              (* plaintext *)
     @-> size_t                   (* max_plaintext_length *)
     @-> ptr uint32_t             (* message_index *)
     @-> returning size_t)        (* length of decrpyted plain-text or olm_error *)

let olm_inbound_group_session_id_length =
  foreign ~from:libolm "olm_inbound_group_session_id_length"
    (ptr OlmInboundGroupSession.t @-> returning size_t)

let olm_inbound_group_session_id =
  foreign ~from:libolm "olm_inbound_group_session_id"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* id *)
     @-> size_t                   (* id_length *)
     @-> returning size_t)        (* length of session id or olm_error *)

let olm_inbound_group_session_first_known_index =
  foreign ~from:libolm "olm_inbound_group_session_first_known_index"
    (ptr OlmInboundGroupSession.t @-> returning uint32_t)

let olm_inbound_group_session_is_verified =
  foreign ~from:libolm "olm_inbound_group_session_is_verified"
    (ptr OlmInboundGroupSession.t @-> returning int)

let olm_export_inbound_group_session_length =
  foreign ~from:libolm "olm_export_inbound_group_session_length"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* key *)
     @-> size_t                   (* key_length *)
     @-> uint32_t                 (* message_index *)
     @-> returning size_t)        (* length of ratchet key or olm_error *)
