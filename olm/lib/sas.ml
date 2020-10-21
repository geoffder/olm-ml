open Ctypes
open Foreign

open Dynamic
open Crypto
open Error

module OlmSAS = struct
  type t
  let t : t structure typ = structure "OlmSAS"
  let last_error     = field t "last_error" OlmErrorCode.t
  let curve25519_key = field t "curve25519_key" OlmCurve25519KeyPair.t
  let secret         = field t "secret" (array curve25519_shared_secret_length uint8_t)
  let their_key_set  = field t "their_key_set" int
  let ()             = seal t

  let allocate_void () : unit ptr =
    allocate_n t ~count:1 |> coerce (ptr t) (ptr void)
end

let olm_sas_last_error =
  foreign ~from:libolm "olm_sas_last_error"
    (ptr OlmSAS.t @-> returning (ptr char))

let olm_sas_size =
  foreign ~from:libolm "olm_sas_size"
    (void @-> returning size_t)

let olm_sas =
  foreign ~from:libolm "olm_sas"
    (ptr void @-> returning (ptr OlmSAS.t))

let olm_clear_sas =
  foreign ~from:libolm "olm_clear_sas"
    (ptr OlmSAS.t @-> returning size_t)

let olm_create_sas_random_length =
  foreign ~from:libolm "olm_create_sas_random_length"
    (void @-> returning size_t)

let olm_create_sas =
  foreign ~from:libolm "olm_create_sas"
    (ptr OlmSAS.t          (* sas *)
     @-> ptr void          (* random *)
     @-> size_t            (* random_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_sas_pubkey_length =
  foreign ~from:libolm "olm_sas_pubkey_length"
    (ptr OlmSAS.t @-> returning size_t)

let olm_sas_get_pubkey =
  foreign ~from:libolm "olm_sas_get_pubkey"
    (ptr OlmSAS.t          (* sas *)
     @-> ptr void          (* pubkey *)
     @-> size_t            (* pubkey_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_sas_set_their_key =
  foreign ~from:libolm "olm_sas_set_their_key"
    (ptr OlmSAS.t          (* sas *)
     @-> ptr void          (* their_key *)
     @-> size_t            (* their_key_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_sas_is_their_key_set =
  foreign ~from:libolm "olm_sas_is_their_key_set"
    (ptr OlmSAS.t @-> returning int)

let olm_sas_generate_bytes =
  foreign ~from:libolm "olm_sas_generate_bytes"
    (ptr OlmSAS.t          (* sas *)
     @-> ptr void          (* info *)
     @-> size_t            (* info_length *)
     @-> ptr void          (* output *)
     @-> size_t            (* output_length *)
     @-> returning size_t) (* olm_error on failure *)

let olm_sas_mac_length =
  foreign ~from:libolm "olm_sas_mac_length"
    (ptr OlmSAS.t @-> returning size_t)

let olm_sas_calculate_mac =
  foreign ~from:libolm "olm_sas_calculate_mac"
    (ptr OlmSAS.t          (* sas *)
     @-> ptr void          (* input *)
     @-> size_t            (* input_length *)
     @-> ptr void          (* info *)
     @-> size_t            (* info_length *)
     @-> ptr void          (* mac *)
     @-> size_t            (* mac_length *)
     @-> returning size_t) (* olm_error on failure *)
