open Ctypes
open Foreign

module OlmInboundGroupSession = struct
  (* NOTE: stand-in junk. Need to figure out representation of structs, and model
   * this struct (along with many others...) *)
  type t = unit ptr
  let t : t typ = ptr void
end

(* NOTE: These are basically all approximations based on the rust bindings,
 * as I learn more about how to properly do this, I'll sweep through an fix them.
 * The fudged boilerplate will serve as a convenient skeleton though. *)

let olm_inbound_group_session_size =
  foreign "olm_inbound_group_session_size"
    (void @-> returning int)

let olm_inbound_group_session =
  foreign "olm_inbound_group_session"
    (void @-> returning OlmInboundGroupSession.t)

let olm_inbound_group_session_last_error =
  foreign "olm_inbound_group_session_last_error"
    (ptr OlmInboundGroupSession.t @-> returning (ptr char))

let olm_clear_inbound_group_session =
  foreign "olm_clear_inbound_group_session"
    (ptr OlmInboundGroupSession.t @-> returning int)

let olm_pickle_inbound_group_session_length =
  foreign "olm_pickle_inbound_group_session_length"
    (ptr OlmInboundGroupSession.t @-> returning int)

let olm_pickle_inbound_group_session =
  foreign "olm_pickle_inbound_group_session"
    (ptr OlmInboundGroupSession.t (* session *)
     @-> ptr void                 (* key *)
     @-> int                      (* key_length *)
     @-> ptr void                 (* pickled *)
     @-> int                      (* pickled_length *)
     @-> returning int)           (* olm_error *)
