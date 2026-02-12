open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_unitspace (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.unitspace_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module UnitSpace = struct
  type t = c_unitspace

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.unitspace_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.unitspace_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_unitspace ptr

  let make (axes : Axesdiscretizer.t) (domain : Domain.t) : t =
    ErrorHandling.multi_read [axes; domain] (fun () ->
      let ptr = Capi_bindings.unitspace_create axes#raw domain#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace ptr
    )

  let raySpace (dr : float) (dtheta : float) (domain : Domain.t) : t =
    ErrorHandling.read domain (fun () ->
      let ptr = Capi_bindings.unitspace_create_ray_space dr dtheta domain#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace ptr
    )

  let cartesianSpace (deltas : Axesdouble.t) (domain : Domain.t) : t =
    ErrorHandling.multi_read [deltas; domain] (fun () ->
      let ptr = Capi_bindings.unitspace_create_cartesian_space deltas#raw domain#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace ptr
    )

  let cartesian1dSpace (delta : float) (domain : Domain.t) : t =
    ErrorHandling.read domain (fun () ->
      let ptr = Capi_bindings.unitspace_create_cartesian_1d_space delta domain#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace ptr
    )

  let cartesian2dSpace (deltas : Axesdouble.t) (domain : Domain.t) : t =
    ErrorHandling.multi_read [deltas; domain] (fun () ->
      let ptr = Capi_bindings.unitspace_create_cartesian_2d_space deltas#raw domain#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.unitspace_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.unitspace_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let axes (handle : t) : Axesdiscretizer.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_axes handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axesdiscretizer result
    )

  let domain (handle : t) : Domain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_domain handle#raw in
      ErrorHandling.raise_if_error ();
      new c_domain result
    )

  let space (handle : t) : Farraydouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_space handle#raw in
      ErrorHandling.raise_if_error ();
      new c_farraydouble result
    )

  let shape (handle : t) : Listint.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_shape handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listint result
    )

  let dimension (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_dimension handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let compile (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_compile handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let createArray (handle : t) (axes : Axesint.t) : Axescontrolarray.t =
    ErrorHandling.multi_read [handle; axes] (fun () ->
      let result = Capi_bindings.unitspace_create_array handle#raw axes#raw in
      ErrorHandling.raise_if_error ();
      new c_axescontrolarray result
    )

  let pushBack (handle : t) (value : Discretizer.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.unitspace_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Discretizer.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.unitspace_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_discretizer result
    )

  let items (handle : t) (out_buffer : Discretizer.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.unitspace_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Discretizer.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.unitspace_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Discretizer.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.unitspace_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.unitspace_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_unitspace result
    )

end