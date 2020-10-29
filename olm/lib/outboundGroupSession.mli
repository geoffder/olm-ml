open Core

type t = { buf : char Ctypes.ptr
         ; ogs : C.Types.OutboundGroupSession.t Ctypes_static.ptr
         }

val size : int

val clear : C.Types.OutboundGroupSession.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

val alloc : unit -> t

val create : unit -> (t, [> OlmError.t ]) result

val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

val encrypt : t -> string -> (string, [> OlmError.t ]) result

val id : t -> (string, [> OlmError.t ]) result

val message_index : t -> int

val session_key : t -> (string, [> OlmError.t ]) result
