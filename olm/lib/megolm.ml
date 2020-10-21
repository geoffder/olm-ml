open Ctypes

let megolm_ratchet_part_length = 32
let megolm_ratchet_parts       = 4
let megolm_ratchet_length      = megolm_ratchet_part_length * megolm_ratchet_parts

module Megolm = struct
  type t
  let t : t structure typ = structure "Megolm"
  let data                = field t "data" (array megolm_ratchet_parts
                                              (array megolm_ratchet_part_length uint8_t))
  let counter             = field t "counter" uint32_t
  let ()                  = seal t
end
