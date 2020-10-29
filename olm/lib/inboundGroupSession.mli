open Core

type t = { buf : char Ctypes.ptr
         ; igs : C.Types.InboundGroupSession.t Ctypes_static.ptr
         }

(** [clear igs] *)
val clear : C.Types.InboundGroupSession.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret] *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc ()] *)
val alloc : unit -> t

(** [create outbound_session_key] *)
val create : string -> (t, [> OlmError.t ]) result

(** [pickle ?pass t] *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle] *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [decrypt t ciphertext] *)
val decrypt : t -> string -> (string * int, [> OlmError.t | `ValueError of string ]) result

(** [id t] *)
val id : t -> (string, [> OlmError.t ]) result

(** [first_known_index t] *)
val first_known_index : t -> int

(** [export_session t message_index] *)
val export_session : t -> int -> (string, [> OlmError.t ]) result

(** [import_session exported_key] *)
val import_session : string -> (t, [> OlmError.t ]) result

(** [is_verified t] *)
val is_verified : t -> bool
