open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_quantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.quantity_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Quantity = struct
  type t = c_quantity

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.quantity_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.quantity_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_quantity ptr

  let make (value : float) (unit : Symbolunit.t) : t =
    ErrorHandling.read unit (fun () ->
      let ptr = Capi_bindings.quantity_create value unit#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let value (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_value handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let unit (handle : t) : Symbolunit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_unit handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let convertTo (handle : t) (target_unit : Symbolunit.t) : unit =
    ErrorHandling.multi_read [handle; target_unit] (fun () ->
      let result = Capi_bindings.quantity_convert_to handle#raw target_unit#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let multiplyInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let multiplyDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let multiplyQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_multiply_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let multiplyEqualsInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let multiplyEqualsDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_multiply_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let multiplyEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_multiply_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let divideInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let divideDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let divideQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_divide_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let divideEqualsInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let divideEqualsDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_divide_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let divideEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_divide_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let power (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_power handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let addQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_add_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let addEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_add_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let subtractQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_subtract_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let subtractEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.quantity_subtract_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let negate (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_negate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let abs (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.quantity_abs handle#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

end