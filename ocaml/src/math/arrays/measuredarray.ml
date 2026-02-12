open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_measuredarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.measuredarray_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MeasuredArray = struct
  type t = c_measuredarray

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.measuredarray_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.measuredarray_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_measuredarray ptr

  let fromData (data : float) (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.measuredarray_from_data data (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    ErrorHandling.raise_if_error ();
    new c_measuredarray ptr

  let fromFarray (farray : Farraydouble.t) : t =
    ErrorHandling.read farray (fun () ->
      let ptr = Capi_bindings.measuredarray_from_farray farray#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let dimension (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_dimension handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      ErrorHandling.raise_if_error ();
      result
    )

  let data (handle : t) (out_buffer : float) (numdata : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusEqualsFarray (handle : t) (other : Farraydouble.t) : unit =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_plus_equals_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_plus_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_plus_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_plus_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let plusFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_plus_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let plusDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_plus_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let plusInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_plus_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let minusEqualsFarray (handle : t) (other : Farraydouble.t) : unit =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_minus_equals_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let minusEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_minus_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let minusEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_minus_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let minusMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_minus_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let minusFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_minus_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let minusDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_minus_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let minusInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_minus_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let negation (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_negation handle#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let timesEqualsMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_times_equals_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let timesEqualsFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_times_equals_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let timesEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_times_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let timesEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_times_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let timesMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_times_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let timesFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_times_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let timesDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_times_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let timesInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_times_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let dividesEqualsMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_divides_equals_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let dividesEqualsFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_divides_equals_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let dividesEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_divides_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let dividesEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_divides_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let dividesMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_divides_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let dividesFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_divides_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let dividesDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_divides_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let dividesInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_divides_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let pow (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_pow handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let abs (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_abs handle#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let min (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_min handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let minFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_min_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let minMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_min_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let max (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_max handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let maxFarray (handle : t) (other : Farraydouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_max_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let maxMeasuredArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_max_measured_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let greaterThan (handle : t) (value : float) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_greater_than handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let lessThan (handle : t) (value : float) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_less_than handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let removeOffset (handle : t) (offset : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_remove_offset handle#raw offset in
      ErrorHandling.raise_if_error ();
      result
    )

  let sum (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_sum handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let reshape (handle : t) (shape : int) (ndims : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_reshape handle#raw (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndims) in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let where (handle : t) (value : float) : Listlistsizet.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_where handle#raw value in
      ErrorHandling.raise_if_error ();
      new c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_flip handle#raw (Unsigned.Size_t.of_int axis) in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let fullGradient (handle : t) (out_buffer : t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.measuredarray_full_gradient handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let gradient (handle : t) (axis : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_gradient handle#raw (Unsigned.Size_t.of_int axis) in
      ErrorHandling.raise_if_error ();
      new c_measuredarray result
    )

  let getSumOfSquares (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_get_sum_of_squares handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getSummedDiffIntOfSquares (handle : t) (other : int) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_get_summed_diff_int_of_squares handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let getSummedDiffDoubleOfSquares (handle : t) (other : float) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measuredarray_get_summed_diff_double_of_squares handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let getSummedDiffArrayOfSquares (handle : t) (other : t) : float =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray_get_summed_diff_array_of_squares handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end