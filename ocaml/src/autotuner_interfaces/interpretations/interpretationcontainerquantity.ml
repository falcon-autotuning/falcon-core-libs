open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_interpretationcontainerquantity_t = object
  method raw : unit ptr
end
class c_interpretationcontainerquantity (h : unit ptr) : c_interpretationcontainerquantity_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontainerquantity_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module InterpretationContainerQuantity = struct
  type t = c_interpretationcontainerquantity

  let make (contextDoubleMap : Mapinterpretationcontextquantity.MapInterpretationContextQuantity.t) : t =
    Error_handling.read contextDoubleMap (fun () ->
      let ptr = Capi_bindings.interpretationcontainerquantity_create contextDoubleMap#raw in
      Error_handling.raise_if_error ();
      new c_interpretationcontainerquantity ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.interpretationcontainerquantity_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_interpretationcontainerquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontainerquantity_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_interpretationcontainerquantity ptr

  let unit (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_unit handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let selectByConnection (handle : t) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_connection handle#raw connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByConnections (handle : t) (connections : Connections.Connections.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_connections handle#raw connections#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByIndependentConnection (handle : t) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_independent_connection handle#raw connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByDependentConnection (handle : t) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_dependent_connection handle#raw connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectContexts (handle : t) (independent_connections : Listconnection.ListConnection.t) (dependent_connections : Listconnection.ListConnection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; independent_connections; dependent_connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_contexts handle#raw independent_connections#raw dependent_connections#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let insertOrAssign (handle : t) (key : Interpretationcontext.InterpretationContext.t) (value : Quantity.Quantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Interpretationcontext.InterpretationContext.t) (value : Quantity.Quantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Interpretationcontext.InterpretationContext.t) : Quantity.Quantity.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Quantity.c_quantity result
    )

  let erase (handle : t) (key : Interpretationcontext.InterpretationContext.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Interpretationcontext.InterpretationContext.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let values (handle : t) : Listquantity.ListQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_values handle#raw in
      Error_handling.raise_if_error ();
      new Listquantity.c_listquantity result
    )

  let items (handle : t) : Listpairinterpretationcontextquantity.ListPairInterpretationContextQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairinterpretationcontextquantity.c_listpairinterpretationcontextquantity result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end