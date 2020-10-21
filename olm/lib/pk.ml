open Ctypes
open Foreign

open Crypto
open Dynamic
open Error

module OlmPkEncryption = struct
  type t
  let t : t structure typ = structure "OlmPkEncryption"
  let last_error          = field t "last_error" OlmErrorCode.t
  let recipient_key       = field t "recipient_key" OlmCurve25519PublicKey.t
  let ()                  = seal t

  let allocate_void () : unit ptr =
    allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
end

let olm_pk_encryption_size =
  foreign ~from:libolm "olm_pk_encryption_size"
    (void @-> returning size_t)

let olm_pk_encryption =
  foreign ~from:libolm "olm_pk_encryption"
    (ptr void @-> returning (ptr OlmPkEncryption.t))

let olm_pk_encryption_last_error =
  foreign ~from:libolm "olm_pk_encryption_last_error"
    (ptr OlmPkEncryption.t @-> returning (ptr char))

let olm_clear_pk_encryption =
  foreign ~from:libolm "olm_clear_pk_encryption"
    (ptr OlmPkEncryption.t @-> returning size_t)

let olm_pk_encryption_set_recipient_key =
  foreign ~from:libolm "olm_pk_encryption_set_recipient_key"
    (ptr OlmPkEncryption.t (* encryption *)
     @-> ptr void          (* public_key *)
     @-> size_t            (* public_key_length*)
     @-> returning size_t) (* olm_error (?) *)

let olm_pk_ciphertext_length =
  foreign ~from:libolm "olm_pk_ciphertext_length"
    (ptr OlmPkEncryption.t (* encryption *)
     @-> size_t            (* plaintext_length*)
     @-> returning size_t) (* length of ciphertext for given plaintext length *)

let olm_pk_mac_length =
  foreign ~from:libolm "olm_pk_mac_length"
    (ptr OlmPkEncryption.t @-> returning size_t)

let olm_pk_key_length =
  foreign ~from:libolm "olm_pk_key_length"
    (void @-> returning size_t)

let olm_pk_encrypt_random_length =
  foreign ~from:libolm "olm_pk_encrypt_random_length"
    (ptr OlmPkEncryption.t @-> returning size_t)

let olm_pk_encrypt =
  foreign ~from:libolm "olm_pk_encrypt"
    (ptr OlmPkEncryption.t (* encryption *)
     @-> ptr void          (* plaintext *)
     @-> size_t            (* plaintext_length*)
     @-> ptr void          (* ciphertext *)
     @-> size_t            (* ciphertext_length*)
     @-> ptr void          (* mac *)
     @-> size_t            (* mac_length*)
     @-> ptr void          (* ephemberal_key *)
     @-> size_t            (* ephemberal_key_size*)
     @-> ptr void          (* random *)
     @-> size_t            (* random_length*)
     @-> returning size_t) (* olm_error on failure *)

module OlmPkDecryption = struct
  type t
  let t : t structure typ = structure "OlmPkDecryption"
  let last_error          = field t "last_error" OlmErrorCode.t
  let key_pair            = field t "key_pair" OlmCurve25519KeyPair.t
  let ()                  = seal t

  let allocate_void () : unit ptr =
    allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
end

let olm_pk_decryption_size =
  foreign ~from:libolm "olm_pk_decryption_size"
    (void @-> returning size_t)

let olm_pk_decryption =
  foreign ~from:libolm "olm_pk_decryption"
    (ptr void @-> returning (ptr OlmPkDecryption.t))

let olm_pk_decryption_last_error =
  foreign ~from:libolm "olm_pk_decryption_last_error"
    (ptr OlmPkDecryption.t @-> returning (ptr char))

let olm_clear_pk_decryption =
  foreign ~from:libolm "olm_clear_pk_decryption"
    (ptr OlmPkDecryption.t @-> returning size_t)

let olm_pk_private_key_length =
  foreign ~from:libolm "olm_pk_private_key_length"
    (void @-> returning size_t)

let olm_pk_generate_key_random_length =
  foreign ~from:libolm "olm_pk_generate_key_random_length"
    (void @-> returning size_t)

let olm_pk_key_from_private =
  foreign ~from:libolm "olm_pk_key_from_private"
    (ptr OlmPkDecryption.t (* decryption *)
     @-> ptr void          (* pubkey *)
     @-> size_t            (* pubkey_length*)
     @-> ptr void          (* privkey *)
     @-> size_t            (* privkey_length*)
     @-> returning size_t) (* olm_error on failure *)

let olm_pickle_pk_decryption_length =
  foreign ~from:libolm "olm_pickle_pk_decryption_length"
    (ptr OlmPkDecryption.t @-> returning size_t)

let olm_pickle_pk_decryption =
  foreign ~from:libolm "olm_pickle_pk_decryption"
    (ptr OlmPkDecryption.t (* decryption *)
     @-> ptr void          (* key *)
     @-> size_t            (* key_length *)
     @-> ptr void          (* pickled *)
     @-> size_t            (* pickled_length*)
     @-> returning size_t) (* olm_error on failure *)

let olm_unpickle_pk_decryption =
  foreign ~from:libolm "olm_unpickle_pk_decryption"
    (ptr OlmPkDecryption.t (* decryption *)
     @-> ptr void          (* key *)
     @-> size_t            (* key_length *)
     @-> ptr void          (* pickled *)
     @-> size_t            (* pickled_length*)
     @-> ptr void          (* pubkey *)
     @-> size_t            (* pubkey_length*)
     @-> returning size_t) (* olm_error on failure *)

let olm_pk_max_plaintext_length =
  foreign ~from:libolm "olm_pk_max_plaintext_length"
    (ptr OlmPkDecryption.t (* decryption *)
     @-> size_t            (* ciphertext_length *)
     @-> returning size_t) (* length of plaintext to result from decrypt *)

let olm_pk_decrypt =
  foreign ~from:libolm "olm_pk_decrypt"
    (ptr OlmPkDecryption.t (* decryption *)
     @-> ptr void          (* ephemberal_key *)
     @-> size_t            (* ephemberal_key_length *)
     @-> ptr void          (* mac *)
     @-> size_t            (* mac_length*)
     @-> ptr void          (* ciphertext *)
     @-> size_t            (* ciphertext_length*)
     @-> ptr void          (* plaintext *)
     @-> size_t            (* max_plaintext_length*)
     @-> returning size_t) (* olm_error on failure *)

let olm_pk_get_private_key =
  foreign ~from:libolm "olm_pk_get_private_key"
    (ptr OlmPkDecryption.t (* decryption *)
     @-> ptr void          (* private_key *)
     @-> size_t            (* private_key_length *)
     @-> returning size_t) (* olm_error if given buffer is too small *)

module OlmPkSigning = struct
  type t
  let t : t structure typ = structure "OlmPkSigning"
  let last_error          = field t "last_error" OlmErrorCode.t
  let key_pair            = field t "key_pair" OlmED25519KeyPair.t
  let ()                  = seal t

  let allocate_void () : unit ptr =
    allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
end

let olm_pk_signing_size =
  foreign ~from:libolm "olm_pk_signing_size"
    (void @-> returning size_t)

let olm_pk_signing =
  foreign ~from:libolm "olm_pk_signing"
    (ptr void @-> returning (ptr OlmPkSigning.t))

let olm_pk_signing_last_error =
  foreign ~from:libolm "olm_pk_signing_last_error"
    (ptr OlmPkSigning.t @-> returning (ptr char))

let olm_clear_pk_signing =
  foreign ~from:libolm "olm_clear_pk_signing"
    (ptr OlmPkSigning.t @-> returning size_t)

let olm_pk_signing_seed_length =
  foreign ~from:libolm "olm_pk_signing_seed_length"
    (void @-> returning size_t)

let olm_pk_signing_public_key_length =
  foreign ~from:libolm "olm_pk_signing_public_key_length"
    (void @-> returning size_t)

let olm_pk_signature_length =
  foreign ~from:libolm "olm_pk_signature_length"
    (void @-> returning size_t)

let olm_pk_sign =
  foreign ~from:libolm "olm_pk_sign"
    (ptr OlmPkSigning.t    (* signing *)
     @-> ptr void          (* message *)
     @-> size_t            (* message_length*)
     @-> ptr void          (* signature *)
     @-> size_t            (* signature_length*)
     @-> returning size_t) (* olm_error on failure *)
