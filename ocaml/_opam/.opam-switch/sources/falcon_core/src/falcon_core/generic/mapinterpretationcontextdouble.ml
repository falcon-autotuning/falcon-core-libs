open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic

class c_mapinterpretationcontextdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapinterpretationcontextdouble_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapInterpretationContextDouble = struct
  type t = c_mapinterpretationcontextdouble

  let empty () : t =
    let ptr = Capi_bindings.mapinterpretationcontextdouble_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextdouble ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapinterpretationcontextdouble_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapinterpretationcontextdouble ptr
    )

  let make (data : PairInterpretationContextDouble.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapinterpretationcontextdouble_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapinterpretationcontextdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapinterpretationcontextdouble_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextdouble ptr

  let insertOrAssign (handle : t) (key : InterpretationContext.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_insert_or_assign handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : InterpretationContext.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_insert handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : InterpretationContext.t) : float =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : InterpretationContext.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : InterpretationContext.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : ListInterpretationContext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let values (handle : t) : ListDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listdouble result
    )

  let items (handle : t) : ListPairInterpretationContextDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextdouble result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextdouble_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end