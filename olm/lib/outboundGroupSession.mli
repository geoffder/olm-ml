open Core

type t = { buf : char Ctypes.ptr
         ; ogs : C.Types.OutboundGroupSession.t Ctypes_static.ptr
         }

(** [clear ogs] *)
val clear : C.Types.OutboundGroupSession.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret] *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc ()] *)
val alloc : unit -> t

(** [create ()] *)
val create : unit -> (t, [> OlmError.t ]) result

(** [pickle ?pass pickle] *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle] *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [encrypt t plaintext] *)
val encrypt : t -> string -> (string, [> OlmError.t ]) result

(** [id t] *)
val id : t -> (string, [> OlmError.t ]) result

(** [message_index t] *)
val message_index : t -> int

(** [session_key t] *)
val session_key : t -> (string, [> OlmError.t ]) result
