open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_pairfloatfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairfloatfloat_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairFloatFloat = struct
  type t = c_pairfloatfloat

  let make (first : float) (second : float) : t =
    let ptr = Capi_bindings.pairfloatfloat_create first second in
    ErrorHandling.raise_if_error ();
    new c_pairfloatfloat ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairfloatfloat_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairfloatfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairfloatfloat_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairfloatfloat ptr

  let first (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairfloatfloat_first handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let second (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairfloatfloat_second handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairfloatfloat_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairfloatfloat_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairfloatfloat_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end