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

(** [clear acc]

    Clear memory backing the given account pointer. *)
val clear : C.Types.Account.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret]

    Check whether return code [ret] is equal to `olm_error()` ( -1 ), returning the
    return value as an int if not, and the `last_error` from the account [t]
    if so. *)
val check_error : t -> Unsigned.Size_t.t -> (int, [> OlmError.t ]) result

(** [alloc ()]

    Allocate an [C.Types.Account.t] and return the pointers in a [t]. *)
val alloc : unit -> t

(** [create ()]

    Create a new Olm account, and its matching identity key pair. If there
    weren't enough random bytes for the account creation the error will be
    [`NotEnoughRandom]. *)
val create : unit -> (t, [> OlmError.t ]) result

(** [pickle ?pass t]

    Stores an account [t] as a base64 string. Encrypts the account using the
    optionally supplied passphrase [?pass]. Returns a base64 encoded string of
    the pickled account on success. *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle]

    Loads an account from a pickled base64-encoded string [pickle] and returns a [t],
    decrypted with the optionall supplied passphrase [?pass]. If the passphrase
    doesn't match the one used to encrypt the account then the error will be
    [`BadAccountKey]. If the base64 couldn't be decoded then the error will be
    [`InvalidBase64]. *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [identity_keys t]

    Get the public part of the identity keys from the account [t]. *)
val identity_keys : t -> (IdentityKeys.t, [> OlmError.t | `YojsonError of string ]) result

(** [sign t msg]

    Signs a message with the private ed25519 identity key of the account [t],
    returning the signature. *)
val sign : t -> string -> (string, [> OlmError.t ]) result

(** [max_one_time_keys t]

    The maximum number of one-time keys the account [t] can store. *)
val max_one_time_keys : t -> (int, [> OlmError.t ]) result

(** [mark_keys_as_published t]

    Mark the current set of one-time keys in account [t] as being published. *)
val mark_keys_as_published : t -> (int, [> OlmError.t ]) result

(** [generate_one_time_keys t n]

    Generate [n] new one-time keys. If the total number of keys stored by this
    account exceeds [max_one_time_keys t] then the old keys are discarded. *)
val generate_one_time_keys : t -> int -> (int, [> OlmError.t ]) result

(** [one_time_keys t]

    Get the public part of the one-time keys for the account [t]. *)
val one_time_keys : t -> (OneTimeKeys.t, [> OlmError.t | `YojsonError of string ]) result
