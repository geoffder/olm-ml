open Core

type t = { buf  : char Ctypes.ptr
         ; util : C.Types.Utility.t Ctypes_static.ptr
         }

val size : int

val clear : C.Types.Utility.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

val alloc : unit -> t

val create : unit -> t

val ed25519_verify : t -> string -> string -> string -> (int, [> OlmError.t ]) result

val sha256 : t -> string -> (string, [> OlmError.t ]) result
