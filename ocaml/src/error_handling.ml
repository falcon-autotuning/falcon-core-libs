(* Error handling module - similar to Go's cmemoryallocation/errorhandling *)
    open Ctypes
    open Foreign

    let lib = Dl.dlopen ~filename:"libfalcon_core_c_api.so" ~flags:[Dl.RTLD_NOW]

    (* External C functions for error handling *)
    let c_get_last_error_code = 
        foreign ~from:lib "get_last_error_code" (void @-> returning int)

    let c_get_last_error_msg = 
        foreign ~from:lib "get_last_error_msg" (void @-> returning string)

    let c_set_last_error = 
        foreign ~from:lib "set_last_error" (int @-> string @-> returning void)

    exception CApiError of string

    (* Check for C-API errors after a call *)
    let check_error () : string option =
        let code = c_get_last_error_code () in
        if code = 0 then
        None
        else
        let msg = c_get_last_error_msg () in
        Some msg

    let raise_if_error () =
        match check_error () with
        | Some err -> 
            (* Reset error before raising *)
            c_set_last_error 0 "";
            raise (CApiError err)
        | None -> ()

    (* Reset error state *)
    let reset_error () =
        c_set_last_error 0 ""

    (* Read wrapper - validates handle and checks errors *)
    let read (handle : 'a) (f : unit -> 'b) : 'b =
        let result = f () in
        raise_if_error ();
        result

    (* Write wrapper - checks errors after write operation *)
    let write (handle : 'a) (f : unit -> unit) : unit =
        f ();
        raise_if_error ()

    (* MultiRead - validates multiple handles *)
    let multi_read (handles : 'a list) (f : unit -> 'b) : 'b =
        let result = f () in
        raise_if_error ();
        result

    (* ReadWrite - combination of read and write *)
    let read_write (write_handle : 'a) (read_handles : 'b list) (f : unit -> unit) : unit =
        f ();
        raise_if_error ()
        
    (* Helper to wrap C calls that might fail *)
    let with_error_check (f : unit -> 'a) : 'a =
        let result = f () in
        raise_if_error ();
        result
    