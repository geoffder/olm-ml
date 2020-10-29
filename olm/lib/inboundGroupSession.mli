open Core

type t = { buf : char Ctypes.ptr
         ; igs : C.Types.InboundGroupSession.t Ctypes_static.ptr
         }

val size : int

val clear : C.Types.InboundGroupSession.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

val alloc : unit -> t

val create : string -> (t, [> OlmError.t ]) result

val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

val decrypt : t -> string -> (string * int, [> OlmError.t | `ValueError of string ]) result

val id : t -> (string, [> OlmError.t ]) result

val first_known_index : t -> int

val export_session : t -> int -> (string, [> OlmError.t ]) result

val import_session : string -> (t, [> OlmError.t ]) result

val is_verified : t -> bool
