open Core

module Message : sig
  type t = { ephemeral_key : string
           ; mac : string
           ; ciphertext : string
           }

  (** [create ephemeral_key mac ciphertext] *)
  val create : string -> string -> string -> t
end

module Encryption : sig
  type t = { buf    : char Ctypes.ptr
           ; pk_enc : C.Types.PkEncryption.t Ctypes_static.ptr
           }

  (** [clear pk_enc] *)
  val clear : C.Types.PkEncryption.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

  (** [check_error t ret] *)
  val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

  (** [alloc ()] *)
  val alloc : unit -> t

  (** [create recipient_key] *)
  val create : string -> (t, [> OlmError.t | `ValueError of string ]) result

  (** [encrypt t plaintext] *)
  val encrypt : t -> string -> (Message.t, [> OlmError.t ]) result
end

module Decryption : sig
  type t = { buf    : char Ctypes.ptr
           ; pk_dec : C.Types.PkDecryption.t Ctypes_static.ptr
           ; pubkey : string
           }

  (** [clear pk_dec] *)
  val clear : C.Types.PkDecryption.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

  (** [check_error t ret] *)
  val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

  (** [alloc ()] *)
  val alloc : unit -> t

  (** [create ()] *)
  val create : unit -> (t, [> OlmError.t ]) result

  (** [pickle ?pass t] *)
  val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

  (** [from_pickle ?pass pickle] *)
  val from_pickle :
    ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

  (** [decrypt t msg] *)
  val decrypt : t -> Message.t -> (string, [> OlmError.t ]) result

  (** [private_key t] *)
  val private_key : t -> (string, [> OlmError.t ]) result
end

module Signing : sig
  type t = { buf    : char Ctypes.ptr
           ; pk_sgn : C.Types.PkSigning.t Ctypes.ptr
           ; pubkey : string
           }

  (** [clear pk_sgn] *)
  val clear : C.Types.PkSigning.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

  (** [check_error t ret] *)
  val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

  (** [alloc ()] *)
  val alloc : unit -> t

  (** [create seed] *)
  val create : string -> (t, [> OlmError.t | `ValueError of string ]) result

  (** [generate_seed ()] *)
  val generate_seed : unit -> string

  (** [sign t msg_str] *)
  val sign : t -> string -> (string, [> OlmError.t ]) result
end
