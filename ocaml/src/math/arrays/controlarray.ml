open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_controlarray_t = object
  method raw : unit ptr
end
class c_controlarray (h : unit ptr) : c_controlarray_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.controlarray_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ControlArray = struct
  type t = c_controlarray

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.controlarray_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_controlarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.controlarray_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_controlarray ptr

  let fromData (data : float) (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.controlarray_from_data data (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_controlarray ptr

  let fromFarray (farray : Farraydouble.FArrayDouble.t) : t =
    Error_handling.read farray (fun () ->
      let ptr = Capi_bindings.controlarray_from_farray farray#raw in
      Error_handling.raise_if_error ();
      new c_controlarray ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let dimension (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_dimension handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let data (handle : t) (out_buffer : float) (numdata : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let plusEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_plus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusControlArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_plus_control_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let plusFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_plus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let plusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let plusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_plus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let minusEqualsFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_minus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusControlArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_minus_control_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let minusFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_minus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let minusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let minusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_minus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let negation (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_negation handle#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let timesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let timesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_times_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let dividesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let dividesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_divides_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let pow (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_pow handle#raw other in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let abs (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_abs handle#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let min (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_min handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_min_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let minControlArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_min_control_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let max (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_max handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let maxFarray (handle : t) (other : Farraydouble.FArrayDouble.t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_max_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let maxControlArray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_max_control_array handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let greaterThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_greater_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let lessThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_less_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let removeOffset (handle : t) (offset : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_remove_offset handle#raw offset in
      Error_handling.raise_if_error ();
      result
    )

  let sum (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_sum handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let where (handle : t) (value : float) : Listlistsizet.ListListSizeT.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_where handle#raw value in
      Error_handling.raise_if_error ();
      new Listlistsizet.c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_flip handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_controlarray result
    )

  let fullGradient (handle : t) (out_buffer : Farraydouble.FArrayDouble.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.controlarray_full_gradient handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let gradient (handle : t) (axis : int) : Farraydouble.FArrayDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_gradient handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new Farraydouble.c_farraydouble result
    )

  let getSumOfSquares (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_get_sum_of_squares handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffIntOfSquares (handle : t) (other : int) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_get_summed_diff_int_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffDoubleOfSquares (handle : t) (other : float) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.controlarray_get_summed_diff_double_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffArrayOfSquares (handle : t) (other : t) : float =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.controlarray_get_summed_diff_array_of_squares handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

end