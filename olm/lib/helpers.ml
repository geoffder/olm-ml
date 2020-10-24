open! Core

module YoJs = Yojson_helpers

let ( >>| ) r f = Result.map ~f r
let ( >>= ) r f = Result.bind ~f r

let allocate_type_void t : unit Ctypes.ptr =
  Ctypes.(allocate_n t ~count:1 |> to_voidp)

let allocate_bytes_void bytes : unit Ctypes.ptr =
  Ctypes.(allocate_n char ~count:bytes |> to_voidp)

let size_of_int = Unsigned.Size_t.of_int
let size_to_int = Unsigned.Size_t.to_int

let olm_error = C.Funcs.error () |> size_to_int

let size_to_result size =
  match size_to_int size with
  | e when e = olm_error -> Result.Error "olm_error"
  | i                    -> Result.return i

let string_of_nullterm_char_ptr char_ptr =
  let open Ctypes in
  let rec loop acc p =
    if is_null p || Char.equal (!@ p) '\000'
    then List.rev acc |> String.of_char_list
    else loop (!@ p :: acc) (p +@ 1)
  in
  loop [] char_ptr

let string_of_voidp ~length voidp =
  let open Ctypes in
  coerce (ptr void) (ptr char) voidp
  |> string_from_ptr ~length

let string_to_voidp s = Ctypes.(CArray.of_string s |> CArray.start |> to_voidp)
