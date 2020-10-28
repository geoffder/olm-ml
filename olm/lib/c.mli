(* TODO: Readability and documentation. *)

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
  (**   *)
  val inbound_group_session_size : unit -> Unsigned.size_t

  (**   *)
  val inbound_group_session :
    unit Ctypes_static.ptr -> Types.InboundGroupSession.t Ctypes_static.ptr

  (**   *)
  val inbound_group_session_last_error :
    Types.InboundGroupSession.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val clear_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_inbound_group_session_length :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val unpickle_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val init_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val import_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val group_decrypt_max_plaintext_length :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val group_decrypt :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint32 Ctypes_static.ptr ->
    Unsigned.size_t

  (**   *)
  val inbound_group_session_id_length :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val inbound_group_session_id :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val inbound_group_session_first_known_index :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.uint32

  (**   *)
  val inbound_group_session_is_verified :
    Types.InboundGroupSession.t Ctypes_static.ptr -> int

  (**   *)
  val export_inbound_group_session_length :
    Types.InboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val export_inbound_group_session :
    Types.InboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint32 ->
    Unsigned.size_t

  (**   *)
  val outbound_group_session_size : unit -> Unsigned.size_t

  (**   *)
  val outbound_group_session :
    unit Ctypes_static.ptr -> Types.OutboundGroupSession.t Ctypes_static.ptr

  (**   *)
  val outbound_group_session_last_error :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val clear_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_outbound_group_session_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val unpickle_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val init_outbound_group_session_random_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val init_outbound_group_session :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val group_encrypt_message_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val group_encrypt :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val outbound_group_session_id_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val outbound_group_session_id :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val outbound_group_session_message_index :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.uint32

  (**   *)
  val outbound_group_session_key_length :
    Types.OutboundGroupSession.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val outbound_group_session_key :
    Types.OutboundGroupSession.t Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val get_library_version :
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    Unsigned.uint8 Ctypes_static.ptr ->
    unit

  (**   *)
  val account_size : unit -> Unsigned.size_t

  (**   *)
  val session_size : unit -> Unsigned.size_t

  (**   *)
  val utility_size : unit -> Unsigned.size_t

  (**   *)
  val account : unit Ctypes_static.ptr -> Types.Account.t Ctypes_static.ptr

  (**   *)
  val session : unit Ctypes_static.ptr -> Types.Session.t Ctypes_static.ptr

  (**   *)
  val utility : unit Ctypes_static.ptr -> Types.Utility.t Ctypes_static.ptr

  (**   *)
  val error : unit -> Unsigned.size_t

  (**   *)
  val account_last_error : Types.Account.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val session_last_error : Types.Session.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val utility_last_error : Types.Utility.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val clear_account : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val clear_session : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val clear_utility : Types.Utility.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_account_length : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_session_length : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_account :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val pickle_session :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val unpickle_account :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val unpickle_session :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val create_account_random_length : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val create_account :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val account_identity_keys_length : Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val account_identity_keys :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val account_signature_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val account_sign :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val account_one_time_keys_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val account_one_time_keys :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val account_mark_keys_as_published :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val account_max_number_of_one_time_keys :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val account_generate_one_time_keys_random_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (**   *)
  val account_generate_one_time_keys :
    Types.Account.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val account_generate_fallback_key_random_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val account_generate_fallback_key :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (**   *)
  val account_fallback_key_length :
    Types.Account.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val account_fallback_key :
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val create_outbound_session_random_length :
    Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
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

  (**   *)
  val create_inbound_session :
    Types.Session.t Ctypes_static.ptr ->
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val create_inbound_session_from :
    Types.Session.t Ctypes_static.ptr ->
    Types.Account.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val session_id_length : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val session_id :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val session_has_received_message :
    Types.Session.t Ctypes_static.ptr -> int

  (**   *)
  val session_describe :
    Types.Session.t Ctypes_static.ptr ->
    char Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit

  (**   *)
  val matches_inbound_session :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val matches_inbound_session_from :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val remove_one_time_keys :
    Types.Account.t Ctypes_static.ptr ->
    Types.Session.t Ctypes_static.ptr ->
    Unsigned.size_t

  (**   *)
  val encrypt_message_type : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val encrypt_random_length : Types.Session.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val encrypt_message_length :
    Types.Session.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (**   *)
  val encrypt :
    Types.Session.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val decrypt_max_plaintext_length :
    Types.Session.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val decrypt :
    Types.Session.t Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val sha256_length : Types.Utility.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val sha256 :
    Types.Utility.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val ed25519_verify :
    Types.Utility.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val pk_encryption_size : unit -> Unsigned.size_t

  (**   *)
  val pk_encryption : unit Ctypes_static.ptr -> Types.PkEncryption.t Ctypes_static.ptr

  (**   *)
  val pk_encryption_last_error :
    Types.PkEncryption.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val clear_pk_encryption : Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pk_encryption_set_recipient_key :
    Types.PkEncryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val pk_ciphertext_length :
    Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (**   *)
  val pk_mac_length : Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pk_key_length : unit -> Unsigned.size_t

  (**   *)
  val pk_encrypt_random_length : Types.PkEncryption.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
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

  (**   *)
  val pk_decryption_size : unit -> Unsigned.size_t

  (**   *)
  val pk_decryption : unit Ctypes_static.ptr -> Types.PkDecryption.t Ctypes_static.ptr

  (**   *)
  val pk_decryption_last_error :
    Types.PkDecryption.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val clear_pk_decryption : Types.PkDecryption.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pk_private_key_length : unit -> Unsigned.size_t

  (**   *)
  val pk_generate_key_random_length : unit -> Unsigned.size_t

  (**   *)
  val pk_key_from_private :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val pickle_pk_decryption_length :
    Types.PkDecryption.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pickle_pk_decryption :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val unpickle_pk_decryption :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val pk_max_plaintext_length :
    Types.PkDecryption.t Ctypes_static.ptr -> Unsigned.size_t -> Unsigned.size_t

  (**   *)
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

  (**   *)
  val pk_get_private_key :
    Types.PkDecryption.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val pk_signing_size : unit -> Unsigned.size_t

  (**   *)
  val pk_signing : unit Ctypes_static.ptr -> Types.PkSigning.t Ctypes_static.ptr

  (**   *)
  val pk_signing_last_error :
    Types.PkSigning.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val clear_pk_signing : Types.PkSigning.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val pk_signing_key_from_seed :
    Types.PkSigning.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val pk_signing_seed_length : unit -> Unsigned.size_t

  (**   *)
  val pk_signing_public_key_length : unit -> Unsigned.size_t

  (**   *)
  val pk_signature_length : unit -> Unsigned.size_t

  (**   *)
  val pk_sign :
    Types.PkSigning.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val sas_last_error : Types.SAS.t Ctypes_static.ptr -> char Ctypes_static.ptr

  (**   *)
  val sas_size : unit -> Unsigned.size_t

  (**   *)
  val sas : unit Ctypes_static.ptr -> Types.SAS.t Ctypes_static.ptr

  (**   *)
  val clear_sas : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val create_sas_random_length : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val create_sas :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val sas_pubkey_length : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
  val sas_get_pubkey :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val sas_set_their_key :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val sas_is_their_key_set : Types.SAS.t Ctypes_static.ptr -> int

  (**   *)
  val sas_generate_bytes :
    Types.SAS.t Ctypes_static.ptr ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    unit Ctypes_static.ptr ->
    Unsigned.size_t ->
    Unsigned.size_t

  (**   *)
  val sas_mac_length : Types.SAS.t Ctypes_static.ptr -> Unsigned.size_t

  (**   *)
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
