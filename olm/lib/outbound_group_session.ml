open Ctypes
open Foreign

open Dynamic
open Crypto
open Megolm
open Error

module OlmOutboundGroupSession = struct
  type t
  let t : t structure typ = structure "OlmOutboundGroupSession"
  let ratchet             = field t "ratchet" Megolm.t
  let signing_key         = field t "signing_key" OlmED25519KeyPair.t
  let last_error          = field t "last_error" OlmErrorCode.t
  let ()                  = seal t

  let allocate_void () : unit ptr =
    allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
end

let olm_outbound_group_session_size =
  foreign ~from:libolm "olm_outbound_group_session_size"
    (void @-> returning size_t)

let olm_outbound_group_session =
  foreign ~from:libolm "olm_outbound_group_session"
    (ptr void @-> returning (ptr OlmOutboundGroupSession.t))

let olm_outbound_group_session_last_error =
  foreign ~from:libolm "olm_outbound_group_session_last_error"
    (ptr OlmOutboundGroupSession.t @-> returning (ptr char))

let olm_clear_outbound_group_session =
  foreign ~from:libolm "olm_clear_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> returning size_t)         (* olm_error *)

let olm_pickle_outbound_group_session_length =
  foreign ~from:libolm "olm_pickle_outbound_group_session_length"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> returning size_t)         (* olm_error *)

let olm_pickle_outbound_group_session =
  foreign ~from:libolm "olm_pickle_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr void                  (* key *)
     @-> size_t                    (* key_length *)
     @-> ptr void                  (* pickled *)
     @-> size_t                    (* pickled_length *)
     @-> returning size_t)         (* olm_error *)

let olm_unpickle_outbound_group_session =
  foreign ~from:libolm "olm_unpickle_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr void                  (* key *)
     @-> size_t                    (* key_length *)
     @-> ptr void                  (* pickled *)
     @-> size_t                    (* pickled_length *)
     @-> returning size_t)         (* olm_error *)

let olm_init_outbound_group_session_random_length =
  foreign ~from:libolm "olm_init_outbound_group_session_random_length"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> returning size_t)         (* olm_error *)

let olm_init_outbound_group_session =
  foreign ~from:libolm "olm_init_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* random *)
     @-> size_t                    (* random_length *)
     @-> returning size_t)         (* olm_error *)

let olm_group_encrypt_message_length =
  foreign ~from:libolm "olm_group_encrypt_message_length"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> size_t                    (* plaintext_length *)
     @-> returning size_t)         (* # bytes that will be created by encryption *)

let olm_group_encrypt =
  foreign ~from:libolm "olm_group_encrypt"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* plaintext *)
     @-> size_t                    (* plaintext_length *)
     @-> ptr uint8_t               (* message *)
     @-> size_t                    (* message_length *)
     @-> returning size_t)         (* length of encrypted message or olm_error *)

let olm_outbound_group_session_id_length =
  foreign ~from:libolm "olm_outbound_group_session_id_length"
    (ptr OlmOutboundGroupSession.t @-> returning size_t)

let olm_outbound_group_session_id =
  foreign ~from:libolm "olm_outbound_group_session_id"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* id *)
     @-> size_t                    (* id_length *)
     @-> returning size_t)         (* length of session id or olm_error *)

let olm_outbound_group_session_message_index =
  foreign ~from:libolm "olm_outbound_group_session_message_index"
    (ptr OlmOutboundGroupSession.t @-> returning uint32_t)

let olm_outbound_group_session_key_length =
  foreign ~from:libolm "olm_outbound_group_session_key_length"
    (ptr OlmOutboundGroupSession.t @-> returning size_t)

let olm_outbound_group_session_key =
  foreign ~from:libolm "olm_outbound_group_session_key"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* key to be used for next message *)
     @-> returning size_t)         (* length of ratchet key or olm_error *)
