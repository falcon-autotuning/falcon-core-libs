open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_devicevoltagestates (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.devicevoltagestates_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module DeviceVoltageStates = struct
  type t = c_devicevoltagestates

  let empty () : t =
    let ptr = Capi_bindings.devicevoltagestates_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_devicevoltagestates ptr

  let make (items : Listdevicevoltagestate.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.devicevoltagestates_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestates ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.devicevoltagestates_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_devicevoltagestates ptr

  let states (handle : t) : Listdevicevoltagestate.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_states handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listdevicevoltagestate result
    )

  let addState (handle : t) (state : Devicevoltagestate.t) : unit =
    ErrorHandling.multi_read [handle; state] (fun () ->
      let result = Capi_bindings.devicevoltagestates_add_state handle#raw state#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let findState (handle : t) (connection : Connection.t) : t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.devicevoltagestates_find_state handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestates result
    )

  let toPoint (handle : t) : Point.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_to_point handle#raw in
      ErrorHandling.raise_if_error ();
      new c_point result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestates_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestates result
    )

  let pushBack (handle : t) (value : Devicevoltagestate.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.devicevoltagestates_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Devicevoltagestate.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let items (handle : t) : Listdevicevoltagestate.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listdevicevoltagestate result
    )

  let contains (handle : t) (value : Devicevoltagestate.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.devicevoltagestates_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Devicevoltagestate.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.devicevoltagestates_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (a : t) (b : t) : bool =
    ErrorHandling.multi_read [a; b] (fun () ->
      let result = Capi_bindings.devicevoltagestates_equal a#raw b#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (a : t) (b : t) : bool =
    ErrorHandling.multi_read [a; b] (fun () ->
      let result = Capi_bindings.devicevoltagestates_not_equal a#raw b#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestates_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end