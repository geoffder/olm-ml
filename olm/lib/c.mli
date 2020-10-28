(* TODO: Readability and documentation. *)

module Types : sig
  val sha256_output_length : int
  val curve25519_key_length : int
  val curve25519_shared_secret_length : int
  val curve25519_random_length : int
  val ed25519_public_key_length : int
  val ed25519_private_key_length : int
  val ed25519_random_length : int
  val ed25519_signature_length : int
  val aes256_key_length : int
  val aes256_iv_length : int
  val megolm_ratchet_part_length : int
  val megolm_ratchet_parts : int
  val megolm_ratchet_length : int

  module ErrorCode : sig
    val olm_success : int64 Olm_c_generated_types.const
    val olm_not_enough_random : int64 Olm_c_generated_types.const
    val olm_output_buffer_too_small : int64 Olm_c_generated_types.const
    val olm_bad_message_version : int64 Olm_c_generated_types.const
    val olm_bad_message_format : int64 Olm_c_generated_types.const
    val olm_bad_message_mac : int64 Olm_c_generated_types.const
    val olm_bad_message_key_id : int64 Olm_c_generated_types.const
    val olm_invalid_base64 : int64 Olm_c_generated_types.const
    val olm_bad_account_key : int64 Olm_c_generated_types.const
    val olm_unknown_pickle_version : int64 Olm_c_generated_types.const
    val olm_corrupted_pickle : int64 Olm_c_generated_types.const
    val olm_bad_session_key : int64 Olm_c_generated_types.const
    val olm_unknown_message_index : int64 Olm_c_generated_types.const
    val olm_bad_legacy_account_pickle : int64 Olm_c_generated_types.const
    val olm_bad_signature : int64 Olm_c_generated_types.const
    val olm_input_buffer_too_small : int64 Olm_c_generated_types.const
    val olm_sas_their_key_not_set : int64 Olm_c_generated_types.const

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

    val t : t Olm_c_generated_types.typ
    val to_string : t -> string
  end

  module Aes256Key : sig
    type t = [ `Aes256Key ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val key :
      (Unsigned.uint8 Ctypes_static.carray, t)
        Olm_c_generated_types.field
  end

  module Aes256Iv : sig
    type t = [ `Aes256Iv ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val iv :
      (Unsigned.uint8 Ctypes_static.carray, t)
        Olm_c_generated_types.field
  end

  module Curve25519PublicKey : sig
    type t = [ `Curve25519PublicKey ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val public_key :
      (Unsigned.uint8 Ctypes_static.carray, t)
        Olm_c_generated_types.field
  end

  module Curve25519PrivateKey : sig
    type t = [ `Curve25519PrivateKey ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val private_key :
      (Unsigned.uint8 Ctypes_static.carray, t)
        Olm_c_generated_types.field
  end

  module Curve25519KeyPair : sig
    type t = [ `Curve25519KeyPair ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val public_key :
      (Curve25519PublicKey.t, t) Olm_c_generated_types.field
    val private_key :
      (Curve25519PrivateKey.t, t) Olm_c_generated_types.field
  end

  module ED25519PublicKey : sig
    type t = [ `ED25519PublicKey ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val public_key :
      (Unsigned.uint8 Ctypes_static.carray, t)
        Olm_c_generated_types.field
  end

  module ED25519PrivateKey : sig
    type t = [ `ED25519PrivateKey ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val private_key :
      (Unsigned.uint8 Ctypes_static.carray, t)
        Olm_c_generated_types.field
  end

  module ED25519KeyPair : sig
    type t = [ `ED25519KeyPair ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val public_key : (ED25519PublicKey.t, t) Olm_c_generated_types.field
    val private_key :
      (ED25519PrivateKey.t, t) Olm_c_generated_types.field
  end

  module Megolm : sig
    type t = [ `Megolm ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val data :
      (Unsigned.uint8 Ctypes_static.carray Ctypes_static.carray, t)
        Olm_c_generated_types.field
    val counter : (Unsigned.uint32, t) Olm_c_generated_types.field
  end

  module InboundGroupSession : sig
    type t = [ `InboundGroupSession ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val initial_ratchet : (Megolm.t, t) Olm_c_generated_types.field
    val latest_ratchet : (Megolm.t, t) Olm_c_generated_types.field
    val signing_key : (ED25519PublicKey.t, t) Olm_c_generated_types.field
    val signing_key_verified : (int, t) Olm_c_generated_types.field
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
  end

  module OutboundGroupSession : sig
    type t = [ `OutboundGroupSession ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val ratchet : (Megolm.t, t) Olm_c_generated_types.field
    val signing_key : (ED25519KeyPair.t, t) Olm_c_generated_types.field
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
  end

  module Account : sig
    type t = [ `Account ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
  end

  module Session : sig
    type t = [ `Session ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
  end

  module Utility : sig
    type t = [ `Utility ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
  end

  module PkEncryption : sig
    type t = [ `PkEncryption ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
    val recipient_key :
      (Curve25519PublicKey.t, t) Olm_c_generated_types.field
  end

  module PkDecryption : sig
    type t = [ `PkDecryption ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
    val key_pair : (Curve25519KeyPair.t, t) Olm_c_generated_types.field
  end

  module PkSigning : sig
    type t = [ `PkSigning ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
    val key_pair : (ED25519KeyPair.t, t) Olm_c_generated_types.field
  end

  module SAS : sig
    type t = [ `SAS ] Ctypes.structure
    val t : t Olm_c_generated_types.typ
    val last_error : (ErrorCode.t, t) Olm_c_generated_types.field
    val curve25519_key :
      (Curve25519KeyPair.t, t) Olm_c_generated_types.field
    val secret :
      (Unsigned.uint8 Ctypes_static.carray, t)
        Olm_c_generated_types.field
    val their_key_set : (int, t) Olm_c_generated_types.field
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
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_inbound_group_session :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_inbound_group_session_length :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_inbound_group_session :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val unpickle_inbound_group_session :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val init_inbound_group_session :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val import_inbound_group_session :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val group_decrypt_max_plaintext_length :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val group_decrypt :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t ->
     Unsigned.uint32 Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val inbound_group_session_id_length :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val inbound_group_session_id :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val inbound_group_session_first_known_index :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint32 Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val inbound_group_session_is_verified :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     int Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val export_inbound_group_session_length :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val export_inbound_group_session :
    (Olm_c_types.InboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t ->
     Unsigned.uint32 -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session :
    (unit Ctypes_static.ptr ->
     Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr
       Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session_last_error :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_outbound_group_session :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_outbound_group_session_length :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_outbound_group_session :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val unpickle_outbound_group_session :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val init_outbound_group_session_random_length :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val init_outbound_group_session :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val group_encrypt_message_length :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val group_encrypt :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session_id_length :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session_id :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session_message_index :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint32 Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session_key_length :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val outbound_group_session_key :
    (Olm_c_types.OutboundGroupSession.t Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val get_library_version :
    (Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     Unsigned.uint8 Ctypes_static.ptr ->
     unit Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val session_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val utility_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account :
    (unit Ctypes_static.ptr ->
     Olm_c_types.Account.t Ctypes_static.ptr
       Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val session :
    (unit Ctypes_static.ptr ->
     Olm_c_types.Session.t Ctypes_static.ptr
       Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val utility :
    (unit Ctypes_static.ptr ->
     Olm_c_types.Utility.t Ctypes_static.ptr
       Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val error :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_last_error :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val session_last_error :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val utility_last_error :
    (Olm_c_types.Utility.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_account :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_session :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_utility :
    (Olm_c_types.Utility.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_account_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_session_length :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_account :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_session :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val unpickle_account :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val unpickle_session :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_account_random_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_account :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_identity_keys_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_identity_keys :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_signature_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_sign :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_one_time_keys_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_one_time_keys :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_mark_keys_as_published :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_max_number_of_one_time_keys :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_generate_one_time_keys_random_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_generate_one_time_keys :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_generate_fallback_key_random_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_generate_fallback_key :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_fallback_key_length :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val account_fallback_key :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_outbound_session_random_length :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_outbound_session :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_inbound_session :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_inbound_session_from :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Olm_c_types.Account.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val session_id_length :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val session_id :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val session_has_received_message :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     int Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val session_describe :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     char Ctypes_static.ptr ->
     Unsigned.size_t -> unit Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val matches_inbound_session :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val matches_inbound_session_from :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val remove_one_time_keys :
    (Olm_c_types.Account.t Ctypes_static.ptr ->
     Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val encrypt_message_type :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val encrypt_random_length :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val encrypt_message_length :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val encrypt :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val decrypt_max_plaintext_length :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val decrypt :
    (Olm_c_types.Session.t Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sha256_length :
    (Olm_c_types.Utility.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sha256 :
    (Olm_c_types.Utility.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val ed25519_verify :
    (Olm_c_types.Utility.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_encryption_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_encryption :
    (unit Ctypes_static.ptr ->
     Olm_c_types.PkEncryption.t Ctypes_static.ptr
       Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_encryption_last_error :
    (Olm_c_types.PkEncryption.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_pk_encryption :
    (Olm_c_types.PkEncryption.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_encryption_set_recipient_key :
    (Olm_c_types.PkEncryption.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_ciphertext_length :
    (Olm_c_types.PkEncryption.t Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_mac_length :
    (Olm_c_types.PkEncryption.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_key_length :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_encrypt_random_length :
    (Olm_c_types.PkEncryption.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_encrypt :
    (Olm_c_types.PkEncryption.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_decryption_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_decryption :
    (unit Ctypes_static.ptr ->
     Olm_c_types.PkDecryption.t Ctypes_static.ptr
       Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_decryption_last_error :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_pk_decryption :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_private_key_length :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_generate_key_random_length :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_key_from_private :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_pk_decryption_length :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pickle_pk_decryption :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val unpickle_pk_decryption :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_max_plaintext_length :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_decrypt :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_get_private_key :
    (Olm_c_types.PkDecryption.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_signing_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_signing :
    (unit Ctypes_static.ptr ->
     Olm_c_types.PkSigning.t Ctypes_static.ptr
       Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_signing_last_error :
    (Olm_c_types.PkSigning.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_pk_signing :
    (Olm_c_types.PkSigning.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_signing_key_from_seed :
    (Olm_c_types.PkSigning.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_signing_seed_length :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_signing_public_key_length :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_signature_length :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val pk_sign :
    (Olm_c_types.PkSigning.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_last_error :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     char Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_size :
    (unit -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas :
    (unit Ctypes_static.ptr ->
     Olm_c_types.SAS.t Ctypes_static.ptr Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val clear_sas :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_sas_random_length :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val create_sas :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_pubkey_length :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_get_pubkey :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_set_their_key :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_is_their_key_set :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     int Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_generate_bytes :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_mac_length :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result

  (**   *)
  val sas_calculate_mac :
    (Olm_c_types.SAS.t Ctypes_static.ptr ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t ->
     unit Ctypes_static.ptr ->
     Unsigned.size_t -> Unsigned.size_t Olm_c_generated_functions.return)
      Olm_c_generated_functions.result
end
