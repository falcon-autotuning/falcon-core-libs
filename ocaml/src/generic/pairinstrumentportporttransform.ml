open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinstrumentportporttransform_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairInstrumentPortPortTransform = struct
  type t = c_pairinstrumentportporttransform

  let make (first : Instrumentport.InstrumentPort.t) (second : Porttransform.PortTransform.t) : t =
    Error_handling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairinstrumentportporttransform_create first#raw second#raw in
      Error_handling.raise_if_error ();
      new c_pairinstrumentportporttransform ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairinstrumentportporttransform_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairinstrumentportporttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinstrumentportporttransform_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_pairinstrumentportporttransform ptr

  let first (handle : t) : Instrumentport.InstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_first handle#raw in
      Error_handling.raise_if_error ();
      new Instrumentport.c_instrumentport result
    )

  let second (handle : t) : Porttransform.PortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_second handle#raw in
      Error_handling.raise_if_error ();
      new Porttransform.c_porttransform result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end