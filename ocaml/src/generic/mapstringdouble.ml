open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapstringdouble_t = object
  method raw : unit ptr
end
class c_mapstringdouble (h : unit ptr) : c_mapstringdouble_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapstringdouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapStringDouble = struct
  type t = c_mapstringdouble

  let empty  : t =
    let ptr = Capi_bindings.mapstringdouble_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapstringdouble ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapstringdouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapstringdouble ptr
    )

  let make (data : Pairstringdouble.PairStringDouble.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapstringdouble_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapstringdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapstringdouble_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapstringdouble ptr

  let insertOrAssign (handle : t) (key : string) (value : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_insert_or_assign handle#raw (Falcon_string.of_string key) value in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : string) (value : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_insert handle#raw (Falcon_string.of_string key) value in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : string) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_at handle#raw (Falcon_string.of_string key) in
      Error_handling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : string) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_erase handle#raw (Falcon_string.of_string key) in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : string) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_contains handle#raw (Falcon_string.of_string key) in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_keys handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let values (handle : t) : Listdouble.ListDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_values handle#raw in
      Error_handling.raise_if_error ();
      new Listdouble.c_listdouble result
    )

  let items (handle : t) : Listpairstringdouble.ListPairStringDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairstringdouble.c_listpairstringdouble result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringdouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringdouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end