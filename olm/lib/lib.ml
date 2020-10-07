open Ctypes
open Foreign

(* crypto.h defines *)
let sha256_output_length            = 32
let curve25519_key_length           = 32
let curve25519_shared_secret_length = 32
let curve25519_random_length        = curve25519_key_length
let ed25519_public_key_length       = 32
let ed25519_private_key_length      = 64
let ed25519_random_length           = 32
let ed25519_signature_length        = 64
let aes256_key_length               = 32
let aes256_iv_length                = 16

(* megolm.h defines *)
let megolm_ratchet_part_length = 32
let megolm_ratchet_parts       = 4
let megolm_ratchet_length      = megolm_ratchet_part_length * megolm_ratchet_parts

module Megolm = struct
  type t
  let t : t structure typ = structure "Megolm"
  let data                = field t "data" (array megolm_ratchet_parts
                                              (array megolm_ratchet_part_length uint8_t))
  let counter             = field t "counter" uint32_t
  let ()                  = seal t
end

module Aes256Key = struct
  type t
  let t : t structure typ = structure "_olm_aes256_key"
  let key                 = field t "key" (array aes256_key_length uint8_t)
  let ()                  = seal t
end

module Aes256Iv = struct
  type t
  let t : t structure typ = structure "_olm_aes256_iv"
  let iv                  = field t "iv" (array aes256_iv_length uint8_t)
  let ()                  = seal t
end

module OlmCurve25519PublicKey = struct
  type t
  let t : t structure typ = structure "_olm_curve25519_public_key"
  let public_key          = field t "public_key" (array curve25519_key_length uint8_t)
  let ()                  = seal t
end

module OlmCurve25519PrivateKey = struct
  type t
  let t : t structure typ = structure "_olm_Curve25519_private_key"
  let private_key         = field t "private_key" (array curve25519_key_length uint8_t)
  let ()                  = seal t
end

module OlmCurve25519KeyPair = struct
  type t
  let t : t structure typ = structure "_olm_curve25519_private_key"
  let public_key          = field t "public_key" OlmCurve25519PublicKey.t
  let private_key         = field t "private_key" OlmCurve25519PrivateKey.t
  let ()                  = seal t
end

module OlmED25519PublicKey = struct
  type t
  let t : t structure typ = structure "_olm_ed25519_public_key"
  let public_key          = field t "public_key" (array ed25519_public_key_length uint8_t)
  let ()                  = seal t
end

module OlmED25519PrivateKey = struct
  type t
  let t : t structure typ = structure "_olm_ed25519_private_key"
  let private_key         = field t "private_key" (array ed25519_private_key_length uint8_t)
  let ()                  = seal t
end

module OlmED25519KeyPair = struct
  type t
  let t : t structure typ = structure "_olm_ed25519_private_key"
  let public_key          = field t "public_key" OlmED25519PublicKey.t
  let private_key         = field t "private_key" OlmED25519PrivateKey.t
  let ()                  = seal t
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

module OlmOutboundGroupSession = struct
  type t
  let t : t structure typ = structure "OlmOutboundGroupSession"
  let ratchet             = field t "ratchet" Megolm.t
  let signing_key         = field t "signing_key" OlmED25519KeyPair.t
  let last_error          = field t "last_error" OlmErrorCode.t
  let ()                  = seal t
end

let olm_inbound_group_session_size =
  foreign "olm_inbound_group_session_size"
    (void @-> returning size_t)

let olm_inbound_group_session =
  foreign "olm_inbound_group_session"
    (void @-> returning (ptr OlmInboundGroupSession.t))

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
     @-> size_t                   (* key_length *)
     @-> ptr void                 (* pickled *)
     @-> size_t                   (* pickled_length *)
     @-> returning size_t)        (* olm_error *)

let olm_unpickle_inbound_group_session =
  foreign "olm_unpickle_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr void                 (* key *)
     @-> size_t                   (* key_length *)
     @-> ptr void                 (* pickled *)
     @-> size_t                   (* pickled_length *)
     @-> returning size_t)        (* olm_error *)

let olm_init_inbound_group_session =
  foreign "olm_init_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> uint8_t                  (* session_key *)
     @-> size_t                   (* session_key_length *)
     @-> returning size_t)        (* olm_error *)

let olm_import_inbound_group_session =
  foreign "olm_import_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> uint8_t                  (* session_key *)
     @-> size_t                   (* session_key_length *)
     @-> returning size_t)        (* olm_error *)

let olm_group_decrypt_max_plaintext_length =
  foreign "olm_group_decrypt_max_plaintext_length"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* message *)
     @-> size_t                   (* message_length *)
     @-> returning size_t)        (* olm_error *)

let olm_group_decrypt =
  foreign "olm_group_decrypt"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* message *)
     @-> size_t                   (* message_length *)
     @-> ptr uint8_t              (* plaintext *)
     @-> size_t                   (* max_plaintext_length *)
     @-> ptr uint32_t             (* message_index *)
     @-> returning size_t)        (* length of decrpyted plain-text or olm_error *)

let olm_inbound_group_session_id_length =
  foreign "olm_inbound_group_session_id_length"
    (ptr OlmInboundGroupSession.t @-> returning size_t)

let olm_inbound_group_session_id =
  foreign "olm_inbound_group_session_id"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* id *)
     @-> size_t                   (* id_length *)
     @-> returning size_t)        (* length of session id or olm_error *)

let olm_inbound_group_session_first_known_index =
  foreign "olm_inbound_group_session_first_known_index"
    (ptr OlmInboundGroupSession.t @-> returning uint32_t)

let olm_inbound_group_session_is_verified =
  foreign "olm_inbound_group_session_is_verified"
    (ptr OlmInboundGroupSession.t @-> returning int)

let olm_export_inbound_group_session_length =
  foreign "olm_export_inbound_group_session_length"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr uint8_t              (* key *)
     @-> size_t                   (* key_length *)
     @-> uint32_t                 (* message_index *)
     @-> returning size_t)        (* length of ratchet key or olm_error *)

let olm_outbound_group_session_size =
  foreign "olm_outbound_group_session_size"
    (void @-> returning size_t)

let olm_outbound_group_session =
  foreign "olm_outbound_group_session"
    (void @-> returning (ptr OlmOutboundGroupSession.t))

let olm_outbound_group_session_last_error =
  foreign "olm_outbound_group_session_last_error"
    (ptr OlmOutboundGroupSession.t @-> returning (ptr char))

let olm_clear_outbound_group_session =
  foreign "olm_clear_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> returning size_t)         (* olm_error *)

let olm_pickle_outbound_group_session_length =
  foreign "olm_pickle_outbound_group_session_length"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> returning size_t)         (* olm_error *)

let olm_pickle_outbound_group_session =
  foreign "olm_pickle_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr void                  (* key *)
     @-> size_t                    (* key_length *)
     @-> ptr void                  (* pickled *)
     @-> size_t                    (* pickled_length *)
     @-> returning size_t)         (* olm_error *)

let olm_unpickle_outbound_group_session =
  foreign "olm_unpickle_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr void                  (* key *)
     @-> size_t                    (* key_length *)
     @-> ptr void                  (* pickled *)
     @-> size_t                    (* pickled_length *)
     @-> returning size_t)         (* olm_error *)

let olm_init_outbound_group_session_random_length =
  foreign "olm_init_outbound_group_session_random_length"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> returning size_t)         (* olm_error *)

let olm_init_outbound_group_session =
  foreign "olm_init_outbound_group_session"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* random *)
     @-> size_t                    (* random_length *)
     @-> returning size_t)         (* olm_error *)

let olm_group_encrypt_message_length =
  foreign "olm_group_encrypt_message_length"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> size_t                    (* plaintext_length *)
     @-> returning size_t)         (* # bytes that will be created by encryption *)

let olm_group_encrypt =
  foreign "olm_group_encrypt"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* plaintext *)
     @-> size_t                    (* plaintext_length *)
     @-> ptr uint8_t               (* message *)
     @-> size_t                    (* message_length *)
     @-> returning size_t)         (* length of encrypted message or olm_error *)

let olm_outbound_group_session_id_length =
  foreign "olm_outbound_group_session_id_length"
    (ptr OlmOutboundGroupSession.t @-> returning size_t)

let olm_outbound_group_session_id =
  foreign "olm_outbound_group_session_id"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* id *)
     @-> size_t                    (* id_length *)
     @-> returning size_t)         (* length of session id or olm_error *)

let olm_outbound_group_session_message_index =
  foreign "olm_outbound_group_session_message_index"
    (ptr OlmOutboundGroupSession.t @-> returning uint32_t)

let olm_outbound_group_session_key_length =
  foreign "olm_outbound_group_session_key_length"
    (ptr OlmOutboundGroupSession.t @-> returning size_t)

let olm_export_outbound_group_session_key =
  foreign "olm_export_outbound_group_session_key"
    (ptr OlmOutboundGroupSession.t (* session *)
     @-> ptr uint8_t               (* key *)
     @-> size_t                    (* key_length *)
     @-> returning size_t)         (* length of ratchet key or olm_error *)
