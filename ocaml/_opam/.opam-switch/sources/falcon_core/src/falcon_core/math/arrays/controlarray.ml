open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic

class c_controlarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.controlarray_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ControlArray = struct
  type t = c_controlarray

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.controlarray_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.controlarray_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_controlarray ptr

  let fromData (data : float) (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.controlarray_from_data data (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    ErrorHandling.raise_if_error ();
    new c_controlarray ptr

  let fromFarray (farray : FArrayDouble.t) : t =
    ErrorHandling.read farray (fun () ->
      let ptr = Capi_bindings.controlarray_from_farray farray#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let dimension (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_dimension handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      ErrorHandling.raise_if_error ();
      result
    )

  let data (handle : t) (out_buffer : float) (numdata : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusEqualsFarray (handle : t) (other : FArrayDouble.t) : unit =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_plus_equals_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let plusControlArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_plus_control_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let plusFarray (handle : t) (other : FArrayDouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_plus_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let plusDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let plusInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let minusEqualsFarray (handle : t) (other : FArrayDouble.t) : unit =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_minus_equals_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let minusEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let minusEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let minusControlArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_minus_control_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let minusFarray (handle : t) (other : FArrayDouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_minus_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let minusDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let minusInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let negation (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_negation handle#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let timesEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let timesEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let timesDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let timesInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let dividesEqualsDouble (handle : t) (other : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let dividesEqualsInt (handle : t) (other : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let dividesDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let dividesInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let pow (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_pow handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let abs (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_abs handle#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let min (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_min handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let minFarray (handle : t) (other : FArrayDouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_min_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let minControlArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_min_control_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let max (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_max handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let maxFarray (handle : t) (other : FArrayDouble.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_max_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let maxControlArray (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_max_control_array handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let greaterThan (handle : t) (value : float) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_greater_than handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let lessThan (handle : t) (value : float) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_less_than handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let removeOffset (handle : t) (offset : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_remove_offset handle#raw offset in
      ErrorHandling.raise_if_error ();
      result
    )

  let sum (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_sum handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let where (handle : t) (value : float) : ListListSizeT.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_where handle#raw value in
      ErrorHandling.raise_if_error ();
      new c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_flip handle#raw (Unsigned.Size_t.of_int axis) in
      ErrorHandling.raise_if_error ();
      new c_controlarray result
    )

  let fullGradient (handle : t) (out_buffer : FArrayDouble.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.controlarray_full_gradient handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let gradient (handle : t) (axis : int) : FArrayDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_gradient handle#raw (Unsigned.Size_t.of_int axis) in
      ErrorHandling.raise_if_error ();
      new c_farraydouble result
    )

  let getSumOfSquares (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_get_sum_of_squares handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getSummedDiffIntOfSquares (handle : t) (other : int) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_get_summed_diff_int_of_squares handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let getSummedDiffDoubleOfSquares (handle : t) (other : float) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.controlarray_get_summed_diff_double_of_squares handle#raw other in
      ErrorHandling.raise_if_error ();
      result
    )

  let getSummedDiffArrayOfSquares (handle : t) (other : t) : float =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_get_summed_diff_array_of_squares handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end