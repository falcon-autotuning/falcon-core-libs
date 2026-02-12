open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapintint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapintint_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapIntInt = struct
  type t = c_mapintint

  let empty () : t =
    let ptr = Capi_bindings.mapintint_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapintint ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapintint_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapintint ptr
    )

  let make (data : Pairintint.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapintint_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapintint ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapintint_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapintint ptr

  let insertOrAssign (handle : t) (key : int) (value : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_insert_or_assign handle#raw key value in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : int) (value : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_insert handle#raw key value in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_at handle#raw key in
      ErrorHandling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_erase handle#raw key in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : int) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_contains handle#raw key in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listint.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listint result
    )

  let values (handle : t) : Listint.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listint result
    )

  let items (handle : t) : Listpairintint.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairintint result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapintint_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapintint_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapintint_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end