(** This module contains utilities for olm. *)

open Core

type t = { buf  : char Ctypes.ptr
         ; util : C.Types.Utility.t Ctypes_static.ptr
         }

(** [clear util]

    Clear memory backing the given [util] pointer. *)
val clear : C.Types.Utility.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

(** [check_error t ret]

    Check whether return code [ret] is equal to `olm_error()` ( -1 ), returning
    the return value as an int if not, and the `last_error` from the utility
    object [t] if so. *)
val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

(** [alloc ()]

    Allocate an [C.Types.Utility.t] and return the pointers in a [t]. *)
val alloc : unit -> t

(** [create ()]

    Alias to [alloc ()], as no additional actions that might cause creation to
    fail are required after allocation and instantiation. *)
val create : unit -> t

(** [ed25519_verify t key message signature]

    Verify that [key] was used to sign [message] to produce the ed25519 [signature]
    with the utility [t]. *)
val ed25519_verify : t -> string -> string -> string -> (int, [> OlmError.t ]) result

(** [sha256 t input]

    Use [t] to calculate the SHA-256 hash of the [input] and encodes it as base64. *)
val sha256 : t -> string -> (string, [> OlmError.t ]) result
