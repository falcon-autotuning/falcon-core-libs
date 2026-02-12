open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_adjacency (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.adjacency_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Adjacency = struct
  type t = c_adjacency

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.adjacency_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_adjacency ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.adjacency_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_adjacency ptr

  let make (data : int) (shape : int) (ndim : int) (indexes : Connections.t) : t =
    ErrorHandling.read indexes (fun () ->
      let ptr = Capi_bindings.adjacency_create data (Unsigned.Size_t.of_int shape) (Unsigned.Size_t.of_int ndim) indexes#raw in
      ErrorHandling.raise_if_error ();
      new c_adjacency ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.adjacency_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.adjacency_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let indexes (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_indexes handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getTruePairs (handle : t) : Listpairsizetsizet.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_get_true_pairs handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairsizetsizet result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let dimension (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_dimension handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let shape (handle : t) (out_buffer : int) (ndim : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_shape handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int ndim) in
      ErrorHandling.raise_if_error ();
      result
    )

  let data (handle : t) (out_buffer : int) (numdata : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_data handle#raw out_buffer (Unsigned.Size_t.of_int numdata) in
      ErrorHandling.raise_if_error ();
      result
    )

  let timesEqualsFarray (handle : t) (other : Farrayint.t) : unit =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.adjacency_times_equals_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let timesFarray (handle : t) (other : Farrayint.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.adjacency_times_farray handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_adjacency result
    )

  let sum (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_sum handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let where (handle : t) (value : int) : Listlistsizet.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_where handle#raw value in
      ErrorHandling.raise_if_error ();
      new c_listlistsizet result
    )

  let flip (handle : t) (axis : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.adjacency_flip handle#raw (Unsigned.Size_t.of_int axis) in
      ErrorHandling.raise_if_error ();
      new c_adjacency result
    )

end