open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

class c_interpretationcontainerquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontainerquantity_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module InterpretationContainerQuantity = struct
  type t = c_interpretationcontainerquantity

  let make (contextDoubleMap : MapInterpretationContextQuantity.t) : t =
    ErrorHandling.read contextDoubleMap (fun () ->
      let ptr = Capi_bindings.interpretationcontainerquantity_create contextDoubleMap#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontainerquantity ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.interpretationcontainerquantity_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontainerquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontainerquantity_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_interpretationcontainerquantity ptr

  let unit (handle : t) : SymbolUnit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_unit handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let selectByConnection (handle : t) (connection : Connection.t) : ListInterpretationContext.t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_connection handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByConnections (handle : t) (connections : Connections.t) : ListInterpretationContext.t =
    ErrorHandling.multi_read [handle; connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_connections handle#raw connections#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByIndependentConnection (handle : t) (connection : Connection.t) : ListInterpretationContext.t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_independent_connection handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectByDependentConnection (handle : t) (connection : Connection.t) : ListInterpretationContext.t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_by_dependent_connection handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let selectContexts (handle : t) (independent_connections : ListConnection.t) (dependent_connections : ListConnection.t) : ListInterpretationContext.t =
    ErrorHandling.multi_read [handle; independent_connections; dependent_connections] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_select_contexts handle#raw independent_connections#raw dependent_connections#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let insertOrAssign (handle : t) (key : InterpretationContext.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : InterpretationContext.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : InterpretationContext.t) : Quantity.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let erase (handle : t) (key : InterpretationContext.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : InterpretationContext.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : ListInterpretationContext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let values (handle : t) : ListQuantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listquantity result
    )

  let items (handle : t) : ListPairInterpretationContextQuantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextquantity result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontainerquantity_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end