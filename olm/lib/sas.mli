open Core

type t = { buf : char Ctypes.ptr
         ; sas : C.Types.SAS.t Ctypes_static.ptr
         }

(** [clear sas] *)
val clear : C.Types.SAS.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret] *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [set_their_pubkey t key] *)
val set_their_pubkey : t -> string -> (int, [> OlmError.t ]) result

(** [alloc ()] *)
val alloc : unit -> t

(** [create ?other_users_pubkey ()] *)
val create : ?other_users_pubkey:string -> unit -> (t, [> OlmError.t ]) result

(** [pubkey t] *)
val pubkey : t -> (string, [> OlmError.t ]) result

(** [other_key_set t] *)
val other_key_set : t -> bool

(** [generate_bytes t extra_info length] *)
val generate_bytes :
  t -> string -> int -> (string, [> OlmError.t | `ValueError of string ]) result

(** [calculate_mac t msg extra_info] *)
val calculate_mac : t -> string -> string -> (string, [> OlmError.t ]) result
