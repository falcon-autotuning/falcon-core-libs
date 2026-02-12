open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_farraydouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.farraydouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module FArrayDouble = struct
  type t = c_farraydouble

  let empty (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farraydouble_create_empty (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farraydouble ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.farraydouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble ptr
    )

  let zeros (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farraydouble_create_zeros (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farraydouble ptr

  let fromShape (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farraydouble_from_shape (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farraydouble ptr

  let fromData (data : float) (shape : int) (ndim : int) : t =
    let ptr = Capi_bindings.farraydouble_from_data data (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) in
    Error_handling.raise_if_error ();
    new c_farraydouble ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.farraydouble_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_farraydouble ptr

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let dimension (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_dimension handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      Error_handling.raise_if_error ();
      result
    )

  let data (handle : t) (out_buffer : float) (numdata : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_plus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_plus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_plus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let plusFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_plus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let plusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_plus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let plusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_plus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let minusEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_minus_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_minus_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_minus_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let minusFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_minus_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let minusDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_minus_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let minusInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_minus_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let negation (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_negation handle#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let timesEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_times_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let timesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_times_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_times_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let timesFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_times_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let timesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_times_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let timesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_times_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let dividesEqualsFarray (handle : t) (other : t) : unit =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_divides_equals_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let dividesEqualsDouble (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_divides_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesEqualsInt (handle : t) (other : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_divides_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let dividesFarray (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_divides_farray handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let dividesDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_divides_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let dividesInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_divides_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let pow (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_pow handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let doublePow (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_double_pow handle#raw other in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let powInplace (handle : t) (other : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_pow_inplace handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let abs (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_abs handle#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let min (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_min handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let minArraywise (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_min_arraywise handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let max (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_max handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let maxArraywise (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_max_arraywise handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let greaterThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_greater_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let lessThan (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_less_than handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let removeOffset (handle : t) (offset : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_remove_offset handle#raw offset in
      Error_handling.raise_if_error ();
      result
    )

  let sum (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_sum handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let reshape (handle : t) (shape : int) (ndims : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_reshape handle#raw (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndims) in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let where (handle : t) (value : float) : Listlistsizet.ListListSizeT.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_where handle#raw value in
      Error_handling.raise_if_error ();
      new Listlistsizet.c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_flip handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let fullGradient (handle : t) (out_buffer : t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.farraydouble_full_gradient handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let gradient (handle : t) (axis : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_gradient handle#raw (Unsigned.Size_t.of_int axis) in
      Error_handling.raise_if_error ();
      new c_farraydouble result
    )

  let getSumOfSquares (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_get_sum_of_squares handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffIntOfSquares (handle : t) (other : int) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_get_summed_diff_int_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffDoubleOfSquares (handle : t) (other : float) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_get_summed_diff_double_of_squares handle#raw other in
      Error_handling.raise_if_error ();
      result
    )

  let getSummedDiffArrayOfSquares (handle : t) (other : t) : float =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.farraydouble_get_summed_diff_array_of_squares handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.farraydouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end