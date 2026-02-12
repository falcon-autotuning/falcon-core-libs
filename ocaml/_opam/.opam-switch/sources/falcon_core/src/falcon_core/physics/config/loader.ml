open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Physics.Config.Core

class c_loader (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.loader_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Loader = struct
  type t = c_loader

  let make (config_path : string) : t =
    let ptr = Capi_bindings.loader_create (Capi_bindings.string_wrap config_path) in
    ErrorHandling.raise_if_error ();
    new c_loader ptr

  let config (handle : t) : Config.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.loader_config handle#raw in
      ErrorHandling.raise_if_error ();
      new c_config result
    )

end