open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_pairintint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairintint_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairIntInt = struct
  type t = c_pairintint

  let make (first : int) (second : int) : t =
    let ptr = Capi_bindings.pairintint_create first second in
    ErrorHandling.raise_if_error ();
    new c_pairintint ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairintint_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairintint ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairintint_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairintint ptr

  let first (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairintint_first handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let second (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairintint_second handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairintint_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairintint_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairintint_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end