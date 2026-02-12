open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapinterpretationcontextdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapinterpretationcontextdouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapInterpretationContextDouble = struct
  type t = c_mapinterpretationcontextdouble

  let empty () : t =
    let ptr = Capi_bindings.mapinterpretationcontextdouble_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapinterpretationcontextdouble ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapinterpretationcontextdouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapinterpretationcontextdouble ptr
    )

  let make (data : Pairinterpretationcontextdouble.PairInterpretationContextDouble.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapinterpretationcontextdouble_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapinterpretationcontextdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapinterpretationcontextdouble_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_mapinterpretationcontextdouble ptr

  let insertOrAssign (handle : t) (key : Interpretationcontext.InterpretationContext.t) (value : float) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_insert_or_assign handle#raw key#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Interpretationcontext.InterpretationContext.t) (value : float) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_insert handle#raw key#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Interpretationcontext.InterpretationContext.t) : float =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : Interpretationcontext.InterpretationContext.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Interpretationcontext.InterpretationContext.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listinterpretationcontext.ListInterpretationContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listinterpretationcontext.c_listinterpretationcontext result
    )

  let values (handle : t) : Listdouble.ListDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_values handle#raw in
      Error_handling.raise_if_error ();
      new Listdouble.c_listdouble result
    )

  let items (handle : t) : Listpairinterpretationcontextdouble.ListPairInterpretationContextDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairinterpretationcontextdouble.c_listpairinterpretationcontextdouble result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end