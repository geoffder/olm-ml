(** This module contains the Olm Session part of the Olm library.

    It is used to establish a peer-to-peer encrypted communication channel between
    two Olm accounts. *)

open Core

module Message : sig
  type t = private PreKey of string | Message of string

  (** [ciphertext t] *)
  val ciphertext : t -> string

  (** [is_pre_key t] *)
  val is_pre_key : t -> bool

  (** [to_size t]

      The size_t identifier of this message's type. PreKey = 0, Message = 1. *)
  val to_size : t -> Unsigned.size_t

  (** [to_string t] *)
  val to_string : t -> string

  (** [create text message_type_int]

      Only means of creating a [Message.t]. [text] must not be empty, and
      [message_type_int] must be 0 (PreKey) or 1 (Message). The type is returned
      by [C.Funcs.encrypt_message_type] as a size_t. [`ValueError] if these
      conditions are not met. *)
  val create : string -> int -> (t, [> `ValueError of string ]) result
end

type t = { buf : char Ctypes.ptr
         ; ses : C.Types.Session.t Ctypes_static.ptr
         }

(** [clear ses]

    Clear memory backing the given [ses] pointer. *)
val clear : C.Types.Session.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret]

    Check whether return code [ret] is equal to `olm_error()` ( -1 ), returning the
    return value as an int if not, and the `last_error` from the session [t] if so. *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc ()]

    Allocate an [C.Types.Session.t] and return the pointers in a [t]. *)
val alloc : unit -> t

(** [create_inbound ?identity_key acc msg]

    Create a new in-bound session with the account [acc] for sending/receiving
    messages from an incoming prekey [msg]. If an [?identity_key] is supplied,
    it will be used to check whether the [msg] was actually sent using it. If
    the base64 key cannot be decoded, the error will will be [`InvalidBase64].
    [`BadMessageVersion] results if the [msg] was for an unsupported protocol.
    If the [msg] could not be decoded, [`BadMessageFormat] will result. If the
    message refers to an unknown one-time key, then the error will be
    [`BadMessageKeyId]. *)
val create_inbound
  :  ?identity_key:string
  -> Account.t
  -> Message.t
  -> (t, [> OlmError.t | `ValueError of string ]) result

(** [create_outbound acc identity_key one_time_key]

    Creates a new outbound session with the account [acc] for sending messages
    to a given [identity_key] and [one_time_key]. If the keys couldn't be
    decoded as base64 then the error message will be "INVALID_BASE64". *)
val create_outbound :
  Account.t -> string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [pickle ?pass t]

    Stores an session object [t] as a base64 string. Encrypting it using the
    optionally supplied passphrase [?pass]. Returns a base64 encoded string of
    the pickled session on success. *)
val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

(** [from_pickle ?pass pickle]

    Loads an session from a pickled base64-encoded string [pickle] and returns a
    [t], decrypted with the optionally supplied passphrase [?pass]. If the
    passphrase doesn't match the one used to encrypt the session then the error
    will be [`BadAccountKey]. If the base64 couldn't be decoded then the error
    will be [`InvalidBase64]. *)
val from_pickle : ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

(** [encrypt t plaintext]

    Encrypts a [plaintext] message using the session [t]. Returns the ciphertext
    as a base64 encoded string on success. *)
val encrypt : t -> string -> (Message.t, [> OlmError.t | `ValueError of string ]) result

(** [decrypt t msg]

    Decrypts a [msg] using the session [t]. Invalid unicode characters are
    replaced with [Uutf.u_rep] unless [ignore_unicode_errors] is set to true. If
    the base64 cannot be decoded, the error will be [`InvalidBase64].
    [`BadMessageVersion] results if the message was for an unsupported protocol.
    If the [msg] could not be decoded, [`BadMessageFormat] will result. If the
    MAC on the message was invalid then the error message will be
    "BAD_MESSAGE_MAC". *)
val decrypt
  :  ?ignore_unicode_errors:bool
  -> t
  -> Message.t
  -> (string, [> OlmError.t | `ValueError of string | `UnicodeError ]) result

(** [id t]

    Get the identifier for the session [t]. It will be the same for both
    ends of the conversation. *)
val id : t -> (string, [> OlmError.t ]) result

(** [matches ?identity_key t msg]

    Checks if the PreKey [msg] (`ValueError if not PreKey) is for the in-bound
    session [t]. This can happen if multiple messages are sent to [t] before it
    sends a message in reply. Returns true if the session matches, false if not.
    If [identity_key] is provided, the [msg] will be checked against it to
    ensure it came from the expected sender. *)
val matches
  :  ?identity_key:string
  -> t
  -> Message.t
  -> (bool, [> OlmError.t | `ValueError of string ]) result

(** [remove_one_time_keys t acc]

    Removes the one-time keys that the session [t] used from the account [acc].
    If the account doesn't have any matching one-time keys then the error will
    be [`BadMessageKeyId]. *)
val remove_one_time_keys : t -> Account.t -> (int, [> OlmError.t ]) result
