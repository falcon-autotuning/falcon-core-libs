(** Wrapper for the C-API StringHandle.
    Named Falcon_string to avoid shadowing Stdlib.String. *)
  open Ctypes

val of_string : string -> unit Ctypes.ptr
(** Convert an OCaml string to a C-API StringHandle *)

val to_string : unit Ctypes.ptr -> string
(** Convert a C-API StringHandle to an OCaml string and destroy the handle *)

val destroy : unit Ctypes.ptr -> unit
(** Destroy a StringHandle without reading *)
