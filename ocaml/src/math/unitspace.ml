open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_unitspace_t = object
  method raw : unit ptr
end
class c_unitspace (h : unit ptr) : c_unitspace_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.unitspace_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module UnitSpace = struct
  type t = c_unitspace

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.unitspace_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_unitspace ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.unitspace_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_unitspace ptr

  let make (axes : Axesdiscretizer.AxesDiscretizer.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [axes; domain] (fun () ->
      let ptr = Capi_bindings.unitspace_create axes#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_unitspace ptr
    )

  let raySpace (dr : float) (dtheta : float) (domain : Domain.Domain.t) : t =
    Error_handling.read domain (fun () ->
      let ptr = Capi_bindings.unitspace_create_ray_space dr dtheta domain#raw in
      Error_handling.raise_if_error ();
      new c_unitspace ptr
    )

  let cartesianSpace (deltas : Axesdouble.AxesDouble.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [deltas; domain] (fun () ->
      let ptr = Capi_bindings.unitspace_create_cartesian_space deltas#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_unitspace ptr
    )

  let cartesian1dSpace (delta : float) (domain : Domain.Domain.t) : t =
    Error_handling.read domain (fun () ->
      let ptr = Capi_bindings.unitspace_create_cartesian_1d_space delta domain#raw in
      Error_handling.raise_if_error ();
      new c_unitspace ptr
    )

  let cartesian2dSpace (deltas : Axesdouble.AxesDouble.t) (domain : Domain.Domain.t) : t =
    Error_handling.multi_read [deltas; domain] (fun () ->
      let ptr = Capi_bindings.unitspace_create_cartesian_2d_space deltas#raw domain#raw in
      Error_handling.raise_if_error ();
      new c_unitspace ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.unitspace_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.unitspace_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let axes (handle : t) : Axesdiscretizer.AxesDiscretizer.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_axes handle#raw in
      Error_handling.raise_if_error ();
      new Axesdiscretizer.c_axesdiscretizer result
    )

  let domain (handle : t) : Domain.Domain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_domain handle#raw in
      Error_handling.raise_if_error ();
      new Domain.c_domain result
    )

  let space (handle : t) : Farraydouble.FArrayDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_space handle#raw in
      Error_handling.raise_if_error ();
      new Farraydouble.c_farraydouble result
    )

  let shape (handle : t) : Listint.ListInt.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_shape handle#raw in
      Error_handling.raise_if_error ();
      new Listint.c_listint result
    )

  let dimension (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_dimension handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let compile (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_compile handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let createArray (handle : t) (axes : Axesint.AxesInt.t) : Axescontrolarray.AxesControlArray.t =
    Error_handling.multi_read [handle; axes] (fun () ->
      let result = Capi_bindings.unitspace_create_array handle#raw axes#raw in
      Error_handling.raise_if_error ();
      new Axescontrolarray.c_axescontrolarray result
    )

  let pushBack (handle : t) (value : Discretizer.Discretizer.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.unitspace_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Discretizer.Discretizer.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.unitspace_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Discretizer.c_discretizer result
    )

  let items (handle : t) (out_buffer : Discretizer.Discretizer.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.unitspace_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let contains (handle : t) (value : Discretizer.Discretizer.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.unitspace_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Discretizer.Discretizer.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.unitspace_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.unitspace_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_unitspace result
    )

end