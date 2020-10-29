open Core

type t = { buf  : char Ctypes.ptr
         ; util : C.Types.Utility.t Ctypes_static.ptr
         }

(** [clear util] *)
val clear : C.Types.Utility.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret] *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc ()] *)
val alloc : unit -> t

(** [create ()] *)
val create : unit -> t

(** [ed25519_verify t key message signature] *)
val ed25519_verify : t -> string -> string -> string -> (int, [> OlmError.t ]) result

(** [sha256 t input] *)
val sha256 : t -> string -> (string, [> OlmError.t ]) result
