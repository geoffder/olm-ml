open Core

type t = { buf : char Ctypes.ptr
         ; sas : C.Types.SAS.t Ctypes_static.ptr
         }

val size : int

val clear : C.Types.SAS.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

val set_their_pubkey : t -> string -> (int, [> OlmError.t ]) result

val alloc : unit -> t

val create : ?other_users_pubkey:string -> unit -> (t, [> OlmError.t ]) result

val pubkey : t -> (string, [> OlmError.t ]) result

val other_key_set : t -> bool

val generate_bytes :
  t -> string -> int -> (string, [> OlmError.t | `ValueError of string ]) result

val calculate_mac : t -> string -> string -> (string, [> OlmError.t ]) result
