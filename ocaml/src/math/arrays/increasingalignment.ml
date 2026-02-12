open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_increasingalignment (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.increasingalignment_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module IncreasingAlignment = struct
  type t = c_increasingalignment

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.increasingalignment_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_increasingalignment ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.increasingalignment_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_increasingalignment ptr

  let empty () : t =
    let ptr = Capi_bindings.increasingalignment_create_empty () in
    Error_handling.raise_if_error ();
    new c_increasingalignment ptr

  let make (alignment : bool) : t =
    let ptr = Capi_bindings.increasingalignment_create alignment in
    Error_handling.raise_if_error ();
    new c_increasingalignment ptr

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.increasingalignment_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.increasingalignment_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.increasingalignment_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let alignment (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.increasingalignment_alignment handle#raw in
      Error_handling.raise_if_error ();
      result
    )

end