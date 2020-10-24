open! Core

let allocate_type_void t : unit Ctypes.ptr =
  Ctypes.(allocate_n t ~count:1 |> to_voidp)

let allocate_bytes_void bytes : unit Ctypes.ptr =
  Ctypes.(allocate_n char ~count:bytes |> to_voidp)

let olm_error = C.Functions.error () |> Unsigned.Size_t.to_int

let size_to_result size =
  match Unsigned.Size_t.to_int size with
  | e when e = olm_error -> Result.Error "olm_error"
  | i                    -> Result.return i

let string_of_null_term_ptr char_ptr =
  let open Ctypes in
  let rec loop acc p =
    if is_null p
    then List.rev acc |> String.of_char_list
    else loop (!@ p :: acc) (p +@ 1)
  in
  loop [] char_ptr
