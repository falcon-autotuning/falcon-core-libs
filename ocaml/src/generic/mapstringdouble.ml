open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapstringdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapstringdouble_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapStringDouble = struct
  type t = c_mapstringdouble

  let empty () : t =
    let ptr = Capi_bindings.mapstringdouble_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapstringdouble ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapstringdouble_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapstringdouble ptr
    )

  let make (data : Pairstringdouble.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapstringdouble_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapstringdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapstringdouble_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapstringdouble ptr

  let insertOrAssign (handle : t) (key : string) (value : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_insert_or_assign handle#raw (Capi_bindings.string_wrap key) value in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : string) (value : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_insert handle#raw (Capi_bindings.string_wrap key) value in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : string) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_at handle#raw (Capi_bindings.string_wrap key) in
      ErrorHandling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : string) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_erase handle#raw (Capi_bindings.string_wrap key) in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : string) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_contains handle#raw (Capi_bindings.string_wrap key) in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_keys handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let values (handle : t) : Listdouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listdouble result
    )

  let items (handle : t) : Listpairstringdouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairstringdouble result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringdouble_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapstringdouble_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapstringdouble_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end