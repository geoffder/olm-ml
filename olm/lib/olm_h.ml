open Ctypes
open Foreign

open Dynamic

module OlmAccount = struct
  type t
  let t : t structure typ = structure "OlmAccount"
  (* let ()                  = seal t *)
end

module OlmSession = struct
  type t
  let t : t structure typ = structure "OlmSession"
  (* let ()                  = seal t *)
end

module OlmUtility = struct
  type t
  let t : t structure typ = structure "OlmUtility"
  (* let ()                  = seal t *)
end

let olm_get_library_version =
  foreign ~from:libolm "olm_get_library_version"
    (ptr uint8_t         (* major *)
     @-> ptr uint8_t     (* minor *)
     @-> ptr uint8_t     (* patch *)
     @-> returning void)

let olm_account_size =
  foreign ~from:libolm "olm_account_size"
    (void @-> returning size_t)

let olm_session_size =
  foreign ~from:libolm "olm_session_size"
    (void @-> returning size_t)

let olm_utility_size =
  foreign ~from:libolm "olm_utility_size"
    (void @-> returning size_t)

let olm_account =
  foreign ~from:libolm "olm_account"
    (ptr void @-> returning (ptr OlmAccount.t))

let olm_session =
  foreign ~from:libolm "olm_session"
    (ptr void @-> returning (ptr OlmSession.t))

let olm_utility =
  foreign ~from:libolm "olm_utility"
    (ptr void @-> returning (ptr OlmUtility.t))

let olm_error =
  foreign ~from:libolm "olm_error"
    (void @-> returning size_t)

let olm_account_last_error =
  foreign ~from:libolm "olm_account_last_error"
    (ptr OlmAccount.t @-> returning (ptr char))

let olm_session_last_error =
  foreign ~from:libolm "olm_session_last_error"
    (ptr OlmSession.t @-> returning (ptr char))

let olm_utility_last_error =
  foreign ~from:libolm "olm_utility_last_error"
    (ptr OlmUtility.t @-> returning (ptr char))

let olm_clear_account =
  foreign ~from:libolm "olm_clear_account"
    (ptr OlmAccount.t @-> returning size_t)

let olm_clear_session =
  foreign ~from:libolm "olm_clear_session"
    (ptr OlmSession.t @-> returning size_t)

let olm_clear_utility =
  foreign ~from:libolm "olm_clear_utility"
    (ptr OlmUtility.t @-> returning size_t)

let olm_pickle_account_length =
  foreign ~from:libolm "olm_pickle_account_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_pickle_session_length =
  foreign ~from:libolm "olm_pickle_session_length"
    (ptr OlmSession.t @-> returning size_t)

let olm_pickle_account =
  foreign ~from:libolm "olm_pickle_account"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* key *)
     @-> size_t            (* key_length *)
     @-> ptr void          (* pickled *)
     @-> size_t            (* pickled_length *)
     @-> returning size_t) (* length of pickled account or olm_error *)

let olm_pickle_session =
  foreign ~from:libolm "olm_pickle_session"
    (ptr OlmSession.t      (* session *)
     @-> ptr void          (* key *)
     @-> size_t            (* key_length *)
     @-> ptr void          (* pickled *)
     @-> size_t            (* pickled_length *)
     @-> returning size_t) (* length of pickled session or olm_error *)

let olm_unpickle_account =
  foreign ~from:libolm "olm_unpickle_account"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* key *)
     @-> size_t            (* key_length *)
     @-> ptr void          (* pickled *)
     @-> size_t            (* pickled_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_unpickle_session =
  foreign ~from:libolm "olm_unpickle_session"
    (ptr OlmSession.t      (* session *)
     @-> ptr void          (* key *)
     @-> size_t            (* key_length *)
     @-> ptr void          (* pickled *)
     @-> size_t            (* pickled_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_create_account_random_length =
  foreign ~from:libolm "olm_create_account_random_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_create_account =
  foreign ~from:libolm "olm_create_account"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* random *)
     @-> size_t            (* random_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_account_identity_keys_length =
  foreign ~from:libolm "olm_account_identity_keys_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_account_identity_keys =
  foreign ~from:libolm "olm_account_identity_keys"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* identity_keys *)
     @-> size_t            (* identity_keys_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_account_signature_length =
  foreign ~from:libolm "olm_account_signature_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_account_sign =
  foreign ~from:libolm "olm_account_sign"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* message *)
     @-> size_t            (* message_length *)
     @-> ptr void          (* signature *)
     @-> size_t            (* signature_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_account_one_time_keys_length =
  foreign ~from:libolm "olm_account_one_time_keys_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_account_one_time_keys =
  foreign ~from:libolm "olm_account_one_time_keys"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* one_time_keys *)
     @-> size_t            (* one_time_keys_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_account_mark_keys_as_published =
  foreign ~from:libolm "olm_account_mark_keys_as_published"
    (ptr OlmAccount.t @-> returning size_t)

let olm_account_max_number_of_one_time_keys =
  foreign ~from:libolm "olm_account_max_number_of_one_time_keys"
    (ptr OlmAccount.t @-> returning size_t)

let olm_account_generate_one_time_keys_random_length =
  foreign ~from:libolm "olm_account_generate_one_time_keys_random_length"
    (ptr OlmAccount.t      (* account *)
     @-> size_t            (* number_of_keys *)
     @-> returning size_t) (* number of random bytes needed *)

let olm_account_generate_one_time_keys =
  foreign ~from:libolm "olm_account_generate_one_time_keys"
    (ptr OlmAccount.t      (* account *)
     @-> size_t            (* number_of_keys *)
     @-> ptr void          (* random *)
     @-> size_t            (* random_length *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_account_generate_fallback_key_random_length =
  foreign ~from:libolm "olm_account_generate_fallback_key_random_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_account_generate_fallback_key =
  foreign ~from:libolm "olm_account_generate_fallback_key"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* random *)
     @-> size_t            (* random_length *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_account_fallback_key_length =
  foreign ~from:libolm "olm_account_fallback_key_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_account_fallback_key =
  foreign ~from:libolm "olm_account_generate_fallback_key"
    (ptr OlmAccount.t      (* account *)
     @-> ptr void          (* fallback_key *)
     @-> size_t            (* fallback_key_size *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_create_outbound_session_random_length =
  foreign ~from:libolm "olm_create_outbound_session_random_length"
    (ptr OlmAccount.t @-> returning size_t)

let olm_create_outbound_session =
  foreign ~from:libolm "olm_create_outbound_session"
    (ptr OlmSession.t      (* session *)
     @-> ptr OlmAccount.t  (* account *)
     @-> ptr void          (* their_identity_key *)
     @-> size_t            (* their_identity_key_length *)
     @-> ptr void          (* their_one_time_key *)
     @-> size_t            (* their_one_time_key_length *)
     @-> ptr void          (* random *)
     @-> size_t            (* random_length *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_create_inbound_session =
  foreign ~from:libolm "olm_create_inbound_session"
    (ptr OlmSession.t      (* session *)
     @-> ptr OlmAccount.t  (* account *)
     @-> ptr void          (* one_time_key_message *)
     @-> size_t            (* message_length *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_create_inbound_session_from =
  foreign ~from:libolm "olm_create_inbound_session_from"
    (ptr OlmSession.t      (* session *)
     @-> ptr OlmAccount.t  (* account *)
     @-> ptr void          (* their_identity_key *)
     @-> size_t            (* their_identity_key_length *)
     @-> ptr void          (* one_time_key_message *)
     @-> size_t            (* message_length *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_session_id_length =
  foreign ~from:libolm "olm_session_id_length"
    (ptr OlmSession.t @-> returning size_t)

let olm_session_id =
  foreign ~from:libolm "olm_session_id"
    (ptr OlmSession.t      (* session *)
     @-> ptr void          (* id *)
     @-> size_t            (* id_length *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_session_has_received_message =
  foreign ~from:libolm "olm_session_has_received_message"
    (ptr OlmSession.t @-> returning int)

let olm_session_describe =
  foreign ~from:libolm "olm_session_describe"
    (ptr OlmSession.t    (* session *)
     @-> ptr char        (* buf *)
     @-> size_t          (* buflen *)
     @-> returning void)

let olm_matches_inbound_session =
  foreign ~from:libolm "olm_matches_inbound_session"
    (ptr OlmSession.t      (* session *)
     @-> ptr void          (* one_time_key_message *)
     @-> size_t            (* message_length *)
     @-> returning size_t) (* 0 if no match, olm_errror on failure *)

let olm_matches_inbound_session_from =
  foreign ~from:libolm "olm_matches_inbound_session_from"
    (ptr OlmSession.t      (* session *)
     @-> ptr void          (* their_identity_key *)
     @-> size_t            (* their_identity_key_length *)
     @-> ptr void          (* one_time_key_message *)
     @-> size_t            (* message_length *)
     @-> returning size_t) (* 0 if no match, olm_errror on failure *)

let olm_encrypt_message_type =
  foreign ~from:libolm "olm_encrypt_message_type"
    (ptr OlmSession.t @-> returning size_t)

let olm_encrypt_random_length =
  foreign ~from:libolm "olm_encrypt_random_length"
    (ptr OlmSession.t @-> returning size_t)

let olm_encrypt_message_length =
  foreign ~from:libolm "olm_encrypt_message_length"
    (ptr OlmSession.t @-> returning size_t)

let olm_encrypt =
  foreign ~from:libolm "olm_encrypt"
    (ptr OlmSession.t      (* session *)
     @-> ptr void          (* plaintext *)
     @-> size_t            (* plaintext_length *)
     @-> ptr void          (* random *)
     @-> size_t            (* random_length *)
     @-> ptr void          (* message *)
     @-> size_t            (* message_length *)
     @-> returning size_t) (* olm_errror on failure *)

let olm_decrypt_max_plaintext_length =
  foreign ~from:libolm "olm_decrypt_max_plaintext_length"
    (ptr OlmSession.t      (* session *)
     @-> size_t            (* message_type *)
     @-> ptr void          (* message *)
     @-> size_t            (* message_length *)
     @-> returning size_t) (* max number of bytes or olm_errror on failure *)

let olm_decrypt =
  foreign ~from:libolm "olm_decrypt"
    (ptr OlmSession.t      (* session *)
     @-> size_t            (* message_type *)
     @-> ptr void          (* message *)
     @-> size_t            (* message_length *)
     @-> ptr void          (* plaintext *)
     @-> size_t            (* max_plaintext_length *)
     @-> returning size_t) (* length of the plaintext or olm_errror on failure *)

let olm_sha256_length =
  foreign ~from:libolm "olm_sha256_length"
    (ptr OlmUtility.t @-> returning size_t)

let olm_sha256 =
  foreign ~from:libolm "olm_sha256"
    (ptr OlmUtility.t      (* utility *)
     @-> ptr void          (* input *)
     @-> size_t            (* input_length *)
     @-> ptr void          (* output *)
     @-> size_t            (* output_length *)
     @-> returning size_t) (* olm_error on failure (?) *)

let olm_ed25519_verify =
  foreign ~from:libolm "olm_ed25519_verify"
    (ptr OlmSession.t      (* utility *)
     @-> ptr void          (* key *)
     @-> size_t            (* key_length *)
     @-> ptr void          (* message *)
     @-> size_t            (* message_length *)
     @-> ptr void          (* signature *)
     @-> size_t            (* signature_length *)
     @-> returning size_t) (* olm_error on failure (?) *)
