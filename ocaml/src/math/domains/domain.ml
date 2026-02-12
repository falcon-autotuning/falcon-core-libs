open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_domain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.domain_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Domain = struct
  type t = c_domain

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.domain_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_domain ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.domain_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_domain ptr

  let make (min_val : float) (max_val : float) (lesser_bound_contained : bool) (greater_bound_contained : bool) : t =
    let ptr = Capi_bindings.domain_create min_val max_val lesser_bound_contained greater_bound_contained in
    ErrorHandling.raise_if_error ();
    new c_domain ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.domain_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.domain_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let lesserBound (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_lesser_bound handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let greaterBound (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_greater_bound handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let lesserBoundContained (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_lesser_bound_contained handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let greaterBoundContained (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_greater_bound_contained handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let in_ (handle : t) (value : float) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_in handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let range (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_range handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let center (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_center handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.domain_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_domain result
    )

  let union (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.domain_union handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_domain result
    )

  let isEmpty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_is_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let containsDomain (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.domain_contains_domain handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let shift (handle : t) (offset : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_shift handle#raw offset in
      ErrorHandling.raise_if_error ();
      new c_domain result
    )

  let scale (handle : t) (scale : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.domain_scale handle#raw scale in
      ErrorHandling.raise_if_error ();
      new c_domain result
    )

  let transform (handle : t) (other : t) (value : float) : float =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.domain_transform handle#raw other#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

end