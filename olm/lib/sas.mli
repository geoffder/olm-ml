(** This module contains functions to perform key verification using the Short
    Authentication String (SAS) method. *)

open Core

type t = { buf : char Ctypes.ptr
         ; sas : C.Types.SAS.t Ctypes_static.ptr
         }

(** [clear sas]

    Clear memory backing the given [sas] pointer. *)
val clear : C.Types.SAS.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret]

    Check whether return code [ret] is equal to `olm_error()` ( -1 ), returning the
    return value as an int if not, and the `last_error` from the sas [t]
    if so. *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [set_their_pubkey t key]

    Set the public [key] of the other user in the SAS object [t]. It needs to be
    set before bytes can be generated for the authentication string and a MAC can
    be calculated. *)
val set_their_pubkey : t -> string -> (int, [> OlmError.t ]) result

(** [alloc ()]

    Allocate an [C.Types.SAS.t] and return the pointers in a [t]. *)
val alloc : unit -> t

(** [create ?other_users_pubkey ()]

    Create a new SAS object with [alloc ()], additionally setting the other users
    public key if provided. *)
val create : ?other_users_pubkey:string -> unit -> (t, [> OlmError.t ]) result

(** [pubkey t]

    Get the public key of the SAS object [t] that can then be shared with another
    user to perform the authentication process. *)
val pubkey : t -> (string, [> OlmError.t ]) result

(** [other_key_set t]

    Check if the other user's pubkey has been set. *)
val other_key_set : t -> bool

(** [generate_bytes t extra_info length]

    Generate bytes to use for the short authentication string with SAS object [t].
    Supplied [extra_info] is mixed in when generating the number of bytes indicated
    by [length]. *)
val generate_bytes :
  t -> string -> int -> (string, [> OlmError.t | `ValueError of string ]) result

(** [calculate_mac t msg extra_info]

    Generate a message authentication code (MAC) based on the shared secret
    held in the SAS object [t], for [msg]. [extra_info] is mixed in with when
    generating the MAC. *)
val calculate_mac : t -> string -> string -> (string, [> OlmError.t ]) result

(** [calculate_mac_long_kdf t msg extra_info]

    For compatibility with an old version of Riot. Should not be used unless
    compatibility with an older non-tagged Olm version is required. *)
val calculate_mac_long_kdf : t -> string -> string -> (string, [> OlmError.t ]) result
