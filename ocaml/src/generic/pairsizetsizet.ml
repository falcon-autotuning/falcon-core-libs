open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairsizetsizet (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairsizetsizet_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairSizeTSizeT = struct
  type t = c_pairsizetsizet

  let make (first : int) (second : int) : t =
    let ptr = Capi_bindings.pairsizetsizet_create (Unsigned.Size_t.of_int first) (Unsigned.Size_t.of_int second) in
    Error_handling.raise_if_error ();
    new c_pairsizetsizet ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairsizetsizet_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairsizetsizet ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairsizetsizet_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_pairsizetsizet ptr

  let first (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairsizetsizet_first handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let second (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairsizetsizet_second handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairsizetsizet_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairsizetsizet_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairsizetsizet_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end