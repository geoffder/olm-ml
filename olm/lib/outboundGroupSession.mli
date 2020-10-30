open Core

type t = { buf : char Ctypes.ptr
         ; ogs : C.Types.OutboundGroupSession.t Ctypes_static.ptr
         }

(** [clear ogs]

    Clear memory backing the given [ogs] pointer. *)
val clear : C.Types.OutboundGroupSession.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret]

    Check whether return code [ret] is equal to `olm_error()` ( -1 ), returning the
    return value as an int if not, and the `last_error` from the outbound group
    session [t] if so. *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc ()]

    Allocate an [C.Types.OutboundGroupSession.t] and return the pointers in a [t]. *)
val alloc : unit -> t

(** [create ()]

    Start a new outbound group session. *)
val create : unit -> (t, [> OlmError.t ]) result

(** [pickle ?pass t]

    Stores an outbound group session object [t] as a base64 string. Encrypting
    it using the optionally supplied passphrase [pass]. Returns a base64
    encoded string of the pickled outbound group session on success. *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle]

    Loads an outbound group session from a pickled base64-encoded string
    [pickle] and returns a [t], decrypted with the optionally supplied
    passphrase [pass]. If the passphrase doesn't match the one used to encrypt
    the outbound group session then the error will be [`BadAccountKey]. If the
    base64 couldn't be decoded then the error will be [`InvalidBase64]. *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [encrypt t plaintext]

    Ecrypts [plaintext] with the outbound group session [t]. *)
val encrypt : t -> string -> (string, [> OlmError.t ]) result

(** [id t]

    A base64 encoded identifier for the session [t]. *)
val id : t -> (string, [> OlmError.t ]) result

(** [message_index t]

    The current message index of the session [t]. Each message is encrypted with
    an increasing index. This is the index for the next message. *)
val message_index : t -> int

(** [session_key t]

    The base64-encoded current ratchet key for the session [t]. Each message is
    encrypted with a different ratchet key. This function returns the ratchet
    key that will be used for the next message. *)
val session_key : t -> (string, [> OlmError.t ]) result
