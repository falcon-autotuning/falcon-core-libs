open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_string (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.string_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module String = struct
  type t = c_string

  let make (raw : char) (length : int) : t =
    let ptr = Capi_bindings.string_create raw (Unsigned.Size_t.of_int length) in
    ErrorHandling.raise_if_error ();
    new c_string ptr

  let wrap (raw : char) : t =
    let ptr = Capi_bindings.string_wrap raw in
    ErrorHandling.raise_if_error ();
    new c_string ptr

end