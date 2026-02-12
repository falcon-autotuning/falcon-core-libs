open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_discretespace (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.discretespace_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module DiscreteSpace = struct
  type t = c_discretespace

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.discretespace_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_discretespace ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.discretespace_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_discretespace ptr

  let make (space : Unitspace.t) (axes : Axescoupledlabelleddomain.t) (increasing : Axesmapstringbool.t) : t =
    ErrorHandling.multi_read [space; axes; increasing] (fun () ->
      let ptr = Capi_bindings.discretespace_create space#raw axes#raw increasing#raw in
      ErrorHandling.raise_if_error ();
      new c_discretespace ptr
    )

  let cartesianDiscreteSpace (divisions : Axesint.t) (axes : Axescoupledlabelleddomain.t) (increasing : Axesmapstringbool.t) (domain : Domain.t) : t =
    ErrorHandling.multi_read [divisions; axes; increasing; domain] (fun () ->
      let ptr = Capi_bindings.discretespace_create_cartesian_discrete_space divisions#raw axes#raw increasing#raw domain#raw in
      ErrorHandling.raise_if_error ();
      new c_discretespace ptr
    )

  let cartesianDiscreteSpace1d (division : int) (shared_domain : Coupledlabelleddomain.t) (increasing : Mapstringbool.t) (domain : Domain.t) : t =
    ErrorHandling.multi_read [shared_domain; increasing; domain] (fun () ->
      let ptr = Capi_bindings.discretespace_create_cartesian_discrete_space_1d division shared_domain#raw increasing#raw domain#raw in
      ErrorHandling.raise_if_error ();
      new c_discretespace ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretespace_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretespace_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretespace_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let space (handle : t) : Unitspace.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretespace_space handle#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace result
    )

  let axes (handle : t) : Axescoupledlabelleddomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretespace_axes handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axescoupledlabelleddomain result
    )

  let increasing (handle : t) : Axesmapstringbool.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretespace_increasing handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axesmapstringbool result
    )

  let knobs (handle : t) : Ports.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretespace_knobs handle#raw in
      ErrorHandling.raise_if_error ();
      new c_ports result
    )

  let validateUnitSpaceDimensionalityMatchesKnobs (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretespace_validate_unit_space_dimensionality_matches_knobs handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let validateKnobUniqueness (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretespace_validate_knob_uniqueness handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getAxis (handle : t) (knob : Instrumentport.t) : int =
    ErrorHandling.multi_read [handle; knob] (fun () ->
      let result = Capi_bindings.discretespace_get_axis handle#raw knob#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getDomain (handle : t) (knob : Instrumentport.t) : Domain.t =
    ErrorHandling.multi_read [handle; knob] (fun () ->
      let result = Capi_bindings.discretespace_get_domain handle#raw knob#raw in
      ErrorHandling.raise_if_error ();
      new c_domain result
    )

  let getProjection (handle : t) (projection : Axesinstrumentport.t) : Axeslabelledcontrolarray.t =
    ErrorHandling.multi_read [handle; projection] (fun () ->
      let result = Capi_bindings.discretespace_get_projection handle#raw projection#raw in
      ErrorHandling.raise_if_error ();
      new c_axeslabelledcontrolarray result
    )

end