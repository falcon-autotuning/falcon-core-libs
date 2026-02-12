open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairstringstring_t = object
  method raw : unit ptr
end
class c_pairstringstring (h : unit ptr) : c_pairstringstring_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairstringstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairStringString = struct
  type t = c_pairstringstring

  let make (first : string) (second : string) : t =
    let ptr = Capi_bindings.pairstringstring_create (Falcon_string.of_string first) (Falcon_string.of_string second) in
    Error_handling.raise_if_error ();
    new c_pairstringstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.pairstringstring_copy (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new c_pairstringstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairstringstring_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairstringstring ptr

  let first (handle : string) : string =
    let result = Capi_bindings.pairstringstring_first (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let second (handle : string) : string =
    let result = Capi_bindings.pairstringstring_second (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairstringstring_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairstringstring_not_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.pairstringstring_to_json_string (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end