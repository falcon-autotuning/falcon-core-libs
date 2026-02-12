open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_measuredarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.measuredarray1d_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MeasuredArray1D = struct
  type t = c_measuredarray1d

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.measuredarray1d_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.measuredarray1d_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_measuredarray1d ptr

  let fromData (data : float) (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.measuredarray1d_from_data data (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_measuredarray1d ptr

  let fromFarray (farray : Farraydouble.FArrayDouble.t) : t =
    Error_handling.read farray (fun () ->
      let ptr = Capi_bindings.measuredarray1d_from_farray farray#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let is1d (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_is_1d handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let as1d (handle : t) : Farraydouble.FArrayDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_as_1d handle#raw in
      Error_handling.raise_if_error ();
      new Farraydouble.c_farraydouble result
    )

  let getStart (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_start handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getEnd (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_end handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isDecreasing (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_is_decreasing handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isIncreasing (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_is_increasing handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getDistance (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_distance handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getMean (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_mean handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getStd (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_std handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let reverse (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_reverse handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getClosestIndex (handle : t) (value : float) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_closest_index handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let evenDivisions (handle : t) (divisions : int) : Listfarraydouble.ListFArrayDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_even_divisions handle#raw (Unsigned.Size_t.of_int divisions) in
      Error_handling.raise_if_error ();
      new Listfarraydouble.c_listfarraydouble result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let dimension (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_dimension handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      Error_handling.raise_if_error ();
      result
    )

  let data (handle : t) (out_buffer : float) (numdata : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_plus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_plus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_plus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_plus_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let plusFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_plus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let plusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_plus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let plusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_plus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let minusEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_minus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_minus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_minus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_minus_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let minusFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_minus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let minusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_minus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let minusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_minus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let negation (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_negation handle#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let timesEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_times_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let timesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_times_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_times_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_times_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let timesFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_times_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let timesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_times_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let timesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_times_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let dividesEqualsMeasuredArray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_equals_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let dividesEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let dividesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let dividesFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let dividesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let dividesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_divides_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let pow (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_pow handle#raw other in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let abs (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_abs handle#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let min (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_min handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_min_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let minMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_min_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let max (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_max handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let maxFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_max_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let maxMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_max_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let greaterThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_greater_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let lessThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_less_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let removeOffset (handle : t) (offset : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_remove_offset handle#raw offset in
      Error_handling.raise_if_error ();
      result
    )

  let sum (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_sum handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let reshape (handle : t) (shape : int) (ndims : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_reshape handle#raw (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndims) in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let where (handle : t) (value : float) : Listlistsizet.ListListSizeT.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_where handle#raw value in
      Error_handling.raise_if_error ();
      new Listlistsizet.c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_flip handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let fullGradient (handle : t) (out_buffer : t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.measuredarray1d_full_gradient handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let gradient (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_gradient handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_measuredarray1d result
    )

  let getSumOfSquares (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_sum_of_squares handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffIntOfSquares (handle : t) (other : int) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_summed_diff_int_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffDoubleOfSquares (handle : t) (other : float) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measuredarray1d_get_summed_diff_double_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffArrayOfSquares (handle : t) (other : t) : float =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measuredarray1d_get_summed_diff_array_of_squares handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

end