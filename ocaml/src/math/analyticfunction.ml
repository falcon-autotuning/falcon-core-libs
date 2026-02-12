open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_analyticfunction (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.analyticfunction_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module AnalyticFunction = struct
  type t = c_analyticfunction

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.analyticfunction_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_analyticfunction ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.analyticfunction_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_analyticfunction ptr

  let make (labels : string) (expression : string) : t =
    let ptr = Capi_bindings.analyticfunction_create (Capi_bindings.string_wrap labels) (Capi_bindings.string_wrap expression) in
    ErrorHandling.raise_if_error ();
    new c_analyticfunction ptr

  let identity () : t =
    let ptr = Capi_bindings.analyticfunction_create_identity () in
    ErrorHandling.raise_if_error ();
    new c_analyticfunction ptr

  let constant (value : float) : t =
    let ptr = Capi_bindings.analyticfunction_create_constant value in
    ErrorHandling.raise_if_error ();
    new c_analyticfunction ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.analyticfunction_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.analyticfunction_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.analyticfunction_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let labels (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.analyticfunction_labels handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let evaluate (handle : t) (args : Mapstringdouble.t) (time : float) : float =
    ErrorHandling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.analyticfunction_evaluate handle#raw args#raw time in
      ErrorHandling.raise_if_error ();
      result
    )

  let evaluateArraywise (handle : t) (args : Mapstringdouble.t) (deltaT : float) (maxTime : float) : Farraydouble.t =
    ErrorHandling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.analyticfunction_evaluate_arraywise handle#raw args#raw deltaT maxTime in
      ErrorHandling.raise_if_error ();
      new c_farraydouble result
    )

end