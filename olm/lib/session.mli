open Core

module Message : sig
  type t = private PreKey of string | Message of string

  (** [ciphertext t] *)
  val ciphertext : t -> string

  (** [is_pre_key t] *)
  val is_pre_key : t -> bool

  (** [to_size t] *)
  val to_size : t -> Unsigned.size_t

  (** [to_string t] *)
  val to_string : t -> string

  (** [create t] *)
  val create : string -> int -> (t, [> `ValueError of string ]) result
end

type t = { buf : char Ctypes.ptr
         ; ses : C.Types.Session.t Ctypes_static.ptr
         }

(** [clear sess] *)
val clear : C.Types.Session.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret] *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc] *)
val alloc : unit -> t

(** [create_inbound ?identity_key acc msg] *)
val create_inbound
  :  ?identity_key:string
  -> Account.t
  -> Message.t
  -> (t, [> OlmError.t | `ValueError of string ]) result

(** [create_outbound acc identity_key one_time_key] *)
val create_outbound :
  Account.t -> string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [pickle ?pass t] *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle] *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [encrypt t plaintext] *)
val encrypt : t -> string -> (Message.t, [> OlmError.t | `ValueError of string ]) result

(** [decrypt t msg] *)
val decrypt : t -> Message.t -> (string, [> OlmError.t | `ValueError of string ]) result

(** [id t] *)
val id : t -> (string, [> OlmError.t ]) result

(** [matches ?identity_key t msg] *)
val matches
  :  ?identity_key:string
  -> t
  -> Message.t
  -> (bool, [> OlmError.t | `ValueError of string ]) result

(** [remove_one_time_keys t acc] *)
val remove_one_time_keys : t -> Account.t -> (int, [> OlmError.t ]) result
