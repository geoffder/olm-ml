open Ctypes

let sha256_output_length            = 32
let curve25519_key_length           = 32
let curve25519_shared_secret_length = 32
let curve25519_random_length        = curve25519_key_length
let ed25519_public_key_length       = 32
let ed25519_private_key_length      = 64
let ed25519_random_length           = 32
let ed25519_signature_length        = 64
let aes256_key_length               = 32
let aes256_iv_length                = 16

module OlmAes256Key = struct
  type t
  let t : t structure typ = structure "_olm_aes256_key"
  let key                 = field t "key" (array aes256_key_length uint8_t)
  let ()                  = seal t
end

module OlmAes256Iv = struct
  type t
  let t : t structure typ = structure "_olm_aes256_iv"
  let iv                  = field t "iv" (array aes256_iv_length uint8_t)
  let ()                  = seal t
end

module OlmCurve25519PublicKey = struct
  type t
  let t : t structure typ = structure "_olm_curve25519_public_key"
  let public_key          = field t "public_key" (array curve25519_key_length uint8_t)
  let ()                  = seal t
end

module OlmCurve25519PrivateKey = struct
  type t
  let t : t structure typ = structure "_olm_curve25519_private_key"
  let private_key         = field t "private_key" (array curve25519_key_length uint8_t)
  let ()                  = seal t
end

module OlmCurve25519KeyPair = struct
  type t
  let t : t structure typ = structure "_olm_curve25519_key_pair"
  let public_key          = field t "public_key" OlmCurve25519PublicKey.t
  let private_key         = field t "private_key" OlmCurve25519PrivateKey.t
  let ()                  = seal t
end

module OlmED25519PublicKey = struct
  type t
  let t : t structure typ = structure "_olm_ed25519_public_key"
  let public_key          = field t "public_key" (array ed25519_public_key_length uint8_t)
  let ()                  = seal t
end

module OlmED25519PrivateKey = struct
  type t
  let t : t structure typ = structure "_olm_ed25519_private_key"
  let private_key         = field t "private_key" (array ed25519_private_key_length uint8_t)
  let ()                  = seal t
end

module OlmED25519KeyPair = struct
  type t
  let t : t structure typ = structure "_olm_ed25519_key_pair"
  let public_key          = field t "public_key" OlmED25519PublicKey.t
  let private_key         = field t "private_key" OlmED25519PrivateKey.t
  let ()                  = seal t
end
