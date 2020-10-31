open! Core

type t =
  [ `Success
  | `NotEnoughRandom
  | `OutputBufferTooSmall
  | `BadMessageVersion
  | `BadMessageFormat
  | `BadMessageMac
  | `BadMessageKeyId
  | `InvalidBase64
  | `BadAccountKey
  | `UnknownPickleVersion
  | `CorruptedPickle
  | `BadSessionKey
  | `UnknownMessageIndex
  | `BadLegacyAccountPickle
  | `BadSignature
  | `InputBufferTooSmall
  | `SasTheirKeyNotSet
  | `UnknownOlmError of string
  ]

let to_string = function
  | `Success                -> "SUCCESS"
  | `NotEnoughRandom        -> "NOT_ENOUGH_RANDOM"
  | `OutputBufferTooSmall   -> "OUTPUT_BUFFER_TOO_SMALL"
  | `BadMessageVersion      -> "BAD_MESSAGE_VERSION"
  | `BadMessageFormat       -> "BAD_MESSAGE_FORMAT"
  | `BadMessageMac          -> "BAD_MESSAGE_MAC"
  | `BadMessageKeyId        -> "BAD_MESSAGE_KEY_ID"
  | `InvalidBase64          -> "INVALID_BASE64"
  | `BadAccountKey          -> "BAD_ACCOUNT_KEY"
  | `UnknownPickleVersion   -> "UNKNOWN_PICKLE_VERSION"
  | `CorruptedPickle        -> "CORRUPTED_PICKLE"
  | `BadSessionKey          -> "BAD_SESSION_KEY"
  | `UnknownMessageIndex    -> "UNKNOWN_MESSAGE_INDEX"
  | `BadLegacyAccountPickle -> "BAD_LEGACY_ACCOUNT_PICKLE"
  | `BadSignature           -> "BAD_SIGNATURE"
  | `InputBufferTooSmall    -> "OLM_INPUT_BUFFER_TOO_SMALL"
  | `SasTheirKeyNotSet      -> "OLM_SAS_THEIR_KEY_NOT_SET"
  | `UnknownOlmError s      -> "Unknown Olm Error: " ^ s

let of_string = function
  | "SUCCESS"                    -> `Success
  | "NOT_ENOUGH_RANDOM"          -> `NotEnoughRandom
  | "OUTPUT_BUFFER_TOO_SMALL"    -> `OutputBufferTooSmall
  | "BAD_MESSAGE_VERSION"        -> `BadMessageVersion
  | "BAD_MESSAGE_FORMAT"         -> `BadMessageFormat
  | "BAD_MESSAGE_MAC"            -> `BadMessageMac
  | "BAD_MESSAGE_KEY_ID"         -> `BadMessageKeyId
  | "INVALID_BASE64"             -> `InvalidBase64
  | "BAD_ACCOUNT_KEY"            -> `BadAccountKey
  | "UNKNOWN_PICKLE_VERSION"     -> `UnknownPickleVersion
  | "CORRUPTED_PICKLE"           -> `CorruptedPickle
  | "BAD_SESSION_KEY"            -> `BadSessionKey
  | "UNKNOWN_MESSAGE_INDEX"      -> `UnknownMessageIndex
  | "BAD_LEGACY_ACCOUNT_PICKLE"  -> `BadLegacyAccountPickle
  | "BAD_SIGNATURE"              -> `BadSignature
  | "OLM_INPUT_BUFFER_TOO_SMALL" -> `InputBufferTooSmall
  | "OLM_SAS_THEIR_KEY_NOT_SET"  -> `SasTheirKeyNotSet
  | s                            -> `UnknownOlmError s

let string_of_nullterm_char_ptr char_ptr =
  let open Ctypes in
  let rec loop acc p =
    if is_null p || Char.equal (!@ p) '\000'
    then List.rev acc |> String.of_char_list
    else loop (!@ p :: acc) (p +@ 1)
  in
  loop [] char_ptr

(* The last_error functions of all libolm objects return null-terminated strings *)
let of_last_error char_ptr =
  string_of_nullterm_char_ptr char_ptr |> of_string
