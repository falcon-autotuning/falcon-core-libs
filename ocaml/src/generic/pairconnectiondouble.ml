open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairconnectiondouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairconnectiondouble_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairConnectionDouble = struct
  type t = c_pairconnectiondouble

  let make (first : Connection.t) (second : float) : t =
    ErrorHandling.read first (fun () ->
      let ptr = Capi_bindings.pairconnectiondouble_create first#raw second in
      ErrorHandling.raise_if_error ();
      new c_pairconnectiondouble ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairconnectiondouble_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairconnectiondouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairconnectiondouble_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairconnectiondouble ptr

  let first (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectiondouble_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let second (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectiondouble_second handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectiondouble_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectiondouble_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectiondouble_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end