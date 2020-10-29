open! Core

type t =
  [ `BadAccountKey
  | `BadLegacyAccountPickle
  | `BadMessageFormat
  | `BadMessageKeyId
  | `BadMessageMac
  | `BadMessageVersion
  | `BadSessionKey
  | `BadSignature
  | `CorruptedPickle
  | `InputBufferTooSmall
  | `InvalidBase64
  | `NotEnoughRandom
  | `OutputBufferTooSmall
  | `SasTheirKeyNotSet
  | `Success
  | `UnknownMessageIndex
  | `UnknownOlmError of string
  | `UnknownPickleVersion
  ]

(** [to_string s]

    Map string to OlmError.t *)
val to_string : [< t ] -> string

(** [of_string s]

    Map string to OlmError.t *)
val of_string : string -> [> t ]

(** [of_last_error char_ptr]

    Map null-terminated C string to OlmError.t *)
val of_last_error : char Ctypes.ptr -> [> t ]
