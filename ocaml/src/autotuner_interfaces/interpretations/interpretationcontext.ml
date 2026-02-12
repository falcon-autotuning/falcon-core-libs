open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_interpretationcontext_t = object
  method raw : unit ptr
end
class c_interpretationcontext (h : unit ptr) : c_interpretationcontext_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontext_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module InterpretationContext = struct
  type t = c_interpretationcontext

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.interpretationcontext_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_interpretationcontext ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontext_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_interpretationcontext ptr

  let make (independant_variables : Axesmeasurementcontext.AxesMeasurementContext.t) (dependant_variables : Listmeasurementcontext.ListMeasurementContext.t) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.multi_read [independant_variables; dependant_variables; unit] (fun () ->
      let ptr = Capi_bindings.interpretationcontext_create independant_variables#raw dependant_variables#raw unit#raw in
      Error_handling.raise_if_error ();
      new c_interpretationcontext ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontext_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontext_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let independentVariables (handle : t) : Axesmeasurementcontext.AxesMeasurementContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_independent_variables handle#raw in
      Error_handling.raise_if_error ();
      new Axesmeasurementcontext.c_axesmeasurementcontext result
    )

  let dependentVariables (handle : t) : Listmeasurementcontext.ListMeasurementContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_dependent_variables handle#raw in
      Error_handling.raise_if_error ();
      new Listmeasurementcontext.c_listmeasurementcontext result
    )

  let unit (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_unit handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let dimension (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_dimension handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let addDependentVariable (handle : t) (variable : Measurementcontext.MeasurementContext.t) : unit =
    Error_handling.multi_read [handle; variable] (fun () ->
      let result = Capi_bindings.interpretationcontext_add_dependent_variable handle#raw variable#raw in
      Error_handling.raise_if_error ();
      result
    )

  let replaceDependentVariable (handle : t) (index : int) (variable : Measurementcontext.MeasurementContext.t) : unit =
    Error_handling.multi_read [handle; variable] (fun () ->
      let result = Capi_bindings.interpretationcontext_replace_dependent_variable handle#raw index variable#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getIndependentVariables (handle : t) (index : int) : Measurementcontext.MeasurementContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_get_independent_variables handle#raw index in
      Error_handling.raise_if_error ();
      new Measurementcontext.c_measurementcontext result
    )

  let withUnit (handle : t) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.multi_read [handle; unit] (fun () ->
      let result = Capi_bindings.interpretationcontext_with_unit handle#raw unit#raw in
      Error_handling.raise_if_error ();
      new c_interpretationcontext result
    )

end