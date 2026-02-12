open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Physics.Config.Geometries

class c_dotgateswithneighbors (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.dotgateswithneighbors_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module DotGatesWithNeighbors = struct
  type t = c_dotgateswithneighbors

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.dotgateswithneighbors_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_dotgateswithneighbors ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.dotgateswithneighbors_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_dotgateswithneighbors ptr

  let empty () : t =
    let ptr = Capi_bindings.dotgateswithneighbors_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_dotgateswithneighbors ptr

  let make (items : ListDotGateWithNeighbors.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.dotgateswithneighbors_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_dotgateswithneighbors ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let isPlungerGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_is_plunger_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isBarrierGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_is_barrier_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_dotgateswithneighbors result
    )

  let pushBack (handle : t) (value : DotGateWithNeighbors.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : DotGateWithNeighbors.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_dotgatewithneighbors result
    )

  let items (handle : t) : ListDotGateWithNeighbors.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listdotgatewithneighbors result
    )

  let contains (handle : t) (value : DotGateWithNeighbors.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : DotGateWithNeighbors.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.dotgateswithneighbors_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end