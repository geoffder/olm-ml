open Core

module IdentityKeys : sig
  type t = private { curve25519 : string; ed25519 : string; }

  (** [equal a b] *)
  val equal     : t -> t -> bool

  (** [of_yojson j] *)
  val of_yojson : Yojson.Safe.t -> (t, [> `YojsonError of string ]) result

  (** [to_yojson t] *)
  val to_yojson : t -> Yojson.Safe.t

  (** [of_string s] *)
  val of_string : string -> (t, [> `YojsonError of string ]) result

  (** [to_string t] *)
  val to_string : t -> string
end

module OneTimeKeys : sig
  type t = private
    { curve25519 : (string, string, String.comparator_witness) Map.t }

  (** [equal a b] *)
  val equal     : t -> t -> bool

  (** [of_yojson j] *)
  val of_yojson : Yojson.Safe.t -> (t, [> `YojsonError of string ]) result

  (** [to_yojson t] *)
  val to_yojson : t -> Yojson.Safe.t

  (** [of_string s] *)
  val of_string : string -> (t, [> `YojsonError of string ]) result

  (** [to_string t] *)
  val to_string : t -> string
end

type t = { buf : char Ctypes_static.ptr
         ; acc : C.Types.Account.t Ctypes_static.ptr
         }

(** [clear acc] *)
val clear : C.Types.Account.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret] *)
val check_error : t -> Unsigned.Size_t.t -> (int, [> OlmError.t ]) result

(** [alloc ()] *)
val alloc : unit -> t

(** [create ()] *)
val create : unit -> (t, [> OlmError.t ]) result

(** [pickle ?pass t] *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle] *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [identity_keys t] *)
val identity_keys : t -> (IdentityKeys.t, [> OlmError.t | `YojsonError of string ]) result

(** [sign t msg] *)
val sign : t -> string -> (string, [> OlmError.t ]) result

(** [max_one_time_keys t] *)
val max_one_time_keys : t -> (int, [> OlmError.t ]) result

(** [mark_keys_as_published t] *)
val mark_keys_as_published : t -> (int, [> OlmError.t ]) result

(** [generate_one_time_keys t count] *)
val generate_one_time_keys : t -> int -> (int, [> OlmError.t ]) result

(** [one_time_keys t] *)
val one_time_keys : t -> (OneTimeKeys.t, [> OlmError.t | `YojsonError of string ]) result
