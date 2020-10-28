(* module Types = Olm_c_types *)
module Types =
  Olm_c_type_descriptions.Descriptions (Olm_c_generated_types)

module Funcs =
  Olm_c_function_descriptions.Descriptions (Olm_c_generated_functions)
