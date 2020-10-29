open Core

module Message : sig
  type t = private PreKey of string | Message of string

  val ciphertext : t -> string

  val is_pre_key : t -> bool

  val to_size : t -> Unsigned.size_t

  val to_string : t -> string

  val create : string -> int -> (t, [> `ValueError of string ]) result
end

type t = { buf : char Ctypes.ptr
         ; ses : C.Types.Session.t Ctypes_static.ptr
         }

val size : int

val clear : C.Types.Session.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

val alloc : unit -> t

val create_inbound
  :  ?identity_key:string
  -> Account.t
  -> Message.t
  -> (t, [> OlmError.t | `ValueError of string ]) result

val create_outbound :
  Account.t -> string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

val encrypt : t -> string -> (Message.t, [> OlmError.t | `ValueError of string ]) result

val decrypt : t -> Message.t -> (string, [> OlmError.t | `ValueError of string ]) result

val id : t -> (string, [> OlmError.t ]) result

val matches
  :  ?identity_key:string
  -> t
  -> Message.t
  -> (bool, [> OlmError.t | `ValueError of string ]) result

val remove_one_time_keys : t -> Account.t -> (int, [> OlmError.t ]) result
