open Core
open Helpers
open Helpers.ResultInfix

let public_key_size_t  = C.Funcs.pk_key_length ()
let public_key_size    = size_to_int public_key_size_t
let private_key_size_t = C.Funcs.pk_private_key_length ()
let private_key_size   = size_to_int private_key_size_t

let signing_public_key_size = C.Funcs.pk_signing_public_key_length () |> size_to_int
let signature_size_t        = C.Funcs.pk_signature_length ()
let signature_size          = size_to_int signature_size_t
let signing_seed_size       = C.Funcs.pk_signing_seed_length () |> size_to_int

module Message = struct
  type t = { ephemeral_key : string
           ; mac           : string
           ; ciphertext    : string
           }

  let create ephemeral_key mac ciphertext = { ephemeral_key; mac; ciphertext }
end

module Encryption = struct
  type t = { buf    : char Ctypes.ptr
           ; pk_enc : C.Types.PkEncryption.t Ctypes_static.ptr
           }

  let size = C.Funcs.pk_encryption_size () |> size_to_int

  let clear pk_enc = C.Funcs.clear_pk_encryption pk_enc |> size_to_result

  let check_error t ret =
    size_to_result ret
    |> Result.map_error ~f:begin fun _ ->
      C.Funcs.pk_encryption_last_error t.pk_enc
      |> OlmError.of_last_error
    end

  let alloc () =
    let finalise = finaliser C.Types.PkEncryption.t clear in
    let buf = allocate_buf ~finalise size in
    { buf; pk_enc = C.Funcs.pk_encryption (Ctypes.to_voidp buf) }

  let create recipient_key =
    non_empty_string ~label:"Key" recipient_key >>|
    string_to_sized_buff Ctypes.void >>= fun (key_buf, key_len) ->
    let t   = alloc () in
    let ret = C.Funcs.pk_encryption_set_recipient_key t.pk_enc key_buf key_len in
    let ()  = zero_bytes Ctypes.void ~length:(size_to_int key_len) key_buf in
    check_error t ret >>| fun _ ->
    t

  let encrypt t plaintext =
    let txt_buf, txt_len = string_to_sized_buff Ctypes.void plaintext in
    let random_len = C.Funcs.pk_encrypt_random_length t.pk_enc in
    let random_buf = random_void (size_to_int random_len) in
    let cipher_len = C.Funcs.pk_ciphertext_length t.pk_enc txt_len in
    let cipher_buf = allocate_bytes_void (size_to_int cipher_len) in
    let mac_len    = C.Funcs.pk_ciphertext_length t.pk_enc txt_len in
    let mac_buf    = allocate_bytes_void (size_to_int cipher_len) in
    let key_buf    = allocate_bytes_void public_key_size in
    let ret = C.Funcs.pk_encrypt t.pk_enc
        txt_buf    txt_len
        cipher_buf cipher_len
        mac_buf    mac_len
        key_buf    public_key_size_t
        random_buf random_len
    in
    let () = zero_bytes Ctypes.void ~length:(size_to_int txt_len) txt_buf in
    check_error t ret >>| fun _ ->
    Message.create
      (string_of_ptr Ctypes.void ~length:public_key_size key_buf)
      (string_of_ptr Ctypes.void ~length:(size_to_int mac_len) mac_buf)
      (string_of_ptr Ctypes.void ~length:(size_to_int cipher_len) cipher_buf)
end

module Decryption = struct
  type t = { buf    : char Ctypes.ptr
           ; pk_dec : C.Types.PkDecryption.t Ctypes_static.ptr
           ; pubkey : string
           }

  let size = C.Funcs.pk_decryption_size () |> size_to_int

  let clear pk_dec = C.Funcs.clear_pk_decryption pk_dec |> size_to_result

  let check_error t ret =
    size_to_result ret
    |> Result.map_error ~f:begin fun _ ->
      C.Funcs.pk_decryption_last_error t.pk_dec
      |> OlmError.of_last_error
    end

  let alloc () =
    let finalise = finaliser C.Types.PkDecryption.t clear in
    let buf = allocate_buf ~finalise size in
    { buf; pk_dec = C.Funcs.pk_decryption (Ctypes.to_voidp buf); pubkey = "" }

  let create () =
    let t          = alloc () in
    let random_buf = random_void private_key_size in
    let random_len = private_key_size_t in
    let key_buf    = allocate_bytes_void public_key_size in
    let key_len    = public_key_size_t in
    C.Funcs.pk_key_from_private t.pk_dec key_buf key_len random_buf random_len
    |> check_error t >>| fun _ ->
    { t with pubkey = string_of_ptr Ctypes.void ~length:public_key_size key_buf }

  let pickle ?(pass="") t =
    let pass_buf, pass_len = string_to_sized_buff Ctypes.void pass in
    let pickle_len         = C.Funcs.pickle_pk_decryption_length t.pk_dec in
    let pickle_buf         = allocate_bytes_void (size_to_int pickle_len) in
    let ret = C.Funcs.pickle_pk_decryption t.pk_dec pass_buf pass_len pickle_buf pickle_len in
    let ()  = zero_bytes Ctypes.void ~length:(size_to_int pass_len) pass_buf in
    check_error t ret >>| fun _ ->
    string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

  let from_pickle ?(pass="") pickle =
    non_empty_string ~label:"Pickle" pickle >>|
    string_to_sized_buff Ctypes.void >>= fun (pickle_buf, pickle_len) ->
    let pass_buf, pass_len = string_to_sized_buff Ctypes.void pass in
    let key_buf            = allocate_bytes_void public_key_size in
    let t                  = alloc () in
    let ret = C.Funcs.unpickle_pk_decryption t.pk_dec
        pass_buf   pass_len
        pickle_buf pickle_len
        key_buf    public_key_size_t
    in
    let () = zero_bytes Ctypes.void ~length:(size_to_int pass_len) pass_buf in
    check_error t ret >>| fun _ ->
    { t with pubkey = string_of_ptr Ctypes.void ~length:public_key_size key_buf }

  let decrypt t (msg : Message.t) =
    let key_buf, key_len       = string_to_sized_buff Ctypes.void msg.ephemeral_key in
    let mac_buf, mac_len       = string_to_sized_buff Ctypes.void msg.mac in
    let cipher_buf, cipher_len = string_to_sized_buff Ctypes.void msg.ciphertext in
    let max_txt_len            = C.Funcs.pk_max_plaintext_length t.pk_dec cipher_len in
    let txt_buf                = allocate_bytes_void (size_to_int max_txt_len) in
    C.Funcs.pk_decrypt t.pk_dec
      key_buf    key_len
      mac_buf    mac_len
      cipher_buf cipher_len
      txt_buf    max_txt_len
    |> check_error t >>| fun txt_len ->
    string_of_ptr_clr Ctypes.void ~length:txt_len txt_buf

  let private_key t =
    let key_buf = allocate_bytes_void private_key_size in
    let key_len = private_key_size_t in
    C.Funcs.pk_get_private_key t.pk_dec key_buf key_len
    |> check_error t >>| fun length ->
    string_of_ptr_clr Ctypes.void ~length key_buf
end

module Signing = struct
  type t = { buf    : char Ctypes.ptr
           ; pk_sgn : C.Types.PkSigning.t Ctypes.ptr
           ; pubkey : string
           }

  let size = C.Funcs.pk_signing_size () |> size_to_int

  let clear pk_sgn = C.Funcs.clear_pk_signing pk_sgn |> size_to_result

  let check_error t ret =
    size_to_result ret
    |> Result.map_error ~f:begin fun _ ->
      C.Funcs.pk_signing_last_error t.pk_sgn
      |> OlmError.of_last_error
    end

  let alloc () =
    let finalise = finaliser C.Types.PkSigning.t clear in
    let buf = allocate_buf ~finalise size in
    { buf; pk_sgn = C.Funcs.pk_signing (Ctypes.to_voidp buf); pubkey = "" }

  let create seed =
    non_empty_string ~label:"Seed" seed >>|
    string_to_sized_buff Ctypes.void >>= fun (seed_buf, seed_len) ->
    let key_len = public_key_size_t in
    let key_buf = allocate_bytes_void signing_public_key_size in
    let t       = alloc () in
    let ret = C.Funcs.pk_signing_key_from_seed t.pk_sgn key_buf key_len seed_buf seed_len in
    let ()  = zero_bytes Ctypes.void ~length:(size_to_int seed_len) seed_buf in
    check_error t ret >>| fun _ ->
    { t with pubkey = string_of_ptr Ctypes.void ~length:public_key_size key_buf }

  let generate_seed () = Cryptokit.Random.(string secure_rng) signing_seed_size

  let sign t msg_str =
    let msg_buf, msg_len = string_to_sized_buff Ctypes.void msg_str in
    let sig_buf          = allocate_bytes_void signature_size in
    C.Funcs.pk_sign t.pk_sgn msg_buf msg_len sig_buf signature_size_t
    |> check_error t >>| fun _ ->
    string_of_ptr Ctypes.void ~length:signature_size sig_buf
end
