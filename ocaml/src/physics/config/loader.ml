open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_loader_t = object
  method raw : unit ptr
end
class c_loader (h : unit ptr) : c_loader_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.loader_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Loader = struct
  type t = c_loader

  let make (config_path : string) : t =
    let ptr = Capi_bindings.loader_create (Falcon_string.of_string config_path) in
    Error_handling.raise_if_error ();
    new c_loader ptr

  let config (handle : t) : Config.Config.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.loader_config handle#raw in
      Error_handling.raise_if_error ();
      new Config.c_config result
    )

end