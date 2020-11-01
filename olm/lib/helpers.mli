(** Various helper functions shared throughout the Olm API modules. *)

open Core

module YoJs = Yojson_helpers

module ResultInfix : sig
  val ( >>| ) : ('a, 'b) result -> ('a -> 'c) -> ('c, 'b) result
  val ( >>= ) : ('a, 'b) result -> ('a -> ('c, 'b) result) -> ('c, 'b) result
end

(** [allocate_buf ?finalise n_bytes]

    Create char buffer of size [n_bytes] with optional [finalise] for the
    garbage collector. *)
val allocate_buf : ?finalise:(char Ctypes.ptr -> unit) -> int -> char Ctypes.ptr

(** [finaliser t clear char_ptr]

    Create a finalisation closure (accepting the [char_ptr] to finalise) for
    [t], using [clear]. Simply performing the necessary coersion between the
    originally allocated char buffer and the actual type [t]. *)
val finaliser : 'a Ctypes.typ -> ('a Ctypes_static.ptr -> 'b) -> char Ctypes_static.ptr -> unit

(** [allocate_bytes_void n_bytes]

    Allocate [n_bytes] of memory and return a void pointer to it. *)
val allocate_bytes_void : int -> unit Ctypes.ptr

val size_of_int : int -> Unsigned.size_t

val size_to_int : Unsigned.size_t -> int

(** [olm_error]

    Integer representation of the return value of [C.Funcs.error] (olm_error ()
    in the C headers.). Return values of libolm functions are checked against this
    to determine whether an error occurred and the [last_error] of the relevant
    Olm object needs to be checked. *)
val olm_error : int

(** [size_to_result size]

    Maps libolm return [size] to an integer in the Result monad if not equal to
    [olm_error], otherwise [`OlmError]. *)
val size_to_result : Unsigned.size_t -> (int, [> `OlmError ]) result

(** [zero_bytes ctyp ~length p]

    Zero out the memory backing the [p] of size [length] and type [ctyp]. *)
val zero_bytes : 'a Ctypes.typ -> length:int -> 'a Ctypes_static.ptr -> unit

(** [string_of_ptr ctyp ~length p]

    Map [p] of size [length] and type [ctyp] to string. *)
val string_of_ptr : 'a Ctypes.typ -> length:int -> 'a Ctypes_static.ptr -> string

(** [string_of_ptr_clr ctyp ~length p]

    [string_of_ptr], but run [zero_bytes] on [p] afterwards. *)
val string_of_ptr_clr : 'a Ctypes.typ -> length:int -> 'a Ctypes_static.ptr -> string

(** [string_to_ptr ctyp s]

    Map [s] to a pointer of type [ctyp]. *)
val string_to_ptr : 'a Ctypes.typ -> string -> 'a Ctypes_static.ptr

(** [string_to_sized_buff ctyp s]

    [string_of_ptr], but also returning the size of the resulting buffer along
    with the pointer in a tuple. *)
val string_to_sized_buff : 'a Ctypes.typ -> string -> 'a Ctypes_static.ptr * Unsigned.size_t

(** [non_empty_string ?label s]

    Map [s] into the Result monad, returning a [`ValueError msg] if it is empty.
    If [label] is provided, it is added to the error message to make it more
    specific. *)
val non_empty_string : ?label:string -> string -> (string, [> `ValueError of string ]) result

module UTF8 : sig
  (** [recode ?ignore_unicode_errors s]

      Re-encode the input utf8 string [s], replacing invalid characters with
      [Uutf.u_rep] by default, or nothing if [ignore_unicode_errors] is true. *)
  val recode
    :  ?ignore_unicode_errors:bool
    -> string
    -> (string, [> `UnicodeError ]) result
end
