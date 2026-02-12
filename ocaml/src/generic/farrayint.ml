open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_farrayint_t = object
  method raw : unit ptr
end
class c_farrayint (h : unit ptr) : c_farrayint_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.farrayint_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module FArrayInt = struct
  type t = c_farrayint

  let empty (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farrayint_create_empty (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farrayint ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.farrayint_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_farrayint ptr
    )

  let zeros (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farrayint_create_zeros (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farrayint ptr

  let fromShape (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farrayint_from_shape (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farrayint ptr

  let fromData (data : int) (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farrayint_from_data data (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farrayint ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.farrayint_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_farrayint ptr

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let dimension (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_dimension handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let data (handle : t) (out_buffer : int) (numdata : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let plusEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_plus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_plus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_plus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_plus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let plusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_plus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let plusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_plus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let minusEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_minus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_minus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_minus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_minus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let minusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_minus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let minusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_minus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let negation (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_negation handle#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let timesEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_times_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let timesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_times_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_times_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_times_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let timesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_times_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let timesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_times_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let dividesEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_divides_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let dividesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_divides_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_divides_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_divides_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let dividesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_divides_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let dividesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_divides_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let pow (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_pow handle#raw other in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let doublePow (handle : t) (other : float) : Farraydouble.FArrayDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_double_pow handle#raw other in
      Error_handling.raise_if_error ();
      new Farraydouble.c_farraydouble result
    )

  let powInplace (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_pow_inplace handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let abs (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_abs handle#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let min (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_min handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minArraywise (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_min_arraywise handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let max (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_max handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let maxArraywise (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_max_arraywise handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let greaterThan (handle : t) (value : int) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_greater_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let lessThan (handle : t) (value : int) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_less_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let removeOffset (handle : t) (offset : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_remove_offset handle#raw offset in
      Error_handling.raise_if_error ();
      result
    )

  let sum (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_sum handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let reshape (handle : t) (shape : int) (ndims : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_reshape handle#raw (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndims) in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let where (handle : t) (value : int) : Listlistsizet.ListListSizeT.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_where handle#raw value in
      Error_handling.raise_if_error ();
      new Listlistsizet.c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_flip handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let fullGradient (handle : t) (out_buffer : t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.farrayint_full_gradient handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let gradient (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_gradient handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_farrayint result
    )

  let getSumOfSquares (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_get_sum_of_squares handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffIntOfSquares (handle : t) (other : int) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_get_summed_diff_int_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffDoubleOfSquares (handle : t) (other : float) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_get_summed_diff_double_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffArrayOfSquares (handle : t) (other : t) : float =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farrayint_get_summed_diff_array_of_squares handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farrayint_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end