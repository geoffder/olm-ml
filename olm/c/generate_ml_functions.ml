let () =
  Cstubs.write_ml
    Format.std_formatter
    ~prefix:Sys.argv.(1)
    (module Olm_c_function_descriptions.Descriptions);
