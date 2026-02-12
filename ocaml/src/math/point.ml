open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_point (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.point_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Point = struct
  type t = c_point

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.point_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_point ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.point_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_point ptr

  let empty () : t =
    let ptr = Capi_bindings.point_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_point ptr

  let make (items : Mapconnectiondouble.t) (unit : Symbolunit.t) : t =
    ErrorHandling.multi_read [items; unit] (fun () ->
      let ptr = Capi_bindings.point_create items#raw unit#raw in
      ErrorHandling.raise_if_error ();
      new c_point ptr
    )

  let fromParent (items : Mapconnectionquantity.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.point_create_from_parent items#raw in
      ErrorHandling.raise_if_error ();
      new c_point ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let unit (handle : t) : Symbolunit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_unit handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let insertOrAssign (handle : t) (key : Connection.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.point_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.point_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.t) : Quantity.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.point_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let erase (handle : t) (key : Connection.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.point_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.point_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let values (handle : t) : Listquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listquantity result
    )

  let items (handle : t) : Listpairconnectionquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectionquantity result
    )

  let coordinates (handle : t) : Mapconnectionquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_coordinates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectionquantity result
    )

  let connections (handle : t) : Listconnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_connections handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let addition (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_addition handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let subtraction (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_subtraction handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let multiplication (handle : t) (scalar : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_multiplication handle#raw scalar in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let division (handle : t) (scalar : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_division handle#raw scalar in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let negation (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.point_negation handle#raw in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let setUnit (handle : t) (unit : Symbolunit.t) : unit =
    ErrorHandling.multi_read [handle; unit] (fun () ->
      let result = Capi_bindings.point_set_unit handle#raw unit#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end