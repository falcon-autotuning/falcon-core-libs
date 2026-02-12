open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_connection (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.connection_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Connection = struct
  type t = c_connection

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.connection_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.connection_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_connection ptr

  let barrierGate (name : string) : t =
    let ptr = Capi_bindings.connection_create_barrier_gate (Capi_bindings.string_wrap name) in
    ErrorHandling.raise_if_error ();
    new c_connection ptr

  let plungerGate (name : string) : t =
    let ptr = Capi_bindings.connection_create_plunger_gate (Capi_bindings.string_wrap name) in
    ErrorHandling.raise_if_error ();
    new c_connection ptr

  let reservoirGate (name : string) : t =
    let ptr = Capi_bindings.connection_create_reservoir_gate (Capi_bindings.string_wrap name) in
    ErrorHandling.raise_if_error ();
    new c_connection ptr

  let screeningGate (name : string) : t =
    let ptr = Capi_bindings.connection_create_screening_gate (Capi_bindings.string_wrap name) in
    ErrorHandling.raise_if_error ();
    new c_connection ptr

  let ohmic (name : string) : t =
    let ptr = Capi_bindings.connection_create_ohmic (Capi_bindings.string_wrap name) in
    ErrorHandling.raise_if_error ();
    new c_connection ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connection_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connection_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_name handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let type_ (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_type handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let isDotGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_is_dot_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isBarrierGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_is_barrier_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isPlungerGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_is_plunger_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isReservoirGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_is_reservoir_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isScreeningGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_is_screening_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isOhmic (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_is_ohmic handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connection_is_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end