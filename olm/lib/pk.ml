open Core
open Helpers

let public_key_size  = C.Funcs.pk_key_length () |> size_to_int
let private_key_size = C.Funcs.pk_private_key_length () |> size_to_int

let signing_public_key_size = C.Funcs.pk_signing_public_key_length () |> size_to_int
let signature_size          = C.Funcs.pk_signature_length () |> size_to_int
let signing_seed_size       = C.Funcs.pk_signing_seed_length () |> size_to_int

module Message = struct
  type t = { ephemeral_key : string
           ; mac           : string
           ; ciphertext    : string
           }

  let create ephemeral_key mac ciphertext = { ephemeral_key; mac; ciphertext }
end

module Encryption = struct
  type t = C.Types.PkEncryption.t Ctypes_static.ptr

  let size = C.Funcs.pk_encryption_size () |> size_to_int

  let clear = C.Funcs.clear_pk_encryption

  let check_error t ret =
    size_to_result ret
    |> Result.map_error
      ~f:(fun _ -> C.Funcs.pk_encryption_last_error t |> string_of_nullterm_char_ptr)

  let create recipient_key =
    non_empty_string ~label:"Key" recipient_key >>|
    string_to_ptr Ctypes.void >>= fun key_buf ->
    let key_len = String.length recipient_key + 1 |> size_of_int in
    let t       = allocate_bytes_void size |> C.Funcs.pk_encryption in
    let ret = C.Funcs.pk_encryption_set_recipient_key t key_buf key_len in
    let ()  = zero_mem Ctypes.void ~length:(size_to_int key_len) key_buf in
    check_error t ret >>| fun _ ->
    t

  let encrypt t plaintext =
    let txt_buf    = string_to_ptr Ctypes.void plaintext in
    let txt_len    = String.length plaintext + 1 |> size_of_int in
    let random_len = C.Funcs.pk_encrypt_random_length t in
    let random_buf = random_void (size_to_int random_len) in
    let cipher_len = C.Funcs.pk_ciphertext_length t txt_len in
    let cipher_buf = allocate_bytes_void (size_to_int cipher_len) in
    let mac_len    = C.Funcs.pk_ciphertext_length t txt_len in
    let mac_buf    = allocate_bytes_void (size_to_int cipher_len) in
    let key_buf    = allocate_bytes_void public_key_size in
    let ret = C.Funcs.pk_encrypt t
        txt_buf    txt_len
        cipher_buf cipher_len
        mac_buf    mac_len
        key_buf    (size_of_int public_key_size)
        random_buf random_len
    in
    let () = zero_mem Ctypes.void ~length:(size_to_int txt_len) txt_buf in
    check_error t ret >>| fun _ ->
    Message.create
      (string_of_ptr Ctypes.void ~length:public_key_size key_buf)
      (string_of_ptr Ctypes.void ~length:(size_to_int mac_len) mac_buf)
      (string_of_ptr Ctypes.void ~length:(size_to_int cipher_len) cipher_buf)
end

module Decryption = struct
  type t = C.Types.PkDecryption.t Ctypes_static.ptr

  let size = C.Funcs.pk_decryption_size () |> size_to_int

  let clear = C.Funcs.clear_pk_decryption

  let check_error t ret =
    size_to_result ret
    |> Result.map_error ~f:begin fun _ ->
      C.Funcs.pk_decryption_last_error t
      |> string_of_nullterm_char_ptr
    end

  let create () =
    let t          = allocate_bytes_void size |> C.Funcs.pk_decryption in
    let random_buf = random_void private_key_size in
    let random_len = size_of_int private_key_size in
    let key_buf    = allocate_bytes_void public_key_size in
    let key_len    = size_of_int public_key_size in
    C.Funcs.pk_key_from_private t key_buf key_len random_buf random_len
    |> check_error t >>| fun _ ->
    t, string_of_ptr Ctypes.void ~length:public_key_size key_buf

  let pickle ?(pass="") t =
    let pass_buf   = string_to_ptr Ctypes.void pass in
    let pass_len   = String.length pass + 1 |> size_of_int in
    let pickle_len = C.Funcs.pickle_pk_decryption_length t in
    let pickle_buf = allocate_bytes_void (size_to_int pickle_len) in
    let ret = C.Funcs.pickle_pk_decryption t pass_buf pass_len pickle_buf pickle_len in
    let ()  = zero_mem Ctypes.void ~length:(size_to_int pass_len) pass_buf in
    check_error t ret >>| fun _ ->
    string_of_ptr Ctypes.void ~length:(size_to_int pickle_len) pickle_buf

  let from_pickle ?(pass="") pickle =
    non_empty_string ~label:"Pickle" pickle >>| string_to_ptr Ctypes.void >>= fun pickle_buf ->
    let pass_buf = string_to_ptr Ctypes.void pass in
    let pass_len = String.length pass + 1 |> size_of_int in
    let key_buf  = allocate_bytes_void public_key_size in
    let t        = allocate_bytes_void size |> C.Funcs.pk_decryption in
    let ret = C.Funcs.unpickle_pk_decryption t
        pass_buf   pass_len
        pickle_buf (String.length pickle + 1 |> size_of_int)
        key_buf    (size_of_int public_key_size)
    in
    let () = zero_mem Ctypes.void ~length:(size_to_int pass_len) pass_buf in
    check_error t ret >>| fun _ ->
    t, string_of_ptr Ctypes.void ~length:public_key_size key_buf

  let decrypt t (msg : Message.t) =
    let key_buf     = string_to_ptr Ctypes.void msg.ephemeral_key in
    let mac_buf     = string_to_ptr Ctypes.void msg.mac in
    let cipher_buf  = string_to_ptr Ctypes.void msg.ciphertext in
    let cipher_len  = String.length msg.ciphertext + 1 |> size_of_int in
    let max_txt_len = C.Funcs.pk_max_plaintext_length t cipher_len in
    let txt_buf     = allocate_bytes_void (size_to_int max_txt_len) in
    C.Funcs.pk_decrypt t
      key_buf    (String.length msg.ephemeral_key + 1 |> size_of_int)
      mac_buf    (String.length msg.mac + 1 |> size_of_int)
      cipher_buf cipher_len
      txt_buf    max_txt_len
    |> check_error t >>| fun txt_len ->
    string_of_ptr_clr Ctypes.void ~length:txt_len txt_buf

  let private_key t =
    let key_buf = allocate_bytes_void private_key_size in
    let key_len = size_of_int private_key_size in
    C.Funcs.pk_get_private_key t key_buf key_len
    |> check_error t >>| fun length ->
    string_of_ptr_clr Ctypes.void ~length key_buf
end

module Signing = struct
  let size = C.Funcs.pk_signing_size () |> size_to_int

  let clear = C.Funcs.clear_pk_signing

  let check_error t ret =
    size_to_result ret
    |> Result.map_error ~f:begin fun _ ->
      C.Funcs.pk_signing_last_error t
      |> string_of_nullterm_char_ptr
    end

  let create seed =
    non_empty_string ~label:"Seed" seed >>| string_to_ptr Ctypes.void >>= fun seed_buf ->
    let seed_len = String.length seed |> size_of_int in
    let key_len  = size_of_int public_key_size in
    let key_buf  = allocate_bytes_void signing_public_key_size in
    let t        = allocate_bytes_void size |> C.Funcs.pk_signing in
    let ret = C.Funcs.pk_signing_key_from_seed t key_buf key_len seed_buf seed_len in
    let ()  = zero_mem Ctypes.void ~length:(size_to_int seed_len) seed_buf in
    check_error t ret >>| fun _ ->
    t, string_of_ptr Ctypes.void ~length:public_key_size key_buf

  let generate_seed () = Cryptokit.Random.(string secure_rng) signing_seed_size

  let sign t msg_str =
    let msg_buf = string_to_ptr Ctypes.void msg_str in
    let msg_len = String.length msg_str |> size_of_int in
    let sig_buf = allocate_bytes_void signature_size in
    C.Funcs.pk_sign t msg_buf msg_len sig_buf (size_of_int signature_size)
    |> check_error t >>| fun _ ->
    string_of_ptr Ctypes.void ~length:signature_size sig_buf
end
