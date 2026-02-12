open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_labelleddomain_t = object
  method raw : unit ptr
end
class c_labelleddomain (h : unit ptr) : c_labelleddomain_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.labelleddomain_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module LabelledDomain = struct
  type t = c_labelleddomain

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.labelleddomain_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_labelleddomain ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.labelleddomain_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_labelleddomain ptr

  let primitiveKnob (default_name : string) (min_val : float) (max_val : float) (psuedo_name : Connection.Connection.t) (instrument_type : string) (lesser_bound_contained : bool) (greater_bound_contained : bool) (units : Symbolunit.SymbolUnit.t) (description : string) : t =
    Error_handling.multi_read [psuedo_name; units] (fun () ->
      let ptr = Capi_bindings.labelleddomain_create_primitive_knob (Falcon_string.of_string default_name) min_val max_val psuedo_name#raw (Falcon_string.of_string instrument_type) lesser_bound_contained greater_bound_contained units#raw (Falcon_string.of_string description) in
      Error_handling.raise_if_error ();
      new c_labelleddomain ptr
    )

  let primitiveMeter (default_name : string) (min_val : float) (max_val : float) (psuedo_name : Connection.Connection.t) (instrument_type : string) (lesser_bound_contained : bool) (greater_bound_contained : bool) (units : Symbolunit.SymbolUnit.t) (description : string) : t =
    Error_handling.multi_read [psuedo_name; units] (fun () ->
      let ptr = Capi_bindings.labelleddomain_create_primitive_meter (Falcon_string.of_string default_name) min_val max_val psuedo_name#raw (Falcon_string.of_string instrument_type) lesser_bound_contained greater_bound_contained units#raw (Falcon_string.of_string description) in
      Error_handling.raise_if_error ();
      new c_labelleddomain ptr
    )

  let primitivePort (default_name : string) (min_val : float) (max_val : float) (psuedo_name : Connection.Connection.t) (instrument_type : string) (lesser_bound_contained : bool) (greater_bound_contained : bool) (units : Symbolunit.SymbolUnit.t) (description : string) : t =
    Error_handling.multi_read [psuedo_name; units] (fun () ->
      let ptr = Capi_bindings.labelleddomain_create_primitive_port (Falcon_string.of_string default_name) min_val max_val psuedo_name#raw (Falcon_string.of_string instrument_type) lesser_bound_contained greater_bound_contained units#raw (Falcon_string.of_string description) in
      Error_handling.raise_if_error ();
      new c_labelleddomain ptr
    )

  let fromPort (min_val : float) (max_val : float) (port : Instrumentport.InstrumentPort.t) (lesser_bound_contained : bool) (greater_bound_contained : bool) : t =
    Error_handling.read port (fun () ->
      let ptr = Capi_bindings.labelleddomain_create_from_port min_val max_val port#raw lesser_bound_contained greater_bound_contained in
      Error_handling.raise_if_error ();
      new c_labelleddomain ptr
    )

  let fromPortAndDomain (port : Instrumentport.InstrumentPort.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [port; domain] (fun () ->
      let ptr = Capi_bindings.labelleddomain_create_from_port_and_domain port#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_labelleddomain ptr
    )

  let fromDomain (domain : Domain.Domain.t) (default_name : string) (psuedo_name : Connection.Connection.t) (instrument_type : string) (units : Symbolunit.SymbolUnit.t) (description : string) : t =
    Error_handling.multi_read [domain; psuedo_name; units] (fun () ->
      let ptr = Capi_bindings.labelleddomain_create_from_domain domain#raw (Falcon_string.of_string default_name) psuedo_name#raw (Falcon_string.of_string instrument_type) units#raw (Falcon_string.of_string description) in
      Error_handling.raise_if_error ();
      new c_labelleddomain ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelleddomain_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelleddomain_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let port (handle : t) : Instrumentport.InstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_port handle#raw in
      Error_handling.raise_if_error ();
      new Instrumentport.c_instrumentport result
    )

  let domain (handle : t) : Domain.Domain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_domain handle#raw in
      Error_handling.raise_if_error ();
      new Domain.c_domain result
    )

  let matchingPort (handle : t) (port : Instrumentport.InstrumentPort.t) : bool =
    Error_handling.multi_read [handle; port] (fun () ->
      let result = Capi_bindings.labelleddomain_matching_port handle#raw port#raw in
      Error_handling.raise_if_error ();
      result
    )

  let lesserBound (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_lesser_bound handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let greaterBound (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_greater_bound handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let lesserBoundContained (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_lesser_bound_contained handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let greaterBoundContained (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_greater_bound_contained handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let in_ (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_in handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let range (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_range handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let center (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_center handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelleddomain_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelleddomain result
    )

  let union (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelleddomain_union handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelleddomain result
    )

  let isEmpty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_is_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let containsDomain (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelleddomain_contains_domain handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let shift (handle : t) (offset : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_shift handle#raw offset in
      Error_handling.raise_if_error ();
      new c_labelleddomain result
    )

  let scale (handle : t) (scale : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelleddomain_scale handle#raw scale in
      Error_handling.raise_if_error ();
      new c_labelleddomain result
    )

  let transform (handle : t) (other : t) (value : float) : float =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelleddomain_transform handle#raw other#raw value in
      Error_handling.raise_if_error ();
      result
    )

end