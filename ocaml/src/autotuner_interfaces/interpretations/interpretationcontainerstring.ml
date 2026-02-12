open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_interpretationcontainerstring_t = object
  method raw : unit ptr
end
class c_interpretationcontainerstring (h : unit ptr) : c_interpretationcontainerstring_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontainerstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module InterpretationContainerString = struct
  type t = c_interpretationcontainerstring

  let make (contextDoubleMap : string) : t =
    let ptr = Capi_bindings.interpretationcontainerstring_create (Falcon_string.of_string contextDoubleMap) in
    Error_handling.raise_if_error ();
    new c_interpretationcontainerstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.interpretationcontainerstring_copy (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new c_interpretationcontainerstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontainerstring_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_interpretationcontainerstring ptr

  let unit (handle : string) : Symbolunit.SymbolUnit.t =
    let result = Capi_bindings.interpretationcontainerstring_unit (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new Symbolunit.c_symbolunit result

  let selectByConnection (handle : string) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.read connection (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_connection (Falcon_string.of_string handle) connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByConnections (handle : string) (connections : Connections.Connections.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.read connections (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_connections (Falcon_string.of_string handle) connections#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByIndependentConnection (handle : string) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.read connection (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_independent_connection (Falcon_string.of_string handle) connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectByDependentConnection (handle : string) (connection : Connection.Connection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.read connection (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_dependent_connection (Falcon_string.of_string handle) connection#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let selectContexts (handle : string) (independent_connections : Listconnection.ListConnection.t) (dependent_connections : Listconnection.ListConnection.t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.multi_read [independent_connections; dependent_connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_contexts (Falcon_string.of_string handle) independent_connections#raw dependent_connections#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let insertOrAssign (handle : string) (key : Interpretationcontext.InterpretationContext.t) (value : string) : unit =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_insert_or_assign (Falcon_string.of_string handle) key#raw (Falcon_string.of_string value) in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : string) (key : Interpretationcontext.InterpretationContext.t) (value : string) : unit =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_insert (Falcon_string.of_string handle) key#raw (Falcon_string.of_string value) in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : string) (key : Interpretationcontext.InterpretationContext.t) : string =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_at (Falcon_string.of_string handle) key#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let erase (handle : string) (key : Interpretationcontext.InterpretationContext.t) : unit =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_erase (Falcon_string.of_string handle) key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : string) : int =
    let result = Capi_bindings.interpretationcontainerstring_size (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let empty (handle : string) : bool =
    let result = Capi_bindings.interpretationcontainerstring_empty (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.interpretationcontainerstring_clear (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let contains (handle : string) (key : Interpretationcontext.InterpretationContext.t) : bool =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_contains (Falcon_string.of_string handle) key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : string) : Listinterpretationcontext.ListInterpretationContext.t =
    let result = Capi_bindings.interpretationcontainerstring_keys (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new Listinterpretationcontext.c_listinterpretationcontext result

  let values (handle : string) : string =
    let result = Capi_bindings.interpretationcontainerstring_values (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) : string =
    let result = Capi_bindings.interpretationcontainerstring_items (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.interpretationcontainerstring_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.interpretationcontainerstring_not_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.interpretationcontainerstring_to_json_string (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end