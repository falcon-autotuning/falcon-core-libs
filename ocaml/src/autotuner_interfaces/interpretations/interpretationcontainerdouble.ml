open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_interpretationcontainerdouble_t = object
  method raw : unit ptr
end
class c_interpretationcontainerdouble (h : unit ptr) : c_interpretationcontainerdouble_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontainerdouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module InterpretationContainerDouble = struct
  type t = c_interpretationcontainerdouble

  let make (contextDoubleMap : Mapinterpretationcontextdouble.MapInterpretationContextDouble.t) : t =
    Error_handling.read contextDoubleMap (fun () ->
      let ptr = Capi_bindings.interpretationcontainerdouble_create contextDoubleMap#raw in
      Error_handling.raise_if_error ();
      new c_interpretationcontainerdouble ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.interpretationcontainerdouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_interpretationcontainerdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontainerdouble_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_interpretationcontainerdouble ptr

  let unit (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_unit handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let selectByConnection (handle : t) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_connection handle#raw connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByConnections (handle : t) (connections : Connections.Connections.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_connections handle#raw connections#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByIndependentConnection (handle : t) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_independent_connection handle#raw connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByDependentConnection (handle : t) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_dependent_connection handle#raw connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectContexts (handle : t) (independent_connections : Listconnection.ListConnection.t) (dependent_connections : Listconnection.ListConnection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [handle; independent_connections; dependent_connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_contexts handle#raw independent_connections#raw dependent_connections#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let insertOrAssign (handle : t) (key : Interpretationcontext.InterpretationContext.t) (value : float) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_insert_or_assign handle#raw key#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Interpretationcontext.InterpretationContext.t) (value : float) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_insert handle#raw key#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Interpretationcontext.InterpretationContext.t) : float =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : Interpretationcontext.InterpretationContext.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Interpretationcontext.InterpretationContext.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let values (handle : t) : Listdouble.ListDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_values handle#raw in
      Error_handling.raise_if_error ();
      new Listdouble.c_listdouble result
    )

  let items (handle : t) : Listpairinterpretationcontextdouble.ListPairInterpretationContextDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairinterpretationcontextdouble.c_listpairinterpretationcontextdouble result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end