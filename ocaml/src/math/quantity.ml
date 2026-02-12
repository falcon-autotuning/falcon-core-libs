open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_quantity_t = object
  method raw : unit ptr
end
class c_quantity (h : unit ptr) : c_quantity_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.quantity_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Quantity = struct
  type t = c_quantity

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.quantity_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_quantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.quantity_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_quantity ptr

  let make (value : float) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.read unit (fun () ->
      let ptr = Capi_bindings.quantity_create value unit#raw in
      Error_handling.raise_if_error ();
      new c_quantity ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let value (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_value handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let unit (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_unit handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let convertTo (handle : t) (target_unit : Symbolunit.SymbolUnit.t) : unit =
    Error_handling.multi_read [handle; target_unit] (fun () ->
      let result = Capi_bindings.quantity_convert_to handle#raw target_unit#raw in
      Error_handling.raise_if_error ();
      result
    )

  let multiplyInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let multiplyDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let multiplyQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_multiply_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let multiplyEqualsInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let multiplyEqualsDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let multiplyEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_multiply_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let divideInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let divideDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let divideQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_divide_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let divideEqualsInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let divideEqualsDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let divideEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_divide_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let power (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_power handle#raw other in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let addQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_add_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let addEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_add_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let subtractQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_subtract_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let subtractEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_subtract_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let negate (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_negate handle#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

  let abs (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.quantity_abs handle#raw in
      Error_handling.raise_if_error ();
      new c_quantity result
    )

end