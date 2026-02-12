open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapgnamegroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapgnamegroup_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapGnameGroup = struct
  type t = c_mapgnamegroup

  let empty () : t =
    let ptr = Capi_bindings.mapgnamegroup_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapgnamegroup ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapgnamegroup_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapgnamegroup ptr
    )

  let make (data : Pairgnamegroup.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapgnamegroup_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapgnamegroup ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapgnamegroup_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapgnamegroup ptr

  let insertOrAssign (handle : t) (key : Gname.t) (value : Group.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapgnamegroup_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Gname.t) (value : Group.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapgnamegroup_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Gname.t) : Group.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapgnamegroup_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_group result
    )

  let erase (handle : t) (key : Gname.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapgnamegroup_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Gname.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapgnamegroup_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listgname.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listgname result
    )

  let values (handle : t) : Listgroup.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listgroup result
    )

  let items (handle : t) : Listpairgnamegroup.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairgnamegroup result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapgnamegroup_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapgnamegroup_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end