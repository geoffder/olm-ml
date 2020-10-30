open Core

type t = { buf : char Ctypes.ptr
         ; igs : C.Types.InboundGroupSession.t Ctypes_static.ptr
         }

(** [clear igs]

    Clear memory backing the given [igs] pointer. *)
val clear : C.Types.InboundGroupSession.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret]

    Check whether return code [ret] is equal to `olm_error()` ( -1 ), returning the
    return value as an int if not, and the `last_error` from the inbound group
    session [t] if so. *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc ()]

    Allocate an [C.Types.InboundGroupSession.t] and return the pointers in a [t]. *)
val alloc : unit -> t

(** [create outbound_session_key]

    Start a new inbound group session, using an exported [outbound_session_key],
    (obtained with [OutboundGroupSession.session_key]). *)
val create : string -> (t, [> OlmError.t ]) result

(** [pickle ?pass t]

    Stores an inbound group session object [t] as a base64 string. Encrypting
    it using the optionally supplied passphrase [pass]. Returns a base64
    encoded string of the pickled inbound group session on success. *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle]

    Loads an inbound group session from a pickled base64-encoded string [pickle]
    and returns a [t], decrypted with the optionally supplied passphrase
    [pass]. If the passphrase doesn't match the one used to encrypt the account
    then the error will be [`BadAccountKey]. If the base64 couldn't be decoded
    then the error will be [`InvalidBase64]. *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [decrypt t ciphertext]

    Returns a tuple of the plain-text decrypted from [ciphertext] by [t] and the
    message index of the decrypted message or an error on failure. Possible
    errors include:

    * [`InvalidBase64]       if the message is not valid base64
    * [`BadMessageVersion]   if the message was encrypted with an unsupported
        version of the protocol
    * [`BadMessageFormat]    if the message headers could not be decoded
    * [`BadMessageMac]       if the message could not be verified
    * [`UnknownMessageIndex] if we do not have a session key
        corresponding to the message's index (i.e., it was sent before
        the session key was shared with us) *)
val decrypt : t -> string -> (string * int, [> OlmError.t | `ValueError of string ]) result

(** [id t]

    A base64 encoded identifier for the session [t]. *)
val id : t -> (string, [> OlmError.t ]) result

(** [first_known_index t]

    The first message index we know how to decrypt for [t]. *)
val first_known_index : t -> int

(** [export_session t message_index]

    Export the base64-encoded ratchet key for the session [t], at the given
    [message_index], in a format which can be used by [import_session]. Error
    will be [`UnknownMessageIndex] if we do not have a session key for
    [message_index] (i.e., it was sent before the session key was shared with
    us) *)
val export_session : t -> int -> (string, [> OlmError.t ]) result

(** [import_session exported_key]

    Creates an inbound group session with an [exported_key] from an (previously)
    existing inbound group session. If the [exported_key] is not valid, the
    error will be [`BadSessionKey]. *)
val import_session : string -> (t, [> OlmError.t ]) result

(** [is_verified t]

    Check if the session has been verified as a valid session. (A session is
    verified either because the original session share was signed, or because we
    have subsequently successfully decrypted a message.) *)
val is_verified : t -> bool
