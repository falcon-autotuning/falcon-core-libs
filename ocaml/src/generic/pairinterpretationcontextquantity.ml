open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairinterpretationcontextquantity_t = object
  method raw : unit ptr
end
class c_pairinterpretationcontextquantity (h : unit ptr) : c_pairinterpretationcontextquantity_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinterpretationcontextquantity_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairInterpretationContextQuantity = struct
  type t = c_pairinterpretationcontextquantity

  let make (first : Interpretationcontext.InterpretationContext.t) (second : Quantity.Quantity.t) : t =
    Error_handling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextquantity_create first#raw second#raw in
      Error_handling.raise_if_error ();
      new c_pairinterpretationcontextquantity ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextquantity_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairinterpretationcontextquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextquantity_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairinterpretationcontextquantity ptr

  let first (handle : t) : Interpretationcontext.InterpretationContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_first handle#raw in
      Error_handling.raise_if_error ();
      new Interpretationcontext.c_interpretationcontext result
    )

  let second (handle : t) : Quantity.Quantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_second handle#raw in
      Error_handling.raise_if_error ();
      new Quantity.c_quantity result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end