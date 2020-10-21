(* open Ctypes
 * open Foreign
 *
 * let libolm =
 *   Dl.dlopen
 *     ~filename:"/home/geoff/GitRepos/ocaml-olm/libolm/build/libolm.so"
 *     ~flags:Dl.[ RTLD_NOW ]
 *
 * (\* crypto.h defines *\)
 * let sha256_output_length            = 32
 * let curve25519_key_length           = 32
 * let curve25519_shared_secret_length = 32
 * let curve25519_random_length        = curve25519_key_length
 * let ed25519_public_key_length       = 32
 * let ed25519_private_key_length      = 64
 * let ed25519_random_length           = 32
 * let ed25519_signature_length        = 64
 * let aes256_key_length               = 32
 * let aes256_iv_length                = 16
 *
 * (\* megolm.h defines *\)
 * let megolm_ratchet_part_length = 32
 * let megolm_ratchet_parts       = 4
 * let megolm_ratchet_length      = megolm_ratchet_part_length * megolm_ratchet_parts
 *
 * module Megolm = struct
 *   type t
 *   let t : t structure typ = structure "Megolm"
 *   let data                = field t "data" (array megolm_ratchet_parts
 *                                               (array megolm_ratchet_part_length uint8_t))
 *   let counter             = field t "counter" uint32_t
 *   let ()                  = seal t
 * end
 *
 * module OlmAes256Key = struct
 *   type t
 *   let t : t structure typ = structure "_olm_aes256_key"
 *   let key                 = field t "key" (array aes256_key_length uint8_t)
 *   let ()                  = seal t
 * end
 *
 * module OlmAes256Iv = struct
 *   type t
 *   let t : t structure typ = structure "_olm_aes256_iv"
 *   let iv                  = field t "iv" (array aes256_iv_length uint8_t)
 *   let ()                  = seal t
 * end
 *
 * module OlmCurve25519PublicKey = struct
 *   type t
 *   let t : t structure typ = structure "_olm_curve25519_public_key"
 *   let public_key          = field t "public_key" (array curve25519_key_length uint8_t)
 *   let ()                  = seal t
 * end
 *
 * module OlmCurve25519PrivateKey = struct
 *   type t
 *   let t : t structure typ = structure "_olm_curve25519_private_key"
 *   let private_key         = field t "private_key" (array curve25519_key_length uint8_t)
 *   let ()                  = seal t
 * end
 *
 * module OlmCurve25519KeyPair = struct
 *   type t
 *   let t : t structure typ = structure "_olm_curve25519_key_pair"
 *   let public_key          = field t "public_key" OlmCurve25519PublicKey.t
 *   let private_key         = field t "private_key" OlmCurve25519PrivateKey.t
 *   let ()                  = seal t
 * end
 *
 * module OlmED25519PublicKey = struct
 *   type t
 *   let t : t structure typ = structure "_olm_ed25519_public_key"
 *   let public_key          = field t "public_key" (array ed25519_public_key_length uint8_t)
 *   let ()                  = seal t
 * end
 *
 * module OlmED25519PrivateKey = struct
 *   type t
 *   let t : t structure typ = structure "_olm_ed25519_private_key"
 *   let private_key         = field t "private_key" (array ed25519_private_key_length uint8_t)
 *   let ()                  = seal t
 * end
 *
 * module OlmED25519KeyPair = struct
 *   type t
 *   let t : t structure typ = structure "_olm_ed25519_key_pair"
 *   let public_key          = field t "public_key" OlmED25519PublicKey.t
 *   let private_key         = field t "private_key" OlmED25519PrivateKey.t
 *   let ()                  = seal t
 * end
 *
 * module OlmErrorCode = struct
 *   type t =
 *     | OLM_SUCCESS
 *     | OLM_NOT_ENOUGH_RANDOM
 *     | OLM_OUTPUT_BUFFER_TOO_SMALL
 *     | OLM_BAD_MESSAGE_VERSION
 *     | OLM_BAD_MESSAGE_FORMAT
 *     | OLM_BAD_MESSAGE_MAC
 *     | OLM_BAD_MESSAGE_KEY_ID
 *     | OLM_INVALID_BASE64
 *     | OLM_BAD_ACCOUNT_KEY
 *     | OLM_UNKNOWN_PICKLE_VERSION
 *     | OLM_CORRUPTED_PICKLE
 *     | OLM_BAD_SESSION_KEY
 *     | OLM_UNKNOWN_MESSAGE_INDEX
 *     | OLM_BAD_LEGACY_ACCOUNT_PICKLE
 *     | OLM_BAD_SIGNATURE
 *     | OLM_INPUT_BUFFER_TOO_SMALL
 *     | OLM_SAS_THEIR_KEY_NOT_SET
 *
 *   let of_int = function
 *     | 0  -> OLM_SUCCESS
 *     | 1  -> OLM_NOT_ENOUGH_RANDOM
 *     | 2  -> OLM_OUTPUT_BUFFER_TOO_SMALL
 *     | 3  -> OLM_BAD_MESSAGE_VERSION
 *     | 4  -> OLM_BAD_MESSAGE_FORMAT
 *     | 5  -> OLM_BAD_MESSAGE_MAC
 *     | 6  -> OLM_BAD_MESSAGE_KEY_ID
 *     | 7  -> OLM_INVALID_BASE64
 *     | 8  -> OLM_BAD_ACCOUNT_KEY
 *     | 9  -> OLM_UNKNOWN_PICKLE_VERSION
 *     | 10 -> OLM_CORRUPTED_PICKLE
 *     | 11 -> OLM_BAD_SESSION_KEY
 *     | 12 -> OLM_UNKNOWN_MESSAGE_INDEX
 *     | 13 -> OLM_BAD_LEGACY_ACCOUNT_PICKLE
 *     | 14 -> OLM_BAD_SIGNATURE
 *     | 15 -> OLM_INPUT_BUFFER_TOO_SMALL
 *     | 16 -> OLM_SAS_THEIR_KEY_NOT_SET
 *     | _ -> raise (Invalid_argument "Unexpected OlmErrorCode value.")
 *
 *   let to_int = function
 *     | OLM_SUCCESS                   -> 0
 *     | OLM_NOT_ENOUGH_RANDOM         -> 1
 *     | OLM_OUTPUT_BUFFER_TOO_SMALL   -> 2
 *     | OLM_BAD_MESSAGE_VERSION       -> 3
 *     | OLM_BAD_MESSAGE_FORMAT        -> 4
 *     | OLM_BAD_MESSAGE_MAC           -> 5
 *     | OLM_BAD_MESSAGE_KEY_ID        -> 6
 *     | OLM_INVALID_BASE64            -> 7
 *     | OLM_BAD_ACCOUNT_KEY           -> 8
 *     | OLM_UNKNOWN_PICKLE_VERSION    -> 9
 *     | OLM_CORRUPTED_PICKLE          -> 10
 *     | OLM_BAD_SESSION_KEY           -> 11
 *     | OLM_UNKNOWN_MESSAGE_INDEX     -> 12
 *     | OLM_BAD_LEGACY_ACCOUNT_PICKLE -> 13
 *     | OLM_BAD_SIGNATURE             -> 14
 *     | OLM_INPUT_BUFFER_TOO_SMALL    -> 15
 *     | OLM_SAS_THEIR_KEY_NOT_SET     -> 16
 *
 *   let to_string = function
 *     | OLM_SUCCESS                   -> "olm_success"
 *     | OLM_NOT_ENOUGH_RANDOM         -> "olm_not_enough_random"
 *     | OLM_OUTPUT_BUFFER_TOO_SMALL   -> "olm_output_buffer_too_small"
 *     | OLM_BAD_MESSAGE_VERSION       -> "olm_bad_message_version"
 *     | OLM_BAD_MESSAGE_FORMAT        -> "olm_bad_message_format"
 *     | OLM_BAD_MESSAGE_MAC           -> "olm_bad_message_mac"
 *     | OLM_BAD_MESSAGE_KEY_ID        -> "olm_bad_message_key_id"
 *     | OLM_INVALID_BASE64            -> "olm_invalid_base64"
 *     | OLM_BAD_ACCOUNT_KEY           -> "olm_bad_account_key"
 *     | OLM_UNKNOWN_PICKLE_VERSION    -> "olm_unknown_pickle_version"
 *     | OLM_CORRUPTED_PICKLE          -> "olm_corrupted_pickle"
 *     | OLM_BAD_SESSION_KEY           -> "olm_bad_session_key"
 *     | OLM_UNKNOWN_MESSAGE_INDEX     -> "olm_unknown_message_index"
 *     | OLM_BAD_LEGACY_ACCOUNT_PICKLE -> "olm_bad_legacy_account_pickle"
 *     | OLM_BAD_SIGNATURE             -> "olm_bad_signature"
 *     | OLM_INPUT_BUFFER_TOO_SMALL    -> "olm_input_buffer_too_small"
 *     | OLM_SAS_THEIR_KEY_NOT_SET     -> "olm_sas_their_key_not_set"
 *
 *   let t = view ~read:of_int ~write:to_int int
 * end
 *
 * module OlmInboundGroupSession = struct
 *   type t
 *   let t : t structure typ  = structure "OlmInboundGroupSession"
 *   let initial_ratchet      = field t "initial_ratchet" Megolm.t
 *   let latest_ratchet       = field t "latest_ratchet" Megolm.t
 *   let signing_key          = field t "signing_key" OlmED25519PublicKey.t
 *   let signing_key_verified = field t "signing_key_verified" int
 *   let last_error           = field t "last_error" OlmErrorCode.t
 *   let ()                   = seal t
 *
 *   let allocate_void () : unit ptr =
 *     allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
 * end
 *
 * module OlmOutboundGroupSession = struct
 *   type t
 *   let t : t structure typ = structure "OlmOutboundGroupSession"
 *   let ratchet             = field t "ratchet" Megolm.t
 *   let signing_key         = field t "signing_key" OlmED25519KeyPair.t
 *   let last_error          = field t "last_error" OlmErrorCode.t
 *   let ()                  = seal t
 *
 *   let allocate_void () : unit ptr =
 *     allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
 * end
 *
 * module OlmAccount = struct
 *   type t
 *   let t : t structure typ = structure "OlmAccount"
 *   let ()                  = seal t
 * end
 *
 * module OlmSession = struct
 *   type t
 *   let t : t structure typ = structure "OlmSession"
 *   let ()                  = seal t
 * end
 *
 * module OlmUtility = struct
 *   type t
 *   let t : t structure typ = structure "OlmUtility"
 *   let ()                  = seal t
 * end
 *
 * (\* inbound_group_session.h *\)
 *
 * let olm_inbound_group_session_size =
 *   foreign (\* ~from:libolm *\) "olm_inbound_group_session_size"
 *     (void @-> returning size_t)
 *
 * let olm_inbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_inbound_group_session"
 *     (ptr void @-> returning (ptr OlmInboundGroupSession.t))
 *
 * let olm_inbound_group_session_last_error =
 *   foreign (\* ~from:libolm *\) "olm_inbound_group_session_last_error"
 *     (ptr OlmInboundGroupSession.t @-> returning (ptr char))
 *
 * let olm_clear_inbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_clear_inbound_group_session"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> returning size_t)        (\* olm_error *\)
 *
 * let olm_pickle_inbound_group_session_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_inbound_group_session_length"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> returning size_t)        (\* olm_error *\)
 *
 * let olm_pickle_inbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_pickle_inbound_group_session"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> ptr void                 (\* key *\)
 *      @-> size_t                   (\* key_length *\)
 *      @-> ptr void                 (\* pickled *\)
 *      @-> size_t                   (\* pickled_length *\)
 *      @-> returning size_t)        (\* olm_error *\)
 *
 * let olm_unpickle_inbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_unpickle_inbound_group_session"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> ptr void                 (\* key *\)
 *      @-> size_t                   (\* key_length *\)
 *      @-> ptr void                 (\* pickled *\)
 *      @-> size_t                   (\* pickled_length *\)
 *      @-> returning size_t)        (\* olm_error *\)
 *
 * let olm_init_inbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_init_inbound_group_session"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> uint8_t                  (\* session_key *\)
 *      @-> size_t                   (\* session_key_length *\)
 *      @-> returning size_t)        (\* olm_error *\)
 *
 * let olm_import_inbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_import_inbound_group_session"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> uint8_t                  (\* session_key *\)
 *      @-> size_t                   (\* session_key_length *\)
 *      @-> returning size_t)        (\* olm_error *\)
 *
 * let olm_group_decrypt_max_plaintext_length =
 *   foreign (\* ~from:libolm *\) "olm_group_decrypt_max_plaintext_length"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t              (\* message *\)
 *      @-> size_t                   (\* message_length *\)
 *      @-> returning size_t)        (\* olm_error *\)
 *
 * let olm_group_decrypt =
 *   foreign (\* ~from:libolm *\) "olm_group_decrypt"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t              (\* message *\)
 *      @-> size_t                   (\* message_length *\)
 *      @-> ptr uint8_t              (\* plaintext *\)
 *      @-> size_t                   (\* max_plaintext_length *\)
 *      @-> ptr uint32_t             (\* message_index *\)
 *      @-> returning size_t)        (\* length of decrpyted plain-text or olm_error *\)
 *
 * let olm_inbound_group_session_id_length =
 *   foreign (\* ~from:libolm *\) "olm_inbound_group_session_id_length"
 *     (ptr OlmInboundGroupSession.t @-> returning size_t)
 *
 * let olm_inbound_group_session_id =
 *   foreign (\* ~from:libolm *\) "olm_inbound_group_session_id"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t              (\* id *\)
 *      @-> size_t                   (\* id_length *\)
 *      @-> returning size_t)        (\* length of session id or olm_error *\)
 *
 * let olm_inbound_group_session_first_known_index =
 *   foreign (\* ~from:libolm *\) "olm_inbound_group_session_first_known_index"
 *     (ptr OlmInboundGroupSession.t @-> returning uint32_t)
 *
 * let olm_inbound_group_session_is_verified =
 *   foreign (\* ~from:libolm *\) "olm_inbound_group_session_is_verified"
 *     (ptr OlmInboundGroupSession.t @-> returning int)
 *
 * let olm_export_inbound_group_session_length =
 *   foreign (\* ~from:libolm *\) "olm_export_inbound_group_session_length"
 *     (ptr OlmInboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t              (\* key *\)
 *      @-> size_t                   (\* key_length *\)
 *      @-> uint32_t                 (\* message_index *\)
 *      @-> returning size_t)        (\* length of ratchet key or olm_error *\)
 *
 * (\* outbound_group_session.h *\)
 *
 * let olm_outbound_group_session_size =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session_size"
 *     (void @-> returning size_t)
 *
 * let olm_outbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session"
 *     (ptr void @-> returning (ptr OlmOutboundGroupSession.t))
 *
 * let olm_outbound_group_session_last_error =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session_last_error"
 *     (ptr OlmOutboundGroupSession.t @-> returning (ptr char))
 *
 * let olm_clear_outbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_clear_outbound_group_session"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> returning size_t)         (\* olm_error *\)
 *
 * let olm_pickle_outbound_group_session_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_outbound_group_session_length"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> returning size_t)         (\* olm_error *\)
 *
 * let olm_pickle_outbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_pickle_outbound_group_session"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> ptr void                  (\* key *\)
 *      @-> size_t                    (\* key_length *\)
 *      @-> ptr void                  (\* pickled *\)
 *      @-> size_t                    (\* pickled_length *\)
 *      @-> returning size_t)         (\* olm_error *\)
 *
 * let olm_unpickle_outbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_unpickle_outbound_group_session"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> ptr void                  (\* key *\)
 *      @-> size_t                    (\* key_length *\)
 *      @-> ptr void                  (\* pickled *\)
 *      @-> size_t                    (\* pickled_length *\)
 *      @-> returning size_t)         (\* olm_error *\)
 *
 * let olm_init_outbound_group_session_random_length =
 *   foreign (\* ~from:libolm *\) "olm_init_outbound_group_session_random_length"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> returning size_t)         (\* olm_error *\)
 *
 * let olm_init_outbound_group_session =
 *   foreign (\* ~from:libolm *\) "olm_init_outbound_group_session"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t               (\* random *\)
 *      @-> size_t                    (\* random_length *\)
 *      @-> returning size_t)         (\* olm_error *\)
 *
 * let olm_group_encrypt_message_length =
 *   foreign (\* ~from:libolm *\) "olm_group_encrypt_message_length"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> size_t                    (\* plaintext_length *\)
 *      @-> returning size_t)         (\* # bytes that will be created by encryption *\)
 *
 * let olm_group_encrypt =
 *   foreign (\* ~from:libolm *\) "olm_group_encrypt"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t               (\* plaintext *\)
 *      @-> size_t                    (\* plaintext_length *\)
 *      @-> ptr uint8_t               (\* message *\)
 *      @-> size_t                    (\* message_length *\)
 *      @-> returning size_t)         (\* length of encrypted message or olm_error *\)
 *
 * let olm_outbound_group_session_id_length =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session_id_length"
 *     (ptr OlmOutboundGroupSession.t @-> returning size_t)
 *
 * let olm_outbound_group_session_id =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session_id"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t               (\* id *\)
 *      @-> size_t                    (\* id_length *\)
 *      @-> returning size_t)         (\* length of session id or olm_error *\)
 *
 * let olm_outbound_group_session_message_index =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session_message_index"
 *     (ptr OlmOutboundGroupSession.t @-> returning uint32_t)
 *
 * let olm_outbound_group_session_key_length =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session_key_length"
 *     (ptr OlmOutboundGroupSession.t @-> returning size_t)
 *
 * let olm_outbound_group_session_key =
 *   foreign (\* ~from:libolm *\) "olm_outbound_group_session_key"
 *     (ptr OlmOutboundGroupSession.t (\* session *\)
 *      @-> ptr uint8_t               (\* key to be used for next message *\)
 *      @-> returning size_t)         (\* length of ratchet key or olm_error *\)
 *
 * (\* olm.h *\)
 *
 * let olm_get_library_version =
 *   foreign (\* ~from:libolm *\) "olm_get_library_version"
 *     (ptr uint8_t         (\* major *\)
 *      @-> ptr uint8_t     (\* minor *\)
 *      @-> ptr uint8_t     (\* patch *\)
 *      @-> returning void)
 *
 * let olm_account_size =
 *   foreign (\* ~from:libolm *\) "olm_account_size"
 *     (void @-> returning size_t)
 *
 * let olm_session_size =
 *   foreign (\* ~from:libolm *\) "olm_session_size"
 *     (void @-> returning size_t)
 *
 * let olm_utility_size =
 *   foreign (\* ~from:libolm *\) "olm_utility_size"
 *     (void @-> returning size_t)
 *
 * let olm_account =
 *   foreign (\* ~from:libolm *\) "olm_account"
 *     (ptr void @-> returning (ptr OlmAccount.t))
 *
 * let olm_session =
 *   foreign (\* ~from:libolm *\) "olm_session"
 *     (ptr void @-> returning (ptr OlmSession.t))
 *
 * let olm_utility =
 *   foreign (\* ~from:libolm *\) "olm_utility"
 *     (ptr void @-> returning (ptr OlmUtility.t))
 *
 * let olm_error =
 *   foreign (\* ~from:libolm *\) "olm_error"
 *     (void @-> returning size_t)
 *
 * let olm_account_last_error =
 *   foreign (\* ~from:libolm *\) "olm_account_last_error"
 *     (ptr OlmAccount.t @-> returning (ptr char))
 *
 * let olm_session_last_error =
 *   foreign (\* ~from:libolm *\) "olm_session_last_error"
 *     (ptr OlmSession.t @-> returning (ptr char))
 *
 * let olm_utility_last_error =
 *   foreign (\* ~from:libolm *\) "olm_utility_last_error"
 *     (ptr OlmUtility.t @-> returning (ptr char))
 *
 * let olm_clear_account =
 *   foreign (\* ~from:libolm *\) "olm_clear_account"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_clear_session =
 *   foreign (\* ~from:libolm *\) "olm_clear_session"
 *     (ptr OlmSession.t @-> returning size_t)
 *
 * let olm_clear_utility =
 *   foreign (\* ~from:libolm *\) "olm_clear_utility"
 *     (ptr OlmUtility.t @-> returning size_t)
 *
 * let olm_pickle_account_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_account_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_pickle_session_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_session_length"
 *     (ptr OlmSession.t @-> returning size_t)
 *
 * let olm_pickle_account =
 *   foreign (\* ~from:libolm *\) "olm_pickle_account"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr void          (\* pickled *\)
 *      @-> size_t            (\* pickled_length *\)
 *      @-> returning size_t) (\* length of pickled account or olm_error *\)
 *
 * let olm_pickle_session =
 *   foreign (\* ~from:libolm *\) "olm_pickle_session"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr void          (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr void          (\* pickled *\)
 *      @-> size_t            (\* pickled_length *\)
 *      @-> returning size_t) (\* length of pickled session or olm_error *\)
 *
 * let olm_unpickle_account =
 *   foreign (\* ~from:libolm *\) "olm_unpickle_account"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr void          (\* pickled *\)
 *      @-> size_t            (\* pickled_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_unpickle_session =
 *   foreign (\* ~from:libolm *\) "olm_unpickle_session"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr void          (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr void          (\* pickled *\)
 *      @-> size_t            (\* pickled_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_create_account_random_length =
 *   foreign (\* ~from:libolm *\) "olm_create_account_random_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_create_account =
 *   foreign (\* ~from:libolm *\) "olm_create_account"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* random *\)
 *      @-> size_t            (\* random_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_account_identity_keys_length =
 *   foreign (\* ~from:libolm *\) "olm_account_identity_keys_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_account_identity_keys =
 *   foreign (\* ~from:libolm *\) "olm_account_identity_keys"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* identity_keys *\)
 *      @-> size_t            (\* identity_keys_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_account_signature_length =
 *   foreign (\* ~from:libolm *\) "olm_account_signature_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_account_sign =
 *   foreign (\* ~from:libolm *\) "olm_account_sign"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> ptr void          (\* signature *\)
 *      @-> size_t            (\* signature_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_account_one_time_keys_length =
 *   foreign (\* ~from:libolm *\) "olm_account_one_time_keys_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_account_one_time_keys =
 *   foreign (\* ~from:libolm *\) "olm_account_one_time_keys"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* one_time_keys *\)
 *      @-> size_t            (\* one_time_keys_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_account_mark_keys_as_published =
 *   foreign (\* ~from:libolm *\) "olm_account_mark_keys_as_published"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_account_max_number_of_one_time_keys =
 *   foreign (\* ~from:libolm *\) "olm_account_max_number_of_one_time_keys"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_account_generate_one_time_keys_random_length =
 *   foreign (\* ~from:libolm *\) "olm_account_generate_one_time_keys_random_length"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> size_t            (\* number_of_keys *\)
 *      @-> returning size_t) (\* number of random bytes needed *\)
 *
 * let olm_account_generate_one_time_keys =
 *   foreign (\* ~from:libolm *\) "olm_account_generate_one_time_keys"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> size_t            (\* number_of_keys *\)
 *      @-> ptr void          (\* random *\)
 *      @-> size_t            (\* random_length *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_account_generate_fallback_key_random_length =
 *   foreign (\* ~from:libolm *\) "olm_account_generate_fallback_key_random_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_account_generate_fallback_key =
 *   foreign (\* ~from:libolm *\) "olm_account_generate_fallback_key"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* random *\)
 *      @-> size_t            (\* random_length *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_account_fallback_key_length =
 *   foreign (\* ~from:libolm *\) "olm_account_fallback_key_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_account_fallback_key =
 *   foreign (\* ~from:libolm *\) "olm_account_generate_fallback_key"
 *     (ptr OlmAccount.t      (\* account *\)
 *      @-> ptr void          (\* fallback_key *\)
 *      @-> size_t            (\* fallback_key_size *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_create_outbound_session_random_length =
 *   foreign (\* ~from:libolm *\) "olm_create_outbound_session_random_length"
 *     (ptr OlmAccount.t @-> returning size_t)
 *
 * let olm_create_outbound_session =
 *   foreign (\* ~from:libolm *\) "olm_create_outbound_session"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr OlmAccount.t  (\* account *\)
 *      @-> ptr void          (\* their_identity_key *\)
 *      @-> size_t            (\* their_identity_key_length *\)
 *      @-> ptr void          (\* their_one_time_key *\)
 *      @-> size_t            (\* their_one_time_key_length *\)
 *      @-> ptr void          (\* random *\)
 *      @-> size_t            (\* random_length *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_create_inbound_session =
 *   foreign (\* ~from:libolm *\) "olm_create_inbound_session"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr OlmAccount.t  (\* account *\)
 *      @-> ptr void          (\* one_time_key_message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_create_inbound_session_from =
 *   foreign (\* ~from:libolm *\) "olm_create_inbound_session_from"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr OlmAccount.t  (\* account *\)
 *      @-> ptr void          (\* their_identity_key *\)
 *      @-> size_t            (\* their_identity_key_length *\)
 *      @-> ptr void          (\* one_time_key_message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_session_id_length =
 *   foreign (\* ~from:libolm *\) "olm_session_id_length"
 *     (ptr OlmSession.t @-> returning size_t)
 *
 * let olm_session_id =
 *   foreign (\* ~from:libolm *\) "olm_session_id"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr void          (\* id *\)
 *      @-> size_t            (\* id_length *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_session_has_received_message =
 *   foreign (\* ~from:libolm *\) "olm_session_has_received_message"
 *     (ptr OlmSession.t @-> returning int)
 *
 * let olm_session_describe =
 *   foreign (\* ~from:libolm *\) "olm_session_describe"
 *     (ptr OlmSession.t    (\* session *\)
 *      @-> ptr char        (\* buf *\)
 *      @-> size_t          (\* buflen *\)
 *      @-> returning void)
 *
 * let olm_matches_inbound_session =
 *   foreign (\* ~from:libolm *\) "olm_matches_inbound_session"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr void          (\* one_time_key_message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> returning size_t) (\* 0 if no match, olm_errror on failure *\)
 *
 * let olm_matches_inbound_session_from =
 *   foreign (\* ~from:libolm *\) "olm_matches_inbound_session_from"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr void          (\* their_identity_key *\)
 *      @-> size_t            (\* their_identity_key_length *\)
 *      @-> ptr void          (\* one_time_key_message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> returning size_t) (\* 0 if no match, olm_errror on failure *\)
 *
 * let olm_encrypt_message_type =
 *   foreign (\* ~from:libolm *\) "olm_encrypt_message_type"
 *     (ptr OlmSession.t @-> returning size_t)
 *
 * let olm_encrypt_random_length =
 *   foreign (\* ~from:libolm *\) "olm_encrypt_random_length"
 *     (ptr OlmSession.t @-> returning size_t)
 *
 * let olm_encrypt_message_length =
 *   foreign (\* ~from:libolm *\) "olm_encrypt_message_length"
 *     (ptr OlmSession.t @-> returning size_t)
 *
 * let olm_encrypt =
 *   foreign (\* ~from:libolm *\) "olm_encrypt"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> ptr void          (\* plaintext *\)
 *      @-> size_t            (\* plaintext_length *\)
 *      @-> ptr void          (\* random *\)
 *      @-> size_t            (\* random_length *\)
 *      @-> ptr void          (\* message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> returning size_t) (\* olm_errror on failure *\)
 *
 * let olm_decrypt_max_plaintext_length =
 *   foreign (\* ~from:libolm *\) "olm_decrypt_max_plaintext_length"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> size_t            (\* message_type *\)
 *      @-> ptr void          (\* message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> returning size_t) (\* max number of bytes or olm_errror on failure *\)
 *
 * let olm_decrypt =
 *   foreign (\* ~from:libolm *\) "olm_decrypt"
 *     (ptr OlmSession.t      (\* session *\)
 *      @-> size_t            (\* message_type *\)
 *      @-> ptr void          (\* message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> ptr void          (\* plaintext *\)
 *      @-> size_t            (\* max_plaintext_length *\)
 *      @-> returning size_t) (\* length of the plaintext or olm_errror on failure *\)
 *
 * let olm_sha256_length =
 *   foreign (\* ~from:libolm *\) "olm_sha256_length"
 *     (ptr OlmUtility.t @-> returning size_t)
 *
 * let olm_sha256 =
 *   foreign (\* ~from:libolm *\) "olm_sha256"
 *     (ptr OlmUtility.t      (\* utility *\)
 *      @-> ptr void          (\* input *\)
 *      @-> size_t            (\* input_length *\)
 *      @-> ptr void          (\* output *\)
 *      @-> size_t            (\* output_length *\)
 *      @-> returning size_t) (\* olm_error on failure (?) *\)
 *
 * let olm_ed25519_verify =
 *   foreign (\* ~from:libolm *\) "olm_ed25519_verify"
 *     (ptr OlmSession.t      (\* utility *\)
 *      @-> ptr void          (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr void          (\* message *\)
 *      @-> size_t            (\* message_length *\)
 *      @-> ptr void          (\* signature *\)
 *      @-> size_t            (\* signature_length *\)
 *      @-> returning size_t) (\* olm_error on failure (?) *\)
 *
 * (\* megolm.h *\)
 *
 * let megolm_init =
 *   foreign (\* ~from:libolm *\) "megolm_init"
 *     (ptr Megolm.t        (\* megolm *\)
 *      @-> ptr uint8_t     (\* random_data *\)
 *      @-> uint32_t        (\* counter *\)
 *      @-> returning void)
 *
 * let megolm_pickle_length =
 *   foreign (\* ~from:libolm *\) "megolm_pickle_length"
 *     (ptr Megolm.t @-> returning size_t)
 *
 * let megolm_pickle =
 *   foreign (\* ~from:libolm *\) "megolm_pickle"
 *     (ptr Megolm.t                 (\* megolm *\)
 *      @-> ptr uint8_t              (\* pos *\)
 *      @-> returning (ptr uint8_t)) (\* pointer to next free space in the buffer *\)
 *
 * let megolm_unpickle =
 *   foreign (\* ~from:libolm *\) "megolm_unpickle"
 *     (ptr Megolm.t                 (\* megolm *\)
 *      @-> ptr uint8_t              (\* pos *\)
 *      @-> ptr uint8_t              (\* end *\)
 *      @-> returning (ptr uint8_t)) (\* pointer to next item in the buffer *\)
 *
 * let megolm_advance =
 *   foreign (\* ~from:libolm *\) "megolm_advance"
 *     (ptr Megolm.t @-> returning void)
 *
 * let megolm_advance_to =
 *   foreign (\* ~from:libolm *\) "megolm_advance_to"
 *     (ptr Megolm.t        (\* megolm *\)
 *      @-> uint32_t        (\* advance_to *\)
 *      @-> returning void)
 *
 * (\* pk.h *\)
 *
 * module OlmPkEncryption = struct
 *   type t
 *   let t : t structure typ = structure "OlmPkEncryption"
 *   let last_error          = field t "last_error" OlmErrorCode.t
 *   let recipient_key       = field t "recipient_key" OlmCurve25519PublicKey.t
 *   let ()                  = seal t
 *
 *   let allocate_void () : unit ptr =
 *     allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
 * end
 *
 * let olm_pk_encryption_size =
 *   foreign (\* ~from:libolm *\) "olm_pk_encryption_size"
 *     (void @-> returning size_t)
 *
 * let olm_pk_encryption =
 *   foreign (\* ~from:libolm *\) "olm_pk_encryption"
 *     (ptr void @-> returning (ptr OlmPkEncryption.t))
 *
 * let olm_pk_encryption_last_error =
 *   foreign (\* ~from:libolm *\) "olm_pk_encryption_last_error"
 *     (ptr OlmPkEncryption.t @-> returning (ptr char))
 *
 * let olm_clear_pk_encryption =
 *   foreign (\* ~from:libolm *\) "olm_clear_pk_encryption"
 *     (ptr OlmPkEncryption.t @-> returning size_t)
 *
 * let olm_pk_encryption_set_recipient_key =
 *   foreign (\* ~from:libolm *\) "olm_pk_encryption_set_recipient_key"
 *     (ptr OlmPkEncryption.t (\* encryption *\)
 *      @-> ptr void          (\* public_key *\)
 *      @-> size_t            (\* public_key_length*\)
 *      @-> returning size_t) (\* olm_error (?) *\)
 *
 * let olm_pk_ciphertext_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_ciphertext_length"
 *     (ptr OlmPkEncryption.t (\* encryption *\)
 *      @-> size_t            (\* plaintext_length*\)
 *      @-> returning size_t) (\* length of ciphertext for given plaintext length *\)
 *
 * let olm_pk_mac_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_mac_length"
 *     (ptr OlmPkEncryption.t @-> returning size_t)
 *
 * let olm_pk_key_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_key_length"
 *     (void @-> returning size_t)
 *
 * let olm_pk_encrypt_random_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_encrypt_random_length"
 *     (ptr OlmPkEncryption.t @-> returning size_t)
 *
 * let olm_pk_encrypt =
 *   foreign (\* ~from:libolm *\) "olm_pk_encrypt"
 *     (ptr OlmPkEncryption.t (\* encryption *\)
 *      @-> ptr void          (\* plaintext *\)
 *      @-> size_t            (\* plaintext_length*\)
 *      @-> ptr void          (\* ciphertext *\)
 *      @-> size_t            (\* ciphertext_length*\)
 *      @-> ptr void          (\* mac *\)
 *      @-> size_t            (\* mac_length*\)
 *      @-> ptr void          (\* ephemberal_key *\)
 *      @-> size_t            (\* ephemberal_key_size*\)
 *      @-> ptr void          (\* random *\)
 *      @-> size_t            (\* random_length*\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * module OlmPkDecryption = struct
 *   type t
 *   let t : t structure typ = structure "OlmPkDecryption"
 *   let last_error          = field t "last_error" OlmErrorCode.t
 *   let key_pair            = field t "key_pair" OlmCurve25519KeyPair.t
 *   let ()                  = seal t
 *
 *   let allocate_void () : unit ptr =
 *     allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
 * end
 *
 * let olm_pk_decryption_size =
 *   foreign (\* ~from:libolm *\) "olm_pk_decryption_size"
 *     (void @-> returning size_t)
 *
 * let olm_pk_decryption =
 *   foreign (\* ~from:libolm *\) "olm_pk_decryption"
 *     (ptr void @-> returning (ptr OlmPkDecryption.t))
 *
 * let olm_pk_decryption_last_error =
 *   foreign (\* ~from:libolm *\) "olm_pk_decryption_last_error"
 *     (ptr OlmPkDecryption.t @-> returning (ptr char))
 *
 * let olm_clear_pk_decryption =
 *   foreign (\* ~from:libolm *\) "olm_clear_pk_decryption"
 *     (ptr OlmPkDecryption.t @-> returning size_t)
 *
 * let olm_pk_private_key_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_private_key_length"
 *     (void @-> returning size_t)
 *
 * let olm_pk_generate_key_random_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_generate_key_random_length"
 *     (void @-> returning size_t)
 *
 * let olm_pk_key_from_private =
 *   foreign (\* ~from:libolm *\) "olm_pk_key_from_private"
 *     (ptr OlmPkDecryption.t (\* decryption *\)
 *      @-> ptr void          (\* pubkey *\)
 *      @-> size_t            (\* pubkey_length*\)
 *      @-> ptr void          (\* privkey *\)
 *      @-> size_t            (\* privkey_length*\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_pickle_pk_decryption_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_pk_decryption_length"
 *     (ptr OlmPkDecryption.t @-> returning size_t)
 *
 * let olm_pickle_pk_decryption =
 *   foreign (\* ~from:libolm *\) "olm_pickle_pk_decryption"
 *     (ptr OlmPkDecryption.t (\* decryption *\)
 *      @-> ptr void          (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr void          (\* pickled *\)
 *      @-> size_t            (\* pickled_length*\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_unpickle_pk_decryption =
 *   foreign (\* ~from:libolm *\) "olm_unpickle_pk_decryption"
 *     (ptr OlmPkDecryption.t (\* decryption *\)
 *      @-> ptr void          (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr void          (\* pickled *\)
 *      @-> size_t            (\* pickled_length*\)
 *      @-> ptr void          (\* pubkey *\)
 *      @-> size_t            (\* pubkey_length*\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_pk_max_plaintext_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_max_plaintext_length"
 *     (ptr OlmPkDecryption.t (\* decryption *\)
 *      @-> size_t            (\* ciphertext_length *\)
 *      @-> returning size_t) (\* length of plaintext to result from decrypt *\)
 *
 * let olm_pk_decrypt =
 *   foreign (\* ~from:libolm *\) "olm_pk_decrypt"
 *     (ptr OlmPkDecryption.t (\* decryption *\)
 *      @-> ptr void          (\* ephemberal_key *\)
 *      @-> size_t            (\* ephemberal_key_length *\)
 *      @-> ptr void          (\* mac *\)
 *      @-> size_t            (\* mac_length*\)
 *      @-> ptr void          (\* ciphertext *\)
 *      @-> size_t            (\* ciphertext_length*\)
 *      @-> ptr void          (\* plaintext *\)
 *      @-> size_t            (\* max_plaintext_length*\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_pk_get_private_key =
 *   foreign (\* ~from:libolm *\) "olm_pk_get_private_key"
 *     (ptr OlmPkDecryption.t (\* decryption *\)
 *      @-> ptr void          (\* private_key *\)
 *      @-> size_t            (\* private_key_length *\)
 *      @-> returning size_t) (\* olm_error if given buffer is too small *\)
 *
 * module OlmPkSigning = struct
 *   type t
 *   let t : t structure typ = structure "OlmPkSigning"
 *   let last_error          = field t "last_error" OlmErrorCode.t
 *   let key_pair            = field t "key_pair" OlmED25519KeyPair.t
 *   let ()                  = seal t
 *
 *   let allocate_void () : unit ptr =
 *     allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
 * end
 *
 * let olm_pk_signing_size =
 *   foreign (\* ~from:libolm *\) "olm_pk_signing_size"
 *     (void @-> returning size_t)
 *
 * let olm_pk_signing =
 *   foreign (\* ~from:libolm *\) "olm_pk_signing"
 *     (ptr void @-> returning (ptr OlmPkSigning.t))
 *
 * let olm_pk_signing_last_error =
 *   foreign (\* ~from:libolm *\) "olm_pk_signing_last_error"
 *     (ptr OlmPkSigning.t @-> returning (ptr char))
 *
 * let olm_clear_pk_signing =
 *   foreign (\* ~from:libolm *\) "olm_clear_pk_signing"
 *     (ptr OlmPkSigning.t @-> returning size_t)
 *
 * let olm_pk_signing_seed_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_pk_signing_seed_length"
 *     (void @-> returning size_t)
 *
 * let olm_pk_signing_public_key_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_pk_signing_public_key_length"
 *     (void @-> returning size_t)
 *
 * let olm_pk_signature_length =
 *   foreign (\* ~from:libolm *\) "olm_pk_signature_length"
 *     (void @-> returning size_t)
 *
 * let olm_pk_sign =
 *   foreign (\* ~from:libolm *\) "olm_pk_sign"
 *     (ptr OlmPkSigning.t    (\* signing *\)
 *      @-> ptr void          (\* message *\)
 *      @-> size_t            (\* message_length*\)
 *      @-> ptr void          (\* signature *\)
 *      @-> size_t            (\* signature_length*\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * (\* sas.h *\)
 *
 * module OlmSAS = struct
 *   type t
 *   let t : t structure typ = structure "OlmSAS"
 *   let last_error     = field t "last_error" OlmErrorCode.t
 *   let curve25519_key = field t "curve25519_key" OlmCurve25519KeyPair.t
 *   let secret         = field t "secret" (array curve25519_shared_secret_length uint8_t)
 *   let their_key_set  = field t "their_key_set" int
 *   let ()             = seal t
 *
 *   let allocate_void () : unit ptr =
 *     allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
 * end
 *
 * let olm_sas_last_error =
 *   foreign (\* ~from:libolm *\) "olm_sas_last_error"
 *     (ptr OlmSAS.t @-> returning (ptr char))
 *
 * let olm_sas_size =
 *   foreign (\* ~from:libolm *\) "olm_sas_size"
 *     (void @-> returning size_t)
 *
 * let olm_sas =
 *   foreign (\* ~from:libolm *\) "olm_sas"
 *     (ptr void @-> returning (ptr OlmSAS.t))
 *
 * let olm_clear_sas =
 *   foreign (\* ~from:libolm *\) "olm_clear_sas"
 *     (ptr OlmSAS.t @-> returning size_t)
 *
 * let olm_sas_random_length =
 *   foreign (\* ~from:libolm *\) "olm_pickle_sas_random_length"
 *     (void @-> returning size_t)
 *
 * let olm_create_sas =
 *   foreign (\* ~from:libolm *\) "olm_create_sas"
 *     (ptr OlmSAS.t          (\* sas *\)
 *      @-> ptr void          (\* random *\)
 *      @-> size_t            (\* random_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_sas_pubkey_length =
 *   foreign (\* ~from:libolm *\) "olm_sas_pubkey_length"
 *     (ptr OlmSAS.t @-> returning size_t)
 *
 * let olm_sas_get_pubkey =
 *   foreign (\* ~from:libolm *\) "olm_sas_get_pubkey"
 *     (ptr OlmSAS.t          (\* sas *\)
 *      @-> ptr void          (\* pubkey *\)
 *      @-> size_t            (\* pubkey_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_sas_set_their_key =
 *   foreign (\* ~from:libolm *\) "olm_sas_set_their_key"
 *     (ptr OlmSAS.t          (\* sas *\)
 *      @-> ptr void          (\* their_key *\)
 *      @-> size_t            (\* their_key_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_sas_is_their_key_set =
 *   foreign (\* ~from:libolm *\) "olm_sas_is_their_key_set"
 *     (ptr OlmSAS.t @-> returning int)
 *
 * let olm_sas_generate_bytes =
 *   foreign (\* ~from:libolm *\) "olm_sas_generate_bytes"
 *     (ptr OlmSAS.t          (\* sas *\)
 *      @-> ptr void          (\* info *\)
 *      @-> size_t            (\* info_length *\)
 *      @-> ptr void          (\* output *\)
 *      @-> size_t            (\* output_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\)
 *
 * let olm_sas_mac_length =
 *   foreign (\* ~from:libolm *\) "olm_sas_mac_length"
 *     (ptr OlmSAS.t @-> returning size_t)
 *
 * let olm_sas_calculate_mac =
 *   foreign (\* ~from:libolm *\) "olm_sas_calculate_mac"
 *     (ptr OlmSAS.t          (\* sas *\)
 *      @-> ptr void          (\* input *\)
 *      @-> size_t            (\* input_length *\)
 *      @-> ptr void          (\* info *\)
 *      @-> size_t            (\* info_length *\)
 *      @-> ptr void          (\* mac *\)
 *      @-> size_t            (\* mac_length *\)
 *      @-> returning size_t) (\* olm_error on failure *\) *)
