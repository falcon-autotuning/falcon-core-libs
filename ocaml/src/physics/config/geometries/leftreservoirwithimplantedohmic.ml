open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_leftreservoirwithimplantedohmic (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.leftreservoirwithimplantedohmic_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module LeftReservoirWithImplantedOhmic = struct
  type t = c_leftreservoirwithimplantedohmic

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.leftreservoirwithimplantedohmic_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_leftreservoirwithimplantedohmic ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.leftreservoirwithimplantedohmic_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_leftreservoirwithimplantedohmic ptr

  let make (name : string) (right_neighbor : Connection.Connection.t) (ohmic : Connection.Connection.t) : t =
    Error_handling.multi_read [right_neighbor; ohmic] (fun () ->
      let ptr = Capi_bindings.leftreservoirwithimplantedohmic_create (Capi_bindings.string_wrap name) right_neighbor#raw ohmic#raw in
      Error_handling.raise_if_error ();
      new c_leftreservoirwithimplantedohmic ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.leftreservoirwithimplantedohmic_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.leftreservoirwithimplantedohmic_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.leftreservoirwithimplantedohmic_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.leftreservoirwithimplantedohmic_name handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let type_ (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.leftreservoirwithimplantedohmic_type handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let ohmic (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.leftreservoirwithimplantedohmic_ohmic handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let rightNeighbor (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.leftreservoirwithimplantedohmic_right_neighbor handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

end