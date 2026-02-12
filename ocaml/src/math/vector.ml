open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_vector (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.vector_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Vector = struct
  type t = c_vector

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.vector_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.vector_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_vector ptr

  let make (start : Point.Point.t) (end_ : Point.Point.t) : t =
    Error_handling.multi_read [start; end_] (fun () ->
      let ptr = Capi_bindings.vector_create start#raw end_#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let fromEnd (end_ : Point.Point.t) : t =
    Error_handling.read end_ (fun () ->
      let ptr = Capi_bindings.vector_create_from_end end_#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let fromQuantities (start : Mapconnectionquantity.MapConnectionQuantity.t) (end_ : Mapconnectionquantity.MapConnectionQuantity.t) : t =
    Error_handling.multi_read [start; end_] (fun () ->
      let ptr = Capi_bindings.vector_create_from_quantities start#raw end_#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let fromEndQuantities (end_ : Mapconnectionquantity.MapConnectionQuantity.t) : t =
    Error_handling.read end_ (fun () ->
      let ptr = Capi_bindings.vector_create_from_end_quantities end_#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let fromDoubles (start : Mapconnectiondouble.MapConnectionDouble.t) (end_ : Mapconnectiondouble.MapConnectionDouble.t) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.multi_read [start; end_; unit] (fun () ->
      let ptr = Capi_bindings.vector_create_from_doubles start#raw end_#raw unit#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let fromEndDoubles (end_ : Mapconnectiondouble.MapConnectionDouble.t) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.multi_read [end_; unit] (fun () ->
      let ptr = Capi_bindings.vector_create_from_end_doubles end_#raw unit#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let fromParent (items : Mapconnectionquantity.MapConnectionQuantity.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.vector_create_from_parent items#raw in
      Error_handling.raise_if_error ();
      new c_vector ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let endPoint (handle : t) : Point.Point.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_end_point handle#raw in
      Error_handling.raise_if_error ();
      new Point.c_point result
    )

  let startPoint (handle : t) : Point.Point.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_start_point handle#raw in
      Error_handling.raise_if_error ();
      new Point.c_point result
    )

  let endQuantities (handle : t) : Mapconnectionquantity.MapConnectionQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_end_quantities handle#raw in
      Error_handling.raise_if_error ();
      new Mapconnectionquantity.c_mapconnectionquantity result
    )

  let startQuantities (handle : t) : Mapconnectionquantity.MapConnectionQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_start_quantities handle#raw in
      Error_handling.raise_if_error ();
      new Mapconnectionquantity.c_mapconnectionquantity result
    )

  let endMap (handle : t) : Mapconnectiondouble.MapConnectionDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_end_map handle#raw in
      Error_handling.raise_if_error ();
      new Mapconnectiondouble.c_mapconnectiondouble result
    )

  let startMap (handle : t) : Mapconnectiondouble.MapConnectionDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_start_map handle#raw in
      Error_handling.raise_if_error ();
      new Mapconnectiondouble.c_mapconnectiondouble result
    )

  let connections (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_connections handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let unit (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_unit handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let principleConnection (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_principle_connection handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let magnitude (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_magnitude handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insertOrAssign (handle : t) (key : Connection.Connection.t) (value : Pairquantityquantity.PairQuantityQuantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.vector_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.Connection.t) (value : Pairquantityquantity.PairQuantityQuantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.vector_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.Connection.t) : Pairquantityquantity.PairQuantityQuantity.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.vector_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Pairquantityquantity.c_pairquantityquantity result
    )

  let erase (handle : t) (key : Connection.Connection.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.vector_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.Connection.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.vector_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let values (handle : t) : Listpairquantityquantity.ListPairQuantityQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_values handle#raw in
      Error_handling.raise_if_error ();
      new Listpairquantityquantity.c_listpairquantityquantity result
    )

  let items (handle : t) : Listpairconnectionpairquantityquantity.ListPairConnectionPairQuantityQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairconnectionpairquantityquantity.c_listpairconnectionpairquantityquantity result
    )

  let addition (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_addition handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let subtraction (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_subtraction handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let doubleMultiplication (handle : t) (scalar : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_double_multiplication handle#raw scalar in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let intMultiplication (handle : t) (scalar : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_int_multiplication handle#raw scalar in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let doubleDivision (handle : t) (scalar : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_double_division handle#raw scalar in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let intDivision (handle : t) (scalar : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_int_division handle#raw scalar in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let negation (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_negation handle#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let updateStartFromStates (handle : t) (state : Devicevoltagestates.DeviceVoltageStates.t) : t =
    Error_handling.multi_read [handle; state] (fun () ->
      let result = Capi_bindings.vector_update_start_from_states handle#raw state#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let translateDoubles (handle : t) (point : Mapconnectiondouble.MapConnectionDouble.t) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.multi_read [handle; point; unit] (fun () ->
      let result = Capi_bindings.vector_translate_doubles handle#raw point#raw unit#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let translateQuantities (handle : t) (point : Mapconnectionquantity.MapConnectionQuantity.t) : t =
    Error_handling.multi_read [handle; point] (fun () ->
      let result = Capi_bindings.vector_translate_quantities handle#raw point#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let translate (handle : t) (point : Point.Point.t) : t =
    Error_handling.multi_read [handle; point] (fun () ->
      let result = Capi_bindings.vector_translate handle#raw point#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let translateToOrigin (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_translate_to_origin handle#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let doubleExtend (handle : t) (extension : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_double_extend handle#raw extension in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let intExtend (handle : t) (extension : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_int_extend handle#raw extension in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let doubleShrink (handle : t) (extension : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_double_shrink handle#raw extension in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let intShrink (handle : t) (extension : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_int_shrink handle#raw extension in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let unitVector (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_unit_vector handle#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let normalize (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.vector_normalize handle#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let project (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.vector_project handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_vector result
    )

  let updateUnit (handle : t) (unit : Symbolunit.SymbolUnit.t) : unit =
    Error_handling.multi_read [handle; unit] (fun () ->
      let result = Capi_bindings.vector_update_unit handle#raw unit#raw in
      Error_handling.raise_if_error ();
      result
    )

end