#include "olm/crypto.h"
#include "olm/error.h"
#include "olm/megolm.h"

struct OlmInboundGroupSession {
    Megolm initial_ratchet;
    Megolm latest_ratchet;
    struct _olm_ed25519_public_key signing_key;
    int signing_key_verified;
    enum OlmErrorCode last_error;
};

struct OlmOutboundGroupSession {
    Megolm ratchet;
    struct _olm_ed25519_key_pair signing_key;
    enum OlmErrorCode last_error;
};

struct OlmPkEncryption {
  enum OlmErrorCode last_error;
  struct _olm_curve25519_public_key recipient_key;
};

struct OlmPkDecryption {
  enum OlmErrorCode last_error;
  struct _olm_curve25519_key_pair key_pair;
};

struct OlmPkSigning {
  enum OlmErrorCode last_error;
  struct _olm_ed25519_key_pair key_pair;
};

struct OlmSAS {
    enum OlmErrorCode last_error;
    struct _olm_curve25519_key_pair curve25519_key;
    uint8_t secret[CURVE25519_SHARED_SECRET_LENGTH];
    int their_key_set;
};
