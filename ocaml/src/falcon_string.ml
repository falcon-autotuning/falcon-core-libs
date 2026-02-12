(** Wrapper for the C-API StringHandle.
    Mirrors Go's str.New / str.ToGoString pattern.
    Named Falcon_string to avoid shadowing Stdlib.String. *)

open Ctypes
open Foreign

let lib = Dl.dlopen ~filename:"libfalcon_core_c_api.so" ~flags:[Dl.RTLD_NOW]

(* C struct: struct string { char* raw; size_t length; } *)
type c_string
let c_string : c_string structure typ = structure "string"
let c_string_raw = field c_string "raw" (ptr char)
let c_string_length = field c_string "length" size_t
let () = seal c_string

(* C-API functions *)
let string_create = foreign ~from:lib "String_create" (ptr char @-> size_t @-> returning (ptr void))
let string_wrap_c = foreign ~from:lib "String_wrap" (ptr char @-> returning (ptr void))
let string_destroy = foreign ~from:lib "String_destroy" (ptr void @-> returning void)

(** Convert an OCaml string to a StringHandle (unit ptr).
    Equivalent to Go's str.New(raw). *)
let of_string (s : string) : unit ptr =
  let len = Stdlib.String.length s in
  let buf = CArray.make char (len + 1) in
  for i = 0 to len - 1 do
    CArray.set buf i s.[i]
  done;
  CArray.set buf len '\000';
  string_create (CArray.start buf) (Unsigned.Size_t.of_int len)

(** Convert a StringHandle (unit ptr) back to an OCaml string, then destroy the handle.
    Equivalent to Go's handle.ToGoString() followed by handle.Close(). *)
let to_string (handle : unit ptr) : string =
  let sp = coerce (ptr void) (ptr c_string) handle in
  let raw_ptr = getf !@sp c_string_raw in
  let len = Unsigned.Size_t.to_int (getf !@sp c_string_length) in
  let result = string_from_ptr raw_ptr ~length:len in
  string_destroy handle;
  result

(** Destroy a StringHandle without reading it. *)
let destroy (handle : unit ptr) : unit =
  string_destroy handle
