# olm-ml
### OCaml bindings for the Olm cryptographic library.

These bindings provide an OCaml API to the olm and megolm cryptographic ratchets
used by the open-source [Matrix](https://matrix.org/) communication protocol.
The repository containing the implementation of the libolm cryptography can be
found [here](https://gitlab.matrix.org/matrix-org/olm). Unfortunately the
hyperlink on the git submodule in the [olm/c/vendor](olm/c/vendor) subdirectory
is broken due to being pointed at GitLab. Library API (as well as testing and
documentation) has been modelled after the [python
bindings](https://gitlab.matrix.org/matrix-org/olm/-/tree/master/python)
included in the Olm repository.

The C bindings themselves have been statically built using the
[ocaml-ctypes](https://github.com/ocamllabs/ocaml-ctypes) Cstubs module, with
organization heavily inspired by [Luv](https://github.com/aantron/luv
"OCaml/ReasonML binding to libuv")

## Documentation:
Odoc generated docs can be found at
[here](https://geoffder.github.io/olm-ml/olm/index.html "ocaml-olm docs"), or
you may take a look at the `.mli` files themselves.
