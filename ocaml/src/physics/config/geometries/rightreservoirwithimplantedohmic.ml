open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_rightreservoirwithimplantedohmic_t = object
  method raw : unit ptr
end
class c_rightreservoirwithimplantedohmic (h : unit ptr) : c_rightreservoirwithimplantedohmic_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.rightreservoirwithimplantedohmic_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module RightReservoirWithImplantedOhmic = struct
  type t = c_rightreservoirwithimplantedohmic

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.rightreservoirwithimplantedohmic_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_rightreservoirwithimplantedohmic ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.rightreservoirwithimplantedohmic_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_rightreservoirwithimplantedohmic ptr

  let make (name : string) (left_neighbor : Connection.Connection.t) (ohmic : Connection.Connection.t) : t =
    Error_handling.multi_read [left_neighbor; ohmic] (fun () ->
      let ptr = Capi_bindings.rightreservoirwithimplantedohmic_create (Falcon_string.of_string name) left_neighbor#raw ohmic#raw in
      Error_handling.raise_if_error ();
      new c_rightreservoirwithimplantedohmic ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_name handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let type_ (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_type handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let ohmic (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_ohmic handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let leftNeighbor (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.rightreservoirwithimplantedohmic_left_neighbor handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

end