open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Physics.Device_structures

class c_rightreservoirwithimplantedohmic (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.rightreservoirwithimplantedohmic_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module RightReservoirWithImplantedOhmic = struct
  type t = c_rightreservoirwithimplantedohmic

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.rightreservoirwithimplantedohmic_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_rightreservoirwithimplantedohmic ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.rightreservoirwithimplantedohmic_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_rightreservoirwithimplantedohmic ptr

  let make (name : string) (left_neighbor : Connection.t) (ohmic : Connection.t) : t =
    ErrorHandling.multi_read [left_neighbor; ohmic] (fun () ->
      let ptr = Capi_bindings.rightreservoirwithimplantedohmic_create (Capi_bindings.string_wrap name) left_neighbor#raw ohmic#raw in
      ErrorHandling.raise_if_error ();
      new c_rightreservoirwithimplantedohmic ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_name handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let type_ (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_type handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let ohmic (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_ohmic handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let leftNeighbor (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_left_neighbor handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

end