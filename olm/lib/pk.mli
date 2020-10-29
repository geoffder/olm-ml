open Core

module Message : sig
  type t = { ephemeral_key : string
           ; mac : string
           ; ciphertext : string
           }

  val create : string -> string -> string -> t
end

module Encryption : sig
  type t = { buf    : char Ctypes.ptr
           ; pk_enc : C.Types.PkEncryption.t Ctypes_static.ptr
           }

  val size : int

  val clear : C.Types.PkEncryption.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

  val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

  val alloc : unit -> t

  val create : string -> (t, [> OlmError.t | `ValueError of string ]) result

  val encrypt : t -> string -> (Message.t, [> OlmError.t ]) result
end

module Decryption : sig
  type t = { buf    : char Ctypes.ptr
           ; pk_dec : C.Types.PkDecryption.t Ctypes_static.ptr
           ; pubkey : string
           }

  val size : int

  val clear : C.Types.PkDecryption.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

  val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

  val alloc : unit -> t

  val create : unit -> (t, [> OlmError.t ]) result

  val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) result

  val from_pickle :
    ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) result

  val decrypt : t -> Message.t -> (string, [> OlmError.t ]) result

  val private_key : t -> (string, [> OlmError.t ]) result
end

module Signing : sig
  type t = { buf    : char Ctypes.ptr
           ; pk_sgn : C.Types.PkSigning.t Ctypes.ptr
           ; pubkey : string
           }

  val size : int

  val clear : C.Types.PkSigning.t Ctypes_static.ptr -> (int, [> `OlmError ]) result

  val check_error : t -> Unsigned.size_t -> (int, [> OlmError.t ]) result

  val alloc : unit -> t

  val create : string -> (t, [> OlmError.t | `ValueError of string ]) result

  val generate_seed : unit -> string

  val sign : t -> string -> (string, [> OlmError.t ]) result
end
