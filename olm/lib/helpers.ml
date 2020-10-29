open Core

module YoJs = Yojson_helpers

module ResultInfix = struct
  let ( >>| ) r f = Result.map ~f r
  let ( >>= ) r f = Result.bind ~f r
end

let allocate_buf ?finalise bytes : char Ctypes.ptr =
  Ctypes.(allocate_n ?finalise char ~count:bytes)

let allocate_type_void t : unit Ctypes.ptr =
  Ctypes.(allocate_n t ~count:1 |> to_voidp)

let allocate_bytes_void bytes : unit Ctypes.ptr =
  Ctypes.(allocate_n char ~count:bytes |> to_voidp)

let finaliser t clear char_ptr =
  Ctypes.(coerce (ptr char) (ptr t) char_ptr) |> clear |> ignore

let size_of_int = Unsigned.Size_t.of_int
let size_to_int = Unsigned.Size_t.to_int

let olm_error = C.Funcs.error () |> size_to_int

let size_to_result size =
  match size_to_int size with
  | e when e = olm_error -> Result.Error `OlmError
  | i                    -> Result.return i

let string_of_nullterm_char_ptr char_ptr =
  let open Ctypes in
  let rec loop acc p =
    if is_null p || Char.equal (!@ p) '\000'
    then List.rev acc |> String.of_char_list
    else loop (!@ p :: acc) (p +@ 1)
  in
  loop [] char_ptr

let zero_bytes ctyp ~length p =
  let int_ptr = Ctypes.(coerce (ptr ctyp) (ptr uint8_t) p) in
  let zero    = Unsigned.UInt8.of_int 0 in
  for i = 0 to length - 1 do Ctypes.((int_ptr +@ i) <-@ zero) done

let string_of_ptr ctyp ~length p =
  Ctypes.(coerce (ptr ctyp) (ptr char) p |> string_from_ptr ~length)

let string_of_ptr_clr ctyp ~length p =
  let str = string_of_ptr ctyp ~length p in
  let ()  = zero_bytes ctyp ~length p in
  str

let string_to_ptr ctyp s =
  Ctypes.(CArray.of_string s |> CArray.start |> coerce (ptr char) (ptr ctyp))

let string_to_sized_buff ctyp s =
  string_to_ptr ctyp s, size_of_int (String.length s)

let random_chars len =
  let open Ctypes in
  Cryptokit.Random.(string secure_rng) len
  |> CArray.of_string
  |> CArray.start

let random_void len = random_chars len |> Ctypes.to_voidp

let random_uint8 len = random_chars len |> Ctypes.(coerce (ptr char) (ptr uint8_t))

let non_empty_string ?(label="String") str =
  if String.length str > 0
  then Result.return str
  else Result.fail (`ValueError (label ^ " can't be empty."))
