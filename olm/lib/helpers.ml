open Core

module YoJs = Yojson_helpers

module ResultInfix = struct
  let ( >>| ) r f = Result.map ~f r
  let ( >>= ) r f = Result.bind ~f r
end

let allocate_buf ?finalise n_bytes : char Ctypes.ptr =
  Ctypes.(allocate_n ?finalise char ~count:n_bytes)

let finaliser t clear char_ptr =
  Ctypes.(coerce (ptr char) (ptr t) char_ptr) |> clear |> ignore

let allocate_bytes_void n_bytes : unit Ctypes.ptr =
  Ctypes.(allocate_n char ~count:n_bytes |> to_voidp)

let size_of_int = Unsigned.Size_t.of_int

let size_to_int = Unsigned.Size_t.to_int

let olm_error = C.Funcs.error () |> size_to_int

let size_to_result size =
  match size_to_int size with
  | e when e = olm_error -> Result.fail `OlmError
  | i                    -> Result.return i

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

let non_empty_string ?(label="String") s =
  if String.length s > 0
  then Result.return s
  else Result.fail (`ValueError (label ^ " can't be empty."))

module UTF8 = struct
  let replace_err e = ignore (Uutf.encode e (`Uchar Uutf.u_rep))

  let ignore_err _ = ()

  let recode ?(ignore_unicode_errors=false) s =
    let policy = if ignore_unicode_errors then ignore_err else replace_err in
    let buf = Buffer.create (String.length s) in
    let rec loop d e = match Uutf.decode d with
      | `Uchar _ as u -> ignore (Uutf.encode e u); loop d e
      | `End          -> ignore (Uutf.encode e `End); Result.return ()
      | `Malformed _  -> policy e; loop d e
      | `Await        -> Result.fail `UnicodeError
    in
    let deco = Uutf.decoder ~encoding:`UTF_8 (`String s) in
    let enco = Uutf.encoder `UTF_8 (`Buffer buf) in
    loop deco enco
    |> Result.map ~f:(fun () -> Buffer.contents buf)
end
