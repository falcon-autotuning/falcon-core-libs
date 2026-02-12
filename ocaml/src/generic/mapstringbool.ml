open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapstringbool_t = object
  method raw : unit ptr
end
class c_mapstringbool (h : unit ptr) : c_mapstringbool_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapstringbool_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapStringBool = struct
  type t = c_mapstringbool

  let empty  : t =
    let ptr = Capi_bindings.mapstringbool_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapstringbool ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapstringbool_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapstringbool ptr
    )

  let make (data : Pairstringbool.PairStringBool.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapstringbool_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapstringbool ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapstringbool_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapstringbool ptr

  let insertOrAssign (handle : t) (key : string) (value : bool) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_insert_or_assign handle#raw (Falcon_string.of_string key) value in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : string) (value : bool) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_insert handle#raw (Falcon_string.of_string key) value in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : string) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_at handle#raw (Falcon_string.of_string key) in
      Error_handling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : string) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_erase handle#raw (Falcon_string.of_string key) in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : string) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_contains handle#raw (Falcon_string.of_string key) in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_keys handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let values (handle : t) : Listbool.ListBool.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_values handle#raw in
      Error_handling.raise_if_error ();
      new Listbool.c_listbool result
    )

  let items (handle : t) : Listpairstringbool.ListPairStringBool.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairstringbool.c_listpairstringbool result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringbool_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringbool_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end