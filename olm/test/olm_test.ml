open! Core
open Olm

let%test "a" = C.Functions.olm_pk_signing_size ()
               |> Unsigned.Size_t.to_int
               |> ( = ) 100
