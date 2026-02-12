open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Generic

class c_mapinterpretationcontextstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapinterpretationcontextstring_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapInterpretationContextString = struct
  type t = c_mapinterpretationcontextstring

  let empty () : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_copy (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let make (data : string) (count : int) : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_create (Capi_bindings.string_wrap data) (Unsigned.Size_t.of_int count) in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapinterpretationcontextstring_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextstring ptr

  let insertOrAssign (handle : string) (key : InterpretationContext.t) (value : string) : unit =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_insert_or_assign (Capi_bindings.string_wrap handle) key#raw (Capi_bindings.string_wrap value) in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : string) (key : InterpretationContext.t) (value : string) : unit =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_insert (Capi_bindings.string_wrap handle) key#raw (Capi_bindings.string_wrap value) in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : string) (key : InterpretationContext.t) : string =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_at (Capi_bindings.string_wrap handle) key#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let erase (handle : string) (key : InterpretationContext.t) : unit =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_erase (Capi_bindings.string_wrap handle) key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : string) : int =
    let result = Capi_bindings.mapinterpretationcontextstring_size (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let empty (handle : string) : bool =
    let result = Capi_bindings.mapinterpretationcontextstring_empty (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.mapinterpretationcontextstring_clear (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let contains (handle : string) (key : InterpretationContext.t) : bool =
    ErrorHandling.read key (fun () ->
      let result = Capi_bindings.mapinterpretationcontextstring_contains (Capi_bindings.string_wrap handle) key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : string) : ListInterpretationContext.t =
    let result = Capi_bindings.mapinterpretationcontextstring_keys (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_listinterpretationcontext result

  let values (handle : string) : string =
    let result = Capi_bindings.mapinterpretationcontextstring_values (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) : string =
    let result = Capi_bindings.mapinterpretationcontextstring_items (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapinterpretationcontextstring_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapinterpretationcontextstring_not_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.mapinterpretationcontextstring_to_json_string (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end