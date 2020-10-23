open! Core
open Olm

let%test "a" = C.Functions.pk_signing_size ()
               |> Unsigned.Size_t.to_int
               |> ( = ) 100
