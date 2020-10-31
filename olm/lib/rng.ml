open Core
open Ctypes

let () = Nocrypto_entropy_unix.initialize ()

let pick_int () = Nocrypto.(Numeric.Int.of_cstruct_be (Rng.generate 1))

(* The int will always be 0 to 255, thus using exn. *)
let pick_char _ = pick_int () |> Char.of_int_exn

let char_buf len =
  List.init ~f:pick_char len
  |> CArray.of_list char
  |> CArray.start

let void_buf len = char_buf len |> to_voidp

let uint8_buf len = char_buf len |> (coerce (ptr char) (ptr uint8_t))

let string len = List.init ~f:pick_char len |> String.of_char_list
