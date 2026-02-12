open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_ports (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.ports_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Ports = struct
  type t = c_ports

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.ports_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_ports ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.ports_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_ports ptr

  let empty () : t =
    let ptr = Capi_bindings.ports_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_ports ptr

  let make (items : Listinstrumentport.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.ports_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_ports ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.ports_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.ports_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let ports (handle : t) : Listinstrumentport.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_ports handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listinstrumentport result
    )

  let defaultNames (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_default_names handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let getPsuedoNames (handle : t) : Listconnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_get_psuedo_names handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let _getRawNames (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports__get_raw_names handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let _getInstrumentFacingNames (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports__get_instrument_facing_names handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let _getPsuedonameMatchingPort (handle : t) (name : Connection.t) : Instrumentport.t =
    ErrorHandling.multi_read [handle; name] (fun () ->
      let result = Capi_bindings.ports__get_psuedoname_matching_port handle#raw name#raw in
      ErrorHandling.raise_if_error ();
      new c_instrumentport result
    )

  let _getInstrumentTypeMatchingPort (handle : t) (insttype : string) : Instrumentport.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports__get_instrument_type_matching_port handle#raw (Capi_bindings.string_wrap insttype) in
      ErrorHandling.raise_if_error ();
      new c_instrumentport result
    )

  let isKnobs (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_is_knobs handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isMeters (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_is_meters handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.ports_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_ports result
    )

  let pushBack (handle : t) (value : Instrumentport.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.ports_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Instrumentport.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_instrumentport result
    )

  let items (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.ports_items handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let contains (handle : t) (value : Instrumentport.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.ports_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Instrumentport.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.ports_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end