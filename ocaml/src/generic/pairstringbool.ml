open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairstringbool_t = object
  method raw : unit ptr
end
class c_pairstringbool (h : unit ptr) : c_pairstringbool_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairstringbool_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairStringBool = struct
  type t = c_pairstringbool

  let make (first : string) (second : bool) : t =
    let ptr = Capi_bindings.pairstringbool_create (Falcon_string.of_string first) second in
    Error_handling.raise_if_error ();
    new c_pairstringbool ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairstringbool_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairstringbool ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairstringbool_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairstringbool ptr

  let first (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairstringbool_first handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let second (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairstringbool_second handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairstringbool_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairstringbool_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairstringbool_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end