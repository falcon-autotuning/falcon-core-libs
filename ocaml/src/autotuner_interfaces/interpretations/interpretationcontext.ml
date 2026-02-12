open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_interpretationcontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.interpretationcontext_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module InterpretationContext = struct
  type t = c_interpretationcontext

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.interpretationcontext_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontext ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.interpretationcontext_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_interpretationcontext ptr

  let make (independant_variables : Axesmeasurementcontext.t) (dependant_variables : Listmeasurementcontext.t) (unit : Symbolunit.t) : t =
    ErrorHandling.multi_read [independant_variables; dependant_variables; unit] (fun () ->
      let ptr = Capi_bindings.interpretationcontext_create independant_variables#raw dependant_variables#raw unit#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontext ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontext_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.interpretationcontext_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let independentVariables (handle : t) : Axesmeasurementcontext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_independent_variables handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axesmeasurementcontext result
    )

  let dependentVariables (handle : t) : Listmeasurementcontext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_dependent_variables handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listmeasurementcontext result
    )

  let unit (handle : t) : Symbolunit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_unit handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let dimension (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_dimension handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let addDependentVariable (handle : t) (variable : Measurementcontext.t) : unit =
    ErrorHandling.multi_read [handle; variable] (fun () ->
      let result = Capi_bindings.interpretationcontext_add_dependent_variable handle#raw variable#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let replaceDependentVariable (handle : t) (index : int) (variable : Measurementcontext.t) : unit =
    ErrorHandling.multi_read [handle; variable] (fun () ->
      let result = Capi_bindings.interpretationcontext_replace_dependent_variable handle#raw index variable#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getIndependentVariables (handle : t) (index : int) : Measurementcontext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.interpretationcontext_get_independent_variables handle#raw index in
      ErrorHandling.raise_if_error ();
      new c_measurementcontext result
    )

  let withUnit (handle : t) (unit : Symbolunit.t) : t =
    ErrorHandling.multi_read [handle; unit] (fun () ->
      let result = Capi_bindings.interpretationcontext_with_unit handle#raw unit#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontext result
    )

end