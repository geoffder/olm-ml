(* open Ctypes
 * open Foreign
 *
 * open Crypto
 * open Dynamic
 * open Error *)

(* base64.h *)

(* let _olm_encode_base64_length =
 *   foreign ~from:libolm "_olm_encode_base64_length"
 *     (size_t @-> returning size_t)
 *
 * let _olm_encode_base64 =
 *   foreign ~from:libolm "_olm_encode_base64"
 *     (ptr uint8_t           (\* input *\)
 *      @-> size_t            (\* input_length *\)
 *      @-> ptr uint8_t       (\* output *\)
 *      @-> returning size_t) (\* number of bytes encoded *\)
 *
 * let _olm_decode_base64_length =
 *   foreign ~from:libolm "_olm_decode_base64_length"
 *     (size_t @-> returning size_t)
 *
 * let _olm_decode_base64 =
 *   foreign ~from:libolm "_olm_decode_base64"
 *     (ptr uint8_t           (\* input *\)
 *      @-> size_t            (\* input_length *\)
 *      @-> ptr uint8_t       (\* output *\)
 *      @-> returning size_t) (\* number of bytes encoded *\)
 *
 * (\* crypto.h *\)
 *
 * let _olm_crypto_aes_encrypt_cbc_length =
 *   foreign ~from:libolm "_olm_crypto_aes_encrypt_cbc_length"
 *     (size_t @-> returning size_t)
 *
 * let _olm_crypto_aes_encrypt_cbc =
 *   foreign ~from:libolm "_olm_crypto_aes_encrypt_cbc"
 *     (ptr OlmAes256Key.t    (\* key *\)
 *      @-> ptr OlmAes256Iv.t (\* iv *\)
 *      @-> ptr uint8_t       (\* input *\)
 *      @-> size_t            (\* input_length *\)
 *      @-> ptr uint8_t       (\* output *\)
 *      @-> returning void)
 *
 * let _olm_crypto_aes_decrypt_cbc =
 *   foreign ~from:libolm "_olm_crypto_aes_decrypt_cbc"
 *     (ptr OlmAes256Key.t     (\* key *\)
 *      @-> ptr OlmAes256Iv.t  (\* iv *\)
 *      @-> ptr uint8_t        (\* input *\)
 *      @-> size_t             (\* input_length *\)
 *      @-> ptr uint8_t        (\* output *\)
 *      @-> returning uint8_t) (\* length of plaintext without padding on success *\)
 *
 * let _olm_crypto_sha256 =
 *   foreign ~from:libolm "_olm_crypto_sha256"
 *     (ptr uint8_t         (\* input *\)
 *      @-> size_t          (\* input_length *\)
 *      @-> ptr uint8_t     (\* output *\)
 *      @-> returning void)
 *
 * let _olm_crypto_hmac_sha256 =
 *   foreign ~from:libolm "_olm_crypto_hmac_sha256"
 *     (ptr uint8_t         (\* key *\)
 *      @-> size_t          (\* key_length *\)
 *      @-> ptr uint8_t     (\* input *\)
 *      @-> size_t          (\* input_length *\)
 *      @-> ptr uint8_t     (\* output *\)
 *      @-> returning void)
 *
 * let _olm_crypto_hkdf_sha256 =
 *   foreign ~from:libolm "_olm_crypto_hkdf_sha256"
 *     (ptr uint8_t         (\* input *\)
 *      @-> size_t          (\* input_length *\)
 *      @-> ptr uint8_t     (\* info *\)
 *      @-> size_t          (\* info_length *\)
 *      @-> ptr uint8_t     (\* salt *\)
 *      @-> size_t          (\* salt_length *\)
 *      @-> ptr uint8_t     (\* output *\)
 *      @-> size_t          (\* output_length *\)
 *      @-> returning void)
 *
 * let _olm_crypto_curve25519_generate_key =
 *   foreign ~from:libolm "_olm_crypto_curve25519_generate_key"
 *     (ptr uint8_t                    (\* random_32_bytes *\)
 *      @-> ptr OlmCurve25519KeyPair.t (\* output *\)
 *      @-> returning void)
 *
 * let _olm_crypto_curve25519_shared_secret =
 *   foreign ~from:libolm "_olm_crypto_curve25519_shared_secret"
 *     (ptr OlmCurve25519KeyPair.t       (\* our_key *\)
 *      @-> ptr OlmCurve25519PublicKey.t (\* their_key *\)
 *      @-> ptr uint8_t                  (\* output *\)
 *      @-> returning void)
 *
 * let _olm_crypto_ed25519_generate_key =
 *   foreign ~from:libolm "_olm_crypto_ed25519_generate_key"
 *     (ptr uint8_t                 (\* random_bytes *\)
 *      @-> ptr OlmED25519KeyPair.t (\* output *\)
 *      @-> returning void)
 *
 * let _olm_crypto_ed25519_sign =
 *   foreign ~from:libolm "_olm_crypto_ed25519_sign"
 *     (ptr OlmED25519KeyPair.t (\* our_key *\)
 *      @-> ptr uint8_t         (\* message *\)
 *      @-> size_t              (\* message_length *\)
 *      @-> ptr uint8_t         (\* output *\)
 *      @-> returning void)
 *
 * let _olm_crypto_ed25519_verify =
 *   foreign ~from:libolm "_olm_crypto_ed25519_verify"
 *     (ptr OlmED25519PublicKey.t (\* their_key *\)
 *      @-> ptr uint8_t           (\* message *\)
 *      @-> size_t                (\* message_length *\)
 *      @-> ptr uint8_t           (\* signature *\)
 *      @-> returning int)        (\* non-zero if valid *\)
 *
 * (\* memory.h *\)
 *
 * let _olm_unset =
 *   foreign ~from:libolm "_olm_unset"
 *     (ptr void            (\* buffer *\)
 *      @-> size_t          (\* buffer_length *\)
 *      @-> returning void)
 *
 * (\* message.h *\)
 *
 * module OlmDecodeGroupMessageResults = struct
 *   type t
 *   let t : t structure typ = structure "_OlmDecodeGroupMessageResults"
 *   let version             = field t "version" uint8_t
 *   let message_index       = field t "message_index" uint32_t
 *   let has_message_index   = field t "has_message_index" int
 *   let ciphertext          = field t "ciphertext" (ptr uint8_t)
 *   let ciphertext_length   = field t "ciphertext_length" size_t
 *   let ()                  = seal t
 * end
 *
 * let _olm_encode_group_message_length =
 *   foreign ~from:libolm "_olm_encode_group_message_length"
 *     (uint32_t              (\* chain_index *\)
 *      @-> size_t            (\* ciphertext_length *\)
 *      @-> size_t            (\* mac_length *\)
 *      @-> size_t            (\* signature_length *\)
 *      @-> returning size_t) (\* length of buffer needed to hold a group message *\)
 *
 * let _olm_encode_group_message =
 *   foreign ~from:libolm "_olm_encode_group_message"
 *     (uint8_t               (\* version *\)
 *      @-> uint32_t          (\* message_index *\)
 *      @-> size_t            (\* ciphertext_length *\)
 *      @-> ptr uint8_t       (\* output *\)
 *      @-> ptr (ptr uint8_t) (\* ciphertext_ptr *\)
 *      @-> returning size_t) (\* size of message, up to the MAC *\)
 *
 * let _olm_decode_group_message =
 *   foreign ~from:libolm "_olm_decode_group_message"
 *     (ptr uint8_t                            (\* input *\)
 *      @-> size_t                             (\* input_length *\)
 *      @-> size_t                             (\* mac_length *\)
 *      @-> size_t                             (\* signature_length *\)
 *      @-> ptr OlmDecodeGroupMessageResults.t (\* results *\)
 *      @-> returning void)
 *
 * (\* pickle.h *\)
 *
 * let _olm_pickle_uint32 =
 *   foreign ~from:libolm "_olm_pickle_uint32"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr uint32_t             (\* value *\)
 *      @-> returning (ptr uint8_t)) (\* new position (?) *\)
 *
 * let _olm_unpickle_uint32 =
 *   foreign ~from:libolm "_olm_unpickle_uint32"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr uint8_t              (\* end *\)
 *      @-> ptr uint32_t             (\* value *\)
 *      @-> returning (ptr uint8_t)) (\* new position (?) *\)
 *
 * let _olm_pickle_bool =
 *   foreign ~from:libolm "_olm_pickle_bool"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr int                  (\* value *\)
 *      @-> returning (ptr uint8_t)) (\* new position (?) *\)
 *
 * let _olm_unpickle_bool =
 *   foreign ~from:libolm "_olm_unpickle_bool"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr uint8_t              (\* end *\)
 *      @-> ptr int                  (\* value *\)
 *      @-> returning (ptr uint8_t)) (\* new position (?) *\)
 *
 * let _olm_pickle_bytes =
 *   foreign ~from:libolm "_olm_pickle_bytes"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr uint8_t              (\* bytes *\)
 *      @-> size_t                   (\* bytes_length *\)
 *      @-> returning (ptr uint8_t)) (\* new position (?) *\)
 *
 * let _olm_unpickle_bytes =
 *   foreign ~from:libolm "_olm_unpickle_bytes"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr uint8_t              (\* end *\)
 *      @-> ptr uint8_t              (\* bytes *\)
 *      @-> size_t                   (\* bytes_length *\)
 *      @-> returning (ptr uint8_t)) (\* new position (?) *\)
 *
 * let _olm_pickle_ed25519_public_key_length =
 *   foreign ~from:libolm "_olm_pickle_ed25519_public_key_length"
 *     (ptr OlmED25519PublicKey.t @-> returning size_t)
 *
 * let _olm_pickle_ed25519_public_key =
 *   foreign ~from:libolm "_olm_pickle_ed25519_public_key"
 *     (ptr uint8_t                   (\* pos *\)
 *      @-> ptr OlmED25519PublicKey.t (\* value *\)
 *      @-> returning (ptr uint8_t))  (\* pointer to next free space in the buffer *\)
 *
 * let _olm_unpickle_ed25519_public_key =
 *   foreign ~from:libolm "_olm_unpickle_ed25519_public_key"
 *     (ptr uint8_t                   (\* pos *\)
 *      @-> ptr uint8_t               (\* end *\)
 *      @-> ptr OlmED25519PublicKey.t (\* value *\)
 *      @-> returning (ptr uint8_t))  (\* pointer to next item in the buffer *\)
 *
 * let _olm_pickle_ed25519_key_pair_length =
 *   foreign ~from:libolm "_olm_pickle_ed25519_key_pair_length"
 *     (ptr OlmED25519KeyPair.t @-> returning size_t)
 *
 * let _olm_pickle_ed25519_key_pair =
 *   foreign ~from:libolm "_olm_pickle_ed25519_key_pair"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr OlmED25519KeyPair.t  (\* value *\)
 *      @-> returning (ptr uint8_t)) (\* pointer to next free space in the buffer *\)
 *
 * let _olm_unpickle_ed25519_key_pair =
 *   foreign ~from:libolm "_olm_unpickle_ed25519_key_pair"
 *     (ptr uint8_t                  (\* pos *\)
 *      @-> ptr uint8_t              (\* end *\)
 *      @-> ptr OlmED25519KeyPair.t  (\* value *\)
 *      @-> returning (ptr uint8_t)) (\* pointer to next item in the buffer *\)
 *
 * (\* pickle_encoding.h *\)
 *
 * let _olm_enc_output_length =
 *   foreign ~from:libolm "_olm_enc_output_length"
 *     (size_t @-> returning size_t)
 *
 * let _olm_enc_output_pos =
 *   foreign ~from:libolm "_olm_enc_output_pos"
 *     (ptr uint8_t                  (\* output *\)
 *      @-> size_t                   (\* raw_length *\)
 *      @-> returning (ptr uint8_t)) (\* point in output buffer to be written to *\)
 *
 * let _olm_enc_output =
 *   foreign ~from:libolm "_olm_enc_output"
 *     (ptr uint8_t           (\* key *\)
 *      @-> size_t            (\* key_length *\)
 *      @-> ptr uint8_t       (\* pickle *\)
 *      @-> size_t            (\* raw_length *\)
 *      @-> returning size_t) (\* number of bytes in encoded pickle *\)
 *
 * let _olm_enc_input =
 *   foreign ~from:libolm "_olm_enc_input"
 *     (ptr uint8_t            (\* key *\)
 *      @-> size_t             (\* key_length *\)
 *      @-> ptr uint8_t        (\* input *\)
 *      @-> size_t             (\* b64_length *\)
 *      @-> ptr OlmErrorCode.t (\* last_error *\)
 *      @-> returning size_t)  (\* bytes in decoded pickle or olm_error *\) *)

(* megolm.h *)

(* let megolm_init =
 *   foreign ~from:libolm "megolm_init"
 *     (ptr Megolm.t        (\* megolm *\)
 *      @-> ptr uint8_t     (\* random_data *\)
 *      @-> uint32_t        (\* counter *\)
 *      @-> returning void)
 *
 * let megolm_pickle_length =
 *   foreign ~from:libolm "megolm_pickle_length"
 *     (ptr Megolm.t @-> returning size_t)
 *
 * let megolm_pickle =
 *   foreign ~from:libolm "megolm_pickle"
 *     (ptr Megolm.t                 (\* megolm *\)
 *      @-> ptr uint8_t              (\* pos *\)
 *      @-> returning (ptr uint8_t)) (\* pointer to next free space in the buffer *\)
 *
 * let megolm_unpickle =
 *   foreign ~from:libolm "megolm_unpickle"
 *     (ptr Megolm.t                 (\* megolm *\)
 *      @-> ptr uint8_t              (\* pos *\)
 *      @-> ptr uint8_t              (\* end *\)
 *      @-> returning (ptr uint8_t)) (\* pointer to next item in the buffer *\)
 *
 * let megolm_advance =
 *   foreign ~from:libolm "megolm_advance"
 *     (ptr Megolm.t @-> returning void)
 *
 * let megolm_advance_to =
 *   foreign ~from:libolm "megolm_advance_to"
 *     (ptr Megolm.t        (\* megolm *\)
 *      @-> uint32_t        (\* advance_to *\)
 *      @-> returning void) *)
