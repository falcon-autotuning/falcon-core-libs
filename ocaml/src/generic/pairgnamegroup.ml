open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairgnamegroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairgnamegroup_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairGnameGroup = struct
  type t = c_pairgnamegroup

  let make (first : Gname.Gname.t) (second : Group.Group.t) : t =
    Error_handling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairgnamegroup_create first#raw second#raw in
      Error_handling.raise_if_error ();
      new c_pairgnamegroup ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairgnamegroup_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairgnamegroup ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairgnamegroup_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_pairgnamegroup ptr

  let first (handle : t) : Gname.Gname.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairgnamegroup_first handle#raw in
      Error_handling.raise_if_error ();
      new Gname.c_gname result
    )

  let second (handle : t) : Group.Group.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairgnamegroup_second handle#raw in
      Error_handling.raise_if_error ();
      new Group.c_group result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairgnamegroup_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairgnamegroup_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairgnamegroup_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end