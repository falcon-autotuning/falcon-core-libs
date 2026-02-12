open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_analyticfunction_t = object
  method raw : unit ptr
end
class c_analyticfunction (h : unit ptr) : c_analyticfunction_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.analyticfunction_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module AnalyticFunction = struct
  type t = c_analyticfunction

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.analyticfunction_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_analyticfunction ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.analyticfunction_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_analyticfunction ptr

  let make (labels : string) (expression : string) : t =
    let ptr = Capi_bindings.analyticfunction_create (Falcon_string.of_string labels) (Falcon_string.of_string expression) in
    Error_handling.raise_if_error ();
    new c_analyticfunction ptr

  let identity  : t =
    let ptr = Capi_bindings.analyticfunction_create_identity () in
    Error_handling.raise_if_error ();
    new c_analyticfunction ptr

  let constant (value : float) : t =
    let ptr = Capi_bindings.analyticfunction_create_constant value in
    Error_handling.raise_if_error ();
    new c_analyticfunction ptr

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.analyticfunction_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.analyticfunction_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.analyticfunction_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let labels (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.analyticfunction_labels handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let evaluate (handle : t) (args : Mapstringdouble.MapStringDouble.t) (time : float) : float =
    Error_handling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.analyticfunction_evaluate handle#raw args#raw time in
      Error_handling.raise_if_error ();
      result
    )

  let evaluateArraywise (handle : t) (args : Mapstringdouble.MapStringDouble.t) (deltaT : float) (maxTime : float) : Farraydouble.FArrayDouble.t =
    Error_handling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.analyticfunction_evaluate_arraywise handle#raw args#raw deltaT maxTime in
      Error_handling.raise_if_error ();
      new Farraydouble.c_farraydouble result
    )

end