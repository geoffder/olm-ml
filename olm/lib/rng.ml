open Core
open Ctypes

let () = Nocrypto_entropy_unix.initialize ()

let char_buf len =
  Nocrypto.Rng.generate len
  |> Cstruct.to_bigarray
  |> array_of_bigarray array1
  |> CArray.start

let void_buf len = char_buf len |> to_voidp

let uint8_buf len = char_buf len |> (coerce (ptr char) (ptr uint8_t))

let string len = char_buf len |> Helpers.string_of_ptr char ~length:len
