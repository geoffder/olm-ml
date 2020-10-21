let libolm =
  Dl.dlopen
    ~filename:"/home/geoff/GitRepos/ocaml-olm/libolm/build/libolm.so"
    ~flags:Dl.[ RTLD_NOW ]
