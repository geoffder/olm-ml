module IdentityKeys : sig
  type t = private { curve25519 : string; ed25519 : string; }
  val equal     : t -> t -> bool
  val of_yojson : Yojson.Safe.t -> (t, [> `YojsonError of string ]) Core.result
  val to_yojson : t -> Yojson.Safe.t
  val of_string : string -> (t, [> `YojsonError of string ]) Core.result
  val to_string : t -> string
end

module OneTimeKeys : sig
  type t = private
    { curve25519 : (string, string, Core.String.comparator_witness) Core.Map.t }
  val equal     : t -> t -> bool
  val of_yojson : Yojson.Safe.t -> (t, [> `YojsonError of string ]) Core.result
  val to_yojson : t -> Yojson.Safe.t
  val of_string : string -> (t, [> `YojsonError of string ]) Core.result
  val to_string : t -> string
end

type t = { buf : char Ctypes_static.ptr
         ; acc : C.Types.Account.t Ctypes_static.ptr
         }

val size : int

val clear : C.Types.Account.t Ctypes_static.ptr -> (int, [> `OlmError ]) Core.Result.t

val check_error : t -> Unsigned.Size_t.t -> (int, [> OlmError.t ]) Core.Result.t

val alloc : unit -> t

val create : unit -> (t, [> OlmError.t ]) Core.Result.t

val pickle : ?pass:string -> t -> (string, [> OlmError.t ]) Core.Result.t

val from_pickle :
  ?pass:string -> string -> (t, [> OlmError.t | `ValueError of string ]) Core.Result.t

val identity_keys :
  t -> (IdentityKeys.t, [> OlmError.t | `YojsonError of string ]) Core.Result.t

val sign : t -> string -> (string, [> OlmError.t ]) Core.Result.t

val max_one_time_keys : t -> (int, [> OlmError.t ]) Core.Result.t

val mark_keys_as_published : t -> (int, [> OlmError.t ]) Core.Result.t

val generate_one_time_keys : t -> int -> (int, [> OlmError.t ]) Core.Result.t

val one_time_keys :
  t -> (OneTimeKeys.t, [> OlmError.t | `YojsonError of string ]) Core.Result.t
