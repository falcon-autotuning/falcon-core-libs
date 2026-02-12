open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic

class c_mapstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapstringbool_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapStringBool = struct
  type t = c_mapstringbool

  let empty () : t =
    let ptr = Capi_bindings.mapstringbool_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapstringbool ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapstringbool_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapstringbool ptr
    )

  let make (data : PairStringBool.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapstringbool_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapstringbool ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapstringbool_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapstringbool ptr

  let insertOrAssign (handle : t) (key : string) (value : bool) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_insert_or_assign handle#raw (Capi_bindings.string_wrap key) value in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : string) (value : bool) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_insert handle#raw (Capi_bindings.string_wrap key) value in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : string) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_at handle#raw (Capi_bindings.string_wrap key) in
      ErrorHandling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : string) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_erase handle#raw (Capi_bindings.string_wrap key) in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : string) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_contains handle#raw (Capi_bindings.string_wrap key) in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_keys handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let values (handle : t) : ListBool.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listbool result
    )

  let items (handle : t) : ListPairStringBool.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairstringbool result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringbool_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringbool_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringbool_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end