open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairdoubledouble_t = object
  method raw : unit ptr
end
class c_pairdoubledouble (h : unit ptr) : c_pairdoubledouble_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairdoubledouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairDoubleDouble = struct
  type t = c_pairdoubledouble

  let make (first : float) (second : float) : t =
    let ptr = Capi_bindings.pairdoubledouble_create first second in
    Error_handling.raise_if_error ();
    new c_pairdoubledouble ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairdoubledouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairdoubledouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairdoubledouble_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairdoubledouble ptr

  let first (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairdoubledouble_first handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let second (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairdoubledouble_second handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairdoubledouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairdoubledouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairdoubledouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end