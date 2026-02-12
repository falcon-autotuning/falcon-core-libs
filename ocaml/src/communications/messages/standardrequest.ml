open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_standardrequest (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.standardrequest_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module StandardRequest = struct
  type t = c_standardrequest

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.standardrequest_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_standardrequest ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.standardrequest_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_standardrequest ptr

  let make (message : string) : t =
    let ptr = Capi_bindings.standardrequest_create (Capi_bindings.string_wrap message) in
    ErrorHandling.raise_if_error ();
    new c_standardrequest ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.standardrequest_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.standardrequest_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.standardrequest_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let message (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.standardrequest_message handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end