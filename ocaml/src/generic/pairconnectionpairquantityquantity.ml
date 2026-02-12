open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairconnectionpairquantityquantity_t = object
  method raw : unit ptr
end
class c_pairconnectionpairquantityquantity (h : unit ptr) : c_pairconnectionpairquantityquantity_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairconnectionpairquantityquantity_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairConnectionPairQuantityQuantity = struct
  type t = c_pairconnectionpairquantityquantity

  let make (first : Connection.Connection.t) (second : Pairquantityquantity.PairQuantityQuantity.t) : t =
    Error_handling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairconnectionpairquantityquantity_create first#raw second#raw in
      Error_handling.raise_if_error ();
      new c_pairconnectionpairquantityquantity ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairconnectionpairquantityquantity_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairconnectionpairquantityquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairconnectionpairquantityquantity_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairconnectionpairquantityquantity ptr

  let first (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionpairquantityquantity_first handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let second (handle : t) : Pairquantityquantity.PairQuantityQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionpairquantityquantity_second handle#raw in
      Error_handling.raise_if_error ();
      new Pairquantityquantity.c_pairquantityquantity result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionpairquantityquantity_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionpairquantityquantity_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionpairquantityquantity_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end