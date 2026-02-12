open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_vector (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.vector_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Vector = struct
  type t = c_vector

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.vector_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.vector_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_vector ptr

  let make (start : Point.t) (end_ : Point.t) : t =
    ErrorHandling.multi_read [start; end_] (fun () ->
      let ptr = Capi_bindings.vector_create start#raw end_#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let fromEnd (end_ : Point.t) : t =
    ErrorHandling.read end_ (fun () ->
      let ptr = Capi_bindings.vector_create_from_end end_#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let fromQuantities (start : Mapconnectionquantity.t) (end_ : Mapconnectionquantity.t) : t =
    ErrorHandling.multi_read [start; end_] (fun () ->
      let ptr = Capi_bindings.vector_create_from_quantities start#raw end_#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let fromEndQuantities (end_ : Mapconnectionquantity.t) : t =
    ErrorHandling.read end_ (fun () ->
      let ptr = Capi_bindings.vector_create_from_end_quantities end_#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let fromDoubles (start : Mapconnectiondouble.t) (end_ : Mapconnectiondouble.t) (unit : Symbolunit.t) : t =
    ErrorHandling.multi_read [start; end_; unit] (fun () ->
      let ptr = Capi_bindings.vector_create_from_doubles start#raw end_#raw unit#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let fromEndDoubles (end_ : Mapconnectiondouble.t) (unit : Symbolunit.t) : t =
    ErrorHandling.multi_read [end_; unit] (fun () ->
      let ptr = Capi_bindings.vector_create_from_end_doubles end_#raw unit#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let fromParent (items : Mapconnectionquantity.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.vector_create_from_parent items#raw in
      ErrorHandling.raise_if_error ();
      new c_vector ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let endPoint (handle : t) : Point.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_end_point handle#raw in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let startPoint (handle : t) : Point.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_start_point handle#raw in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let endQuantities (handle : t) : Mapconnectionquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_end_quantities handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectionquantity result
    )

  let startQuantities (handle : t) : Mapconnectionquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_start_quantities handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectionquantity result
    )

  let endMap (handle : t) : Mapconnectiondouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_end_map handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectiondouble result
    )

  let startMap (handle : t) : Mapconnectiondouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_start_map handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectiondouble result
    )

  let connections (handle : t) : Listconnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_connections handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let unit (handle : t) : Symbolunit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_unit handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let principleConnection (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_principle_connection handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let magnitude (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_magnitude handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insertOrAssign (handle : t) (key : Connection.t) (value : Pairquantityquantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.vector_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.t) (value : Pairquantityquantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.vector_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.t) : Pairquantityquantity.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.vector_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_pairquantityquantity result
    )

  let erase (handle : t) (key : Connection.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.vector_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.vector_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let values (handle : t) : Listpairquantityquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairquantityquantity result
    )

  let items (handle : t) : Listpairconnectionpairquantityquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectionpairquantityquantity result
    )

  let addition (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_addition handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let subtraction (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_subtraction handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let doubleMultiplication (handle : t) (scalar : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_double_multiplication handle#raw scalar in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let intMultiplication (handle : t) (scalar : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_int_multiplication handle#raw scalar in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let doubleDivision (handle : t) (scalar : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_double_division handle#raw scalar in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let intDivision (handle : t) (scalar : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_int_division handle#raw scalar in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let negation (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_negation handle#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let updateStartFromStates (handle : t) (state : Devicevoltagestates.t) : t =
    ErrorHandling.multi_read [handle; state] (fun () ->
      let result = Capi_bindings.vector_update_start_from_states handle#raw state#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let translateDoubles (handle : t) (point : Mapconnectiondouble.t) (unit : Symbolunit.t) : t =
    ErrorHandling.multi_read [handle; point; unit] (fun () ->
      let result = Capi_bindings.vector_translate_doubles handle#raw point#raw unit#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let translateQuantities (handle : t) (point : Mapconnectionquantity.t) : t =
    ErrorHandling.multi_read [handle; point] (fun () ->
      let result = Capi_bindings.vector_translate_quantities handle#raw point#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let translate (handle : t) (point : Point.t) : t =
    ErrorHandling.multi_read [handle; point] (fun () ->
      let result = Capi_bindings.vector_translate handle#raw point#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let translateToOrigin (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_translate_to_origin handle#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let doubleExtend (handle : t) (extension : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_double_extend handle#raw extension in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let intExtend (handle : t) (extension : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_int_extend handle#raw extension in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let doubleShrink (handle : t) (extension : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_double_shrink handle#raw extension in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let intShrink (handle : t) (extension : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_int_shrink handle#raw extension in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let unitVector (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_unit_vector handle#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let normalize (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.vector_normalize handle#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let project (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_project handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_vector result
    )

  let updateUnit (handle : t) (unit : Symbolunit.t) : unit =
    ErrorHandling.multi_read [handle; unit] (fun () ->
      let result = Capi_bindings.vector_update_unit handle#raw unit#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end