open Ctypes

module OlmErrorCode = struct
  type t =
    | OLM_SUCCESS
    | OLM_NOT_ENOUGH_RANDOM
    | OLM_OUTPUT_BUFFER_TOO_SMALL
    | OLM_BAD_MESSAGE_VERSION
    | OLM_BAD_MESSAGE_FORMAT
    | OLM_BAD_MESSAGE_MAC
    | OLM_BAD_MESSAGE_KEY_ID
    | OLM_INVALID_BASE64
    | OLM_BAD_ACCOUNT_KEY
    | OLM_UNKNOWN_PICKLE_VERSION
    | OLM_CORRUPTED_PICKLE
    | OLM_BAD_SESSION_KEY
    | OLM_UNKNOWN_MESSAGE_INDEX
    | OLM_BAD_LEGACY_ACCOUNT_PICKLE
    | OLM_BAD_SIGNATURE
    | OLM_INPUT_BUFFER_TOO_SMALL
    | OLM_SAS_THEIR_KEY_NOT_SET

  let of_int = function
    | 0  -> OLM_SUCCESS
    | 1  -> OLM_NOT_ENOUGH_RANDOM
    | 2  -> OLM_OUTPUT_BUFFER_TOO_SMALL
    | 3  -> OLM_BAD_MESSAGE_VERSION
    | 4  -> OLM_BAD_MESSAGE_FORMAT
    | 5  -> OLM_BAD_MESSAGE_MAC
    | 6  -> OLM_BAD_MESSAGE_KEY_ID
    | 7  -> OLM_INVALID_BASE64
    | 8  -> OLM_BAD_ACCOUNT_KEY
    | 9  -> OLM_UNKNOWN_PICKLE_VERSION
    | 10 -> OLM_CORRUPTED_PICKLE
    | 11 -> OLM_BAD_SESSION_KEY
    | 12 -> OLM_UNKNOWN_MESSAGE_INDEX
    | 13 -> OLM_BAD_LEGACY_ACCOUNT_PICKLE
    | 14 -> OLM_BAD_SIGNATURE
    | 15 -> OLM_INPUT_BUFFER_TOO_SMALL
    | 16 -> OLM_SAS_THEIR_KEY_NOT_SET
    | _ -> raise (Invalid_argument "Unexpected OlmErrorCode value.")

  let to_int = function
    | OLM_SUCCESS                   -> 0
    | OLM_NOT_ENOUGH_RANDOM         -> 1
    | OLM_OUTPUT_BUFFER_TOO_SMALL   -> 2
    | OLM_BAD_MESSAGE_VERSION       -> 3
    | OLM_BAD_MESSAGE_FORMAT        -> 4
    | OLM_BAD_MESSAGE_MAC           -> 5
    | OLM_BAD_MESSAGE_KEY_ID        -> 6
    | OLM_INVALID_BASE64            -> 7
    | OLM_BAD_ACCOUNT_KEY           -> 8
    | OLM_UNKNOWN_PICKLE_VERSION    -> 9
    | OLM_CORRUPTED_PICKLE          -> 10
    | OLM_BAD_SESSION_KEY           -> 11
    | OLM_UNKNOWN_MESSAGE_INDEX     -> 12
    | OLM_BAD_LEGACY_ACCOUNT_PICKLE -> 13
    | OLM_BAD_SIGNATURE             -> 14
    | OLM_INPUT_BUFFER_TOO_SMALL    -> 15
    | OLM_SAS_THEIR_KEY_NOT_SET     -> 16

  let to_string = function
    | OLM_SUCCESS                   -> "olm_success"
    | OLM_NOT_ENOUGH_RANDOM         -> "olm_not_enough_random"
    | OLM_OUTPUT_BUFFER_TOO_SMALL   -> "olm_output_buffer_too_small"
    | OLM_BAD_MESSAGE_VERSION       -> "olm_bad_message_version"
    | OLM_BAD_MESSAGE_FORMAT        -> "olm_bad_message_format"
    | OLM_BAD_MESSAGE_MAC           -> "olm_bad_message_mac"
    | OLM_BAD_MESSAGE_KEY_ID        -> "olm_bad_message_key_id"
    | OLM_INVALID_BASE64            -> "olm_invalid_base64"
    | OLM_BAD_ACCOUNT_KEY           -> "olm_bad_account_key"
    | OLM_UNKNOWN_PICKLE_VERSION    -> "olm_unknown_pickle_version"
    | OLM_CORRUPTED_PICKLE          -> "olm_corrupted_pickle"
    | OLM_BAD_SESSION_KEY           -> "olm_bad_session_key"
    | OLM_UNKNOWN_MESSAGE_INDEX     -> "olm_unknown_message_index"
    | OLM_BAD_LEGACY_ACCOUNT_PICKLE -> "olm_bad_legacy_account_pickle"
    | OLM_BAD_SIGNATURE             -> "olm_bad_signature"
    | OLM_INPUT_BUFFER_TOO_SMALL    -> "olm_input_buffer_too_small"
    | OLM_SAS_THEIR_KEY_NOT_SET     -> "olm_sas_their_key_not_set"

  let t = view ~read:of_int ~write:to_int int
end
