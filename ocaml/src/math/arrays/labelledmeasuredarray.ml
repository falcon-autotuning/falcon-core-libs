open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_labelledmeasuredarray_t = object
  method raw : unit ptr
end
class c_labelledmeasuredarray (h : unit ptr) : c_labelledmeasuredarray_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.labelledmeasuredarray_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module LabelledMeasuredArray = struct
  type t = c_labelledmeasuredarray

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.labelledmeasuredarray_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.labelledmeasuredarray_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_labelledmeasuredarray ptr

  let fromFarray (farray : Farraydouble.FArrayDouble.t) (label : Acquisitioncontext.AcquisitionContext.t) : t =
    Error_handling.multi_read [farray; label] (fun () ->
      let ptr = Capi_bindings.labelledmeasuredarray_from_farray farray#raw label#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray ptr
    )

  let fromMeasuredArray (measuredarray : Measuredarray.MeasuredArray.t) (label : Acquisitioncontext.AcquisitionContext.t) : t =
    Error_handling.multi_read [measuredarray; label] (fun () ->
      let ptr = Capi_bindings.labelledmeasuredarray_from_measured_array measuredarray#raw label#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let label (handle : t) : Acquisitioncontext.AcquisitionContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_label handle#raw in
      Error_handling.raise_if_error ();
      new Acquisitioncontext.c_acquisitioncontext result
    )

  let connection (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_connection handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let instrumentType (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_instrument_type handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let units (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_units handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let dimension (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_dimension handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let data (handle : t) (out_buffer : float) (numdata : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let plusEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_plus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_plus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_plus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_plus_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let plusFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_plus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let plusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_plus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let plusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_plus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let minusEqualsMeasuredArray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_equals_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusMeasuredArray (handle : t) (other : Measuredarray.MeasuredArray.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let minusFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let minusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let minusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_minus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let negation (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_negation handle#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let timesEqualsMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_equals_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let timesEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let timesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let timesFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let timesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let timesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_times_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let dividesEqualsMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_equals_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let dividesEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let dividesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let dividesFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let dividesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let dividesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_divides_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let pow (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_pow handle#raw other in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let abs (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_abs handle#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let min (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_min handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_min_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let minMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_min_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let max (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_max handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let maxFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_max_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let maxMeasuredArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_max_measured_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let greaterThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_greater_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let lessThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_less_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let removeOffset (handle : t) (offset : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_remove_offset handle#raw offset in
      Error_handling.raise_if_error ();
      result
    )

  let sum (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_sum handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let reshape (handle : t) (shape : int) (ndims : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_reshape handle#raw (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndims) in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let where (handle : t) (value : float) : Listlistsizet.ListListSizeT.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_where handle#raw value in
      Error_handling.raise_if_error ();
      new Listlistsizet.c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_flip handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let fullGradient (handle : t) (out_buffer : t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_full_gradient handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let gradient (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_gradient handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let getSumOfSquares (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_get_sum_of_squares handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffIntOfSquares (handle : t) (other : int) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_get_summed_diff_int_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffDoubleOfSquares (handle : t) (other : float) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_get_summed_diff_double_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffArrayOfSquares (handle : t) (other : t) : float =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledmeasuredarray_get_summed_diff_array_of_squares handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

end