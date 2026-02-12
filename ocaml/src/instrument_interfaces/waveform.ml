open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_waveform_t = object
  method raw : unit ptr
end
class c_waveform (h : unit ptr) : c_waveform_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.waveform_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Waveform = struct
  type t = c_waveform

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.waveform_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.waveform_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_waveform ptr

  let make (space : Discretespace.DiscreteSpace.t) (transforms : Listporttransform.ListPortTransform.t) : t =
    Error_handling.multi_read [space; transforms] (fun () ->
      let ptr = Capi_bindings.waveform_create space#raw transforms#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let cartesianWaveform (divisions : Axesint.AxesInt.t) (axes : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t) (increasing : Axesmapstringbool.AxesMapStringBool.t) (transforms : Listporttransform.ListPortTransform.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [divisions; axes; increasing; transforms; domain] (fun () ->
      let ptr = Capi_bindings.waveform_create_cartesian_waveform divisions#raw axes#raw increasing#raw transforms#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let cartesianIdentityWaveform (divisions : Axesint.AxesInt.t) (axes : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t) (increasing : Axesmapstringbool.AxesMapStringBool.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [divisions; axes; increasing; domain] (fun () ->
      let ptr = Capi_bindings.waveform_create_cartesian_identity_waveform divisions#raw axes#raw increasing#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let cartesianWaveform2d (divisions : Axesint.AxesInt.t) (axes : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t) (increasing : Axesmapstringbool.AxesMapStringBool.t) (transforms : Listporttransform.ListPortTransform.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [divisions; axes; increasing; transforms; domain] (fun () ->
      let ptr = Capi_bindings.waveform_create_cartesian_waveform_2d divisions#raw axes#raw increasing#raw transforms#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let cartesianIdentityWaveform2d (divisions : Axesint.AxesInt.t) (axes : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t) (increasing : Axesmapstringbool.AxesMapStringBool.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [divisions; axes; increasing; domain] (fun () ->
      let ptr = Capi_bindings.waveform_create_cartesian_identity_waveform_2d divisions#raw axes#raw increasing#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let cartesianWaveform1d (division : int) (shared_domain : Coupledlabelleddomain.CoupledLabelledDomain.t) (increasing : Mapstringbool.MapStringBool.t) (transforms : Listporttransform.ListPortTransform.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [shared_domain; increasing; transforms; domain] (fun () ->
      let ptr = Capi_bindings.waveform_create_cartesian_waveform_1d division shared_domain#raw increasing#raw transforms#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let cartesianIdentityWaveform1d (division : int) (shared_domain : Coupledlabelleddomain.CoupledLabelledDomain.t) (increasing : Mapstringbool.MapStringBool.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [shared_domain; increasing; domain] (fun () ->
      let ptr = Capi_bindings.waveform_create_cartesian_identity_waveform_1d division shared_domain#raw increasing#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_waveform ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.waveform_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.waveform_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let space (handle : t) : Discretespace.DiscreteSpace.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_space handle#raw in
      Error_handling.raise_if_error ();
      new Discretespace.c_discretespace result
    )

  let transforms (handle : t) : Listporttransform.ListPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_transforms handle#raw in
      Error_handling.raise_if_error ();
      new Listporttransform.c_listporttransform result
    )

  let pushBack (handle : t) (value : Porttransform.PortTransform.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.waveform_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Porttransform.PortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Porttransform.c_porttransform result
    )

  let items (handle : t) : Listporttransform.ListPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.waveform_items handle#raw in
      Error_handling.raise_if_error ();
      new Listporttransform.c_listporttransform result
    )

  let contains (handle : t) (value : Porttransform.PortTransform.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.waveform_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Porttransform.PortTransform.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.waveform_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.waveform_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_waveform result
    )

end