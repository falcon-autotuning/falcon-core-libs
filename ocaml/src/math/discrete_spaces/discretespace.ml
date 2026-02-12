open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_discretespace_t = object
  method raw : unit ptr
end
class c_discretespace (h : unit ptr) : c_discretespace_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.discretespace_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module DiscreteSpace = struct
  type t = c_discretespace

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.discretespace_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_discretespace ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.discretespace_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_discretespace ptr

  let make (space : Unitspace.UnitSpace.t) (axes : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t) (increasing : Axesmapstringbool.AxesMapStringBool.t) : t =
    Error_handling.multi_read [space; axes; increasing] (fun () ->
      let ptr = Capi_bindings.discretespace_create space#raw axes#raw increasing#raw in
      Error_handling.raise_if_error ();
      new c_discretespace ptr
    )

  let cartesianDiscreteSpace (divisions : Axesint.AxesInt.t) (axes : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t) (increasing : Axesmapstringbool.AxesMapStringBool.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [divisions; axes; increasing; domain] (fun () ->
      let ptr = Capi_bindings.discretespace_create_cartesian_discrete_space divisions#raw axes#raw increasing#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_discretespace ptr
    )

  let cartesianDiscreteSpace1d (division : int) (shared_domain : Coupledlabelleddomain.CoupledLabelledDomain.t) (increasing : Mapstringbool.MapStringBool.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [shared_domain; increasing; domain] (fun () ->
      let ptr = Capi_bindings.discretespace_create_cartesian_discrete_space_1d division shared_domain#raw increasing#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_discretespace ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretespace_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretespace_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretespace_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let space (handle : t) : Unitspace.UnitSpace.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretespace_space handle#raw in
      Error_handling.raise_if_error ();
      new Unitspace.c_unitspace result
    )

  let axes (handle : t) : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretespace_axes handle#raw in
      Error_handling.raise_if_error ();
      new Axescoupledlabelleddomain.c_axescoupledlabelleddomain result
    )

  let increasing (handle : t) : Axesmapstringbool.AxesMapStringBool.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretespace_increasing handle#raw in
      Error_handling.raise_if_error ();
      new Axesmapstringbool.c_axesmapstringbool result
    )

  let knobs (handle : t) : Ports.Ports.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretespace_knobs handle#raw in
      Error_handling.raise_if_error ();
      new Ports.c_ports result
    )

  let validateUnitSpaceDimensionalityMatchesKnobs (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretespace_validate_unit_space_dimensionality_matches_knobs handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let validateKnobUniqueness (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretespace_validate_knob_uniqueness handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getAxis (handle : t) (knob : Instrumentport.InstrumentPort.t) : int =
    Error_handling.multi_read [handle; knob] (fun () ->
      let result = Capi_bindings.discretespace_get_axis handle#raw knob#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getDomain (handle : t) (knob : Instrumentport.InstrumentPort.t) : Domain.Domain.t =
    Error_handling.multi_read [handle; knob] (fun () ->
      let result = Capi_bindings.discretespace_get_domain handle#raw knob#raw in
      Error_handling.raise_if_error ();
      new Domain.c_domain result
    )

  let getProjection (handle : t) (projection : Axesinstrumentport.AxesInstrumentPort.t) : Axeslabelledcontrolarray.AxesLabelledControlArray.t =
    Error_handling.multi_read [handle; projection] (fun () ->
      let result = Capi_bindings.discretespace_get_projection handle#raw projection#raw in
      Error_handling.raise_if_error ();
      new Axeslabelledcontrolarray.c_axeslabelledcontrolarray result
    )

end