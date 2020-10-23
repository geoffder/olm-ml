open! Core
open! Olm_c_types
open! Olm_c_generated_functions

let%test "a" = olm_stub_111_olm_pk_signing_size ()
               |> ignore; true
