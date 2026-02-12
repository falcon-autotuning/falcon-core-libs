open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_interpretationcontainerstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontainerstring_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module InterpretationContainerString = struct
  type t = c_interpretationcontainerstring

  let make (contextDoubleMap : string) : t =
    let ptr = Capi_bindings.interpretationcontainerstring_create (Capi_bindings.string_wrap contextDoubleMap) in
    ErrorHandling.raise_if_error ();
    new c_interpretationcontainerstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.interpretationcontainerstring_copy (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_interpretationcontainerstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontainerstring_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_interpretationcontainerstring ptr

  let unit (handle : string) : Symbolunit.t =
    let result = Capi_bindings.interpretationcontainerstring_unit (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_symbolunit result

  let selectByConnection (handle : string) (connection : Connection.t) : Listinterpretationcontext.t =
    ErrorHandling.read connection (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_connection (Capi_bindings.string_wrap handle) connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByConnections (handle : string) (connections : Connections.t) : Listinterpretationcontext.t =
    ErrorHandling.read connections (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_connections (Capi_bindings.string_wrap handle) connections#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByIndependentConnection (handle : string) (connection : Connection.t) : Listinterpretationcontext.t =
    ErrorHandling.read connection (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_independent_connection (Capi_bindings.string_wrap handle) connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByDependentConnection (handle : string) (connection : Connection.t) : Listinterpretationcontext.t =
    ErrorHandling.read connection (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_by_dependent_connection (Capi_bindings.string_wrap handle) connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectContexts (handle : string) (independent_connections : Listconnection.t) (dependent_connections : Listconnection.t) : Listinterpretationcontext.t =
    ErrorHandling.multi_read [independent_connections; dependent_connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_select_contexts (Capi_bindings.string_wrap handle) independent_connections#raw dependent_connections#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let insertOrAssign (handle : string) (key : Interpretationcontext.t) (value : string) : unit =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_insert_or_assign (Capi_bindings.string_wrap handle) key#raw (Capi_bindings.string_wrap value) in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : string) (key : Interpretationcontext.t) (value : string) : unit =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_insert (Capi_bindings.string_wrap handle) key#raw (Capi_bindings.string_wrap value) in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : string) (key : Interpretationcontext.t) : string =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_at (Capi_bindings.string_wrap handle) key#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let erase (handle : string) (key : Interpretationcontext.t) : unit =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_erase (Capi_bindings.string_wrap handle) key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : string) : int =
    let result = Capi_bindings.interpretationcontainerstring_size (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let empty (handle : string) : bool =
    let result = Capi_bindings.interpretationcontainerstring_empty (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.interpretationcontainerstring_clear (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let contains (handle : string) (key : Interpretationcontext.t) : bool =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.interpretationcontainerstring_contains (Capi_bindings.string_wrap handle) key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : string) : Listinterpretationcontext.t =
    let result = Capi_bindings.interpretationcontainerstring_keys (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_listinterpretationcontext result

  let values (handle : string) : string =
    let result = Capi_bindings.interpretationcontainerstring_values (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) : string =
    let result = Capi_bindings.interpretationcontainerstring_items (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.interpretationcontainerstring_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.interpretationcontainerstring_not_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.interpretationcontainerstring_to_json_string (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end