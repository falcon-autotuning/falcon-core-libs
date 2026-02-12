open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_gname_t = object
  method raw : unit ptr
end
class c_gname (h : unit ptr) : c_gname_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.gname_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Gname = struct
  type t = c_gname

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.gname_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_gname ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.gname_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_gname ptr

  let fromNum (num : int) : t =
    let ptr = Capi_bindings.gname_create_from_num num in
    Error_handling.raise_if_error ();
    new c_gname ptr

  let make (name : string) : t =
    let ptr = Capi_bindings.gname_create (Falcon_string.of_string name) in
    Error_handling.raise_if_error ();
    new c_gname ptr

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gname_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gname_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gname_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let gname (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gname_gname handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end