(** Bindings to libolm. Docstrings are adapted from the
    {{: https://gitlab.matrix.org/matrix-org/olm/-/tree/master/include/olm }
    C Headers. } *)

module Types : sig
  val sha256_output_length            : int
  val curve25519_key_length           : int
  val curve25519_shared_secret_length : int
  val curve25519_random_length        : int
  val ed25519_public_key_length       : int
  val ed25519_private_key_length      : int
  val ed25519_random_length           : int
  val ed25519_signature_length        : int
  val aes256_key_length               : int
  val aes256_iv_length                : int
  val megolm_ratchet_part_length      : int
  val megolm_ratchet_parts            : int
  val megolm_ratchet_length           : int

  module ErrorCode : sig
    val olm_success                   : int64 Olm_c_generated_types.const
    val olm_not_enough_random         : int64 Olm_c_generated_types.const
    val olm_output_buffer_too_small   : int64 Olm_c_generated_types.const
    val olm_bad_message_version       : int64 Olm_c_generated_types.const
    val olm_bad_message_format        : int64 Olm_c_generated_types.const
    val olm_bad_message_mac           : int64 Olm_c_generated_types.const
    val olm_bad_message_key_id        : int64 Olm_c_generated_types.const
    val olm_invalid_base64            : int64 Olm_c_generated_types.const
    val olm_bad_account_key           : int64 Olm_c_generated_types.const
    val olm_unknown_pickle_version    : int64 Olm_c_generated_types.const
    val olm_corrupted_pickle          : int64 Olm_c_generated_types.const
    val olm_bad_session_key           : int64 Olm_c_generated_types.const
    val olm_unknown_message_index     : int64 Olm_c_generated_types.const
    val olm_bad_legacy_account_pickle : int64 Olm_c_generated_types.const
    val olm_bad_signature             : int64 Olm_c_generated_types.const
    val olm_input_buffer_too_small    : int64 Olm_c_generated_types.const
    val olm_sas_their_key_not_set     : int64 Olm_c_generated_types.const

    type t =
      Olm_c_type_descriptions.Descriptions(Olm_c_generated_types).ErrorCode.t =
        Success
      | NotEnoughRandom
      | OutputBufferTooSmall
      | BadMessageVersion
      | BadMessageFormat
      | BadMessageMac
      | BadMessageKeyId
      | InvalidBase64
      | BadAccountKey
      | UnknownPickleVersion
      | CorruptedPickle
      | BadSessionKey
      | UnknownMessageIndex
      | BadLegacyAccountPickle
      | BadSignature
      | InputBufferTooSmall
      | SasTheirKeyNotSet

    val t         : t Ctypes_static.typ
    val to_string : t -> string
  end

  module Aes256Key : sig
    type t = [ `Aes256Key ] Ctypes.structure
    val t   : t Ctypes_static.typ
    val key : (Unsigned.uint8 Ctypes_static.carray, t) Olm_c_generated_types.field
  end

  module Aes256Iv : sig
    type t = [ `Aes256Iv ] Ctypes.structure
    val t  : t Ctypes_static.typ
    val iv : (Unsigned.uint8 Ctypes_static.carray, t) Olm_c_generated_types.field
  end

  module Curve25519PublicKey : sig
    type t = [ `Curve25519PublicKey ] Ctypes.structure
    val t          : t Ctypes_static.typ
    val public_key : (Unsigned.uint8 Ctypes_static.carray, t) Olm_c_generated_types.field
  end

  module Curve25519PrivateKey : sig
    type t = [ `Curve25519PrivateKey ] Ctypes.structure
    val t           : t Ctypes_static.typ
    val private_key : (Unsigned.uint8 Ctypes_static.carray, t) Olm_c_generated_types.field
  end

  module Curve25519KeyPair : sig
    type t = [ `Curve25519KeyPair ] Ctypes.structure
    val t           : t Ctypes_static.typ
    val public_key  : (Curve25519PublicKey.t, t) Olm_c_generated_types.field
    val private_key : (Curve25519PrivateKey.t, t) Olm_c_generated_types.field
  end

  module ED25519PublicKey : sig
    type t = [ `ED25519PublicKey ] Ctypes.structure
    val t          : t Ctypes_static.typ
    val public_key : (Unsigned.uint8 Ctypes_static.carray, t) Olm_c_generated_types.field
  end

  module ED25519PrivateKey : sig
    type t = [ `ED25519PrivateKey ] Ctypes.structure
    val t           : t Ctypes_static.typ
    val private_key : (Unsigned.uint8 Ctypes_static.carray, t) Olm_c_generated_types.field
  end

  module ED25519KeyPair : sig
    type t = [ `ED25519KeyPair ] Ctypes.structure
    val t           : t Ctypes_static.typ
    val public_key  : (ED25519PublicKey.t, t) Olm_c_generated_types.field
    val private_key : (ED25519PrivateKey.t, t) Olm_c_generated_types.field
  end

  module Megolm : sig
    type t = [ `Megolm ] Ctypes.structure
    val t    : t Ctypes_static.typ
    val data :
      (Unsigned.uint8 Ctypes_static.carray Ctypes_static.carray, t)
        Olm_c_generated_types.field
    val counter : (Unsigned.uint32, t) Olm_c_generated_types.field
  end

  module InboundGroupSession : sig
    type t = [ `InboundGroupSession ] Ctypes.structure
    val t                    : t Ctypes_static.typ
    val initial_ratchet      : (Megolm.t, t) Olm_c_generated_types.field
    val latest_ratchet       : (Megolm.t, t) Olm_c_generated_types.field
    val signing_key          : (ED25519PublicKey.t, t) Olm_c_generated_types.field
    val signing_key_verified : (int, t) Olm_c_generated_types.field
    val last_error           : (ErrorCode.t, t) Olm_c_generated_types.field
  end

  module OutboundGroupSession : sig
    type t = [ `OutboundGroupSession ] Ctypes.structure
    val t           : t Ctypes_static.typ
    val ratchet     : (Megolm.t, t) Olm_c_generated_types.field
    val signing_key : (ED25519KeyPair.t, t) Olm_c_generated_types.field
    val last_error  : (ErrorCode.t, t) Olm_c_generated_types.field
  end

  module Account : sig
    type t = [ `Account ] Ctypes.structure
    val t : t Ctypes_static.typ
  end

  module Session : sig
    type t = [ `Session ] Ctypes.structure
    val t : t Ctypes_static.typ
  end

  module Utility : sig
    type t = [ `Utility ] Ctypes.structure
    val t : t Ctypes_static.typ
  end

  module PkEncryption : sig
    type t = [ `PkEncryption ] Ctypes.structure
    val t             : t Ctypes_static.typ
    val last_error    : (ErrorCode.t, t) Olm_c_generated_types.field
    val recipient_key : (Curve25519PublicKey.t, t) Olm_c_generated_types.field
  end

  module PkDecryption : sig
    type t = [ `PkDecryption ] Ctypes.structure
    val t          : t Ctypes_static.typ
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
    val key_pair   : (Curve25519KeyPair.t, t) Olm_c_generated_types.field
  end

  module PkSigning : sig
    type t = [ `PkSigning ] Ctypes.structure
    val t          : t Ctypes_static.typ
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
    val key_pair   : (ED25519KeyPair.t, t) Olm_c_generated_types.field
  end

  module SAS : sig
    type t = [ `SAS ] Ctypes.structure
    val t              : t Ctypes_static.typ
    val last_error     : (ErrorCode.t, t) Olm_c_generated_types.field
    val curve25519_key : (Curve25519KeyPair.t, t) Olm_c_generated_types.field
    val secret         : (Unsigned.uint8 Ctypes_static.carray, t) Olm_c_generated_types.field
    val their_key_set  : (int, t) Olm_c_generated_types.field
  end
end

module Funcs : sig
  (** [inbound_group_session_size ()]

      Get the size of an inbound group session, in bytes. *)
  val inbound_group_session_size : unit -> Unsigned.size_t

  (** [inbound_group_session session key key_length message_index]

      Initialise an inbound group session object using the supplied memory The
      supplied memory should be at least olm_inbound_group_session_size()
      bytes. *)
  val inbound_group_session :
    unit Ctypes_static.ptr -> Types.InboundGroupSession.t Ctypes_static.ptr

  (** [inbound_group_session_last_error sess]

      A null terminated string describing the most recent error to happen to a
      group session *)
  val inbound_group_session_last_error :
    Types.InboundGroupSession.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [clear_inbound_group_session sess]

      Clears the memory used to back this group session *)
  val clear_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_inbound_group_session_length sess]

      Returns the number of bytes needed to store an inbound group session *)
  val pickle_inbound_group_session_length :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_inbound_group_session sess key key_len pickled pickled_len]

      Initialise an inbound group session object using the supplied memory
      The supplied memory should be at least olm_inbound_group_session_size()
      bytes. *)
  val pickle_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [unpickle_inbound_group_session sess key key_len pickled pickled_len]

      Loads a group session from a pickled base64 string. Decrypts the session
      using the supplied key.

      Returns olm_error() on failure. If the key doesn't match the one used to
      encrypt the account then olm_inbound_group_session_last_error() will be
      "BAD_ACCOUNT_KEY". If the base64 couldn't be decoded then
      olm_inbound_group_session_last_error() will be "INVALID_BASE64". The input
      pickled buffer is destroyed *)
  val unpickle_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [init_inbound_group_session sess sess_key sess_key_len]

      Returns the number of bytes needed to store an inbound group session *)
  val init_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [import_inbound_group_session sess sess_key sess_key_len]

      Import an inbound group session, from a previous export.

      Returns olm_error() on failure. On failure last_error will be set with an
      error code. The last_error will be:

     * OLM_INVALID_BASE64  if the session_key is not valid base64
     * OLM_BAD_SESSION_KEY if the session_key is invalid *)
  val import_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [group_decrypt_max_plaintext_length sess msg msg_len]

      Get an upper bound on the number of bytes of plain-text the decrypt method
      will write for a given input message length. The actual size could be
      different due to padding.

      The input message buffer is destroyed.

      Returns olm_error() on failure. *)
  val group_decrypt_max_plaintext_length :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [group_decrypt sess msg msg_len plaintext max_plaintext_len msg_index]

      Decrypt a message. The input message buffer is destroyed. Returns the length of
      the decrypted plain-text, or olm_error() on failure.

      On failure last_error will be set with an error code. The last_error will
      be:
      * OLM_OUTPUT_BUFFER_TOO_SMALL if the plain-text buffer is too small
      * OLM_INVALID_BASE64 if the message is not valid base-64
      * OLM_BAD_MESSAGE_VERSION if the message was encrypted with an unsupported
        version of the protocol
      * OLM_BAD_MESSAGE_FORMAT if the message headers could not be decoded
      * OLM_BAD_MESSAGE_MAC    if the message could not be verified
      * OLM_UNKNOWN_MESSAGE_INDEX  if we do not have a session key corresponding
        to the message's index (ie, it was sent before the session key was shared
        with us) *)
  val group_decrypt :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint32 Ctypes_static.ptr ->
    Unsigned.size_t

  (** [inbound_group_session_id_length sess]

      Get the number of bytes returned by olm_inbound_group_session_id() *)
  val inbound_group_session_id_length :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [inbound_group_session_id sess id id_len]

      Get a base64-encoded identifier for this session.

      Returns the length of the session id on success or olm_error() on
      failure. On failure last_error will be set with an error code. The
      last_error will be OUTPUT_BUFFER_TOO_SMALL if the id buffer was too
      small. *)
  val inbound_group_session_id :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [inbound_group_session_first_known_index sess]

      Get the first message index we know how to decrypt. *)
  val inbound_group_session_first_known_index :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.uint32

  (** [inbound_group_session_is_verified sess]

      Check if the session has been verified as a valid session.

      (A session is verified either because the original session share was signed,
      or because we have subsequently successfully decrypted a message.)

      This is mainly intended for the unit tests, currently. *)
  val inbound_group_session_is_verified :
    Types.InboundGroupSession.t Ctypes_static.ptr -> int

  (** [export_inbound_group_session_length sess]

      Get the number of bytes returned by olm_export_inbound_group_session() *)
  val export_inbound_group_session_length :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [export_inbound_group_session sess key key_len msg_index]

      Export the base64-encoded ratchet key for this session, at the given index,
      in a format which can be used by olm_import_inbound_group_session

      Returns the length of the ratchet key on success or olm_error() on
      failure. On failure last_error will be set with an error code. The
      last_error will be:
      * OUTPUT_BUFFER_TOO_SMALL if the buffer was too small
      * OLM_UNKNOWN_MESSAGE_INDEX  if we do not have a session key corresponding
        to the given index (ie, it was sent before the session key was shared
        with us) *)
  val export_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint32 ->
    Unsigned.size_t

  (** [outbound_group_session_size ()]

      Get the size of an outbound group session, in bytes. *)
  val outbound_group_session_size : unit -> Unsigned.size_t

  (** [outbound_group_session mem]

      Initialise an outbound group session object using the supplied memory
      The supplied memory should be at least olm_outbound_group_session_size()
      bytes. *)
  val outbound_group_session :
    unit Ctypes_static.ptr -> Types.OutboundGroupSession.t Ctypes_static.ptr

  (** [outbound_group_session_last_error sess]

      A null terminated string describing the most recent error to happen to a
      group session *)
  val outbound_group_session_last_error :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [clear_outbound_group_session sess]

      Initialise an outbound group session object using the supplied memory
      The supplied memory should be at least olm_outbound_group_session_size()
      bytes. *)
  val clear_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_outbound_group_session_length sess]

      Get the size of an outbound group session, in bytes. *)
  val pickle_outbound_group_session_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_outbound_group_session sess key key_len pickled pickled_len]

      Stores a group session as a base64 string. Encrypts the session using the
      supplied key. Returns the length of the session on success.

      Returns olm_error() on failure. If the pickle output buffer
      is smaller than olm_pickle_outbound_group_session_length() then
      olm_outbound_group_session_last_error() will be "OUTPUT_BUFFER_TOO_SMALL" *)
  val pickle_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [unpickle_outbound_group_session sess key key_len pickled pickled_len]

      Loads a group session from a pickled base64 string. Decrypts the session
      using the supplied key.

      Returns olm_error() on failure. If the key doesn't match the one used to
      encrypt the account then olm_outbound_group_session_last_error() will be
      "BAD_ACCOUNT_KEY". If the base64 couldn't be decoded then
      olm_outbound_group_session_last_error() will be "INVALID_BASE64". The input
      pickled buffer is destroyed
  *)
  val unpickle_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [init_outbound_group_session_random_length sess]

      The number of random bytes needed to create an outbound group session *)
  val init_outbound_group_session_random_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [init_outbound_group_session sess random random_len]

      Start a new outbound group session. Returns olm_error() on failure. On
      failure last_error will be set with an error code. The last_error will be
      NOT_ENOUGH_RANDOM if the number of random bytes was too small. *)
  val init_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [group_encrypt_message_length sess plaintext_len]

      The number of bytes that will be created by encrypting a message *)
  val group_encrypt_message_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [group_encrypt sess plaintext plaintext_len msg msg_len]

      Encrypt some plain-text. Returns the length of the encrypted message or
      olm_error() on failure. On failure last_error will be set with an
      error code. The last_error will be OUTPUT_BUFFER_TOO_SMALL if the output
      buffer is too small. *)
  val group_encrypt :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [outbound_group_session_id_length sess]

      Get the number of bytes returned by olm_outbound_group_session_id() *)
  val outbound_group_session_id_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [outbound_group_session_id sess id id_len]

      Get a base64-encoded identifier for this session.

      Returns the length of the session id on success or olm_error() on
      failure. On failure last_error will be set with an error code. The
      last_error will be OUTPUT_BUFFER_TOO_SMALL if the id buffer was too
      small. *)
  val outbound_group_session_id :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [outbound_group_session_message_index sess]

      Get the current message index for this session.

      Each message is sent with an increasing index; this returns the index for
      the next message. *)
  val outbound_group_session_message_index :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.uint32

  (** [outbound_group_session_key_length sess]

      Get the number of bytes returned by olm_outbound_group_session_key() *)
  val outbound_group_session_key_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (** [outbound_group_session_key sess key key_len]

      Get the base64-encoded current ratchet key for this session.

      Each message is sent with a different ratchet key. This function returns the
      ratchet key that will be used for the next message.

      Returns the length of the ratchet key on success or olm_error() on
      failure. On failure last_error will be set with an error code. The
      last_error will be OUTPUT_BUFFER_TOO_SMALL if the buffer was too small. *)
  val outbound_group_session_key :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [get_library_version major minor patch]

      Get the version number of the library.
      Arguments will be updated if non-null. *)
  val get_library_version :
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    unit

  (** [account_size ()]

      The size of an account object in bytes *)
  val account_size : unit -> Unsigned.size_t

  (** [session_size ()]

      The size of a session object in bytes *)
  val session_size : unit -> Unsigned.size_t

  (** [utility_size ()]

      The size of a utility object in bytes *)
  val utility_size : unit -> Unsigned.size_t

  (** [account mem]

      Initialise an account object using the supplied memory
      The supplied memory must be at least olm_account_size() bytes *)
  val account : unit Ctypes_static.ptr -> Types.Account.t Ctypes_static.ptr

  (** [session mem]

      Initialise a session object using the supplied memory
      The supplied memory must be at least olm_session_size() bytes *)
  val session : unit Ctypes_static.ptr -> Types.Session.t Ctypes_static.ptr

  (** [utility mem]

      Initialise a utility object using the supplied memory
      The supplied memory must be at least olm_utility_size() bytes *)
  val utility : unit Ctypes_static.ptr -> Types.Utility.t Ctypes_static.ptr

  (** [error ()]

      The value that olm will return from a function if there was an error *)
  val error : unit -> Unsigned.size_t

  (** [account_last_error acc]

      A null terminated string describing the most recent error to happen to an
      account *)
  val account_last_error : Types.Account.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [session_last_error sess]

      A null terminated string describing the most recent error to happen to a
      session *)
  val session_last_error : Types.Session.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [utility_last_error util]

      A null terminated string describing the most recent error to happen to a
      utility *)
  val utility_last_error : Types.Utility.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [clear_account acc]

      Clears the memory used to back this account *)
  val clear_account : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [clear_session sess]

      Clears the memory used to back this session *)
  val clear_session : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (** [clear_utility util]

      Clears the memory used to back this utility *)
  val clear_utility : Types.Utility.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_account_length acc]

      Returns the number of bytes needed to store an account *)
  val pickle_account_length : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_session_length sess]

      Returns the number of bytes needed to store a session *)
  val pickle_session_length : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_account acc key key_len pickled pickled_len]

      Stores an account as a base64 string. Encrypts the account using the
      supplied key. Returns the length of the pickled account on success.
      Returns olm_error() on failure. If the pickle output buffer
      is smaller than olm_pickle_account_length() then
      olm_account_last_error() will be "OUTPUT_BUFFER_TOO_SMALL" *)
  val pickle_account :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pickle_session sess key key_len pickled pickled_len]

      Stores a session as a base64 string. Encrypts the session using the
      supplied key. Returns the length of the pickled session on success.
      Returns olm_error() on failure. If the pickle output buffer
      is smaller than olm_pickle_session_length() then
      olm_session_last_error() will be "OUTPUT_BUFFER_TOO_SMALL" *)
  val pickle_session :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [unpickle_account acc key key_len pickled pickled_len]

      Loads an account from a pickled base64 string. Decrypts the account using
      the supplied key. Returns olm_error() on failure. If the key doesn't
      match the one used to encrypt the account then olm_account_last_error()
      will be "BAD_ACCOUNT_KEY". If the base64 couldn't be decoded then
      olm_account_last_error() will be "INVALID_BASE64". The input pickled
      buffer is destroyed *)
  val unpickle_account :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [unpickle_session sess key key_len pickled pickled_len]

      Loads a session from a pickled base64 string. Decrypts the session using
      the supplied key. Returns olm_error() on failure. If the key doesn't
      match the one used to encrypt the account then olm_session_last_error()
      will be "BAD_ACCOUNT_KEY". If the base64 couldn't be decoded then
      olm_session_last_error() will be "INVALID_BASE64". The input pickled
      buffer is destroyed *)
  val unpickle_session :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [create_account_random_length acc]

      The number of random bytes needed to create an account. *)
  val create_account_random_length : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [create_account acc random random_len]

      Creates a new account. Returns olm_error() on failure. If there weren't
      enough random bytes then olm_account_last_error() will be
      "NOT_ENOUGH_RANDOM" *)
  val create_account :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [account_identity_keys_length acc]

      The size of the output buffer needed to hold the identity keys *)
  val account_identity_keys_length : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [account_identity_keys acc identity_keys identity_keys_len]

      Writes the public parts of the identity keys for the account into the
      identity_keys output buffer. Returns olm_error() on failure. If the
      identity_keys buffer was too small then olm_account_last_error() will be
      "OUTPUT_BUFFER_TOO_SMALL" *)
  val account_identity_keys :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [account_signature_length acc]

      The length of an ed25519 signature encoded as base64. *)
  val account_signature_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [account_sign acc msg msg_len signature signature_len]

      Signs a message with the ed25519 key for this account. Returns olm_error()
      on failure. If the signature buffer was too small then
      olm_account_last_error() will be "OUTPUT_BUFFER_TOO_SMALL" *)
  val account_sign :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [account_one_time_keys_length acc]
      The size of the output buffer needed to hold the one time keys *)
  val account_one_time_keys_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [account_one_time_keys acc one_time_keys one_time_keys_len]

      Writes the public parts of the unpublished one time keys for the account
      into the one_time_keys output buffer.

      The returned data is a JSON-formatted object with the single property
      curve25519, which is itself an object mapping key id to base64-encoded
      Curve25519 key. For example:
      {[
        curve25519: {
          "AAAAAA": "wo76WcYtb0Vk/pBOdmduiGJ0wIEjW4IBMbbQn7aSnTo";
          "AAAAAB": "LRvjo46L1X2vx69sS9QNFD29HWulxrmW11Up5AfAjgU"
        }
      ]}
      Returns olm_error() on failure.

      If the one_time_keys buffer was too small then olm_account_last_error()
      will be "OUTPUT_BUFFER_TOO_SMALL". *)
  val account_one_time_keys :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [account_mark_keys_as_published acc]

      Marks the current set of one time keys as being published. *)
  val account_mark_keys_as_published :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [account_max_number_of_one_time_keys acc]
      The largest number of one time keys this account can store. *)
  val account_max_number_of_one_time_keys :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [account_generate_one_time_keys_random_length acc number_of_keys]
      The number of random bytes needed to generate a given number of new one
      time keys. *)
  val account_generate_one_time_keys_random_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (** [account_generate_one_time_keys acc number_of_keys random random_len]

      Generates a number of new one time keys. If the total number of keys stored
      by this account exceeds max_number_of_one_time_keys() then the old keys are
      discarded. Returns olm_error() on error. If the number of random bytes is
      too small then olm_account_last_error() will be "NOT_ENOUGH_RANDOM". *)
  val account_generate_one_time_keys :
    Types.Account.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [account_generate_fallback_key_random_length acc]

      The number of random bytes needed to generate a fallback key. *)
  val account_generate_fallback_key_random_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [account_generate_fallback_key acc random random_len]

      Generates a new fallback key. Only one previous fallback key is
      stored. Returns olm_error() on error. If the number of random bytes is too
      small then olm_account_last_error() will be "NOT_ENOUGH_RANDOM". *)
  val account_generate_fallback_key :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (** [account_fallback_key_length acc]

      The number of bytes needed to hold the fallback key as returned by
      olm_account_fallback_key. *)
  val account_fallback_key_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (** [account_fallback_key acc fallback_key fallback_key_size] *)
  val account_fallback_key :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [create_outbound_session_random_length sess]

      The number of random bytes needed to create an outbound session *)
  val create_outbound_session_random_length :
    Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (** [create_outbound_session
        sess
        acc
        their_identity_key their_identity_key_len
        their_one_time_key their_one_time_key_len
        random             random_len
      ]

      Creates a new out-bound session for sending messages to a given identity_key
      and one_time_key. Returns olm_error() on failure. If the keys couldn't be
      decoded as base64 then olm_session_last_error() will be "INVALID_BASE64"
      If there weren't enough random bytes then olm_session_last_error() will
      be "NOT_ENOUGH_RANDOM". *)
  val create_outbound_session :
    Types.Session.t Ctypes_static.ptr ->
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [create_inbound_session sess acc one_time_key_msg one_time_key_msg_len]

      Create a new in-bound session for sending/receiving messages from an
      incoming PRE_KEY message. Returns olm_error() on failure. If the base64
      couldn't be decoded then olm_session_last_error will be "INVALID_BASE64".
      If the message was for an unsupported protocol version then
      olm_session_last_error() will be "BAD_MESSAGE_VERSION". If the message
      couldn't be decoded then then olm_session_last_error() will be
      "BAD_MESSAGE_FORMAT". If the message refers to an unknown one time
      key then olm_session_last_error() will be "BAD_MESSAGE_KEY_ID". *)
  val create_inbound_session :
    Types.Session.t Ctypes_static.ptr ->
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [create_inbound_session_from
        sess
        acc
        their_identity_key their_identity_key_len
        one_time_key_msg   one_time_key_msg_len
      ]

      Create a new in-bound session for sending/receiving messages from an
      incoming PRE_KEY message. Returns olm_error() on failure. If the base64
      couldn't be decoded then olm_session_last_error will be "INVALID_BASE64".
      If the message was for an unsupported protocol version then
      olm_session_last_error() will be "BAD_MESSAGE_VERSION". If the message
      couldn't be decoded then then olm_session_last_error() will be
      "BAD_MESSAGE_FORMAT". If the message refers to an unknown one time
      key then olm_session_last_error() will be "BAD_MESSAGE_KEY_ID". *)
  val create_inbound_session_from :
    Types.Session.t Ctypes_static.ptr ->
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [session_id_length sess]

      The length of the buffer needed to return the id for this session. *)
  val session_id_length : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (** [session_id sess id id_len]

      An identifier for this session. Will be the same for both ends of the
      conversation. If the id buffer is too small then olm_session_last_error()
      will be "OUTPUT_BUFFER_TOO_SMALL". *)
  val session_id :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [session_has_received_message sess] *)
  val session_has_received_message :
    Types.Session.t Ctypes_static.ptr -> int

  (** [session_describe sess buf buf_len]

      Write a null-terminated string describing the internal state of an olm
      session to the buffer provided for debugging and logging purposes. *)
  val session_describe :
    Types.Session.t Ctypes_static.ptr ->
    char Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit

  (** [matches_inbound_session sess one_time_key_msg one_time_key_msg_len]

      Checks if the PRE_KEY message is for this in-bound session. This can happen
      if multiple messages are sent to this account before this account sends a
      message in reply. The one_time_key_message buffer is destroyed. Returns 1 if
      the session matches. Returns 0 if the session does not match. Returns
      olm_error() on failure. If the base64 couldn't be decoded then
      olm_session_last_error will be "INVALID_BASE64".  If the message was for an
      unsupported protocol version then olm_session_last_error() will be
      "BAD_MESSAGE_VERSION". If the message couldn't be decoded then then
      olm_session_last_error() will be "BAD_MESSAGE_FORMAT". *)
  val matches_inbound_session :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [matches_inbound_session_from
        sess
        their_identity_key their_identity_key_len
        one_time_key_msg one_time_key_msg_len
      ]

      Checks if the PRE_KEY message is for this in-bound session. This can happen
      if multiple messages are sent to this account before this account sends a
      message in reply. The one_time_key_message buffer is destroyed. Returns 1 if
      the session matches. Returns 0 if the session does not match. Returns
      olm_error() on failure. If the base64 couldn't be decoded then
      olm_session_last_error will be "INVALID_BASE64".  If the message was for an
      unsupported protocol version then olm_session_last_error() will be
      "BAD_MESSAGE_VERSION". If the message couldn't be decoded then then
      olm_session_last_error() will be "BAD_MESSAGE_FORMAT". *)
  val matches_inbound_session_from :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [remove_one_time_keys acc sess]

      Removes the one time keys that the session used from the account. Returns
      olm_error() on failure. If the account doesn't have any matching one time
      keys then olm_account_last_error() will be "BAD_MESSAGE_KEY_ID". *)
  val remove_one_time_keys :
    Types.Account.t Ctypes_static.ptr ->
    Types.Session.t Ctypes_static.ptr ->
    Unsigned.size_t

  (** [encrypt_message_type sess]

      The type of the next message that olm_encrypt() will return. Returns
      OLM_MESSAGE_TYPE_PRE_KEY if the message will be a PRE_KEY message.
      Returns OLM_MESSAGE_TYPE_MESSAGE if the message will be a normal message.
      Returns olm_error on failure. *)
  val encrypt_message_type : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (** [encrypt_random_length sess]

      The number of random bytes needed to encrypt the next message. *)
  val encrypt_random_length : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (** [encrypt_message_length sess plaintext_len]

      The size of the next message in bytes for the given number of plain-text bytes *)
  val encrypt_message_length :
    Types.Session.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (** [encrypt sess plaintext plaintext_len random random_len msg msg_len]

      Encrypts a message using the session. Returns the length of the message in
      bytes on success. Writes the message as base64 into the message buffer.
      Returns olm_error() on failure. If the message buffer is too small then
      olm_session_last_error() will be "OUTPUT_BUFFER_TOO_SMALL". If there
      weren't enough random bytes then olm_session_last_error() will be
      "NOT_ENOUGH_RANDOM". *)
  val encrypt :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [decrypt_max_plaintext_length sess msg_type msg msg_len]

      The maximum number of bytes of plain-text a given message could decode to.
      The actual size could be different due to padding. The input message buffer
      is destroyed. Returns olm_error() on failure. If the message base64
      couldn't be decoded then olm_session_last_error() will be
      "INVALID_BASE64". If the message is for an unsupported version of the
      protocol then olm_session_last_error() will be "BAD_MESSAGE_VERSION".
      If the message couldn't be decoded then olm_session_last_error() will be
      "BAD_MESSAGE_FORMAT". *)
  val decrypt_max_plaintext_length :
    Types.Session.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [decrypt sess msg_type msg msg_len plaintext max_plaintext_len]

      Decrypts a message using the session. The input message buffer is destroyed.
      Returns the length of the plain-text on success. Returns olm_error() on
      failure. If the plain-text buffer is smaller than
      olm_decrypt_max_plaintext_length() then olm_session_last_error()
      will be "OUTPUT_BUFFER_TOO_SMALL". If the base64 couldn't be decoded then
      olm_session_last_error() will be "INVALID_BASE64". If the message is for
      an unsupported version of the protocol then olm_session_last_error() will
      be "BAD_MESSAGE_VERSION". If the message couldn't be decoded then
      olm_session_last_error() will be "BAD_MESSAGE_FORMAT".
      If the MAC on the message was invalid then olm_session_last_error() will
      be "BAD_MESSAGE_MAC". *)
  val decrypt :
    Types.Session.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [sha256_length util]

      The length of the buffer needed to hold the SHA-256 hash. *)
  val sha256_length : Types.Utility.t Ctypes_static.ptr -> Unsigned.size_t

  (** [sha256 util input input_len output output_len]

      Calculates the SHA-256 hash of the input and encodes it as base64. If the
      output buffer is smaller than olm_sha256_length() then
      olm_utility_last_error() will be "OUTPUT_BUFFER_TOO_SMALL". *)
  val sha256 :
    Types.Utility.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [ed25519_verify util key key_len msg msg_len signature signature_len]

      Verify an ed25519 signature. If the key was too small then
      olm_utility_last_error() will be "INVALID_BASE64". If the signature was
      invalid then olm_utility_last_error() will be "BAD_MESSAGE_MAC". *)
  val ed25519_verify :
    Types.Utility.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pk_encryption_size ()]

      The size of an encryption object in bytes *)
  val pk_encryption_size : unit -> Unsigned.size_t

  (** [pk_encryption mem]

      Initialise an encryption object using the supplied memory
      The supplied memory must be at least olm_pk_encryption_size() bytes *)
  val pk_encryption : unit Ctypes_static.ptr -> Types.PkEncryption.t Ctypes_static.ptr

  (** [pk_encryption_last_error encryption]

      A null terminated string describing the most recent error to happen to an
      encryption object *)
  val pk_encryption_last_error :
    Types.PkEncryption.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [clear_pk_encryption encryption]

      Clears the memory used to back this encryption object *)
  val clear_pk_encryption : Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pk_encryption_set_recipient_key encryption public_key public_key_len]

      Set the recipient's public key for encrypting to *)
  val pk_encryption_set_recipient_key :
    Types.PkEncryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pk_ciphertext_length encryption plaintext_len]

      Get the length of the ciphertext that will correspond to a plaintext of the
      given length. *)
  val pk_ciphertext_length :
    Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (** [pk_mac_length encryption]

      Get the length of the message authentication code. *)
  val pk_mac_length : Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pk_key_length ()]

      Get the length of a public or ephemeral key *)
  val pk_key_length : unit -> Unsigned.size_t

  (** [pk_encrypt_random_length encryption]

      The number of random bytes needed to encrypt a message. *)
  val pk_encrypt_random_length : Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pk_encrypt
        encryption
        plaintext    plaintext_len
        ciphertext   ciphertext_len
        mac          mac_len
        ephermal_key ephemeral_key_size
        random       random_len
      ]

      Encrypt a plaintext for the recipient set using
      olm_pk_encryption_set_recipient_key. Writes to the ciphertext, mac, and
      ephemeral_key buffers, whose values should be sent to the recipient. mac is
      a Message Authentication Code to ensure that the data is received and
      decrypted properly. ephemeral_key is the public part of the ephemeral key
      used (together with the recipient's key) to generate a symmetric encryption
      key. Returns olm_error() on failure. If the ciphertext, mac, or
      ephemeral_key buffers were too small then olm_pk_encryption_last_error()
      will be "OUTPUT_BUFFER_TOO_SMALL". If there weren't enough random bytes then
      olm_pk_encryption_last_error() will be "OLM_INPUT_BUFFER_TOO_SMALL". *)
  val pk_encrypt :
    Types.PkEncryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pk_decryption_size ()]

      The size of a decryption object in bytes *)
  val pk_decryption_size : unit -> Unsigned.size_t

  (** [pk_decryption mem]

      Initialise a decryption object using the supplied memory
      The supplied memory must be at least olm_pk_decryption_size() bytes *)
  val pk_decryption : unit Ctypes_static.ptr -> Types.PkDecryption.t Ctypes_static.ptr

  (** [pk_decryption_last_error decryption]

      A null terminated string describing the most recent error to happen to a
      decription object *)
  val pk_decryption_last_error :
    Types.PkDecryption.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [clear_pk_decryption decryption]

      Clears the memory used to back this decryption object *)
  val clear_pk_decryption : Types.PkDecryption.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pk_private_key_length ()]

      Get the number of bytes required to store an olm private key *)
  val pk_private_key_length : unit -> Unsigned.size_t

  (** [pk_key_from_private decryption pubkey pubkey_len privkey privkey_len]

      Initialise the key from the private part of a key as returned by
      olm_pk_get_private_key(). The associated public key will be written to the
      pubkey buffer. Returns olm_error() on failure. If the pubkey buffer is too
      small then olm_pk_decryption_last_error() will be "OUTPUT_BUFFER_TOO_SMALL".
      If the private key was not long enough then olm_pk_decryption_last_error()
      will be "OLM_INPUT_BUFFER_TOO_SMALL".

      Note that the pubkey is a base64 encoded string, but the private key is
      an unencoded byte array *)
  val pk_key_from_private :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pickle_pk_decryption_length decryption]

      Returns the number of bytes needed to store a decryption object. *)
  val pickle_pk_decryption_length :
    Types.PkDecryption.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pickle_pk_decryption decryption key key_len pickled pickled_len]

      Stores decryption object as a base64 string. Encrypts the object using the
      supplied key. Returns the length of the pickled object on success.
      Returns olm_error() on failure. If the pickle output buffer
      is smaller than olm_pickle_pk_decryption_length() then
      olm_pk_decryption_last_error() will be "OUTPUT_BUFFER_TOO_SMALL" *)
  val pickle_pk_decryption :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [unpickle_pk_decryption decryption key key_len pickled pickled_len]

      Loads a decryption object from a pickled base64 string. The associated
      public key will be written to the pubkey buffer. Decrypts the object using
      the supplied key. Returns olm_error() on failure. If the key doesn't
      match the one used to encrypt the account then olm_pk_decryption_last_error()
      will be "BAD_ACCOUNT_KEY". If the base64 couldn't be decoded then
      olm_pk_decryption_last_error() will be "INVALID_BASE64". The input pickled
      buffer is destroyed *)
  val unpickle_pk_decryption :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pk_max_plaintext_length decryption ciphertext_len]

      Get the length of the plaintext that will correspond to a ciphertext of the
      given length. *)
  val pk_max_plaintext_length :
    Types.PkDecryption.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (** [pk_decrypt
        decryption
        ephemeral_key ephemeral_key_len
        mac           mac_len
        ciphertext    ciphertext_len
        plaintext     max_plaintext_len
      ]

      Decrypt a ciphertext. The input ciphertext buffer is destroyed. See the
      olm_pk_encrypt function for descriptions of the ephemeral_key and mac
      arguments. Returns the length of the plaintext on success. Returns
      olm_error() on failure. If the plaintext buffer is too small then
      olm_pk_encryption_last_error() will be "OUTPUT_BUFFER_TOO_SMALL". *)
  val pk_decrypt :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pk_get_private_key decryption private_key private_key_len]

      Get the private key for an OlmDecryption object as an unencoded byte array
      private_key must be a pointer to a buffer of at least
      olm_pk_private_key_length() bytes and this length must be passed in
      private_key_length. If the given buffer is too small, returns olm_error()
      and olm_pk_encryption_last_error() will be "OUTPUT_BUFFER_TOO_SMALL".
      Returns the number of bytes written. *)
  val pk_get_private_key :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pk_signing_size ()]

      The size of a signing object in bytes *)
  val pk_signing_size : unit -> Unsigned.size_t

  (** [pk_signing mem]

      Initialise a signing object using the supplied memory
      The supplied memory must be at least olm_pk_signing_size() bytes *)
  val pk_signing : unit Ctypes_static.ptr -> Types.PkSigning.t Ctypes_static.ptr

  (** [pk_signing_last_error sign]

      A null terminated string describing the most recent error to happen to a
      signing object *)
  val pk_signing_last_error :
    Types.PkSigning.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [clear_pk_signing sign]

      Clears the memory used to back this signing object *)
  val clear_pk_signing : Types.PkSigning.t Ctypes_static.ptr -> Unsigned.size_t

  (** [pk_signing_key_from_seed sign pubkey pubkey_len seed seed_len]

      Initialise the signing object with a public/private keypair from a seed. The
      associated public key will be written to the pubkey buffer. Returns
      olm_error() on failure. If the public key buffer is too small then
      olm_pk_signing_last_error() will be "OUTPUT_BUFFER_TOO_SMALL".  If the seed
      buffer is too small then olm_pk_signing_last_error() will be
      "INPUT_BUFFER_TOO_SMALL". *)
  val pk_signing_key_from_seed :
    Types.PkSigning.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [pk_signing_seed_length ()]

      The size required for the seed for initialising a signing object. *)
  val pk_signing_seed_length : unit -> Unsigned.size_t

  (** [pk_signing_public_key_length ()]

      The size of the public key of a signing object. *)
  val pk_signing_public_key_length : unit -> Unsigned.size_t

  (** [pk_signature_length ()]

      The size of a signature created by a signing object. *)
  val pk_signature_length : unit -> Unsigned.size_t

  (** [pk_sign sign msg msg_len signature signature_len]

      Sign a message. The signature will be written to the signature
      buffer. Returns olm_error() on failure. If the signature buffer is too
      small, olm_pk_signing_last_error() will be "OUTPUT_BUFFER_TOO_SMALL". *)
  val pk_sign :
    Types.PkSigning.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [sas_last_error sas]

      A null terminated string describing the most recent error to happen to an
      SAS object. *)
  val sas_last_error : Types.SAS.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (** [sas_size ()]

      The size of an SAS object in bytes. *)
  val sas_size : unit -> Unsigned.size_t

  (** [sas mem]

      Initialize an SAS object using the supplied memory.
      The supplied memory must be at least `olm_sas_size()` bytes. *)
  val sas : unit Ctypes_static.ptr -> Types.SAS.t Ctypes_static.ptr

  (** [clear_sas sas]

      Clears the memory used to back an SAS object. *)
  val clear_sas : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (** [create_sas_random_length sas]

      The number of random bytes needed to create an SAS object. *)
  val create_sas_random_length : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (** [create_sass sas random random_len]

      Creates a new SAS object.

      Takes the SAS object to create, initialized by `olm_sas()`, and an array
      of random bytes (and it's length) to use as entropy. The contents of the
      random buffer may be overwritten.

      Returns `olm_error()` on failure.  If there weren't enough random bytes then
      `olm_sas_last_error()` will be `NOT_ENOUGH_RANDOM`. *)
  val create_sas :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [sas_pubkey_length sas]

      The size of a public key in bytes. *)
  val sas_pubkey_length : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (** [sas_get_pubkey sas pubkey pubkey_len]

      Get the public key for the SAS object. Takes a buffer in which to store the
      public key, which must be of at least `olm_sas_pubkey_length()`.

      Returns `olm_error()` on failure. If the `pubkey` buffer is too small, then
      `olm_sas_last_error()` will be `OUTPUT_BUFFER_TOO_SMALL`. *)
  val sas_get_pubkey :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [sas_set_their_key sas their_key their_key_len]

      Sets the public key of other user. Takes the SAS object, and the other user's
      public key (which will be overwritten).

      Returns `olm_error()` on failure.  If the `their_key` buffer is too small,
      then `olm_sas_last_error()` will be `INPUT_BUFFER_TOO_SMALL`. *)
  val sas_set_their_key :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [sas_is_their_key_set sas]

      Checks if their key was set. *)
  val sas_is_their_key_set : Types.SAS.t Ctypes_static.ptr -> int

  (** [sas_generate_bytes sas info info_len output output_len]

      Generate bytes to use for the short authentication string.

      Takes a SAS object, extra information to mix in when generating the bytes, as
      per the Matrix spec, and a buffer in which to store the output. For
      hex-based SAS as in the Matrix spec, the length of the output will be 5. *)
  val sas_generate_bytes :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (** [sas_mac_length sas]

      The size of the message authentication code generated by
      olm_sas_calculate_mac()`. *)
  val sas_mac_length : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (** [sas_calculate_mac sas input input_len info info_len mac mac_len]

      Generate a message authentication code (MAC) based on the shared secret.

      Takes a SAS object, the message to produce the authentication code for,
      the extra information to mix in when generating the MAC, as per the Matrix spec,
      and the buffer in which to store the generated MAC.

      Returns `olm_error()` on failure.  If the `mac` buffer is too small, then
      `olm_sas_last_error()` will be `OUTPUT_BUFFER_TOO_SMALL`. *)
  val sas_calculate_mac :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t
end
