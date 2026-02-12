open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_interpretationcontainerdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontainerdouble_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module InterpretationContainerDouble = struct
  type t = c_interpretationcontainerdouble

  let make (contextDoubleMap : Mapinterpretationcontextdouble.t) : t =
    ErrorHandling.read contextDoubleMap (fun () ->
      let ptr = Capi_bindings.interpretationcontainerdouble_create contextDoubleMap#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontainerdouble ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.interpretationcontainerdouble_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontainerdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontainerdouble_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_interpretationcontainerdouble ptr

  let unit (handle : t) : Symbolunit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_unit handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let selectByConnection (handle : t) (connection : Connection.t) : Listinterpretationcontext.t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_connection handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByConnections (handle : t) (connections : Connections.t) : Listinterpretationcontext.t =
    ErrorHandling.multi_read [handle; connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_connections handle#raw connections#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByIndependentConnection (handle : t) (connection : Connection.t) : Listinterpretationcontext.t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_independent_connection handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByDependentConnection (handle : t) (connection : Connection.t) : Listinterpretationcontext.t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_by_dependent_connection handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectContexts (handle : t) (independent_connections : Listconnection.t) (dependent_connections : Listconnection.t) : Listinterpretationcontext.t =
    ErrorHandling.multi_read [handle; independent_connections; dependent_connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_select_contexts handle#raw independent_connections#raw dependent_connections#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let insertOrAssign (handle : t) (key : Interpretationcontext.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_insert_or_assign handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Interpretationcontext.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_insert handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Interpretationcontext.t) : float =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : Interpretationcontext.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Interpretationcontext.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listinterpretationcontext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let values (handle : t) : Listdouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listdouble result
    )

  let items (handle : t) : Listpairinterpretationcontextdouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextdouble result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerdouble_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end