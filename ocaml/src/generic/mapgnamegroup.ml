open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapgnamegroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapgnamegroup_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapGnameGroup = struct
  type t = c_mapgnamegroup

  let empty () : t =
    let ptr = Capi_bindings.mapgnamegroup_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapgnamegroup ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapgnamegroup_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapgnamegroup ptr
    )

  let make (data : Pairgnamegroup.PairGnameGroup.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapgnamegroup_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapgnamegroup ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapgnamegroup_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_mapgnamegroup ptr

  let insertOrAssign (handle : t) (key : Gname.Gname.t) (value : Group.Group.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapgnamegroup_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Gname.Gname.t) (value : Group.Group.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapgnamegroup_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Gname.Gname.t) : Group.Group.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapgnamegroup_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Group.c_group result
    )

  let erase (handle : t) (key : Gname.Gname.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapgnamegroup_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Gname.Gname.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapgnamegroup_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listgname.ListGname.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listgname.c_listgname result
    )

  let values (handle : t) : Listgroup.ListGroup.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_values handle#raw in
      Error_handling.raise_if_error ();
      new Listgroup.c_listgroup result
    )

  let items (handle : t) : Listpairgnamegroup.ListPairGnameGroup.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairgnamegroup.c_listpairgnamegroup result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapgnamegroup_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapgnamegroup_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapgnamegroup_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end