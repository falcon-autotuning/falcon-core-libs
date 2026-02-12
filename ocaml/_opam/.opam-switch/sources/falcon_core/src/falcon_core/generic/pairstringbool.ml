open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_pairstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairstringbool_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairStringBool = struct
  type t = c_pairstringbool

  let make (first : string) (second : bool) : t =
    let ptr = Capi_bindings.pairstringbool_create (Capi_bindings.string_wrap first) second in
    ErrorHandling.raise_if_error ();
    new c_pairstringbool ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairstringbool_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairstringbool ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairstringbool_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairstringbool ptr

  let first (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairstringbool_first handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let second (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairstringbool_second handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairstringbool_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairstringbool_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairstringbool_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end