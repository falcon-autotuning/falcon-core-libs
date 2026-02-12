open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairconnectionfloat_t = object
  method raw : unit ptr
end
class c_pairconnectionfloat (h : unit ptr) : c_pairconnectionfloat_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairconnectionfloat_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairConnectionFloat = struct
  type t = c_pairconnectionfloat

  let make (first : Connection.Connection.t) (second : float) : t =
    Error_handling.read first (fun () ->
      let ptr = Capi_bindings.pairconnectionfloat_create first#raw second in
      Error_handling.raise_if_error ();
      new c_pairconnectionfloat ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairconnectionfloat_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairconnectionfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairconnectionfloat_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairconnectionfloat ptr

  let first (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionfloat_first handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let second (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionfloat_second handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionfloat_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionfloat_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionfloat_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end