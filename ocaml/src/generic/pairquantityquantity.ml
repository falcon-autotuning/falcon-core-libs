open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairquantityquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairquantityquantity_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairQuantityQuantity = struct
  type t = c_pairquantityquantity

  let make (first : Quantity.t) (second : Quantity.t) : t =
    ErrorHandling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairquantityquantity_create first#raw second#raw in
      ErrorHandling.raise_if_error ();
      new c_pairquantityquantity ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairquantityquantity_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairquantityquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairquantityquantity_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairquantityquantity ptr

  let first (handle : t) : Quantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairquantityquantity_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let second (handle : t) : Quantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairquantityquantity_second handle#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairquantityquantity_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairquantityquantity_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairquantityquantity_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end