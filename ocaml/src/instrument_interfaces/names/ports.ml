open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_ports_t = object
  method raw : unit ptr
end
class c_ports (h : unit ptr) : c_ports_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.ports_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Ports = struct
  type t = c_ports

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.ports_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_ports ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.ports_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_ports ptr

  let empty  : t =
    let ptr = Capi_bindings.ports_create_empty () in
    Error_handling.raise_if_error ();
    new c_ports ptr

  let make (items : Listinstrumentport.ListInstrumentPort.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.ports_create items#raw in
      Error_handling.raise_if_error ();
      new c_ports ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.ports_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.ports_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let ports (handle : t) : Listinstrumentport.ListInstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_ports handle#raw in
      Error_handling.raise_if_error ();
      new Listinstrumentport.c_listinstrumentport result
    )

  let defaultNames (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_default_names handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let getPsuedoNames (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_get_psuedo_names handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let _getRawNames (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports__get_raw_names handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let _getInstrumentFacingNames (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports__get_instrument_facing_names handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let _getPsuedonameMatchingPort (handle : t) (name : Connection.Connection.t) : Instrumentport.InstrumentPort.t =
    Error_handling.multi_read [handle; name] (fun () ->
      let result = Capi_bindings.ports__get_psuedoname_matching_port handle#raw name#raw in
      Error_handling.raise_if_error ();
      new Instrumentport.c_instrumentport result
    )

  let _getInstrumentTypeMatchingPort (handle : t) (insttype : string) : Instrumentport.InstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports__get_instrument_type_matching_port handle#raw (Falcon_string.of_string insttype) in
      Error_handling.raise_if_error ();
      new Instrumentport.c_instrumentport result
    )

  let isKnobs (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_is_knobs handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isMeters (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_is_meters handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.ports_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_ports result
    )

  let pushBack (handle : t) (value : Instrumentport.InstrumentPort.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.ports_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Instrumentport.InstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Instrumentport.c_instrumentport result
    )

  let items (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.ports_items handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let contains (handle : t) (value : Instrumentport.InstrumentPort.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.ports_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Instrumentport.InstrumentPort.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.ports_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

end