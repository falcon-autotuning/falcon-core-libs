open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_pairintfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairintfloat_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairIntFloat = struct
  type t = c_pairintfloat

  let make (first : int) (second : float) : t =
    let ptr = Capi_bindings.pairintfloat_create first second in
    ErrorHandling.raise_if_error ();
    new c_pairintfloat ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairintfloat_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairintfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairintfloat_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairintfloat ptr

  let first (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairintfloat_first handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let second (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairintfloat_second handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairintfloat_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairintfloat_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairintfloat_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end