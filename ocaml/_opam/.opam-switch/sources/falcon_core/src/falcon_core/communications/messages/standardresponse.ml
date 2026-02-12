open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_standardresponse (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.standardresponse_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module StandardResponse = struct
  type t = c_standardresponse

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.standardresponse_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_standardresponse ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.standardresponse_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_standardresponse ptr

  let make (message : string) : t =
    let ptr = Capi_bindings.standardresponse_create (Capi_bindings.string_wrap message) in
    ErrorHandling.raise_if_error ();
    new c_standardresponse ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.standardresponse_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.standardresponse_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.standardresponse_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let message (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.standardresponse_message handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end