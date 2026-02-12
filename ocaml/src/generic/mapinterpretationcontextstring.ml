open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapinterpretationcontextstring_t = object
  method raw : unit ptr
end
class c_mapinterpretationcontextstring (h : unit ptr) : c_mapinterpretationcontextstring_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapinterpretationcontextstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapInterpretationContextString = struct
  type t = c_mapinterpretationcontextstring

  let empty  : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_copy (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let make (data : string) (count : int) : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_create (Falcon_string.of_string data) (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let insertOrAssign (handle : string) (key : Interpretationcontext.InterpretationContext.t) (value : string) : unit =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_insert_or_assign (Falcon_string.of_string handle) key#raw (Falcon_string.of_string value) in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : string) (key : Interpretationcontext.InterpretationContext.t) (value : string) : unit =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_insert (Falcon_string.of_string handle) key#raw (Falcon_string.of_string value) in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : string) (key : Interpretationcontext.InterpretationContext.t) : string =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_at (Falcon_string.of_string handle) key#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let erase (handle : string) (key : Interpretationcontext.InterpretationContext.t) : unit =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_erase (Falcon_string.of_string handle) key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : string) : int =
    let result = Capi_bindings.mapinterpretationcontextstring_size (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let empty (handle : string) : bool =
    let result = Capi_bindings.mapinterpretationcontextstring_empty (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.mapinterpretationcontextstring_clear (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let contains (handle : string) (key : Interpretationcontext.InterpretationContext.t) : bool =
    Error_handling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_contains (Falcon_string.of_string handle) key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : string) : Listinterpretationcontext.ListInterpretationContext.t =
    let result = Capi_bindings.mapinterpretationcontextstring_keys (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new Listinterpretationcontext.c_listinterpretationcontext result

  let values (handle : string) : string =
    let result = Capi_bindings.mapinterpretationcontextstring_values (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) : string =
    let result = Capi_bindings.mapinterpretationcontextstring_items (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapinterpretationcontextstring_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapinterpretationcontextstring_not_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.mapinterpretationcontextstring_to_json_string (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end