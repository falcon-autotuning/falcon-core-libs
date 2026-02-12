open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_time (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.time_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Time = struct
  type t = c_time

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.time_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_time ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.time_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_time ptr

  let now () : t =
    let ptr = Capi_bindings.time_create_now () in
    ErrorHandling.raise_if_error ();
    new c_time ptr

  let at (micro_seconds_since_epoch : int64) : t =
    let ptr = Capi_bindings.time_create_at (Int64.of_int micro_seconds_since_epoch) in
    ErrorHandling.raise_if_error ();
    new c_time ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.time_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.time_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.time_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let microSecondsSinceEpoch (handle : t) : int64 =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.time_micro_seconds_since_epoch handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let time (handle : t) : int64 =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.time_time handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.time_to_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end