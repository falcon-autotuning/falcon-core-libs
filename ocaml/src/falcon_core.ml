open Capi_bindings
open Ctypes

type 'a handle = {
  raw : unit ptr;
  mutable owned : bool;
}

type list_handle
type map_handle
type pair_handle
type axes_handle
type farray_handle

class c_hdf5data (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (hdf5data_destroy raw_val)) self
end

module HDF5Data = struct
  type t = c_hdf5data
  let from_json_string json = new c_hdf5data (hdf5data_from_json_string json)
  let make shape unit_domain domain_labels ranges metadata measurement_title unique_id timestamp = new c_hdf5data (hdf5data_create shape unit_domain domain_labels ranges metadata measurement_title unique_id timestamp)
  let new_from_file path = new c_hdf5data (hdf5data_create_from_file path)
  let new_from_communications request response device_voltage_states session_id measurement_title unique_id timestamp = new c_hdf5data (hdf5data_create_from_communications request response device_voltage_states session_id measurement_title unique_id timestamp)
  let copy handle = hdf5data_copy handle
  let equal handle other = hdf5data_equal handle other
  let not_equal handle other = hdf5data_not_equal handle other
  let to_json_string handle = hdf5data_to_json_string handle
  let to_file handle path = hdf5data_to_file handle path
  let to_communications handle = hdf5data_to_communications handle
  let shape handle = hdf5data_shape handle
  let unit_domain handle = hdf5data_unit_domain handle
  let domain_labels handle = hdf5data_domain_labels handle
  let ranges handle = hdf5data_ranges handle
  let metadata handle = hdf5data_metadata handle
  let measurement_title handle = hdf5data_measurement_title handle
  let unique_id handle = hdf5data_unique_id handle
  let timestamp handle = hdf5data_timestamp handle
end

class c_time (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (time_destroy raw_val)) self
end

module Time = struct
  type t = c_time
  let from_json_string json = new c_time (time_from_json_string json)
  let new_now () = new c_time (time_create_now ())
  let new_at micro_seconds_since_epoch = new c_time (time_create_at micro_seconds_since_epoch)
  let copy handle = time_copy handle
  let equal handle other = time_equal handle other
  let not_equal handle other = time_not_equal handle other
  let to_json_string handle = time_to_json_string handle
  let micro_seconds_since_epoch handle = time_micro_seconds_since_epoch handle
  let time handle = time_time handle
  let to_string handle = time_to_string handle
end

class c_string (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (string_destroy raw_val)) self
end

module String = struct
  type t = c_string
  let make raw length = new c_string (string_create raw length)
  let wrap raw = string_wrap raw
  let of_string s = wrap s
end

class c_listsizet (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listsizet_destroy raw_val)) self
end

module ListSizeT = struct
  type t = c_listsizet
  let new_empty () = new c_listsizet (listsizet_create_empty ())
  let allocate count = new c_listsizet (listsizet_allocate count)
  let fill_value count value = new c_listsizet (listsizet_fill_value count value)
  let make data count = new c_listsizet (listsizet_create data count)
  let from_json_string json = new c_listsizet (listsizet_from_json_string json)
  let copy handle = listsizet_copy handle
  let push_back handle value = listsizet_push_back handle value
  let size handle = listsizet_size handle
  let empty handle = listsizet_empty handle
  let erase_at handle idx = listsizet_erase_at handle idx
  let clear handle = listsizet_clear handle
  let at handle idx = listsizet_at handle idx
  let items handle out_buffer buffer_size = listsizet_items handle out_buffer buffer_size
  let contains handle value = listsizet_contains handle value
  let index handle value = listsizet_index handle value
  let intersection handle other = listsizet_intersection handle other
  let equal handle other = listsizet_equal handle other
  let not_equal handle other = listsizet_not_equal handle other
  let to_json_string handle = listsizet_to_json_string handle
end

class c_liststring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (liststring_destroy raw_val)) self
end

module ListString = struct
  type t = c_liststring
  let new_empty () = new c_liststring (liststring_create_empty ())
  let allocate count = new c_liststring (liststring_allocate count)
  let fill_value count value = new c_liststring (liststring_fill_value count value)
  let make data count = new c_liststring (liststring_create data count)
  let from_json_string json = new c_liststring (liststring_from_json_string json)
  let copy handle = liststring_copy handle
  let push_back handle value = liststring_push_back handle value
  let size handle = liststring_size handle
  let empty handle = liststring_empty handle
  let erase_at handle idx = liststring_erase_at handle idx
  let clear handle = liststring_clear handle
  let at handle idx = liststring_at handle idx
  let items handle out_buffer buffer_size = liststring_items handle out_buffer buffer_size
  let contains handle value = liststring_contains handle value
  let index handle value = liststring_index handle value
  let intersection handle other = liststring_intersection handle other
  let equal handle other = liststring_equal handle other
  let not_equal handle other = liststring_not_equal handle other
  let to_json_string handle = liststring_to_json_string handle
end

class c_listbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listbool_destroy raw_val)) self
end

module ListBool = struct
  type t = c_listbool
  let new_empty () = new c_listbool (listbool_create_empty ())
  let allocate count = new c_listbool (listbool_allocate count)
  let fill_value count value = new c_listbool (listbool_fill_value count value)
  let make data count = new c_listbool (listbool_create data count)
  let from_json_string json = new c_listbool (listbool_from_json_string json)
  let copy handle = listbool_copy handle
  let push_back handle value = listbool_push_back handle value
  let size handle = listbool_size handle
  let empty handle = listbool_empty handle
  let erase_at handle idx = listbool_erase_at handle idx
  let clear handle = listbool_clear handle
  let at handle idx = listbool_at handle idx
  let items handle out_buffer buffer_size = listbool_items handle out_buffer buffer_size
  let contains handle value = listbool_contains handle value
  let index handle value = listbool_index handle value
  let intersection handle other = listbool_intersection handle other
  let equal handle other = listbool_equal handle other
  let not_equal handle other = listbool_not_equal handle other
  let to_json_string handle = listbool_to_json_string handle
end

class c_pairstringdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairstringdouble_destroy raw_val)) self
end

module PairStringDouble = struct
  type t = c_pairstringdouble
  let make first second = new c_pairstringdouble (pairstringdouble_create first second)
  let from_json_string json = new c_pairstringdouble (pairstringdouble_from_json_string json)
  let copy handle = pairstringdouble_copy handle
  let first handle = pairstringdouble_first handle
  let second handle = pairstringdouble_second handle
  let equal handle other = pairstringdouble_equal handle other
  let not_equal handle other = pairstringdouble_not_equal handle other
  let to_json_string handle = pairstringdouble_to_json_string handle
end

class c_pairstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairstringbool_destroy raw_val)) self
end

module PairStringBool = struct
  type t = c_pairstringbool
  let make first second = new c_pairstringbool (pairstringbool_create first second)
  let from_json_string json = new c_pairstringbool (pairstringbool_from_json_string json)
  let copy handle = pairstringbool_copy handle
  let first handle = pairstringbool_first handle
  let second handle = pairstringbool_second handle
  let equal handle other = pairstringbool_equal handle other
  let not_equal handle other = pairstringbool_not_equal handle other
  let to_json_string handle = pairstringbool_to_json_string handle
end

class c_pairsizetsizet (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairsizetsizet_destroy raw_val)) self
end

module PairSizeTSizeT = struct
  type t = c_pairsizetsizet
  let make first second = new c_pairsizetsizet (pairsizetsizet_create first second)
  let from_json_string json = new c_pairsizetsizet (pairsizetsizet_from_json_string json)
  let copy handle = pairsizetsizet_copy handle
  let first handle = pairsizetsizet_first handle
  let second handle = pairsizetsizet_second handle
  let equal handle other = pairsizetsizet_equal handle other
  let not_equal handle other = pairsizetsizet_not_equal handle other
  let to_json_string handle = pairsizetsizet_to_json_string handle
end

class c_listpairsizetsizet (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairsizetsizet_destroy raw_val)) self
end

module ListPairSizeTSizeT = struct
  type t = c_listpairsizetsizet
  let new_empty () = new c_listpairsizetsizet (listpairsizetsizet_create_empty ())
  let fill_value count value = new c_listpairsizetsizet (listpairsizetsizet_fill_value count value)
  let make data count = new c_listpairsizetsizet (listpairsizetsizet_create data count)
  let from_json_string json = new c_listpairsizetsizet (listpairsizetsizet_from_json_string json)
  let copy handle = listpairsizetsizet_copy handle
  let push_back handle value = listpairsizetsizet_push_back handle value
  let size handle = listpairsizetsizet_size handle
  let empty handle = listpairsizetsizet_empty handle
  let erase_at handle idx = listpairsizetsizet_erase_at handle idx
  let clear handle = listpairsizetsizet_clear handle
  let at handle idx = listpairsizetsizet_at handle idx
  let items handle out_buffer buffer_size = listpairsizetsizet_items handle out_buffer buffer_size
  let contains handle value = listpairsizetsizet_contains handle value
  let index handle value = listpairsizetsizet_index handle value
  let intersection handle other = listpairsizetsizet_intersection handle other
  let equal handle other = listpairsizetsizet_equal handle other
  let not_equal handle other = listpairsizetsizet_not_equal handle other
  let to_json_string handle = listpairsizetsizet_to_json_string handle
end

class c_listpairstringdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairstringdouble_destroy raw_val)) self
end

module ListPairStringDouble = struct
  type t = c_listpairstringdouble
  let new_empty () = new c_listpairstringdouble (listpairstringdouble_create_empty ())
  let fill_value count value = new c_listpairstringdouble (listpairstringdouble_fill_value count value)
  let make data count = new c_listpairstringdouble (listpairstringdouble_create data count)
  let from_json_string json = new c_listpairstringdouble (listpairstringdouble_from_json_string json)
  let copy handle = listpairstringdouble_copy handle
  let push_back handle value = listpairstringdouble_push_back handle value
  let size handle = listpairstringdouble_size handle
  let empty handle = listpairstringdouble_empty handle
  let erase_at handle idx = listpairstringdouble_erase_at handle idx
  let clear handle = listpairstringdouble_clear handle
  let at handle idx = listpairstringdouble_at handle idx
  let items handle out_buffer buffer_size = listpairstringdouble_items handle out_buffer buffer_size
  let contains handle value = listpairstringdouble_contains handle value
  let index handle value = listpairstringdouble_index handle value
  let intersection handle other = listpairstringdouble_intersection handle other
  let equal handle other = listpairstringdouble_equal handle other
  let not_equal handle other = listpairstringdouble_not_equal handle other
  let to_json_string handle = listpairstringdouble_to_json_string handle
end

class c_listlistsizet (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listlistsizet_destroy raw_val)) self
end

module ListListSizeT = struct
  type t = c_listlistsizet
  let new_empty () = new c_listlistsizet (listlistsizet_create_empty ())
  let fill_value count value = new c_listlistsizet (listlistsizet_fill_value count value)
  let make data count = new c_listlistsizet (listlistsizet_create data count)
  let from_json_string json = new c_listlistsizet (listlistsizet_from_json_string json)
  let copy handle = listlistsizet_copy handle
  let push_back handle value = listlistsizet_push_back handle value
  let size handle = listlistsizet_size handle
  let empty handle = listlistsizet_empty handle
  let erase_at handle idx = listlistsizet_erase_at handle idx
  let clear handle = listlistsizet_clear handle
  let at handle idx = listlistsizet_at handle idx
  let items handle out_buffer buffer_size = listlistsizet_items handle out_buffer buffer_size
  let contains handle value = listlistsizet_contains handle value
  let index handle value = listlistsizet_index handle value
  let intersection handle other = listlistsizet_intersection handle other
  let equal handle other = listlistsizet_equal handle other
  let not_equal handle other = listlistsizet_not_equal handle other
  let to_json_string handle = listlistsizet_to_json_string handle
end

class c_farraydouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (farraydouble_destroy raw_val)) self
end

module FArrayDouble = struct
  type t = c_farraydouble
  let new_empty shape ndim = new c_farraydouble (farraydouble_create_empty shape ndim)
  let new_zeros shape ndim = new c_farraydouble (farraydouble_create_zeros shape ndim)
  let from_json_string json = new c_farraydouble (farraydouble_from_json_string json)
  let copy handle = farraydouble_copy handle
  let from_shape shape ndim = farraydouble_from_shape shape ndim
  let from_data data shape ndim = farraydouble_from_data data shape ndim
  let size handle = farraydouble_size handle
  let dimension handle = farraydouble_dimension handle
  let shape handle out_buffer ndim = farraydouble_shape handle out_buffer ndim
  let data handle out_buffer numdata = farraydouble_data handle out_buffer numdata
  let plus_equals_farray handle other = farraydouble_plus_equals_farray handle other
  let plus_equals_double handle other = farraydouble_plus_equals_double handle other
  let plus_equals_int handle other = farraydouble_plus_equals_int handle other
  let plus_farray handle other = farraydouble_plus_farray handle other
  let plus_double handle other = farraydouble_plus_double handle other
  let plus_int handle other = farraydouble_plus_int handle other
  let minus_equals_farray handle other = farraydouble_minus_equals_farray handle other
  let minus_equals_double handle other = farraydouble_minus_equals_double handle other
  let minus_equals_int handle other = farraydouble_minus_equals_int handle other
  let minus_farray handle other = farraydouble_minus_farray handle other
  let minus_double handle other = farraydouble_minus_double handle other
  let minus_int handle other = farraydouble_minus_int handle other
  let negation handle = farraydouble_negation handle
  let times_equals_farray handle other = farraydouble_times_equals_farray handle other
  let times_equals_double handle other = farraydouble_times_equals_double handle other
  let times_equals_int handle other = farraydouble_times_equals_int handle other
  let times_farray handle other = farraydouble_times_farray handle other
  let times_double handle other = farraydouble_times_double handle other
  let times_int handle other = farraydouble_times_int handle other
  let divides_equals_farray handle other = farraydouble_divides_equals_farray handle other
  let divides_equals_double handle other = farraydouble_divides_equals_double handle other
  let divides_equals_int handle other = farraydouble_divides_equals_int handle other
  let divides_farray handle other = farraydouble_divides_farray handle other
  let divides_double handle other = farraydouble_divides_double handle other
  let divides_int handle other = farraydouble_divides_int handle other
  let pow handle other = farraydouble_pow handle other
  let double_pow handle other = farraydouble_double_pow handle other
  let pow_inplace handle other = farraydouble_pow_inplace handle other
  let abs handle = farraydouble_abs handle
  let min handle = farraydouble_min handle
  let min_arraywise handle other = farraydouble_min_arraywise handle other
  let max handle = farraydouble_max handle
  let max_arraywise handle other = farraydouble_max_arraywise handle other
  let equal handle other = farraydouble_equal handle other
  let not_equal handle other = farraydouble_not_equal handle other
  let greater_than handle value = farraydouble_greater_than handle value
  let less_than handle value = farraydouble_less_than handle value
  let remove_offset handle offset = farraydouble_remove_offset handle offset
  let sum handle = farraydouble_sum handle
  let reshape handle shape ndims = farraydouble_reshape handle shape ndims
  let where handle value = farraydouble_where handle value
  let flip handle axis = farraydouble_flip handle axis
  let full_gradient handle out_buffer buffer_size = farraydouble_full_gradient handle out_buffer buffer_size
  let gradient handle axis = farraydouble_gradient handle axis
  let get_sum_of_squares handle = farraydouble_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = farraydouble_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = farraydouble_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = farraydouble_get_summed_diff_array_of_squares handle other
  let to_json_string handle = farraydouble_to_json_string handle
end

class c_listfarraydouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listfarraydouble_destroy raw_val)) self
end

module ListFArrayDouble = struct
  type t = c_listfarraydouble
  let new_empty () = new c_listfarraydouble (listfarraydouble_create_empty ())
  let fill_value count value = new c_listfarraydouble (listfarraydouble_fill_value count value)
  let make data count = new c_listfarraydouble (listfarraydouble_create data count)
  let from_json_string json = new c_listfarraydouble (listfarraydouble_from_json_string json)
  let copy handle = listfarraydouble_copy handle
  let push_back handle value = listfarraydouble_push_back handle value
  let size handle = listfarraydouble_size handle
  let empty handle = listfarraydouble_empty handle
  let erase_at handle idx = listfarraydouble_erase_at handle idx
  let clear handle = listfarraydouble_clear handle
  let at handle idx = listfarraydouble_at handle idx
  let items handle out_buffer buffer_size = listfarraydouble_items handle out_buffer buffer_size
  let contains handle value = listfarraydouble_contains handle value
  let index handle value = listfarraydouble_index handle value
  let intersection handle other = listfarraydouble_intersection handle other
  let equal handle other = listfarraydouble_equal handle other
  let not_equal handle other = listfarraydouble_not_equal handle other
  let to_json_string handle = listfarraydouble_to_json_string handle
end

class c_farrayint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (farrayint_destroy raw_val)) self
end

module FArrayInt = struct
  type t = c_farrayint
  let new_empty shape ndim = new c_farrayint (farrayint_create_empty shape ndim)
  let new_zeros shape ndim = new c_farrayint (farrayint_create_zeros shape ndim)
  let from_json_string json = new c_farrayint (farrayint_from_json_string json)
  let copy handle = farrayint_copy handle
  let from_shape shape ndim = farrayint_from_shape shape ndim
  let from_data data shape ndim = farrayint_from_data data shape ndim
  let size handle = farrayint_size handle
  let dimension handle = farrayint_dimension handle
  let shape handle out_buffer ndim = farrayint_shape handle out_buffer ndim
  let data handle out_buffer numdata = farrayint_data handle out_buffer numdata
  let plus_equals_farray handle other = farrayint_plus_equals_farray handle other
  let plus_equals_double handle other = farrayint_plus_equals_double handle other
  let plus_equals_int handle other = farrayint_plus_equals_int handle other
  let plus_farray handle other = farrayint_plus_farray handle other
  let plus_double handle other = farrayint_plus_double handle other
  let plus_int handle other = farrayint_plus_int handle other
  let minus_equals_farray handle other = farrayint_minus_equals_farray handle other
  let minus_equals_double handle other = farrayint_minus_equals_double handle other
  let minus_equals_int handle other = farrayint_minus_equals_int handle other
  let minus_farray handle other = farrayint_minus_farray handle other
  let minus_double handle other = farrayint_minus_double handle other
  let minus_int handle other = farrayint_minus_int handle other
  let negation handle = farrayint_negation handle
  let times_equals_farray handle other = farrayint_times_equals_farray handle other
  let times_equals_double handle other = farrayint_times_equals_double handle other
  let times_equals_int handle other = farrayint_times_equals_int handle other
  let times_farray handle other = farrayint_times_farray handle other
  let times_double handle other = farrayint_times_double handle other
  let times_int handle other = farrayint_times_int handle other
  let divides_equals_farray handle other = farrayint_divides_equals_farray handle other
  let divides_equals_double handle other = farrayint_divides_equals_double handle other
  let divides_equals_int handle other = farrayint_divides_equals_int handle other
  let divides_farray handle other = farrayint_divides_farray handle other
  let divides_double handle other = farrayint_divides_double handle other
  let divides_int handle other = farrayint_divides_int handle other
  let pow handle other = farrayint_pow handle other
  let double_pow handle other = farrayint_double_pow handle other
  let pow_inplace handle other = farrayint_pow_inplace handle other
  let abs handle = farrayint_abs handle
  let min handle = farrayint_min handle
  let min_arraywise handle other = farrayint_min_arraywise handle other
  let max handle = farrayint_max handle
  let max_arraywise handle other = farrayint_max_arraywise handle other
  let equal handle other = farrayint_equal handle other
  let not_equal handle other = farrayint_not_equal handle other
  let greater_than handle value = farrayint_greater_than handle value
  let less_than handle value = farrayint_less_than handle value
  let remove_offset handle offset = farrayint_remove_offset handle offset
  let sum handle = farrayint_sum handle
  let reshape handle shape ndims = farrayint_reshape handle shape ndims
  let where handle value = farrayint_where handle value
  let flip handle axis = farrayint_flip handle axis
  let full_gradient handle out_buffer buffer_size = farrayint_full_gradient handle out_buffer buffer_size
  let gradient handle axis = farrayint_gradient handle axis
  let get_sum_of_squares handle = farrayint_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = farrayint_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = farrayint_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = farrayint_get_summed_diff_array_of_squares handle other
  let to_json_string handle = farrayint_to_json_string handle
end

class c_listint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listint_destroy raw_val)) self
end

module ListInt = struct
  type t = c_listint
  let new_empty () = new c_listint (listint_create_empty ())
  let allocate count = new c_listint (listint_allocate count)
  let fill_value count value = new c_listint (listint_fill_value count value)
  let make data count = new c_listint (listint_create data count)
  let from_json_string json = new c_listint (listint_from_json_string json)
  let copy handle = listint_copy handle
  let push_back handle value = listint_push_back handle value
  let size handle = listint_size handle
  let empty handle = listint_empty handle
  let erase_at handle idx = listint_erase_at handle idx
  let clear handle = listint_clear handle
  let at handle idx = listint_at handle idx
  let items handle out_buffer buffer_size = listint_items handle out_buffer buffer_size
  let contains handle value = listint_contains handle value
  let index handle value = listint_index handle value
  let intersection handle other = listint_intersection handle other
  let equal handle other = listint_equal handle other
  let not_equal handle other = listint_not_equal handle other
  let to_json_string handle = listint_to_json_string handle
end

class c_listfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listfloat_destroy raw_val)) self
end

module ListFloat = struct
  type t = c_listfloat
  let new_empty () = new c_listfloat (listfloat_create_empty ())
  let allocate count = new c_listfloat (listfloat_allocate count)
  let fill_value count value = new c_listfloat (listfloat_fill_value count value)
  let make data count = new c_listfloat (listfloat_create data count)
  let from_json_string json = new c_listfloat (listfloat_from_json_string json)
  let copy handle = listfloat_copy handle
  let push_back handle value = listfloat_push_back handle value
  let size handle = listfloat_size handle
  let empty handle = listfloat_empty handle
  let erase_at handle idx = listfloat_erase_at handle idx
  let clear handle = listfloat_clear handle
  let at handle idx = listfloat_at handle idx
  let items handle out_buffer buffer_size = listfloat_items handle out_buffer buffer_size
  let contains handle value = listfloat_contains handle value
  let index handle value = listfloat_index handle value
  let intersection handle other = listfloat_intersection handle other
  let equal handle other = listfloat_equal handle other
  let not_equal handle other = listfloat_not_equal handle other
  let to_json_string handle = listfloat_to_json_string handle
end

class c_listdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listdouble_destroy raw_val)) self
end

module ListDouble = struct
  type t = c_listdouble
  let new_empty () = new c_listdouble (listdouble_create_empty ())
  let allocate count = new c_listdouble (listdouble_allocate count)
  let fill_value count value = new c_listdouble (listdouble_fill_value count value)
  let make data count = new c_listdouble (listdouble_create data count)
  let from_json_string json = new c_listdouble (listdouble_from_json_string json)
  let copy handle = listdouble_copy handle
  let push_back handle value = listdouble_push_back handle value
  let size handle = listdouble_size handle
  let empty handle = listdouble_empty handle
  let erase_at handle idx = listdouble_erase_at handle idx
  let clear handle = listdouble_clear handle
  let at handle idx = listdouble_at handle idx
  let items handle out_buffer buffer_size = listdouble_items handle out_buffer buffer_size
  let contains handle value = listdouble_contains handle value
  let index handle value = listdouble_index handle value
  let intersection handle other = listdouble_intersection handle other
  let equal handle other = listdouble_equal handle other
  let not_equal handle other = listdouble_not_equal handle other
  let to_json_string handle = listdouble_to_json_string handle
end

class c_pairintint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairintint_destroy raw_val)) self
end

module PairIntInt = struct
  type t = c_pairintint
  let make first second = new c_pairintint (pairintint_create first second)
  let from_json_string json = new c_pairintint (pairintint_from_json_string json)
  let copy handle = pairintint_copy handle
  let first handle = pairintint_first handle
  let second handle = pairintint_second handle
  let equal handle other = pairintint_equal handle other
  let not_equal handle other = pairintint_not_equal handle other
  let to_json_string handle = pairintint_to_json_string handle
end

class c_pairfloatfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairfloatfloat_destroy raw_val)) self
end

module PairFloatFloat = struct
  type t = c_pairfloatfloat
  let make first second = new c_pairfloatfloat (pairfloatfloat_create first second)
  let from_json_string json = new c_pairfloatfloat (pairfloatfloat_from_json_string json)
  let copy handle = pairfloatfloat_copy handle
  let first handle = pairfloatfloat_first handle
  let second handle = pairfloatfloat_second handle
  let equal handle other = pairfloatfloat_equal handle other
  let not_equal handle other = pairfloatfloat_not_equal handle other
  let to_json_string handle = pairfloatfloat_to_json_string handle
end

class c_pairdoubledouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairdoubledouble_destroy raw_val)) self
end

module PairDoubleDouble = struct
  type t = c_pairdoubledouble
  let make first second = new c_pairdoubledouble (pairdoubledouble_create first second)
  let from_json_string json = new c_pairdoubledouble (pairdoubledouble_from_json_string json)
  let copy handle = pairdoubledouble_copy handle
  let first handle = pairdoubledouble_first handle
  let second handle = pairdoubledouble_second handle
  let equal handle other = pairdoubledouble_equal handle other
  let not_equal handle other = pairdoubledouble_not_equal handle other
  let to_json_string handle = pairdoubledouble_to_json_string handle
end

class c_pairintfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairintfloat_destroy raw_val)) self
end

module PairIntFloat = struct
  type t = c_pairintfloat
  let make first second = new c_pairintfloat (pairintfloat_create first second)
  let from_json_string json = new c_pairintfloat (pairintfloat_from_json_string json)
  let copy handle = pairintfloat_copy handle
  let first handle = pairintfloat_first handle
  let second handle = pairintfloat_second handle
  let equal handle other = pairintfloat_equal handle other
  let not_equal handle other = pairintfloat_not_equal handle other
  let to_json_string handle = pairintfloat_to_json_string handle
end

class c_pairquantityquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairquantityquantity_destroy raw_val)) self
end

module PairQuantityQuantity = struct
  type t = c_pairquantityquantity
  let make first second = new c_pairquantityquantity (pairquantityquantity_create first second)
  let from_json_string json = new c_pairquantityquantity (pairquantityquantity_from_json_string json)
  let copy handle = pairquantityquantity_copy handle
  let first handle = pairquantityquantity_first handle
  let second handle = pairquantityquantity_second handle
  let equal handle other = pairquantityquantity_equal handle other
  let not_equal handle other = pairquantityquantity_not_equal handle other
  let to_json_string handle = pairquantityquantity_to_json_string handle
end

class c_listpairquantityquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairquantityquantity_destroy raw_val)) self
end

module ListPairQuantityQuantity = struct
  type t = c_listpairquantityquantity
  let new_empty () = new c_listpairquantityquantity (listpairquantityquantity_create_empty ())
  let fill_value count value = new c_listpairquantityquantity (listpairquantityquantity_fill_value count value)
  let make data count = new c_listpairquantityquantity (listpairquantityquantity_create data count)
  let from_json_string json = new c_listpairquantityquantity (listpairquantityquantity_from_json_string json)
  let copy handle = listpairquantityquantity_copy handle
  let push_back handle value = listpairquantityquantity_push_back handle value
  let size handle = listpairquantityquantity_size handle
  let empty handle = listpairquantityquantity_empty handle
  let erase_at handle idx = listpairquantityquantity_erase_at handle idx
  let clear handle = listpairquantityquantity_clear handle
  let at handle idx = listpairquantityquantity_at handle idx
  let items handle out_buffer buffer_size = listpairquantityquantity_items handle out_buffer buffer_size
  let contains handle value = listpairquantityquantity_contains handle value
  let index handle value = listpairquantityquantity_index handle value
  let intersection handle other = listpairquantityquantity_intersection handle other
  let equal handle other = listpairquantityquantity_equal handle other
  let not_equal handle other = listpairquantityquantity_not_equal handle other
  let to_json_string handle = listpairquantityquantity_to_json_string handle
end

class c_pairconnectionfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairconnectionfloat_destroy raw_val)) self
end

module PairConnectionFloat = struct
  type t = c_pairconnectionfloat
  let make first second = new c_pairconnectionfloat (pairconnectionfloat_create first second)
  let from_json_string json = new c_pairconnectionfloat (pairconnectionfloat_from_json_string json)
  let copy handle = pairconnectionfloat_copy handle
  let first handle = pairconnectionfloat_first handle
  let second handle = pairconnectionfloat_second handle
  let equal handle other = pairconnectionfloat_equal handle other
  let not_equal handle other = pairconnectionfloat_not_equal handle other
  let to_json_string handle = pairconnectionfloat_to_json_string handle
end

class c_pairconnectiondouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairconnectiondouble_destroy raw_val)) self
end

module PairConnectionDouble = struct
  type t = c_pairconnectiondouble
  let make first second = new c_pairconnectiondouble (pairconnectiondouble_create first second)
  let from_json_string json = new c_pairconnectiondouble (pairconnectiondouble_from_json_string json)
  let copy handle = pairconnectiondouble_copy handle
  let first handle = pairconnectiondouble_first handle
  let second handle = pairconnectiondouble_second handle
  let equal handle other = pairconnectiondouble_equal handle other
  let not_equal handle other = pairconnectiondouble_not_equal handle other
  let to_json_string handle = pairconnectiondouble_to_json_string handle
end

class c_pairconnectionconnection (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairconnectionconnection_destroy raw_val)) self
end

module PairConnectionConnection = struct
  type t = c_pairconnectionconnection
  let make first second = new c_pairconnectionconnection (pairconnectionconnection_create first second)
  let from_json_string json = new c_pairconnectionconnection (pairconnectionconnection_from_json_string json)
  let copy handle = pairconnectionconnection_copy handle
  let first handle = pairconnectionconnection_first handle
  let second handle = pairconnectionconnection_second handle
  let equal handle other = pairconnectionconnection_equal handle other
  let not_equal handle other = pairconnectionconnection_not_equal handle other
  let to_json_string handle = pairconnectionconnection_to_json_string handle
end

class c_listconnection (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listconnection_destroy raw_val)) self
end

module ListConnection = struct
  type t = c_listconnection
  let new_empty () = new c_listconnection (listconnection_create_empty ())
  let fill_value count value = new c_listconnection (listconnection_fill_value count value)
  let make data count = new c_listconnection (listconnection_create data count)
  let from_json_string json = new c_listconnection (listconnection_from_json_string json)
  let copy handle = listconnection_copy handle
  let push_back handle value = listconnection_push_back handle value
  let size handle = listconnection_size handle
  let empty handle = listconnection_empty handle
  let erase_at handle idx = listconnection_erase_at handle idx
  let clear handle = listconnection_clear handle
  let at handle idx = listconnection_at handle idx
  let items handle out_buffer buffer_size = listconnection_items handle out_buffer buffer_size
  let contains handle value = listconnection_contains handle value
  let index handle value = listconnection_index handle value
  let intersection handle other = listconnection_intersection handle other
  let equal handle other = listconnection_equal handle other
  let not_equal handle other = listconnection_not_equal handle other
  let to_json_string handle = listconnection_to_json_string handle
end

class c_listchannel (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listchannel_destroy raw_val)) self
end

module ListChannel = struct
  type t = c_listchannel
  let new_empty () = new c_listchannel (listchannel_create_empty ())
  let fill_value count value = new c_listchannel (listchannel_fill_value count value)
  let make data count = new c_listchannel (listchannel_create data count)
  let from_json_string json = new c_listchannel (listchannel_from_json_string json)
  let copy handle = listchannel_copy handle
  let push_back handle value = listchannel_push_back handle value
  let size handle = listchannel_size handle
  let empty handle = listchannel_empty handle
  let erase_at handle idx = listchannel_erase_at handle idx
  let clear handle = listchannel_clear handle
  let at handle idx = listchannel_at handle idx
  let items handle out_buffer buffer_size = listchannel_items handle out_buffer buffer_size
  let contains handle value = listchannel_contains handle value
  let index handle value = listchannel_index handle value
  let intersection handle other = listchannel_intersection handle other
  let equal handle other = listchannel_equal handle other
  let not_equal handle other = listchannel_not_equal handle other
  let to_json_string handle = listchannel_to_json_string handle
end

class c_listquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listquantity_destroy raw_val)) self
end

module ListQuantity = struct
  type t = c_listquantity
  let new_empty () = new c_listquantity (listquantity_create_empty ())
  let fill_value count value = new c_listquantity (listquantity_fill_value count value)
  let make data count = new c_listquantity (listquantity_create data count)
  let from_json_string json = new c_listquantity (listquantity_from_json_string json)
  let copy handle = listquantity_copy handle
  let push_back handle value = listquantity_push_back handle value
  let size handle = listquantity_size handle
  let empty handle = listquantity_empty handle
  let erase_at handle idx = listquantity_erase_at handle idx
  let clear handle = listquantity_clear handle
  let at handle idx = listquantity_at handle idx
  let items handle out_buffer buffer_size = listquantity_items handle out_buffer buffer_size
  let contains handle value = listquantity_contains handle value
  let index handle value = listquantity_index handle value
  let intersection handle other = listquantity_intersection handle other
  let equal handle other = listquantity_equal handle other
  let not_equal handle other = listquantity_not_equal handle other
  let to_json_string handle = listquantity_to_json_string handle
end

class c_listdevicevoltagestate (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listdevicevoltagestate_destroy raw_val)) self
end

module ListDeviceVoltageState = struct
  type t = c_listdevicevoltagestate
  let new_empty () = new c_listdevicevoltagestate (listdevicevoltagestate_create_empty ())
  let fill_value count value = new c_listdevicevoltagestate (listdevicevoltagestate_fill_value count value)
  let make data count = new c_listdevicevoltagestate (listdevicevoltagestate_create data count)
  let from_json_string json = new c_listdevicevoltagestate (listdevicevoltagestate_from_json_string json)
  let copy handle = listdevicevoltagestate_copy handle
  let push_back handle value = listdevicevoltagestate_push_back handle value
  let size handle = listdevicevoltagestate_size handle
  let empty handle = listdevicevoltagestate_empty handle
  let erase_at handle idx = listdevicevoltagestate_erase_at handle idx
  let clear handle = listdevicevoltagestate_clear handle
  let at handle idx = listdevicevoltagestate_at handle idx
  let items handle out_buffer buffer_size = listdevicevoltagestate_items handle out_buffer buffer_size
  let contains handle value = listdevicevoltagestate_contains handle value
  let index handle value = listdevicevoltagestate_index handle value
  let intersection handle other = listdevicevoltagestate_intersection handle other
  let equal handle other = listdevicevoltagestate_equal handle other
  let not_equal handle other = listdevicevoltagestate_not_equal handle other
  let to_json_string handle = listdevicevoltagestate_to_json_string handle
end

class c_listlabelleddomain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listlabelleddomain_destroy raw_val)) self
end

module ListLabelledDomain = struct
  type t = c_listlabelleddomain
  let new_empty () = new c_listlabelleddomain (listlabelleddomain_create_empty ())
  let fill_value count value = new c_listlabelleddomain (listlabelleddomain_fill_value count value)
  let make data count = new c_listlabelleddomain (listlabelleddomain_create data count)
  let from_json_string json = new c_listlabelleddomain (listlabelleddomain_from_json_string json)
  let copy handle = listlabelleddomain_copy handle
  let push_back handle value = listlabelleddomain_push_back handle value
  let size handle = listlabelleddomain_size handle
  let empty handle = listlabelleddomain_empty handle
  let erase_at handle idx = listlabelleddomain_erase_at handle idx
  let clear handle = listlabelleddomain_clear handle
  let at handle idx = listlabelleddomain_at handle idx
  let items handle out_buffer buffer_size = listlabelleddomain_items handle out_buffer buffer_size
  let contains handle value = listlabelleddomain_contains handle value
  let index handle value = listlabelleddomain_index handle value
  let intersection handle other = listlabelleddomain_intersection handle other
  let equal handle other = listlabelleddomain_equal handle other
  let not_equal handle other = listlabelleddomain_not_equal handle other
  let to_json_string handle = listlabelleddomain_to_json_string handle
end

class c_listinstrumentport (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listinstrumentport_destroy raw_val)) self
end

module ListInstrumentPort = struct
  type t = c_listinstrumentport
  let new_empty () = new c_listinstrumentport (listinstrumentport_create_empty ())
  let fill_value count value = new c_listinstrumentport (listinstrumentport_fill_value count value)
  let make data count = new c_listinstrumentport (listinstrumentport_create data count)
  let from_json_string json = new c_listinstrumentport (listinstrumentport_from_json_string json)
  let copy handle = listinstrumentport_copy handle
  let push_back handle value = listinstrumentport_push_back handle value
  let size handle = listinstrumentport_size handle
  let empty handle = listinstrumentport_empty handle
  let erase_at handle idx = listinstrumentport_erase_at handle idx
  let clear handle = listinstrumentport_clear handle
  let at handle idx = listinstrumentport_at handle idx
  let items handle out_buffer buffer_size = listinstrumentport_items handle out_buffer buffer_size
  let contains handle value = listinstrumentport_contains handle value
  let index handle value = listinstrumentport_index handle value
  let intersection handle other = listinstrumentport_intersection handle other
  let equal handle other = listinstrumentport_equal handle other
  let not_equal handle other = listinstrumentport_not_equal handle other
  let to_json_string handle = listinstrumentport_to_json_string handle
end

class c_listconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listconnections_destroy raw_val)) self
end

module ListConnections = struct
  type t = c_listconnections
  let new_empty () = new c_listconnections (listconnections_create_empty ())
  let fill_value count value = new c_listconnections (listconnections_fill_value count value)
  let make data count = new c_listconnections (listconnections_create data count)
  let from_json_string json = new c_listconnections (listconnections_from_json_string json)
  let copy handle = listconnections_copy handle
  let push_back handle value = listconnections_push_back handle value
  let size handle = listconnections_size handle
  let empty handle = listconnections_empty handle
  let erase_at handle idx = listconnections_erase_at handle idx
  let clear handle = listconnections_clear handle
  let at handle idx = listconnections_at handle idx
  let items handle out_buffer buffer_size = listconnections_items handle out_buffer buffer_size
  let contains handle value = listconnections_contains handle value
  let index handle value = listconnections_index handle value
  let intersection handle other = listconnections_intersection handle other
  let equal handle other = listconnections_equal handle other
  let not_equal handle other = listconnections_not_equal handle other
  let to_json_string handle = listconnections_to_json_string handle
end

class c_listimpedance (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listimpedance_destroy raw_val)) self
end

module ListImpedance = struct
  type t = c_listimpedance
  let new_empty () = new c_listimpedance (listimpedance_create_empty ())
  let fill_value count value = new c_listimpedance (listimpedance_fill_value count value)
  let make data count = new c_listimpedance (listimpedance_create data count)
  let from_json_string json = new c_listimpedance (listimpedance_from_json_string json)
  let copy handle = listimpedance_copy handle
  let push_back handle value = listimpedance_push_back handle value
  let size handle = listimpedance_size handle
  let empty handle = listimpedance_empty handle
  let erase_at handle idx = listimpedance_erase_at handle idx
  let clear handle = listimpedance_clear handle
  let at handle idx = listimpedance_at handle idx
  let items handle out_buffer buffer_size = listimpedance_items handle out_buffer buffer_size
  let contains handle value = listimpedance_contains handle value
  let index handle value = listimpedance_index handle value
  let intersection handle other = listimpedance_intersection handle other
  let equal handle other = listimpedance_equal handle other
  let not_equal handle other = listimpedance_not_equal handle other
  let to_json_string handle = listimpedance_to_json_string handle
end

class c_pairconnectionconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairconnectionconnections_destroy raw_val)) self
end

module PairConnectionConnections = struct
  type t = c_pairconnectionconnections
  let make first second = new c_pairconnectionconnections (pairconnectionconnections_create first second)
  let from_json_string json = new c_pairconnectionconnections (pairconnectionconnections_from_json_string json)
  let copy handle = pairconnectionconnections_copy handle
  let first handle = pairconnectionconnections_first handle
  let second handle = pairconnectionconnections_second handle
  let equal handle other = pairconnectionconnections_equal handle other
  let not_equal handle other = pairconnectionconnections_not_equal handle other
  let to_json_string handle = pairconnectionconnections_to_json_string handle
end

class c_listpairintint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairintint_destroy raw_val)) self
end

module ListPairIntInt = struct
  type t = c_listpairintint
  let new_empty () = new c_listpairintint (listpairintint_create_empty ())
  let fill_value count value = new c_listpairintint (listpairintint_fill_value count value)
  let make data count = new c_listpairintint (listpairintint_create data count)
  let from_json_string json = new c_listpairintint (listpairintint_from_json_string json)
  let copy handle = listpairintint_copy handle
  let push_back handle value = listpairintint_push_back handle value
  let size handle = listpairintint_size handle
  let empty handle = listpairintint_empty handle
  let erase_at handle idx = listpairintint_erase_at handle idx
  let clear handle = listpairintint_clear handle
  let at handle idx = listpairintint_at handle idx
  let items handle out_buffer buffer_size = listpairintint_items handle out_buffer buffer_size
  let contains handle value = listpairintint_contains handle value
  let index handle value = listpairintint_index handle value
  let intersection handle other = listpairintint_intersection handle other
  let equal handle other = listpairintint_equal handle other
  let not_equal handle other = listpairintint_not_equal handle other
  let to_json_string handle = listpairintint_to_json_string handle
end

class c_listpairfloatfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairfloatfloat_destroy raw_val)) self
end

module ListPairFloatFloat = struct
  type t = c_listpairfloatfloat
  let new_empty () = new c_listpairfloatfloat (listpairfloatfloat_create_empty ())
  let fill_value count value = new c_listpairfloatfloat (listpairfloatfloat_fill_value count value)
  let make data count = new c_listpairfloatfloat (listpairfloatfloat_create data count)
  let from_json_string json = new c_listpairfloatfloat (listpairfloatfloat_from_json_string json)
  let copy handle = listpairfloatfloat_copy handle
  let push_back handle value = listpairfloatfloat_push_back handle value
  let size handle = listpairfloatfloat_size handle
  let empty handle = listpairfloatfloat_empty handle
  let erase_at handle idx = listpairfloatfloat_erase_at handle idx
  let clear handle = listpairfloatfloat_clear handle
  let at handle idx = listpairfloatfloat_at handle idx
  let items handle out_buffer buffer_size = listpairfloatfloat_items handle out_buffer buffer_size
  let contains handle value = listpairfloatfloat_contains handle value
  let index handle value = listpairfloatfloat_index handle value
  let intersection handle other = listpairfloatfloat_intersection handle other
  let equal handle other = listpairfloatfloat_equal handle other
  let not_equal handle other = listpairfloatfloat_not_equal handle other
  let to_json_string handle = listpairfloatfloat_to_json_string handle
end

class c_listpairintfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairintfloat_destroy raw_val)) self
end

module ListPairIntFloat = struct
  type t = c_listpairintfloat
  let new_empty () = new c_listpairintfloat (listpairintfloat_create_empty ())
  let fill_value count value = new c_listpairintfloat (listpairintfloat_fill_value count value)
  let make data count = new c_listpairintfloat (listpairintfloat_create data count)
  let from_json_string json = new c_listpairintfloat (listpairintfloat_from_json_string json)
  let copy handle = listpairintfloat_copy handle
  let push_back handle value = listpairintfloat_push_back handle value
  let size handle = listpairintfloat_size handle
  let empty handle = listpairintfloat_empty handle
  let erase_at handle idx = listpairintfloat_erase_at handle idx
  let clear handle = listpairintfloat_clear handle
  let at handle idx = listpairintfloat_at handle idx
  let items handle out_buffer buffer_size = listpairintfloat_items handle out_buffer buffer_size
  let contains handle value = listpairintfloat_contains handle value
  let index handle value = listpairintfloat_index handle value
  let intersection handle other = listpairintfloat_intersection handle other
  let equal handle other = listpairintfloat_equal handle other
  let not_equal handle other = listpairintfloat_not_equal handle other
  let to_json_string handle = listpairintfloat_to_json_string handle
end

class c_listpairconnectionfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairconnectionfloat_destroy raw_val)) self
end

module ListPairConnectionFloat = struct
  type t = c_listpairconnectionfloat
  let new_empty () = new c_listpairconnectionfloat (listpairconnectionfloat_create_empty ())
  let fill_value count value = new c_listpairconnectionfloat (listpairconnectionfloat_fill_value count value)
  let make data count = new c_listpairconnectionfloat (listpairconnectionfloat_create data count)
  let from_json_string json = new c_listpairconnectionfloat (listpairconnectionfloat_from_json_string json)
  let copy handle = listpairconnectionfloat_copy handle
  let push_back handle value = listpairconnectionfloat_push_back handle value
  let size handle = listpairconnectionfloat_size handle
  let empty handle = listpairconnectionfloat_empty handle
  let erase_at handle idx = listpairconnectionfloat_erase_at handle idx
  let clear handle = listpairconnectionfloat_clear handle
  let at handle idx = listpairconnectionfloat_at handle idx
  let items handle out_buffer buffer_size = listpairconnectionfloat_items handle out_buffer buffer_size
  let contains handle value = listpairconnectionfloat_contains handle value
  let index handle value = listpairconnectionfloat_index handle value
  let intersection handle other = listpairconnectionfloat_intersection handle other
  let equal handle other = listpairconnectionfloat_equal handle other
  let not_equal handle other = listpairconnectionfloat_not_equal handle other
  let to_json_string handle = listpairconnectionfloat_to_json_string handle
end

class c_listpairconnectiondouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairconnectiondouble_destroy raw_val)) self
end

module ListPairConnectionDouble = struct
  type t = c_listpairconnectiondouble
  let new_empty () = new c_listpairconnectiondouble (listpairconnectiondouble_create_empty ())
  let fill_value count value = new c_listpairconnectiondouble (listpairconnectiondouble_fill_value count value)
  let make data count = new c_listpairconnectiondouble (listpairconnectiondouble_create data count)
  let from_json_string json = new c_listpairconnectiondouble (listpairconnectiondouble_from_json_string json)
  let copy handle = listpairconnectiondouble_copy handle
  let push_back handle value = listpairconnectiondouble_push_back handle value
  let size handle = listpairconnectiondouble_size handle
  let empty handle = listpairconnectiondouble_empty handle
  let erase_at handle idx = listpairconnectiondouble_erase_at handle idx
  let clear handle = listpairconnectiondouble_clear handle
  let at handle idx = listpairconnectiondouble_at handle idx
  let items handle out_buffer buffer_size = listpairconnectiondouble_items handle out_buffer buffer_size
  let contains handle value = listpairconnectiondouble_contains handle value
  let index handle value = listpairconnectiondouble_index handle value
  let intersection handle other = listpairconnectiondouble_intersection handle other
  let equal handle other = listpairconnectiondouble_equal handle other
  let not_equal handle other = listpairconnectiondouble_not_equal handle other
  let to_json_string handle = listpairconnectiondouble_to_json_string handle
end

class c_listpairconnectionconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairconnectionconnections_destroy raw_val)) self
end

module ListPairConnectionConnections = struct
  type t = c_listpairconnectionconnections
  let new_empty () = new c_listpairconnectionconnections (listpairconnectionconnections_create_empty ())
  let fill_value count value = new c_listpairconnectionconnections (listpairconnectionconnections_fill_value count value)
  let make data count = new c_listpairconnectionconnections (listpairconnectionconnections_create data count)
  let from_json_string json = new c_listpairconnectionconnections (listpairconnectionconnections_from_json_string json)
  let copy handle = listpairconnectionconnections_copy handle
  let push_back handle value = listpairconnectionconnections_push_back handle value
  let size handle = listpairconnectionconnections_size handle
  let empty handle = listpairconnectionconnections_empty handle
  let erase_at handle idx = listpairconnectionconnections_erase_at handle idx
  let clear handle = listpairconnectionconnections_clear handle
  let at handle idx = listpairconnectionconnections_at handle idx
  let items handle out_buffer buffer_size = listpairconnectionconnections_items handle out_buffer buffer_size
  let contains handle value = listpairconnectionconnections_contains handle value
  let index handle value = listpairconnectionconnections_index handle value
  let intersection handle other = listpairconnectionconnections_intersection handle other
  let equal handle other = listpairconnectionconnections_equal handle other
  let not_equal handle other = listpairconnectionconnections_not_equal handle other
  let to_json_string handle = listpairconnectionconnections_to_json_string handle
end

class c_mapstringdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapstringdouble_destroy raw_val)) self
end

module MapStringDouble = struct
  type t = c_mapstringdouble
  let new_empty () = new c_mapstringdouble (mapstringdouble_create_empty ())
  let make data count = new c_mapstringdouble (mapstringdouble_create data count)
  let from_json_string json = new c_mapstringdouble (mapstringdouble_from_json_string json)
  let copy handle = mapstringdouble_copy handle
  let insert_or_assign handle key value = mapstringdouble_insert_or_assign handle key value
  let insert handle key value = mapstringdouble_insert handle key value
  let at handle key = mapstringdouble_at handle key
  let erase handle key = mapstringdouble_erase handle key
  let size handle = mapstringdouble_size handle
  let empty handle = mapstringdouble_empty handle
  let clear handle = mapstringdouble_clear handle
  let contains handle key = mapstringdouble_contains handle key
  let keys handle = mapstringdouble_keys handle
  let values handle = mapstringdouble_values handle
  let items handle = mapstringdouble_items handle
  let equal handle other = mapstringdouble_equal handle other
  let not_equal handle other = mapstringdouble_not_equal handle other
  let to_json_string handle = mapstringdouble_to_json_string handle
end

class c_mapintint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapintint_destroy raw_val)) self
end

module MapIntInt = struct
  type t = c_mapintint
  let new_empty () = new c_mapintint (mapintint_create_empty ())
  let make data count = new c_mapintint (mapintint_create data count)
  let from_json_string json = new c_mapintint (mapintint_from_json_string json)
  let copy handle = mapintint_copy handle
  let insert_or_assign handle key value = mapintint_insert_or_assign handle key value
  let insert handle key value = mapintint_insert handle key value
  let at handle key = mapintint_at handle key
  let erase handle key = mapintint_erase handle key
  let size handle = mapintint_size handle
  let empty handle = mapintint_empty handle
  let clear handle = mapintint_clear handle
  let contains handle key = mapintint_contains handle key
  let keys handle = mapintint_keys handle
  let values handle = mapintint_values handle
  let items handle = mapintint_items handle
  let equal handle other = mapintint_equal handle other
  let not_equal handle other = mapintint_not_equal handle other
  let to_json_string handle = mapintint_to_json_string handle
end

class c_mapfloatfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapfloatfloat_destroy raw_val)) self
end

module MapFloatFloat = struct
  type t = c_mapfloatfloat
  let new_empty () = new c_mapfloatfloat (mapfloatfloat_create_empty ())
  let make data count = new c_mapfloatfloat (mapfloatfloat_create data count)
  let from_json_string json = new c_mapfloatfloat (mapfloatfloat_from_json_string json)
  let copy handle = mapfloatfloat_copy handle
  let insert_or_assign handle key value = mapfloatfloat_insert_or_assign handle key value
  let insert handle key value = mapfloatfloat_insert handle key value
  let at handle key = mapfloatfloat_at handle key
  let erase handle key = mapfloatfloat_erase handle key
  let size handle = mapfloatfloat_size handle
  let empty handle = mapfloatfloat_empty handle
  let clear handle = mapfloatfloat_clear handle
  let contains handle key = mapfloatfloat_contains handle key
  let keys handle = mapfloatfloat_keys handle
  let values handle = mapfloatfloat_values handle
  let items handle = mapfloatfloat_items handle
  let equal handle other = mapfloatfloat_equal handle other
  let not_equal handle other = mapfloatfloat_not_equal handle other
  let to_json_string handle = mapfloatfloat_to_json_string handle
end

class c_mapconnectionfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapconnectionfloat_destroy raw_val)) self
end

module MapConnectionFloat = struct
  type t = c_mapconnectionfloat
  let new_empty () = new c_mapconnectionfloat (mapconnectionfloat_create_empty ())
  let make data count = new c_mapconnectionfloat (mapconnectionfloat_create data count)
  let from_json_string json = new c_mapconnectionfloat (mapconnectionfloat_from_json_string json)
  let copy handle = mapconnectionfloat_copy handle
  let insert_or_assign handle key value = mapconnectionfloat_insert_or_assign handle key value
  let insert handle key value = mapconnectionfloat_insert handle key value
  let at handle key = mapconnectionfloat_at handle key
  let erase handle key = mapconnectionfloat_erase handle key
  let size handle = mapconnectionfloat_size handle
  let empty handle = mapconnectionfloat_empty handle
  let clear handle = mapconnectionfloat_clear handle
  let contains handle key = mapconnectionfloat_contains handle key
  let keys handle = mapconnectionfloat_keys handle
  let values handle = mapconnectionfloat_values handle
  let items handle = mapconnectionfloat_items handle
  let equal handle other = mapconnectionfloat_equal handle other
  let not_equal handle other = mapconnectionfloat_not_equal handle other
  let to_json_string handle = mapconnectionfloat_to_json_string handle
end

class c_mapconnectiondouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapconnectiondouble_destroy raw_val)) self
end

module MapConnectionDouble = struct
  type t = c_mapconnectiondouble
  let new_empty () = new c_mapconnectiondouble (mapconnectiondouble_create_empty ())
  let make data count = new c_mapconnectiondouble (mapconnectiondouble_create data count)
  let from_json_string json = new c_mapconnectiondouble (mapconnectiondouble_from_json_string json)
  let copy handle = mapconnectiondouble_copy handle
  let insert_or_assign handle key value = mapconnectiondouble_insert_or_assign handle key value
  let insert handle key value = mapconnectiondouble_insert handle key value
  let at handle key = mapconnectiondouble_at handle key
  let erase handle key = mapconnectiondouble_erase handle key
  let size handle = mapconnectiondouble_size handle
  let empty handle = mapconnectiondouble_empty handle
  let clear handle = mapconnectiondouble_clear handle
  let contains handle key = mapconnectiondouble_contains handle key
  let keys handle = mapconnectiondouble_keys handle
  let values handle = mapconnectiondouble_values handle
  let items handle = mapconnectiondouble_items handle
  let equal handle other = mapconnectiondouble_equal handle other
  let not_equal handle other = mapconnectiondouble_not_equal handle other
  let to_json_string handle = mapconnectiondouble_to_json_string handle
end

class c_pairconnectionquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairconnectionquantity_destroy raw_val)) self
end

module PairConnectionQuantity = struct
  type t = c_pairconnectionquantity
  let make first second = new c_pairconnectionquantity (pairconnectionquantity_create first second)
  let from_json_string json = new c_pairconnectionquantity (pairconnectionquantity_from_json_string json)
  let copy handle = pairconnectionquantity_copy handle
  let first handle = pairconnectionquantity_first handle
  let second handle = pairconnectionquantity_second handle
  let equal handle other = pairconnectionquantity_equal handle other
  let not_equal handle other = pairconnectionquantity_not_equal handle other
  let to_json_string handle = pairconnectionquantity_to_json_string handle
end

class c_listpairconnectionquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairconnectionquantity_destroy raw_val)) self
end

module ListPairConnectionQuantity = struct
  type t = c_listpairconnectionquantity
  let new_empty () = new c_listpairconnectionquantity (listpairconnectionquantity_create_empty ())
  let fill_value count value = new c_listpairconnectionquantity (listpairconnectionquantity_fill_value count value)
  let make data count = new c_listpairconnectionquantity (listpairconnectionquantity_create data count)
  let from_json_string json = new c_listpairconnectionquantity (listpairconnectionquantity_from_json_string json)
  let copy handle = listpairconnectionquantity_copy handle
  let push_back handle value = listpairconnectionquantity_push_back handle value
  let size handle = listpairconnectionquantity_size handle
  let empty handle = listpairconnectionquantity_empty handle
  let erase_at handle idx = listpairconnectionquantity_erase_at handle idx
  let clear handle = listpairconnectionquantity_clear handle
  let at handle idx = listpairconnectionquantity_at handle idx
  let items handle out_buffer buffer_size = listpairconnectionquantity_items handle out_buffer buffer_size
  let contains handle value = listpairconnectionquantity_contains handle value
  let index handle value = listpairconnectionquantity_index handle value
  let intersection handle other = listpairconnectionquantity_intersection handle other
  let equal handle other = listpairconnectionquantity_equal handle other
  let not_equal handle other = listpairconnectionquantity_not_equal handle other
  let to_json_string handle = listpairconnectionquantity_to_json_string handle
end

class c_mapconnectionquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapconnectionquantity_destroy raw_val)) self
end

module MapConnectionQuantity = struct
  type t = c_mapconnectionquantity
  let new_empty () = new c_mapconnectionquantity (mapconnectionquantity_create_empty ())
  let make data count = new c_mapconnectionquantity (mapconnectionquantity_create data count)
  let from_json_string json = new c_mapconnectionquantity (mapconnectionquantity_from_json_string json)
  let copy handle = mapconnectionquantity_copy handle
  let insert_or_assign handle key value = mapconnectionquantity_insert_or_assign handle key value
  let insert handle key value = mapconnectionquantity_insert handle key value
  let at handle key = mapconnectionquantity_at handle key
  let erase handle key = mapconnectionquantity_erase handle key
  let size handle = mapconnectionquantity_size handle
  let empty handle = mapconnectionquantity_empty handle
  let clear handle = mapconnectionquantity_clear handle
  let contains handle key = mapconnectionquantity_contains handle key
  let keys handle = mapconnectionquantity_keys handle
  let values handle = mapconnectionquantity_values handle
  let items handle = mapconnectionquantity_items handle
  let equal handle other = mapconnectionquantity_equal handle other
  let not_equal handle other = mapconnectionquantity_not_equal handle other
  let to_json_string handle = mapconnectionquantity_to_json_string handle
end

class c_pairconnectionpairquantityquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairconnectionpairquantityquantity_destroy raw_val)) self
end

module PairConnectionPairQuantityQuantity = struct
  type t = c_pairconnectionpairquantityquantity
  let make first second = new c_pairconnectionpairquantityquantity (pairconnectionpairquantityquantity_create first second)
  let from_json_string json = new c_pairconnectionpairquantityquantity (pairconnectionpairquantityquantity_from_json_string json)
  let copy handle = pairconnectionpairquantityquantity_copy handle
  let first handle = pairconnectionpairquantityquantity_first handle
  let second handle = pairconnectionpairquantityquantity_second handle
  let equal handle other = pairconnectionpairquantityquantity_equal handle other
  let not_equal handle other = pairconnectionpairquantityquantity_not_equal handle other
  let to_json_string handle = pairconnectionpairquantityquantity_to_json_string handle
end

class c_listpairconnectionpairquantityquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairconnectionpairquantityquantity_destroy raw_val)) self
end

module ListPairConnectionPairQuantityQuantity = struct
  type t = c_listpairconnectionpairquantityquantity
  let new_empty () = new c_listpairconnectionpairquantityquantity (listpairconnectionpairquantityquantity_create_empty ())
  let fill_value count value = new c_listpairconnectionpairquantityquantity (listpairconnectionpairquantityquantity_fill_value count value)
  let make data count = new c_listpairconnectionpairquantityquantity (listpairconnectionpairquantityquantity_create data count)
  let from_json_string json = new c_listpairconnectionpairquantityquantity (listpairconnectionpairquantityquantity_from_json_string json)
  let copy handle = listpairconnectionpairquantityquantity_copy handle
  let push_back handle value = listpairconnectionpairquantityquantity_push_back handle value
  let size handle = listpairconnectionpairquantityquantity_size handle
  let empty handle = listpairconnectionpairquantityquantity_empty handle
  let erase_at handle idx = listpairconnectionpairquantityquantity_erase_at handle idx
  let clear handle = listpairconnectionpairquantityquantity_clear handle
  let at handle idx = listpairconnectionpairquantityquantity_at handle idx
  let items handle out_buffer buffer_size = listpairconnectionpairquantityquantity_items handle out_buffer buffer_size
  let contains handle value = listpairconnectionpairquantityquantity_contains handle value
  let index handle value = listpairconnectionpairquantityquantity_index handle value
  let intersection handle other = listpairconnectionpairquantityquantity_intersection handle other
  let equal handle other = listpairconnectionpairquantityquantity_equal handle other
  let not_equal handle other = listpairconnectionpairquantityquantity_not_equal handle other
  let to_json_string handle = listpairconnectionpairquantityquantity_to_json_string handle
end

class c_listdiscretizer (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listdiscretizer_destroy raw_val)) self
end

module ListDiscretizer = struct
  type t = c_listdiscretizer
  let new_empty () = new c_listdiscretizer (listdiscretizer_create_empty ())
  let fill_value count value = new c_listdiscretizer (listdiscretizer_fill_value count value)
  let make data count = new c_listdiscretizer (listdiscretizer_create data count)
  let from_json_string json = new c_listdiscretizer (listdiscretizer_from_json_string json)
  let copy handle = listdiscretizer_copy handle
  let push_back handle value = listdiscretizer_push_back handle value
  let size handle = listdiscretizer_size handle
  let empty handle = listdiscretizer_empty handle
  let erase_at handle idx = listdiscretizer_erase_at handle idx
  let clear handle = listdiscretizer_clear handle
  let at handle idx = listdiscretizer_at handle idx
  let items handle out_buffer buffer_size = listdiscretizer_items handle out_buffer buffer_size
  let contains handle value = listdiscretizer_contains handle value
  let index handle value = listdiscretizer_index handle value
  let intersection handle other = listdiscretizer_intersection handle other
  let equal handle other = listdiscretizer_equal handle other
  let not_equal handle other = listdiscretizer_not_equal handle other
  let to_json_string handle = listdiscretizer_to_json_string handle
end

class c_listcontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listcontrolarray_destroy raw_val)) self
end

module ListControlArray = struct
  type t = c_listcontrolarray
  let new_empty () = new c_listcontrolarray (listcontrolarray_create_empty ())
  let fill_value count value = new c_listcontrolarray (listcontrolarray_fill_value count value)
  let make data count = new c_listcontrolarray (listcontrolarray_create data count)
  let from_json_string json = new c_listcontrolarray (listcontrolarray_from_json_string json)
  let copy handle = listcontrolarray_copy handle
  let push_back handle value = listcontrolarray_push_back handle value
  let size handle = listcontrolarray_size handle
  let empty handle = listcontrolarray_empty handle
  let erase_at handle idx = listcontrolarray_erase_at handle idx
  let clear handle = listcontrolarray_clear handle
  let at handle idx = listcontrolarray_at handle idx
  let items handle out_buffer buffer_size = listcontrolarray_items handle out_buffer buffer_size
  let contains handle value = listcontrolarray_contains handle value
  let index handle value = listcontrolarray_index handle value
  let intersection handle other = listcontrolarray_intersection handle other
  let equal handle other = listcontrolarray_equal handle other
  let not_equal handle other = listcontrolarray_not_equal handle other
  let to_json_string handle = listcontrolarray_to_json_string handle
end

class c_listcontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listcontrolarray1d_destroy raw_val)) self
end

module ListControlArray1D = struct
  type t = c_listcontrolarray1d
  let new_empty () = new c_listcontrolarray1d (listcontrolarray1d_create_empty ())
  let fill_value count value = new c_listcontrolarray1d (listcontrolarray1d_fill_value count value)
  let make data count = new c_listcontrolarray1d (listcontrolarray1d_create data count)
  let from_json_string json = new c_listcontrolarray1d (listcontrolarray1d_from_json_string json)
  let copy handle = listcontrolarray1d_copy handle
  let push_back handle value = listcontrolarray1d_push_back handle value
  let size handle = listcontrolarray1d_size handle
  let empty handle = listcontrolarray1d_empty handle
  let erase_at handle idx = listcontrolarray1d_erase_at handle idx
  let clear handle = listcontrolarray1d_clear handle
  let at handle idx = listcontrolarray1d_at handle idx
  let items handle out_buffer buffer_size = listcontrolarray1d_items handle out_buffer buffer_size
  let contains handle value = listcontrolarray1d_contains handle value
  let index handle value = listcontrolarray1d_index handle value
  let intersection handle other = listcontrolarray1d_intersection handle other
  let equal handle other = listcontrolarray1d_equal handle other
  let not_equal handle other = listcontrolarray1d_not_equal handle other
  let to_json_string handle = listcontrolarray1d_to_json_string handle
end

class c_listcoupledlabelleddomain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listcoupledlabelleddomain_destroy raw_val)) self
end

module ListCoupledLabelledDomain = struct
  type t = c_listcoupledlabelleddomain
  let new_empty () = new c_listcoupledlabelleddomain (listcoupledlabelleddomain_create_empty ())
  let fill_value count value = new c_listcoupledlabelleddomain (listcoupledlabelleddomain_fill_value count value)
  let make data count = new c_listcoupledlabelleddomain (listcoupledlabelleddomain_create data count)
  let from_json_string json = new c_listcoupledlabelleddomain (listcoupledlabelleddomain_from_json_string json)
  let copy handle = listcoupledlabelleddomain_copy handle
  let push_back handle value = listcoupledlabelleddomain_push_back handle value
  let size handle = listcoupledlabelleddomain_size handle
  let empty handle = listcoupledlabelleddomain_empty handle
  let erase_at handle idx = listcoupledlabelleddomain_erase_at handle idx
  let clear handle = listcoupledlabelleddomain_clear handle
  let at handle idx = listcoupledlabelleddomain_at handle idx
  let items handle out_buffer buffer_size = listcoupledlabelleddomain_items handle out_buffer buffer_size
  let contains handle value = listcoupledlabelleddomain_contains handle value
  let index handle value = listcoupledlabelleddomain_index handle value
  let intersection handle other = listcoupledlabelleddomain_intersection handle other
  let equal handle other = listcoupledlabelleddomain_equal handle other
  let not_equal handle other = listcoupledlabelleddomain_not_equal handle other
  let to_json_string handle = listcoupledlabelleddomain_to_json_string handle
end

class c_listpairstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairstringbool_destroy raw_val)) self
end

module ListPairStringBool = struct
  type t = c_listpairstringbool
  let new_empty () = new c_listpairstringbool (listpairstringbool_create_empty ())
  let fill_value count value = new c_listpairstringbool (listpairstringbool_fill_value count value)
  let make data count = new c_listpairstringbool (listpairstringbool_create data count)
  let from_json_string json = new c_listpairstringbool (listpairstringbool_from_json_string json)
  let copy handle = listpairstringbool_copy handle
  let push_back handle value = listpairstringbool_push_back handle value
  let size handle = listpairstringbool_size handle
  let empty handle = listpairstringbool_empty handle
  let erase_at handle idx = listpairstringbool_erase_at handle idx
  let clear handle = listpairstringbool_clear handle
  let at handle idx = listpairstringbool_at handle idx
  let items handle out_buffer buffer_size = listpairstringbool_items handle out_buffer buffer_size
  let contains handle value = listpairstringbool_contains handle value
  let index handle value = listpairstringbool_index handle value
  let intersection handle other = listpairstringbool_intersection handle other
  let equal handle other = listpairstringbool_equal handle other
  let not_equal handle other = listpairstringbool_not_equal handle other
  let to_json_string handle = listpairstringbool_to_json_string handle
end

class c_mapstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapstringbool_destroy raw_val)) self
end

module MapStringBool = struct
  type t = c_mapstringbool
  let new_empty () = new c_mapstringbool (mapstringbool_create_empty ())
  let make data count = new c_mapstringbool (mapstringbool_create data count)
  let from_json_string json = new c_mapstringbool (mapstringbool_from_json_string json)
  let copy handle = mapstringbool_copy handle
  let insert_or_assign handle key value = mapstringbool_insert_or_assign handle key value
  let insert handle key value = mapstringbool_insert handle key value
  let at handle key = mapstringbool_at handle key
  let erase handle key = mapstringbool_erase handle key
  let size handle = mapstringbool_size handle
  let empty handle = mapstringbool_empty handle
  let clear handle = mapstringbool_clear handle
  let contains handle key = mapstringbool_contains handle key
  let keys handle = mapstringbool_keys handle
  let values handle = mapstringbool_values handle
  let items handle = mapstringbool_items handle
  let equal handle other = mapstringbool_equal handle other
  let not_equal handle other = mapstringbool_not_equal handle other
  let to_json_string handle = mapstringbool_to_json_string handle
end

class c_listmapstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listmapstringbool_destroy raw_val)) self
end

module ListMapStringBool = struct
  type t = c_listmapstringbool
  let new_empty () = new c_listmapstringbool (listmapstringbool_create_empty ())
  let fill_value count value = new c_listmapstringbool (listmapstringbool_fill_value count value)
  let make data count = new c_listmapstringbool (listmapstringbool_create data count)
  let from_json_string json = new c_listmapstringbool (listmapstringbool_from_json_string json)
  let copy handle = listmapstringbool_copy handle
  let push_back handle value = listmapstringbool_push_back handle value
  let size handle = listmapstringbool_size handle
  let empty handle = listmapstringbool_empty handle
  let erase_at handle idx = listmapstringbool_erase_at handle idx
  let clear handle = listmapstringbool_clear handle
  let at handle idx = listmapstringbool_at handle idx
  let items handle out_buffer buffer_size = listmapstringbool_items handle out_buffer buffer_size
  let contains handle value = listmapstringbool_contains handle value
  let index handle value = listmapstringbool_index handle value
  let intersection handle other = listmapstringbool_intersection handle other
  let equal handle other = listmapstringbool_equal handle other
  let not_equal handle other = listmapstringbool_not_equal handle other
  let to_json_string handle = listmapstringbool_to_json_string handle
end

class c_listdotgatewithneighbors (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listdotgatewithneighbors_destroy raw_val)) self
end

module ListDotGateWithNeighbors = struct
  type t = c_listdotgatewithneighbors
  let new_empty () = new c_listdotgatewithneighbors (listdotgatewithneighbors_create_empty ())
  let fill_value count value = new c_listdotgatewithneighbors (listdotgatewithneighbors_fill_value count value)
  let make data count = new c_listdotgatewithneighbors (listdotgatewithneighbors_create data count)
  let from_json_string json = new c_listdotgatewithneighbors (listdotgatewithneighbors_from_json_string json)
  let copy handle = listdotgatewithneighbors_copy handle
  let push_back handle value = listdotgatewithneighbors_push_back handle value
  let size handle = listdotgatewithneighbors_size handle
  let empty handle = listdotgatewithneighbors_empty handle
  let erase_at handle idx = listdotgatewithneighbors_erase_at handle idx
  let clear handle = listdotgatewithneighbors_clear handle
  let at handle idx = listdotgatewithneighbors_at handle idx
  let items handle out_buffer buffer_size = listdotgatewithneighbors_items handle out_buffer buffer_size
  let contains handle value = listdotgatewithneighbors_contains handle value
  let index handle value = listdotgatewithneighbors_index handle value
  let intersection handle other = listdotgatewithneighbors_intersection handle other
  let equal handle other = listdotgatewithneighbors_equal handle other
  let not_equal handle other = listdotgatewithneighbors_not_equal handle other
  let to_json_string handle = listdotgatewithneighbors_to_json_string handle
end

class c_listgroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listgroup_destroy raw_val)) self
end

module ListGroup = struct
  type t = c_listgroup
  let new_empty () = new c_listgroup (listgroup_create_empty ())
  let fill_value count value = new c_listgroup (listgroup_fill_value count value)
  let make data count = new c_listgroup (listgroup_create data count)
  let from_json_string json = new c_listgroup (listgroup_from_json_string json)
  let copy handle = listgroup_copy handle
  let push_back handle value = listgroup_push_back handle value
  let size handle = listgroup_size handle
  let empty handle = listgroup_empty handle
  let erase_at handle idx = listgroup_erase_at handle idx
  let clear handle = listgroup_clear handle
  let at handle idx = listgroup_at handle idx
  let items handle out_buffer buffer_size = listgroup_items handle out_buffer buffer_size
  let contains handle value = listgroup_contains handle value
  let index handle value = listgroup_index handle value
  let intersection handle other = listgroup_intersection handle other
  let equal handle other = listgroup_equal handle other
  let not_equal handle other = listgroup_not_equal handle other
  let to_json_string handle = listgroup_to_json_string handle
end

class c_listgname (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listgname_destroy raw_val)) self
end

module ListGname = struct
  type t = c_listgname
  let new_empty () = new c_listgname (listgname_create_empty ())
  let fill_value count value = new c_listgname (listgname_fill_value count value)
  let make data count = new c_listgname (listgname_create data count)
  let from_json_string json = new c_listgname (listgname_from_json_string json)
  let copy handle = listgname_copy handle
  let push_back handle value = listgname_push_back handle value
  let size handle = listgname_size handle
  let empty handle = listgname_empty handle
  let erase_at handle idx = listgname_erase_at handle idx
  let clear handle = listgname_clear handle
  let at handle idx = listgname_at handle idx
  let items handle out_buffer buffer_size = listgname_items handle out_buffer buffer_size
  let contains handle value = listgname_contains handle value
  let index handle value = listgname_index handle value
  let intersection handle other = listgname_intersection handle other
  let equal handle other = listgname_equal handle other
  let not_equal handle other = listgname_not_equal handle other
  let to_json_string handle = listgname_to_json_string handle
end

class c_pairchannelconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairchannelconnections_destroy raw_val)) self
end

module PairChannelConnections = struct
  type t = c_pairchannelconnections
  let make first second = new c_pairchannelconnections (pairchannelconnections_create first second)
  let from_json_string json = new c_pairchannelconnections (pairchannelconnections_from_json_string json)
  let copy handle = pairchannelconnections_copy handle
  let first handle = pairchannelconnections_first handle
  let second handle = pairchannelconnections_second handle
  let equal handle other = pairchannelconnections_equal handle other
  let not_equal handle other = pairchannelconnections_not_equal handle other
  let to_json_string handle = pairchannelconnections_to_json_string handle
end

class c_listpairchannelconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairchannelconnections_destroy raw_val)) self
end

module ListPairChannelConnections = struct
  type t = c_listpairchannelconnections
  let new_empty () = new c_listpairchannelconnections (listpairchannelconnections_create_empty ())
  let fill_value count value = new c_listpairchannelconnections (listpairchannelconnections_fill_value count value)
  let make data count = new c_listpairchannelconnections (listpairchannelconnections_create data count)
  let from_json_string json = new c_listpairchannelconnections (listpairchannelconnections_from_json_string json)
  let copy handle = listpairchannelconnections_copy handle
  let push_back handle value = listpairchannelconnections_push_back handle value
  let size handle = listpairchannelconnections_size handle
  let empty handle = listpairchannelconnections_empty handle
  let erase_at handle idx = listpairchannelconnections_erase_at handle idx
  let clear handle = listpairchannelconnections_clear handle
  let at handle idx = listpairchannelconnections_at handle idx
  let items handle out_buffer buffer_size = listpairchannelconnections_items handle out_buffer buffer_size
  let contains handle value = listpairchannelconnections_contains handle value
  let index handle value = listpairchannelconnections_index handle value
  let intersection handle other = listpairchannelconnections_intersection handle other
  let equal handle other = listpairchannelconnections_equal handle other
  let not_equal handle other = listpairchannelconnections_not_equal handle other
  let to_json_string handle = listpairchannelconnections_to_json_string handle
end

class c_mapchannelconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapchannelconnections_destroy raw_val)) self
end

module MapChannelConnections = struct
  type t = c_mapchannelconnections
  let new_empty () = new c_mapchannelconnections (mapchannelconnections_create_empty ())
  let make data count = new c_mapchannelconnections (mapchannelconnections_create data count)
  let from_json_string json = new c_mapchannelconnections (mapchannelconnections_from_json_string json)
  let copy handle = mapchannelconnections_copy handle
  let insert_or_assign handle key value = mapchannelconnections_insert_or_assign handle key value
  let insert handle key value = mapchannelconnections_insert handle key value
  let at handle key = mapchannelconnections_at handle key
  let erase handle key = mapchannelconnections_erase handle key
  let size handle = mapchannelconnections_size handle
  let empty handle = mapchannelconnections_empty handle
  let clear handle = mapchannelconnections_clear handle
  let contains handle key = mapchannelconnections_contains handle key
  let keys handle = mapchannelconnections_keys handle
  let values handle = mapchannelconnections_values handle
  let items handle = mapchannelconnections_items handle
  let equal handle other = mapchannelconnections_equal handle other
  let not_equal handle other = mapchannelconnections_not_equal handle other
  let to_json_string handle = mapchannelconnections_to_json_string handle
end

class c_pairgnamegroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairgnamegroup_destroy raw_val)) self
end

module PairGnameGroup = struct
  type t = c_pairgnamegroup
  let make first second = new c_pairgnamegroup (pairgnamegroup_create first second)
  let from_json_string json = new c_pairgnamegroup (pairgnamegroup_from_json_string json)
  let copy handle = pairgnamegroup_copy handle
  let first handle = pairgnamegroup_first handle
  let second handle = pairgnamegroup_second handle
  let equal handle other = pairgnamegroup_equal handle other
  let not_equal handle other = pairgnamegroup_not_equal handle other
  let to_json_string handle = pairgnamegroup_to_json_string handle
end

class c_listpairgnamegroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairgnamegroup_destroy raw_val)) self
end

module ListPairGnameGroup = struct
  type t = c_listpairgnamegroup
  let new_empty () = new c_listpairgnamegroup (listpairgnamegroup_create_empty ())
  let fill_value count value = new c_listpairgnamegroup (listpairgnamegroup_fill_value count value)
  let make data count = new c_listpairgnamegroup (listpairgnamegroup_create data count)
  let from_json_string json = new c_listpairgnamegroup (listpairgnamegroup_from_json_string json)
  let copy handle = listpairgnamegroup_copy handle
  let push_back handle value = listpairgnamegroup_push_back handle value
  let size handle = listpairgnamegroup_size handle
  let empty handle = listpairgnamegroup_empty handle
  let erase_at handle idx = listpairgnamegroup_erase_at handle idx
  let clear handle = listpairgnamegroup_clear handle
  let at handle idx = listpairgnamegroup_at handle idx
  let items handle out_buffer buffer_size = listpairgnamegroup_items handle out_buffer buffer_size
  let contains handle value = listpairgnamegroup_contains handle value
  let index handle value = listpairgnamegroup_index handle value
  let intersection handle other = listpairgnamegroup_intersection handle other
  let equal handle other = listpairgnamegroup_equal handle other
  let not_equal handle other = listpairgnamegroup_not_equal handle other
  let to_json_string handle = listpairgnamegroup_to_json_string handle
end

class c_mapgnamegroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapgnamegroup_destroy raw_val)) self
end

module MapGnameGroup = struct
  type t = c_mapgnamegroup
  let new_empty () = new c_mapgnamegroup (mapgnamegroup_create_empty ())
  let make data count = new c_mapgnamegroup (mapgnamegroup_create data count)
  let from_json_string json = new c_mapgnamegroup (mapgnamegroup_from_json_string json)
  let copy handle = mapgnamegroup_copy handle
  let insert_or_assign handle key value = mapgnamegroup_insert_or_assign handle key value
  let insert handle key value = mapgnamegroup_insert handle key value
  let at handle key = mapgnamegroup_at handle key
  let erase handle key = mapgnamegroup_erase handle key
  let size handle = mapgnamegroup_size handle
  let empty handle = mapgnamegroup_empty handle
  let clear handle = mapgnamegroup_clear handle
  let contains handle key = mapgnamegroup_contains handle key
  let keys handle = mapgnamegroup_keys handle
  let values handle = mapgnamegroup_values handle
  let items handle = mapgnamegroup_items handle
  let equal handle other = mapgnamegroup_equal handle other
  let not_equal handle other = mapgnamegroup_not_equal handle other
  let to_json_string handle = mapgnamegroup_to_json_string handle
end

class c_listmeasurementcontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listmeasurementcontext_destroy raw_val)) self
end

module ListMeasurementContext = struct
  type t = c_listmeasurementcontext
  let new_empty () = new c_listmeasurementcontext (listmeasurementcontext_create_empty ())
  let fill_value count value = new c_listmeasurementcontext (listmeasurementcontext_fill_value count value)
  let make data count = new c_listmeasurementcontext (listmeasurementcontext_create data count)
  let from_json_string json = new c_listmeasurementcontext (listmeasurementcontext_from_json_string json)
  let copy handle = listmeasurementcontext_copy handle
  let push_back handle value = listmeasurementcontext_push_back handle value
  let size handle = listmeasurementcontext_size handle
  let empty handle = listmeasurementcontext_empty handle
  let erase_at handle idx = listmeasurementcontext_erase_at handle idx
  let clear handle = listmeasurementcontext_clear handle
  let at handle idx = listmeasurementcontext_at handle idx
  let items handle out_buffer buffer_size = listmeasurementcontext_items handle out_buffer buffer_size
  let contains handle value = listmeasurementcontext_contains handle value
  let index handle value = listmeasurementcontext_index handle value
  let intersection handle other = listmeasurementcontext_intersection handle other
  let equal handle other = listmeasurementcontext_equal handle other
  let not_equal handle other = listmeasurementcontext_not_equal handle other
  let to_json_string handle = listmeasurementcontext_to_json_string handle
end

class c_listporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listporttransform_destroy raw_val)) self
end

module ListPortTransform = struct
  type t = c_listporttransform
  let new_empty () = new c_listporttransform (listporttransform_create_empty ())
  let fill_value count value = new c_listporttransform (listporttransform_fill_value count value)
  let make data count = new c_listporttransform (listporttransform_create data count)
  let from_json_string json = new c_listporttransform (listporttransform_from_json_string json)
  let copy handle = listporttransform_copy handle
  let push_back handle value = listporttransform_push_back handle value
  let size handle = listporttransform_size handle
  let empty handle = listporttransform_empty handle
  let erase_at handle idx = listporttransform_erase_at handle idx
  let clear handle = listporttransform_clear handle
  let at handle idx = listporttransform_at handle idx
  let items handle out_buffer buffer_size = listporttransform_items handle out_buffer buffer_size
  let contains handle value = listporttransform_contains handle value
  let index handle value = listporttransform_index handle value
  let intersection handle other = listporttransform_intersection handle other
  let equal handle other = listporttransform_equal handle other
  let not_equal handle other = listporttransform_not_equal handle other
  let to_json_string handle = listporttransform_to_json_string handle
end

class c_listwaveform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listwaveform_destroy raw_val)) self
end

module ListWaveform = struct
  type t = c_listwaveform
  let new_empty () = new c_listwaveform (listwaveform_create_empty ())
  let fill_value count value = new c_listwaveform (listwaveform_fill_value count value)
  let make data count = new c_listwaveform (listwaveform_create data count)
  let from_json_string json = new c_listwaveform (listwaveform_from_json_string json)
  let copy handle = listwaveform_copy handle
  let push_back handle value = listwaveform_push_back handle value
  let size handle = listwaveform_size handle
  let empty handle = listwaveform_empty handle
  let erase_at handle idx = listwaveform_erase_at handle idx
  let clear handle = listwaveform_clear handle
  let at handle idx = listwaveform_at handle idx
  let items handle out_buffer buffer_size = listwaveform_items handle out_buffer buffer_size
  let contains handle value = listwaveform_contains handle value
  let index handle value = listwaveform_index handle value
  let intersection handle other = listwaveform_intersection handle other
  let equal handle other = listwaveform_equal handle other
  let not_equal handle other = listwaveform_not_equal handle other
  let to_json_string handle = listwaveform_to_json_string handle
end

class c_pairinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairinstrumentportporttransform_destroy raw_val)) self
end

module PairInstrumentPortPortTransform = struct
  type t = c_pairinstrumentportporttransform
  let make first second = new c_pairinstrumentportporttransform (pairinstrumentportporttransform_create first second)
  let from_json_string json = new c_pairinstrumentportporttransform (pairinstrumentportporttransform_from_json_string json)
  let copy handle = pairinstrumentportporttransform_copy handle
  let first handle = pairinstrumentportporttransform_first handle
  let second handle = pairinstrumentportporttransform_second handle
  let equal handle other = pairinstrumentportporttransform_equal handle other
  let not_equal handle other = pairinstrumentportporttransform_not_equal handle other
  let to_json_string handle = pairinstrumentportporttransform_to_json_string handle
end

class c_listpairinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairinstrumentportporttransform_destroy raw_val)) self
end

module ListPairInstrumentPortPortTransform = struct
  type t = c_listpairinstrumentportporttransform
  let new_empty () = new c_listpairinstrumentportporttransform (listpairinstrumentportporttransform_create_empty ())
  let fill_value count value = new c_listpairinstrumentportporttransform (listpairinstrumentportporttransform_fill_value count value)
  let make data count = new c_listpairinstrumentportporttransform (listpairinstrumentportporttransform_create data count)
  let from_json_string json = new c_listpairinstrumentportporttransform (listpairinstrumentportporttransform_from_json_string json)
  let copy handle = listpairinstrumentportporttransform_copy handle
  let push_back handle value = listpairinstrumentportporttransform_push_back handle value
  let size handle = listpairinstrumentportporttransform_size handle
  let empty handle = listpairinstrumentportporttransform_empty handle
  let erase_at handle idx = listpairinstrumentportporttransform_erase_at handle idx
  let clear handle = listpairinstrumentportporttransform_clear handle
  let at handle idx = listpairinstrumentportporttransform_at handle idx
  let items handle out_buffer buffer_size = listpairinstrumentportporttransform_items handle out_buffer buffer_size
  let contains handle value = listpairinstrumentportporttransform_contains handle value
  let index handle value = listpairinstrumentportporttransform_index handle value
  let intersection handle other = listpairinstrumentportporttransform_intersection handle other
  let equal handle other = listpairinstrumentportporttransform_equal handle other
  let not_equal handle other = listpairinstrumentportporttransform_not_equal handle other
  let to_json_string handle = listpairinstrumentportporttransform_to_json_string handle
end

class c_mapinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapinstrumentportporttransform_destroy raw_val)) self
end

module MapInstrumentPortPortTransform = struct
  type t = c_mapinstrumentportporttransform
  let new_empty () = new c_mapinstrumentportporttransform (mapinstrumentportporttransform_create_empty ())
  let make data count = new c_mapinstrumentportporttransform (mapinstrumentportporttransform_create data count)
  let from_json_string json = new c_mapinstrumentportporttransform (mapinstrumentportporttransform_from_json_string json)
  let copy handle = mapinstrumentportporttransform_copy handle
  let insert_or_assign handle key value = mapinstrumentportporttransform_insert_or_assign handle key value
  let insert handle key value = mapinstrumentportporttransform_insert handle key value
  let at handle key = mapinstrumentportporttransform_at handle key
  let erase handle key = mapinstrumentportporttransform_erase handle key
  let size handle = mapinstrumentportporttransform_size handle
  let empty handle = mapinstrumentportporttransform_empty handle
  let clear handle = mapinstrumentportporttransform_clear handle
  let contains handle key = mapinstrumentportporttransform_contains handle key
  let keys handle = mapinstrumentportporttransform_keys handle
  let values handle = mapinstrumentportporttransform_values handle
  let items handle = mapinstrumentportporttransform_items handle
  let equal handle other = mapinstrumentportporttransform_equal handle other
  let not_equal handle other = mapinstrumentportporttransform_not_equal handle other
  let to_json_string handle = mapinstrumentportporttransform_to_json_string handle
end

class c_listlabelledcontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listlabelledcontrolarray_destroy raw_val)) self
end

module ListLabelledControlArray = struct
  type t = c_listlabelledcontrolarray
  let new_empty () = new c_listlabelledcontrolarray (listlabelledcontrolarray_create_empty ())
  let fill_value count value = new c_listlabelledcontrolarray (listlabelledcontrolarray_fill_value count value)
  let make data count = new c_listlabelledcontrolarray (listlabelledcontrolarray_create data count)
  let from_json_string json = new c_listlabelledcontrolarray (listlabelledcontrolarray_from_json_string json)
  let copy handle = listlabelledcontrolarray_copy handle
  let push_back handle value = listlabelledcontrolarray_push_back handle value
  let size handle = listlabelledcontrolarray_size handle
  let empty handle = listlabelledcontrolarray_empty handle
  let erase_at handle idx = listlabelledcontrolarray_erase_at handle idx
  let clear handle = listlabelledcontrolarray_clear handle
  let at handle idx = listlabelledcontrolarray_at handle idx
  let items handle out_buffer buffer_size = listlabelledcontrolarray_items handle out_buffer buffer_size
  let contains handle value = listlabelledcontrolarray_contains handle value
  let index handle value = listlabelledcontrolarray_index handle value
  let intersection handle other = listlabelledcontrolarray_intersection handle other
  let equal handle other = listlabelledcontrolarray_equal handle other
  let not_equal handle other = listlabelledcontrolarray_not_equal handle other
  let to_json_string handle = listlabelledcontrolarray_to_json_string handle
end

class c_listacquisitioncontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listacquisitioncontext_destroy raw_val)) self
end

module ListAcquisitionContext = struct
  type t = c_listacquisitioncontext
  let new_empty () = new c_listacquisitioncontext (listacquisitioncontext_create_empty ())
  let fill_value count value = new c_listacquisitioncontext (listacquisitioncontext_fill_value count value)
  let make data count = new c_listacquisitioncontext (listacquisitioncontext_create data count)
  let from_json_string json = new c_listacquisitioncontext (listacquisitioncontext_from_json_string json)
  let copy handle = listacquisitioncontext_copy handle
  let push_back handle value = listacquisitioncontext_push_back handle value
  let size handle = listacquisitioncontext_size handle
  let empty handle = listacquisitioncontext_empty handle
  let erase_at handle idx = listacquisitioncontext_erase_at handle idx
  let clear handle = listacquisitioncontext_clear handle
  let at handle idx = listacquisitioncontext_at handle idx
  let items handle out_buffer buffer_size = listacquisitioncontext_items handle out_buffer buffer_size
  let contains handle value = listacquisitioncontext_contains handle value
  let index handle value = listacquisitioncontext_index handle value
  let intersection handle other = listacquisitioncontext_intersection handle other
  let equal handle other = listacquisitioncontext_equal handle other
  let not_equal handle other = listacquisitioncontext_not_equal handle other
  let to_json_string handle = listacquisitioncontext_to_json_string handle
end

class c_listlabelledcontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listlabelledcontrolarray1d_destroy raw_val)) self
end

module ListLabelledControlArray1D = struct
  type t = c_listlabelledcontrolarray1d
  let new_empty () = new c_listlabelledcontrolarray1d (listlabelledcontrolarray1d_create_empty ())
  let fill_value count value = new c_listlabelledcontrolarray1d (listlabelledcontrolarray1d_fill_value count value)
  let make data count = new c_listlabelledcontrolarray1d (listlabelledcontrolarray1d_create data count)
  let from_json_string json = new c_listlabelledcontrolarray1d (listlabelledcontrolarray1d_from_json_string json)
  let copy handle = listlabelledcontrolarray1d_copy handle
  let push_back handle value = listlabelledcontrolarray1d_push_back handle value
  let size handle = listlabelledcontrolarray1d_size handle
  let empty handle = listlabelledcontrolarray1d_empty handle
  let erase_at handle idx = listlabelledcontrolarray1d_erase_at handle idx
  let clear handle = listlabelledcontrolarray1d_clear handle
  let at handle idx = listlabelledcontrolarray1d_at handle idx
  let items handle out_buffer buffer_size = listlabelledcontrolarray1d_items handle out_buffer buffer_size
  let contains handle value = listlabelledcontrolarray1d_contains handle value
  let index handle value = listlabelledcontrolarray1d_index handle value
  let intersection handle other = listlabelledcontrolarray1d_intersection handle other
  let equal handle other = listlabelledcontrolarray1d_equal handle other
  let not_equal handle other = listlabelledcontrolarray1d_not_equal handle other
  let to_json_string handle = listlabelledcontrolarray1d_to_json_string handle
end

class c_listlabelledmeasuredarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listlabelledmeasuredarray_destroy raw_val)) self
end

module ListLabelledMeasuredArray = struct
  type t = c_listlabelledmeasuredarray
  let new_empty () = new c_listlabelledmeasuredarray (listlabelledmeasuredarray_create_empty ())
  let fill_value count value = new c_listlabelledmeasuredarray (listlabelledmeasuredarray_fill_value count value)
  let make data count = new c_listlabelledmeasuredarray (listlabelledmeasuredarray_create data count)
  let from_json_string json = new c_listlabelledmeasuredarray (listlabelledmeasuredarray_from_json_string json)
  let copy handle = listlabelledmeasuredarray_copy handle
  let push_back handle value = listlabelledmeasuredarray_push_back handle value
  let size handle = listlabelledmeasuredarray_size handle
  let empty handle = listlabelledmeasuredarray_empty handle
  let erase_at handle idx = listlabelledmeasuredarray_erase_at handle idx
  let clear handle = listlabelledmeasuredarray_clear handle
  let at handle idx = listlabelledmeasuredarray_at handle idx
  let items handle out_buffer buffer_size = listlabelledmeasuredarray_items handle out_buffer buffer_size
  let contains handle value = listlabelledmeasuredarray_contains handle value
  let index handle value = listlabelledmeasuredarray_index handle value
  let intersection handle other = listlabelledmeasuredarray_intersection handle other
  let equal handle other = listlabelledmeasuredarray_equal handle other
  let not_equal handle other = listlabelledmeasuredarray_not_equal handle other
  let to_json_string handle = listlabelledmeasuredarray_to_json_string handle
end

class c_listlabelledmeasuredarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listlabelledmeasuredarray1d_destroy raw_val)) self
end

module ListLabelledMeasuredArray1D = struct
  type t = c_listlabelledmeasuredarray1d
  let new_empty () = new c_listlabelledmeasuredarray1d (listlabelledmeasuredarray1d_create_empty ())
  let fill_value count value = new c_listlabelledmeasuredarray1d (listlabelledmeasuredarray1d_fill_value count value)
  let make data count = new c_listlabelledmeasuredarray1d (listlabelledmeasuredarray1d_create data count)
  let from_json_string json = new c_listlabelledmeasuredarray1d (listlabelledmeasuredarray1d_from_json_string json)
  let copy handle = listlabelledmeasuredarray1d_copy handle
  let push_back handle value = listlabelledmeasuredarray1d_push_back handle value
  let size handle = listlabelledmeasuredarray1d_size handle
  let empty handle = listlabelledmeasuredarray1d_empty handle
  let erase_at handle idx = listlabelledmeasuredarray1d_erase_at handle idx
  let clear handle = listlabelledmeasuredarray1d_clear handle
  let at handle idx = listlabelledmeasuredarray1d_at handle idx
  let items handle out_buffer buffer_size = listlabelledmeasuredarray1d_items handle out_buffer buffer_size
  let contains handle value = listlabelledmeasuredarray1d_contains handle value
  let index handle value = listlabelledmeasuredarray1d_index handle value
  let intersection handle other = listlabelledmeasuredarray1d_intersection handle other
  let equal handle other = listlabelledmeasuredarray1d_equal handle other
  let not_equal handle other = listlabelledmeasuredarray1d_not_equal handle other
  let to_json_string handle = listlabelledmeasuredarray1d_to_json_string handle
end

class c_pairstringstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairstringstring_destroy raw_val)) self
end

module PairStringString = struct
  type t = c_pairstringstring
  let make first second = new c_pairstringstring (pairstringstring_create first second)
  let from_json_string json = new c_pairstringstring (pairstringstring_from_json_string json)
  let copy handle = pairstringstring_copy handle
  let first handle = pairstringstring_first handle
  let second handle = pairstringstring_second handle
  let equal handle other = pairstringstring_equal handle other
  let not_equal handle other = pairstringstring_not_equal handle other
  let to_json_string handle = pairstringstring_to_json_string handle
end

class c_listpairstringstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairstringstring_destroy raw_val)) self
end

module ListPairStringString = struct
  type t = c_listpairstringstring
  let new_empty () = new c_listpairstringstring (listpairstringstring_create_empty ())
  let fill_value count value = new c_listpairstringstring (listpairstringstring_fill_value count value)
  let make data count = new c_listpairstringstring (listpairstringstring_create data count)
  let from_json_string json = new c_listpairstringstring (listpairstringstring_from_json_string json)
  let copy handle = listpairstringstring_copy handle
  let push_back handle value = listpairstringstring_push_back handle value
  let size handle = listpairstringstring_size handle
  let empty handle = listpairstringstring_empty handle
  let erase_at handle idx = listpairstringstring_erase_at handle idx
  let clear handle = listpairstringstring_clear handle
  let at handle idx = listpairstringstring_at handle idx
  let items handle out_buffer buffer_size = listpairstringstring_items handle out_buffer buffer_size
  let contains handle value = listpairstringstring_contains handle value
  let index handle value = listpairstringstring_index handle value
  let intersection handle other = listpairstringstring_intersection handle other
  let equal handle other = listpairstringstring_equal handle other
  let not_equal handle other = listpairstringstring_not_equal handle other
  let to_json_string handle = listpairstringstring_to_json_string handle
end

class c_mapstringstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapstringstring_destroy raw_val)) self
end

module MapStringString = struct
  type t = c_mapstringstring
  let new_empty () = new c_mapstringstring (mapstringstring_create_empty ())
  let make data count = new c_mapstringstring (mapstringstring_create data count)
  let from_json_string json = new c_mapstringstring (mapstringstring_from_json_string json)
  let copy handle = mapstringstring_copy handle
  let insert_or_assign handle key value = mapstringstring_insert_or_assign handle key value
  let insert handle key value = mapstringstring_insert handle key value
  let at handle key = mapstringstring_at handle key
  let erase handle key = mapstringstring_erase handle key
  let size handle = mapstringstring_size handle
  let empty handle = mapstringstring_empty handle
  let clear handle = mapstringstring_clear handle
  let contains handle key = mapstringstring_contains handle key
  let keys handle = mapstringstring_keys handle
  let values handle = mapstringstring_values handle
  let items handle = mapstringstring_items handle
  let equal handle other = mapstringstring_equal handle other
  let not_equal handle other = mapstringstring_not_equal handle other
  let to_json_string handle = mapstringstring_to_json_string handle
end

class c_pairmeasurementresponsemeasurementrequest (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairmeasurementresponsemeasurementrequest_destroy raw_val)) self
end

module PairMeasurementResponseMeasurementRequest = struct
  type t = c_pairmeasurementresponsemeasurementrequest
  let make first second = new c_pairmeasurementresponsemeasurementrequest (pairmeasurementresponsemeasurementrequest_create first second)
  let from_json_string json = new c_pairmeasurementresponsemeasurementrequest (pairmeasurementresponsemeasurementrequest_from_json_string json)
  let copy handle = pairmeasurementresponsemeasurementrequest_copy handle
  let first handle = pairmeasurementresponsemeasurementrequest_first handle
  let second handle = pairmeasurementresponsemeasurementrequest_second handle
  let equal handle other = pairmeasurementresponsemeasurementrequest_equal handle other
  let not_equal handle other = pairmeasurementresponsemeasurementrequest_not_equal handle other
  let to_json_string handle = pairmeasurementresponsemeasurementrequest_to_json_string handle
end

class c_listinterpretationcontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listinterpretationcontext_destroy raw_val)) self
end

module ListInterpretationContext = struct
  type t = c_listinterpretationcontext
  let new_empty () = new c_listinterpretationcontext (listinterpretationcontext_create_empty ())
  let fill_value count value = new c_listinterpretationcontext (listinterpretationcontext_fill_value count value)
  let make data count = new c_listinterpretationcontext (listinterpretationcontext_create data count)
  let from_json_string json = new c_listinterpretationcontext (listinterpretationcontext_from_json_string json)
  let copy handle = listinterpretationcontext_copy handle
  let push_back handle value = listinterpretationcontext_push_back handle value
  let size handle = listinterpretationcontext_size handle
  let empty handle = listinterpretationcontext_empty handle
  let erase_at handle idx = listinterpretationcontext_erase_at handle idx
  let clear handle = listinterpretationcontext_clear handle
  let at handle idx = listinterpretationcontext_at handle idx
  let items handle out_buffer buffer_size = listinterpretationcontext_items handle out_buffer buffer_size
  let contains handle value = listinterpretationcontext_contains handle value
  let index handle value = listinterpretationcontext_index handle value
  let intersection handle other = listinterpretationcontext_intersection handle other
  let equal handle other = listinterpretationcontext_equal handle other
  let not_equal handle other = listinterpretationcontext_not_equal handle other
  let to_json_string handle = listinterpretationcontext_to_json_string handle
end

class c_pairinterpretationcontextdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairinterpretationcontextdouble_destroy raw_val)) self
end

module PairInterpretationContextDouble = struct
  type t = c_pairinterpretationcontextdouble
  let make first second = new c_pairinterpretationcontextdouble (pairinterpretationcontextdouble_create first second)
  let from_json_string json = new c_pairinterpretationcontextdouble (pairinterpretationcontextdouble_from_json_string json)
  let copy handle = pairinterpretationcontextdouble_copy handle
  let first handle = pairinterpretationcontextdouble_first handle
  let second handle = pairinterpretationcontextdouble_second handle
  let equal handle other = pairinterpretationcontextdouble_equal handle other
  let not_equal handle other = pairinterpretationcontextdouble_not_equal handle other
  let to_json_string handle = pairinterpretationcontextdouble_to_json_string handle
end

class c_listpairinterpretationcontextdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairinterpretationcontextdouble_destroy raw_val)) self
end

module ListPairInterpretationContextDouble = struct
  type t = c_listpairinterpretationcontextdouble
  let new_empty () = new c_listpairinterpretationcontextdouble (listpairinterpretationcontextdouble_create_empty ())
  let fill_value count value = new c_listpairinterpretationcontextdouble (listpairinterpretationcontextdouble_fill_value count value)
  let make data count = new c_listpairinterpretationcontextdouble (listpairinterpretationcontextdouble_create data count)
  let from_json_string json = new c_listpairinterpretationcontextdouble (listpairinterpretationcontextdouble_from_json_string json)
  let copy handle = listpairinterpretationcontextdouble_copy handle
  let push_back handle value = listpairinterpretationcontextdouble_push_back handle value
  let size handle = listpairinterpretationcontextdouble_size handle
  let empty handle = listpairinterpretationcontextdouble_empty handle
  let erase_at handle idx = listpairinterpretationcontextdouble_erase_at handle idx
  let clear handle = listpairinterpretationcontextdouble_clear handle
  let at handle idx = listpairinterpretationcontextdouble_at handle idx
  let items handle out_buffer buffer_size = listpairinterpretationcontextdouble_items handle out_buffer buffer_size
  let contains handle value = listpairinterpretationcontextdouble_contains handle value
  let index handle value = listpairinterpretationcontextdouble_index handle value
  let intersection handle other = listpairinterpretationcontextdouble_intersection handle other
  let equal handle other = listpairinterpretationcontextdouble_equal handle other
  let not_equal handle other = listpairinterpretationcontextdouble_not_equal handle other
  let to_json_string handle = listpairinterpretationcontextdouble_to_json_string handle
end

class c_mapinterpretationcontextdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapinterpretationcontextdouble_destroy raw_val)) self
end

module MapInterpretationContextDouble = struct
  type t = c_mapinterpretationcontextdouble
  let new_empty () = new c_mapinterpretationcontextdouble (mapinterpretationcontextdouble_create_empty ())
  let make data count = new c_mapinterpretationcontextdouble (mapinterpretationcontextdouble_create data count)
  let from_json_string json = new c_mapinterpretationcontextdouble (mapinterpretationcontextdouble_from_json_string json)
  let copy handle = mapinterpretationcontextdouble_copy handle
  let insert_or_assign handle key value = mapinterpretationcontextdouble_insert_or_assign handle key value
  let insert handle key value = mapinterpretationcontextdouble_insert handle key value
  let at handle key = mapinterpretationcontextdouble_at handle key
  let erase handle key = mapinterpretationcontextdouble_erase handle key
  let size handle = mapinterpretationcontextdouble_size handle
  let empty handle = mapinterpretationcontextdouble_empty handle
  let clear handle = mapinterpretationcontextdouble_clear handle
  let contains handle key = mapinterpretationcontextdouble_contains handle key
  let keys handle = mapinterpretationcontextdouble_keys handle
  let values handle = mapinterpretationcontextdouble_values handle
  let items handle = mapinterpretationcontextdouble_items handle
  let equal handle other = mapinterpretationcontextdouble_equal handle other
  let not_equal handle other = mapinterpretationcontextdouble_not_equal handle other
  let to_json_string handle = mapinterpretationcontextdouble_to_json_string handle
end

class c_pairinterpretationcontextstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairinterpretationcontextstring_destroy raw_val)) self
end

module PairInterpretationContextString = struct
  type t = c_pairinterpretationcontextstring
  let make first second = new c_pairinterpretationcontextstring (pairinterpretationcontextstring_create first second)
  let from_json_string json = new c_pairinterpretationcontextstring (pairinterpretationcontextstring_from_json_string json)
  let copy handle = pairinterpretationcontextstring_copy handle
  let first handle = pairinterpretationcontextstring_first handle
  let second handle = pairinterpretationcontextstring_second handle
  let equal handle other = pairinterpretationcontextstring_equal handle other
  let not_equal handle other = pairinterpretationcontextstring_not_equal handle other
  let to_json_string handle = pairinterpretationcontextstring_to_json_string handle
end

class c_mapinterpretationcontextstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapinterpretationcontextstring_destroy raw_val)) self
end

module MapInterpretationContextString = struct
  type t = c_mapinterpretationcontextstring
  let new_empty () = new c_mapinterpretationcontextstring (mapinterpretationcontextstring_create_empty ())
  let make data count = new c_mapinterpretationcontextstring (mapinterpretationcontextstring_create data count)
  let from_json_string json = new c_mapinterpretationcontextstring (mapinterpretationcontextstring_from_json_string json)
  let copy handle = mapinterpretationcontextstring_copy handle
  let insert_or_assign handle key value = mapinterpretationcontextstring_insert_or_assign handle key value
  let insert handle key value = mapinterpretationcontextstring_insert handle key value
  let at handle key = mapinterpretationcontextstring_at handle key
  let erase handle key = mapinterpretationcontextstring_erase handle key
  let size handle = mapinterpretationcontextstring_size handle
  let empty handle = mapinterpretationcontextstring_empty handle
  let clear handle = mapinterpretationcontextstring_clear handle
  let contains handle key = mapinterpretationcontextstring_contains handle key
  let keys handle = mapinterpretationcontextstring_keys handle
  let values handle = mapinterpretationcontextstring_values handle
  let items handle = mapinterpretationcontextstring_items handle
  let equal handle other = mapinterpretationcontextstring_equal handle other
  let not_equal handle other = mapinterpretationcontextstring_not_equal handle other
  let to_json_string handle = mapinterpretationcontextstring_to_json_string handle
end

class c_listpairinterpretationcontextstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairinterpretationcontextstring_destroy raw_val)) self
end

module ListPairInterpretationContextString = struct
  type t = c_listpairinterpretationcontextstring
  let new_empty () = new c_listpairinterpretationcontextstring (listpairinterpretationcontextstring_create_empty ())
  let fill_value count value = new c_listpairinterpretationcontextstring (listpairinterpretationcontextstring_fill_value count value)
  let make data count = new c_listpairinterpretationcontextstring (listpairinterpretationcontextstring_create data count)
  let from_json_string json = new c_listpairinterpretationcontextstring (listpairinterpretationcontextstring_from_json_string json)
  let copy handle = listpairinterpretationcontextstring_copy handle
  let push_back handle value = listpairinterpretationcontextstring_push_back handle value
  let size handle = listpairinterpretationcontextstring_size handle
  let empty handle = listpairinterpretationcontextstring_empty handle
  let erase_at handle idx = listpairinterpretationcontextstring_erase_at handle idx
  let clear handle = listpairinterpretationcontextstring_clear handle
  let at handle idx = listpairinterpretationcontextstring_at handle idx
  let items handle out_buffer buffer_size = listpairinterpretationcontextstring_items handle out_buffer buffer_size
  let contains handle value = listpairinterpretationcontextstring_contains handle value
  let index handle value = listpairinterpretationcontextstring_index handle value
  let intersection handle other = listpairinterpretationcontextstring_intersection handle other
  let equal handle other = listpairinterpretationcontextstring_equal handle other
  let not_equal handle other = listpairinterpretationcontextstring_not_equal handle other
  let to_json_string handle = listpairinterpretationcontextstring_to_json_string handle
end

class c_pairinterpretationcontextquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (pairinterpretationcontextquantity_destroy raw_val)) self
end

module PairInterpretationContextQuantity = struct
  type t = c_pairinterpretationcontextquantity
  let make first second = new c_pairinterpretationcontextquantity (pairinterpretationcontextquantity_create first second)
  let from_json_string json = new c_pairinterpretationcontextquantity (pairinterpretationcontextquantity_from_json_string json)
  let copy handle = pairinterpretationcontextquantity_copy handle
  let first handle = pairinterpretationcontextquantity_first handle
  let second handle = pairinterpretationcontextquantity_second handle
  let equal handle other = pairinterpretationcontextquantity_equal handle other
  let not_equal handle other = pairinterpretationcontextquantity_not_equal handle other
  let to_json_string handle = pairinterpretationcontextquantity_to_json_string handle
end

class c_listpairinterpretationcontextquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (listpairinterpretationcontextquantity_destroy raw_val)) self
end

module ListPairInterpretationContextQuantity = struct
  type t = c_listpairinterpretationcontextquantity
  let new_empty () = new c_listpairinterpretationcontextquantity (listpairinterpretationcontextquantity_create_empty ())
  let fill_value count value = new c_listpairinterpretationcontextquantity (listpairinterpretationcontextquantity_fill_value count value)
  let make data count = new c_listpairinterpretationcontextquantity (listpairinterpretationcontextquantity_create data count)
  let from_json_string json = new c_listpairinterpretationcontextquantity (listpairinterpretationcontextquantity_from_json_string json)
  let copy handle = listpairinterpretationcontextquantity_copy handle
  let push_back handle value = listpairinterpretationcontextquantity_push_back handle value
  let size handle = listpairinterpretationcontextquantity_size handle
  let empty handle = listpairinterpretationcontextquantity_empty handle
  let erase_at handle idx = listpairinterpretationcontextquantity_erase_at handle idx
  let clear handle = listpairinterpretationcontextquantity_clear handle
  let at handle idx = listpairinterpretationcontextquantity_at handle idx
  let items handle out_buffer buffer_size = listpairinterpretationcontextquantity_items handle out_buffer buffer_size
  let contains handle value = listpairinterpretationcontextquantity_contains handle value
  let index handle value = listpairinterpretationcontextquantity_index handle value
  let intersection handle other = listpairinterpretationcontextquantity_intersection handle other
  let equal handle other = listpairinterpretationcontextquantity_equal handle other
  let not_equal handle other = listpairinterpretationcontextquantity_not_equal handle other
  let to_json_string handle = listpairinterpretationcontextquantity_to_json_string handle
end

class c_mapinterpretationcontextquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (mapinterpretationcontextquantity_destroy raw_val)) self
end

module MapInterpretationContextQuantity = struct
  type t = c_mapinterpretationcontextquantity
  let new_empty () = new c_mapinterpretationcontextquantity (mapinterpretationcontextquantity_create_empty ())
  let make data count = new c_mapinterpretationcontextquantity (mapinterpretationcontextquantity_create data count)
  let from_json_string json = new c_mapinterpretationcontextquantity (mapinterpretationcontextquantity_from_json_string json)
  let copy handle = mapinterpretationcontextquantity_copy handle
  let insert_or_assign handle key value = mapinterpretationcontextquantity_insert_or_assign handle key value
  let insert handle key value = mapinterpretationcontextquantity_insert handle key value
  let at handle key = mapinterpretationcontextquantity_at handle key
  let erase handle key = mapinterpretationcontextquantity_erase handle key
  let size handle = mapinterpretationcontextquantity_size handle
  let empty handle = mapinterpretationcontextquantity_empty handle
  let clear handle = mapinterpretationcontextquantity_clear handle
  let contains handle key = mapinterpretationcontextquantity_contains handle key
  let keys handle = mapinterpretationcontextquantity_keys handle
  let values handle = mapinterpretationcontextquantity_values handle
  let items handle = mapinterpretationcontextquantity_items handle
  let equal handle other = mapinterpretationcontextquantity_equal handle other
  let not_equal handle other = mapinterpretationcontextquantity_not_equal handle other
  let to_json_string handle = mapinterpretationcontextquantity_to_json_string handle
end

class c_waveform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (waveform_destroy raw_val)) self
end

module Waveform = struct
  type t = c_waveform
  let from_json_string json = new c_waveform (waveform_from_json_string json)
  let make space transforms = new c_waveform (waveform_create space transforms)
  let new_cartesian_waveform divisions axes increasing transforms domain = new c_waveform (waveform_create_cartesian_waveform divisions axes increasing transforms domain)
  let new_cartesian_identity_waveform divisions axes increasing domain = new c_waveform (waveform_create_cartesian_identity_waveform divisions axes increasing domain)
  let new_cartesian_waveform_2d divisions axes increasing transforms domain = new c_waveform (waveform_create_cartesian_waveform_2d divisions axes increasing transforms domain)
  let new_cartesian_identity_waveform_2d divisions axes increasing domain = new c_waveform (waveform_create_cartesian_identity_waveform_2d divisions axes increasing domain)
  let new_cartesian_waveform_1d division shared_domain increasing transforms domain = new c_waveform (waveform_create_cartesian_waveform_1d division shared_domain increasing transforms domain)
  let new_cartesian_identity_waveform_1d division shared_domain increasing domain = new c_waveform (waveform_create_cartesian_identity_waveform_1d division shared_domain increasing domain)
  let copy handle = waveform_copy handle
  let equal handle other = waveform_equal handle other
  let not_equal handle other = waveform_not_equal handle other
  let to_json_string handle = waveform_to_json_string handle
  let space handle = waveform_space handle
  let transforms handle = waveform_transforms handle
  let push_back handle value = waveform_push_back handle value
  let size handle = waveform_size handle
  let empty handle = waveform_empty handle
  let erase_at handle idx = waveform_erase_at handle idx
  let clear handle = waveform_clear handle
  let at handle idx = waveform_at handle idx
  let items handle = waveform_items handle
  let contains handle value = waveform_contains handle value
  let index handle value = waveform_index handle value
  let intersection handle other = waveform_intersection handle other
end

class c_analyticfunction (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (analyticfunction_destroy raw_val)) self
end

module AnalyticFunction = struct
  type t = c_analyticfunction
  let from_json_string json = new c_analyticfunction (analyticfunction_from_json_string json)
  let make labels expression = new c_analyticfunction (analyticfunction_create labels expression)
  let new_identity () = new c_analyticfunction (analyticfunction_create_identity ())
  let new_constant value = new c_analyticfunction (analyticfunction_create_constant value)
  let copy handle = analyticfunction_copy handle
  let equal handle other = analyticfunction_equal handle other
  let not_equal handle other = analyticfunction_not_equal handle other
  let to_json_string handle = analyticfunction_to_json_string handle
  let labels handle = analyticfunction_labels handle
  let evaluate handle args time = analyticfunction_evaluate handle args time
  let evaluate_arraywise handle args deltaT maxTime = analyticfunction_evaluate_arraywise handle args deltaT maxTime
end

class c_point (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (point_destroy raw_val)) self
end

module Point = struct
  type t = c_point
  let from_json_string json = new c_point (point_from_json_string json)
  let new_empty () = new c_point (point_create_empty ())
  let make items unit = new c_point (point_create items unit)
  let new_from_parent items = new c_point (point_create_from_parent items)
  let copy handle = point_copy handle
  let equal handle other = point_equal handle other
  let not_equal handle other = point_not_equal handle other
  let to_json_string handle = point_to_json_string handle
  let unit handle = point_unit handle
  let insert_or_assign handle key value = point_insert_or_assign handle key value
  let insert handle key value = point_insert handle key value
  let at handle key = point_at handle key
  let erase handle key = point_erase handle key
  let size handle = point_size handle
  let empty handle = point_empty handle
  let clear handle = point_clear handle
  let contains handle key = point_contains handle key
  let keys handle = point_keys handle
  let values handle = point_values handle
  let items handle = point_items handle
  let coordinates handle = point_coordinates handle
  let connections handle = point_connections handle
  let addition handle other = point_addition handle other
  let subtraction handle other = point_subtraction handle other
  let multiplication handle scalar = point_multiplication handle scalar
  let division handle scalar = point_division handle scalar
  let negation handle = point_negation handle
  let set_unit handle unit = point_set_unit handle unit
end

class c_quantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (quantity_destroy raw_val)) self
end

module Quantity = struct
  type t = c_quantity
  let from_json_string json = new c_quantity (quantity_from_json_string json)
  let make value unit = new c_quantity (quantity_create value unit)
  let copy handle = quantity_copy handle
  let equal handle other = quantity_equal handle other
  let not_equal handle other = quantity_not_equal handle other
  let to_json_string handle = quantity_to_json_string handle
  let value handle = quantity_value handle
  let unit handle = quantity_unit handle
  let convert_to handle target_unit = quantity_convert_to handle target_unit
  let multiply_int handle other = quantity_multiply_int handle other
  let multiply_double handle other = quantity_multiply_double handle other
  let multiply_quantity handle other = quantity_multiply_quantity handle other
  let multiply_equals_int handle other = quantity_multiply_equals_int handle other
  let multiply_equals_double handle other = quantity_multiply_equals_double handle other
  let multiply_equals_quantity handle other = quantity_multiply_equals_quantity handle other
  let divide_int handle other = quantity_divide_int handle other
  let divide_double handle other = quantity_divide_double handle other
  let divide_quantity handle other = quantity_divide_quantity handle other
  let divide_equals_int handle other = quantity_divide_equals_int handle other
  let divide_equals_double handle other = quantity_divide_equals_double handle other
  let divide_equals_quantity handle other = quantity_divide_equals_quantity handle other
  let power handle other = quantity_power handle other
  let add_quantity handle other = quantity_add_quantity handle other
  let add_equals_quantity handle other = quantity_add_equals_quantity handle other
  let subtract_quantity handle other = quantity_subtract_quantity handle other
  let subtract_equals_quantity handle other = quantity_subtract_equals_quantity handle other
  let negate handle = quantity_negate handle
  let abs handle = quantity_abs handle
end

class c_unitspace (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (unitspace_destroy raw_val)) self
end

module UnitSpace = struct
  type t = c_unitspace
  let from_json_string json = new c_unitspace (unitspace_from_json_string json)
  let make axes domain = new c_unitspace (unitspace_create axes domain)
  let new_ray_space dr dtheta domain = new c_unitspace (unitspace_create_ray_space dr dtheta domain)
  let new_cartesian_space deltas domain = new c_unitspace (unitspace_create_cartesian_space deltas domain)
  let new_cartesian_1d_space delta domain = new c_unitspace (unitspace_create_cartesian_1d_space delta domain)
  let new_cartesian_2d_space deltas domain = new c_unitspace (unitspace_create_cartesian_2d_space deltas domain)
  let new_array handle axes = new c_unitspace (unitspace_create_array handle axes)
  let copy handle = unitspace_copy handle
  let equal handle other = unitspace_equal handle other
  let not_equal handle other = unitspace_not_equal handle other
  let to_json_string handle = unitspace_to_json_string handle
  let axes handle = unitspace_axes handle
  let domain handle = unitspace_domain handle
  let space handle = unitspace_space handle
  let shape handle = unitspace_shape handle
  let dimension handle = unitspace_dimension handle
  let compile handle = unitspace_compile handle
  let push_back handle value = unitspace_push_back handle value
  let size handle = unitspace_size handle
  let empty handle = unitspace_empty handle
  let erase_at handle idx = unitspace_erase_at handle idx
  let clear handle = unitspace_clear handle
  let at handle idx = unitspace_at handle idx
  let items handle out_buffer buffer_size = unitspace_items handle out_buffer buffer_size
  let contains handle value = unitspace_contains handle value
  let index handle value = unitspace_index handle value
  let intersection handle other = unitspace_intersection handle other
end

class c_vector (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (vector_destroy raw_val)) self
end

module Vector = struct
  type t = c_vector
  let from_json_string json = new c_vector (vector_from_json_string json)
  let make start end_ = new c_vector (vector_create start end_)
  let new_from_end end_ = new c_vector (vector_create_from_end end_)
  let new_from_quantities start end_ = new c_vector (vector_create_from_quantities start end_)
  let new_from_end_quantities end_ = new c_vector (vector_create_from_end_quantities end_)
  let new_from_doubles start end_ unit = new c_vector (vector_create_from_doubles start end_ unit)
  let new_from_end_doubles end_ unit = new c_vector (vector_create_from_end_doubles end_ unit)
  let new_from_parent items = new c_vector (vector_create_from_parent items)
  let copy handle = vector_copy handle
  let equal handle other = vector_equal handle other
  let not_equal handle other = vector_not_equal handle other
  let to_json_string handle = vector_to_json_string handle
  let end_point handle = vector_end_point handle
  let start_point handle = vector_start_point handle
  let end_quantities handle = vector_end_quantities handle
  let start_quantities handle = vector_start_quantities handle
  let end_map handle = vector_end_map handle
  let start_map handle = vector_start_map handle
  let connections handle = vector_connections handle
  let unit handle = vector_unit handle
  let principle_connection handle = vector_principle_connection handle
  let magnitude handle = vector_magnitude handle
  let insert_or_assign handle key value = vector_insert_or_assign handle key value
  let insert handle key value = vector_insert handle key value
  let at handle key = vector_at handle key
  let erase handle key = vector_erase handle key
  let size handle = vector_size handle
  let empty handle = vector_empty handle
  let clear handle = vector_clear handle
  let contains handle key = vector_contains handle key
  let keys handle = vector_keys handle
  let values handle = vector_values handle
  let items handle = vector_items handle
  let addition handle other = vector_addition handle other
  let subtraction handle other = vector_subtraction handle other
  let double_multiplication handle scalar = vector_double_multiplication handle scalar
  let int_multiplication handle scalar = vector_int_multiplication handle scalar
  let double_division handle scalar = vector_double_division handle scalar
  let int_division handle scalar = vector_int_division handle scalar
  let negation handle = vector_negation handle
  let update_start_from_states handle state = vector_update_start_from_states handle state
  let translate_doubles handle point unit = vector_translate_doubles handle point unit
  let translate_quantities handle point = vector_translate_quantities handle point
  let translate handle point = vector_translate handle point
  let translate_to_origin handle = vector_translate_to_origin handle
  let double_extend handle extension = vector_double_extend handle extension
  let int_extend handle extension = vector_int_extend handle extension
  let double_shrink handle extension = vector_double_shrink handle extension
  let int_shrink handle extension = vector_int_shrink handle extension
  let unit_vector handle = vector_unit_vector handle
  let normalize handle = vector_normalize handle
  let project handle other = vector_project handle other
  let update_unit handle unit = vector_update_unit handle unit
end

class c_axesdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axesdouble_destroy raw_val)) self
end

module AxesDouble = struct
  type t = c_axesdouble
  let new_empty () = new c_axesdouble (axesdouble_create_empty ())
  let make data = new c_axesdouble (axesdouble_create data)
  let from_json_string json = new c_axesdouble (axesdouble_from_json_string json)
  let copy handle = axesdouble_copy handle
  let push_back handle value = axesdouble_push_back handle value
  let size handle = axesdouble_size handle
  let empty handle = axesdouble_empty handle
  let erase_at handle idx = axesdouble_erase_at handle idx
  let clear handle = axesdouble_clear handle
  let at handle idx = axesdouble_at handle idx
  let items handle out_buffer buffer_size = axesdouble_items handle out_buffer buffer_size
  let contains handle value = axesdouble_contains handle value
  let index handle value = axesdouble_index handle value
  let intersection handle other = axesdouble_intersection handle other
  let equal handle other = axesdouble_equal handle other
  let not_equal handle other = axesdouble_not_equal handle other
  let to_json_string handle = axesdouble_to_json_string handle
end

class c_axesint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axesint_destroy raw_val)) self
end

module AxesInt = struct
  type t = c_axesint
  let new_empty () = new c_axesint (axesint_create_empty ())
  let make data = new c_axesint (axesint_create data)
  let from_json_string json = new c_axesint (axesint_from_json_string json)
  let copy handle = axesint_copy handle
  let push_back handle value = axesint_push_back handle value
  let size handle = axesint_size handle
  let empty handle = axesint_empty handle
  let erase_at handle idx = axesint_erase_at handle idx
  let clear handle = axesint_clear handle
  let at handle idx = axesint_at handle idx
  let items handle out_buffer buffer_size = axesint_items handle out_buffer buffer_size
  let contains handle value = axesint_contains handle value
  let index handle value = axesint_index handle value
  let intersection handle other = axesint_intersection handle other
  let equal handle other = axesint_equal handle other
  let not_equal handle other = axesint_not_equal handle other
  let to_json_string handle = axesint_to_json_string handle
end

class c_axesdiscretizer (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axesdiscretizer_destroy raw_val)) self
end

module AxesDiscretizer = struct
  type t = c_axesdiscretizer
  let new_empty () = new c_axesdiscretizer (axesdiscretizer_create_empty ())
  let make data = new c_axesdiscretizer (axesdiscretizer_create data)
  let from_json_string json = new c_axesdiscretizer (axesdiscretizer_from_json_string json)
  let copy handle = axesdiscretizer_copy handle
  let push_back handle value = axesdiscretizer_push_back handle value
  let size handle = axesdiscretizer_size handle
  let empty handle = axesdiscretizer_empty handle
  let erase_at handle idx = axesdiscretizer_erase_at handle idx
  let clear handle = axesdiscretizer_clear handle
  let at handle idx = axesdiscretizer_at handle idx
  let items handle out_buffer buffer_size = axesdiscretizer_items handle out_buffer buffer_size
  let contains handle value = axesdiscretizer_contains handle value
  let index handle value = axesdiscretizer_index handle value
  let intersection handle other = axesdiscretizer_intersection handle other
  let equal handle other = axesdiscretizer_equal handle other
  let not_equal handle other = axesdiscretizer_not_equal handle other
  let to_json_string handle = axesdiscretizer_to_json_string handle
end

class c_axescontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axescontrolarray_destroy raw_val)) self
end

module AxesControlArray = struct
  type t = c_axescontrolarray
  let new_empty () = new c_axescontrolarray (axescontrolarray_create_empty ())
  let make data = new c_axescontrolarray (axescontrolarray_create data)
  let from_json_string json = new c_axescontrolarray (axescontrolarray_from_json_string json)
  let copy handle = axescontrolarray_copy handle
  let push_back handle value = axescontrolarray_push_back handle value
  let size handle = axescontrolarray_size handle
  let empty handle = axescontrolarray_empty handle
  let erase_at handle idx = axescontrolarray_erase_at handle idx
  let clear handle = axescontrolarray_clear handle
  let at handle idx = axescontrolarray_at handle idx
  let items handle out_buffer buffer_size = axescontrolarray_items handle out_buffer buffer_size
  let contains handle value = axescontrolarray_contains handle value
  let index handle value = axescontrolarray_index handle value
  let intersection handle other = axescontrolarray_intersection handle other
  let equal handle other = axescontrolarray_equal handle other
  let not_equal handle other = axescontrolarray_not_equal handle other
  let to_json_string handle = axescontrolarray_to_json_string handle
end

class c_axescontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axescontrolarray1d_destroy raw_val)) self
end

module AxesControlArray1D = struct
  type t = c_axescontrolarray1d
  let new_empty () = new c_axescontrolarray1d (axescontrolarray1d_create_empty ())
  let make data = new c_axescontrolarray1d (axescontrolarray1d_create data)
  let from_json_string json = new c_axescontrolarray1d (axescontrolarray1d_from_json_string json)
  let copy handle = axescontrolarray1d_copy handle
  let push_back handle value = axescontrolarray1d_push_back handle value
  let size handle = axescontrolarray1d_size handle
  let empty handle = axescontrolarray1d_empty handle
  let erase_at handle idx = axescontrolarray1d_erase_at handle idx
  let clear handle = axescontrolarray1d_clear handle
  let at handle idx = axescontrolarray1d_at handle idx
  let items handle out_buffer buffer_size = axescontrolarray1d_items handle out_buffer buffer_size
  let contains handle value = axescontrolarray1d_contains handle value
  let index handle value = axescontrolarray1d_index handle value
  let intersection handle other = axescontrolarray1d_intersection handle other
  let equal handle other = axescontrolarray1d_equal handle other
  let not_equal handle other = axescontrolarray1d_not_equal handle other
  let to_json_string handle = axescontrolarray1d_to_json_string handle
end

class c_axescoupledlabelleddomain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axescoupledlabelleddomain_destroy raw_val)) self
end

module AxesCoupledLabelledDomain = struct
  type t = c_axescoupledlabelleddomain
  let new_empty () = new c_axescoupledlabelleddomain (axescoupledlabelleddomain_create_empty ())
  let make data = new c_axescoupledlabelleddomain (axescoupledlabelleddomain_create data)
  let from_json_string json = new c_axescoupledlabelleddomain (axescoupledlabelleddomain_from_json_string json)
  let copy handle = axescoupledlabelleddomain_copy handle
  let push_back handle value = axescoupledlabelleddomain_push_back handle value
  let size handle = axescoupledlabelleddomain_size handle
  let empty handle = axescoupledlabelleddomain_empty handle
  let erase_at handle idx = axescoupledlabelleddomain_erase_at handle idx
  let clear handle = axescoupledlabelleddomain_clear handle
  let at handle idx = axescoupledlabelleddomain_at handle idx
  let items handle out_buffer buffer_size = axescoupledlabelleddomain_items handle out_buffer buffer_size
  let contains handle value = axescoupledlabelleddomain_contains handle value
  let index handle value = axescoupledlabelleddomain_index handle value
  let intersection handle other = axescoupledlabelleddomain_intersection handle other
  let equal handle other = axescoupledlabelleddomain_equal handle other
  let not_equal handle other = axescoupledlabelleddomain_not_equal handle other
  let to_json_string handle = axescoupledlabelleddomain_to_json_string handle
end

class c_axesinstrumentport (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axesinstrumentport_destroy raw_val)) self
end

module AxesInstrumentPort = struct
  type t = c_axesinstrumentport
  let new_empty () = new c_axesinstrumentport (axesinstrumentport_create_empty ())
  let make data = new c_axesinstrumentport (axesinstrumentport_create data)
  let from_json_string json = new c_axesinstrumentport (axesinstrumentport_from_json_string json)
  let copy handle = axesinstrumentport_copy handle
  let push_back handle value = axesinstrumentport_push_back handle value
  let size handle = axesinstrumentport_size handle
  let empty handle = axesinstrumentport_empty handle
  let erase_at handle idx = axesinstrumentport_erase_at handle idx
  let clear handle = axesinstrumentport_clear handle
  let at handle idx = axesinstrumentport_at handle idx
  let items handle out_buffer buffer_size = axesinstrumentport_items handle out_buffer buffer_size
  let contains handle value = axesinstrumentport_contains handle value
  let index handle value = axesinstrumentport_index handle value
  let intersection handle other = axesinstrumentport_intersection handle other
  let equal handle other = axesinstrumentport_equal handle other
  let not_equal handle other = axesinstrumentport_not_equal handle other
  let to_json_string handle = axesinstrumentport_to_json_string handle
end

class c_axesmapstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axesmapstringbool_destroy raw_val)) self
end

module AxesMapStringBool = struct
  type t = c_axesmapstringbool
  let new_empty () = new c_axesmapstringbool (axesmapstringbool_create_empty ())
  let make data = new c_axesmapstringbool (axesmapstringbool_create data)
  let from_json_string json = new c_axesmapstringbool (axesmapstringbool_from_json_string json)
  let copy handle = axesmapstringbool_copy handle
  let push_back handle value = axesmapstringbool_push_back handle value
  let size handle = axesmapstringbool_size handle
  let empty handle = axesmapstringbool_empty handle
  let erase_at handle idx = axesmapstringbool_erase_at handle idx
  let clear handle = axesmapstringbool_clear handle
  let at handle idx = axesmapstringbool_at handle idx
  let items handle out_buffer buffer_size = axesmapstringbool_items handle out_buffer buffer_size
  let contains handle value = axesmapstringbool_contains handle value
  let index handle value = axesmapstringbool_index handle value
  let intersection handle other = axesmapstringbool_intersection handle other
  let equal handle other = axesmapstringbool_equal handle other
  let not_equal handle other = axesmapstringbool_not_equal handle other
  let to_json_string handle = axesmapstringbool_to_json_string handle
end

class c_axesmeasurementcontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axesmeasurementcontext_destroy raw_val)) self
end

module AxesMeasurementContext = struct
  type t = c_axesmeasurementcontext
  let new_empty () = new c_axesmeasurementcontext (axesmeasurementcontext_create_empty ())
  let make data = new c_axesmeasurementcontext (axesmeasurementcontext_create data)
  let from_json_string json = new c_axesmeasurementcontext (axesmeasurementcontext_from_json_string json)
  let copy handle = axesmeasurementcontext_copy handle
  let push_back handle value = axesmeasurementcontext_push_back handle value
  let size handle = axesmeasurementcontext_size handle
  let empty handle = axesmeasurementcontext_empty handle
  let erase_at handle idx = axesmeasurementcontext_erase_at handle idx
  let clear handle = axesmeasurementcontext_clear handle
  let at handle idx = axesmeasurementcontext_at handle idx
  let items handle out_buffer buffer_size = axesmeasurementcontext_items handle out_buffer buffer_size
  let contains handle value = axesmeasurementcontext_contains handle value
  let index handle value = axesmeasurementcontext_index handle value
  let intersection handle other = axesmeasurementcontext_intersection handle other
  let equal handle other = axesmeasurementcontext_equal handle other
  let not_equal handle other = axesmeasurementcontext_not_equal handle other
  let to_json_string handle = axesmeasurementcontext_to_json_string handle
end

class c_axeslabelledcontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axeslabelledcontrolarray_destroy raw_val)) self
end

module AxesLabelledControlArray = struct
  type t = c_axeslabelledcontrolarray
  let new_empty () = new c_axeslabelledcontrolarray (axeslabelledcontrolarray_create_empty ())
  let make data = new c_axeslabelledcontrolarray (axeslabelledcontrolarray_create data)
  let from_json_string json = new c_axeslabelledcontrolarray (axeslabelledcontrolarray_from_json_string json)
  let copy handle = axeslabelledcontrolarray_copy handle
  let push_back handle value = axeslabelledcontrolarray_push_back handle value
  let size handle = axeslabelledcontrolarray_size handle
  let empty handle = axeslabelledcontrolarray_empty handle
  let erase_at handle idx = axeslabelledcontrolarray_erase_at handle idx
  let clear handle = axeslabelledcontrolarray_clear handle
  let at handle idx = axeslabelledcontrolarray_at handle idx
  let items handle out_buffer buffer_size = axeslabelledcontrolarray_items handle out_buffer buffer_size
  let contains handle value = axeslabelledcontrolarray_contains handle value
  let index handle value = axeslabelledcontrolarray_index handle value
  let intersection handle other = axeslabelledcontrolarray_intersection handle other
  let equal handle other = axeslabelledcontrolarray_equal handle other
  let not_equal handle other = axeslabelledcontrolarray_not_equal handle other
  let to_json_string handle = axeslabelledcontrolarray_to_json_string handle
end

class c_axeslabelledcontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axeslabelledcontrolarray1d_destroy raw_val)) self
end

module AxesLabelledControlArray1D = struct
  type t = c_axeslabelledcontrolarray1d
  let new_empty () = new c_axeslabelledcontrolarray1d (axeslabelledcontrolarray1d_create_empty ())
  let make data = new c_axeslabelledcontrolarray1d (axeslabelledcontrolarray1d_create data)
  let from_json_string json = new c_axeslabelledcontrolarray1d (axeslabelledcontrolarray1d_from_json_string json)
  let copy handle = axeslabelledcontrolarray1d_copy handle
  let push_back handle value = axeslabelledcontrolarray1d_push_back handle value
  let size handle = axeslabelledcontrolarray1d_size handle
  let empty handle = axeslabelledcontrolarray1d_empty handle
  let erase_at handle idx = axeslabelledcontrolarray1d_erase_at handle idx
  let clear handle = axeslabelledcontrolarray1d_clear handle
  let at handle idx = axeslabelledcontrolarray1d_at handle idx
  let items handle out_buffer buffer_size = axeslabelledcontrolarray1d_items handle out_buffer buffer_size
  let contains handle value = axeslabelledcontrolarray1d_contains handle value
  let index handle value = axeslabelledcontrolarray1d_index handle value
  let intersection handle other = axeslabelledcontrolarray1d_intersection handle other
  let equal handle other = axeslabelledcontrolarray1d_equal handle other
  let not_equal handle other = axeslabelledcontrolarray1d_not_equal handle other
  let to_json_string handle = axeslabelledcontrolarray1d_to_json_string handle
end

class c_axeslabelledmeasuredarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axeslabelledmeasuredarray_destroy raw_val)) self
end

module AxesLabelledMeasuredArray = struct
  type t = c_axeslabelledmeasuredarray
  let new_empty () = new c_axeslabelledmeasuredarray (axeslabelledmeasuredarray_create_empty ())
  let make data = new c_axeslabelledmeasuredarray (axeslabelledmeasuredarray_create data)
  let from_json_string json = new c_axeslabelledmeasuredarray (axeslabelledmeasuredarray_from_json_string json)
  let copy handle = axeslabelledmeasuredarray_copy handle
  let push_back handle value = axeslabelledmeasuredarray_push_back handle value
  let size handle = axeslabelledmeasuredarray_size handle
  let empty handle = axeslabelledmeasuredarray_empty handle
  let erase_at handle idx = axeslabelledmeasuredarray_erase_at handle idx
  let clear handle = axeslabelledmeasuredarray_clear handle
  let at handle idx = axeslabelledmeasuredarray_at handle idx
  let items handle out_buffer buffer_size = axeslabelledmeasuredarray_items handle out_buffer buffer_size
  let contains handle value = axeslabelledmeasuredarray_contains handle value
  let index handle value = axeslabelledmeasuredarray_index handle value
  let intersection handle other = axeslabelledmeasuredarray_intersection handle other
  let equal handle other = axeslabelledmeasuredarray_equal handle other
  let not_equal handle other = axeslabelledmeasuredarray_not_equal handle other
  let to_json_string handle = axeslabelledmeasuredarray_to_json_string handle
end

class c_axeslabelledmeasuredarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (axeslabelledmeasuredarray1d_destroy raw_val)) self
end

module AxesLabelledMeasuredArray1D = struct
  type t = c_axeslabelledmeasuredarray1d
  let new_empty () = new c_axeslabelledmeasuredarray1d (axeslabelledmeasuredarray1d_create_empty ())
  let make data = new c_axeslabelledmeasuredarray1d (axeslabelledmeasuredarray1d_create data)
  let from_json_string json = new c_axeslabelledmeasuredarray1d (axeslabelledmeasuredarray1d_from_json_string json)
  let copy handle = axeslabelledmeasuredarray1d_copy handle
  let push_back handle value = axeslabelledmeasuredarray1d_push_back handle value
  let size handle = axeslabelledmeasuredarray1d_size handle
  let empty handle = axeslabelledmeasuredarray1d_empty handle
  let erase_at handle idx = axeslabelledmeasuredarray1d_erase_at handle idx
  let clear handle = axeslabelledmeasuredarray1d_clear handle
  let at handle idx = axeslabelledmeasuredarray1d_at handle idx
  let items handle out_buffer buffer_size = axeslabelledmeasuredarray1d_items handle out_buffer buffer_size
  let contains handle value = axeslabelledmeasuredarray1d_contains handle value
  let index handle value = axeslabelledmeasuredarray1d_index handle value
  let intersection handle other = axeslabelledmeasuredarray1d_intersection handle other
  let equal handle other = axeslabelledmeasuredarray1d_equal handle other
  let not_equal handle other = axeslabelledmeasuredarray1d_not_equal handle other
  let to_json_string handle = axeslabelledmeasuredarray1d_to_json_string handle
end

class c_loader (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (loader_destroy raw_val)) self
end

module Loader = struct
  type t = c_loader
  let make config_path = new c_loader (loader_create config_path)
  let config handle = loader_config handle
end

class c_connection (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (connection_destroy raw_val)) self
end

module Connection = struct
  type t = c_connection
  let from_json_string json = new c_connection (connection_from_json_string json)
  let new_barrier_gate name = new c_connection (connection_create_barrier_gate name)
  let new_plunger_gate name = new c_connection (connection_create_plunger_gate name)
  let new_reservoir_gate name = new c_connection (connection_create_reservoir_gate name)
  let new_screening_gate name = new c_connection (connection_create_screening_gate name)
  let new_ohmic name = new c_connection (connection_create_ohmic name)
  let copy handle = connection_copy handle
  let equal handle other = connection_equal handle other
  let not_equal handle other = connection_not_equal handle other
  let to_json_string handle = connection_to_json_string handle
  let name handle = connection_name handle
  let type_ handle = connection_type handle
  let is_dot_gate handle = connection_is_dot_gate handle
  let is_barrier_gate handle = connection_is_barrier_gate handle
  let is_plunger_gate handle = connection_is_plunger_gate handle
  let is_reservoir_gate handle = connection_is_reservoir_gate handle
  let is_screening_gate handle = connection_is_screening_gate handle
  let is_ohmic handle = connection_is_ohmic handle
  let is_gate handle = connection_is_gate handle
end

class c_connections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (connections_destroy raw_val)) self
end

module Connections = struct
  type t = c_connections
  let from_json_string json = new c_connections (connections_from_json_string json)
  let new_empty () = new c_connections (connections_create_empty ())
  let make items = new c_connections (connections_create items)
  let copy handle = connections_copy handle
  let equal handle other = connections_equal handle other
  let not_equal handle other = connections_not_equal handle other
  let to_json_string handle = connections_to_json_string handle
  let is_gates handle = connections_is_gates handle
  let is_ohmics handle = connections_is_ohmics handle
  let is_dot_gates handle = connections_is_dot_gates handle
  let is_plunger_gates handle = connections_is_plunger_gates handle
  let is_barrier_gates handle = connections_is_barrier_gates handle
  let is_reservoir_gates handle = connections_is_reservoir_gates handle
  let is_screening_gates handle = connections_is_screening_gates handle
  let intersection handle other = connections_intersection handle other
  let push_back handle value = connections_push_back handle value
  let size handle = connections_size handle
  let empty handle = connections_empty handle
  let erase_at handle idx = connections_erase_at handle idx
  let clear handle = connections_clear handle
  let at handle idx = connections_at handle idx
  let items handle = connections_items handle
  let contains handle value = connections_contains handle value
  let index handle value = connections_index handle value
  let from_list l =
    let c = new_empty () in
    List.iter (fun v -> ignore (push_back c#raw v#raw)) l;
    c
end

class c_gaterelations (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (gaterelations_destroy raw_val)) self
end

module GateRelations = struct
  type t = c_gaterelations
  let from_json_string json = new c_gaterelations (gaterelations_from_json_string json)
  let new_empty () = new c_gaterelations (gaterelations_create_empty ())
  let make items = new c_gaterelations (gaterelations_create items)
  let copy handle = gaterelations_copy handle
  let equal handle other = gaterelations_equal handle other
  let not_equal handle other = gaterelations_not_equal handle other
  let to_json_string handle = gaterelations_to_json_string handle
  let insert_or_assign handle key value = gaterelations_insert_or_assign handle key value
  let insert handle key value = gaterelations_insert handle key value
  let at handle key = gaterelations_at handle key
  let erase handle key = gaterelations_erase handle key
  let size handle = gaterelations_size handle
  let empty handle = gaterelations_empty handle
  let clear handle = gaterelations_clear handle
  let contains handle key = gaterelations_contains handle key
  let keys handle = gaterelations_keys handle
  let values handle = gaterelations_values handle
  let items handle = gaterelations_items handle
end

class c_impedance (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (impedance_destroy raw_val)) self
end

module Impedance = struct
  type t = c_impedance
  let from_json_string json = new c_impedance (impedance_from_json_string json)
  let make connection resistance capacitance = new c_impedance (impedance_create connection resistance capacitance)
  let copy handle = impedance_copy handle
  let equal handle other = impedance_equal handle other
  let not_equal handle other = impedance_not_equal handle other
  let to_json_string handle = impedance_to_json_string handle
  let connection handle = impedance_connection handle
  let resistance handle = impedance_resistance handle
  let capacitance handle = impedance_capacitance handle
end

class c_impedances (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (impedances_destroy raw_val)) self
end

module Impedances = struct
  type t = c_impedances
  let from_json_string json = new c_impedances (impedances_from_json_string json)
  let new_empty () = new c_impedances (impedances_create_empty ())
  let make items = new c_impedances (impedances_create items)
  let copy handle = impedances_copy handle
  let equal handle other = impedances_equal handle other
  let not_equal handle other = impedances_not_equal handle other
  let to_json_string handle = impedances_to_json_string handle
  let push_back handle value = impedances_push_back handle value
  let size handle = impedances_size handle
  let empty handle = impedances_empty handle
  let erase_at handle idx = impedances_erase_at handle idx
  let clear handle = impedances_clear handle
  let at handle idx = impedances_at handle idx
  let items handle = impedances_items handle
  let contains handle value = impedances_contains handle value
  let intersection handle other = impedances_intersection handle other
  let index handle value = impedances_index handle value
end

class c_symbolunit (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (symbolunit_destroy raw_val)) self
end

module SymbolUnit = struct
  type t = c_symbolunit
  let from_json_string json = new c_symbolunit (symbolunit_from_json_string json)
  let new_meter () = new c_symbolunit (symbolunit_create_meter ())
  let new_kilogram () = new c_symbolunit (symbolunit_create_kilogram ())
  let new_second () = new c_symbolunit (symbolunit_create_second ())
  let new_ampere () = new c_symbolunit (symbolunit_create_ampere ())
  let new_kelvin () = new c_symbolunit (symbolunit_create_kelvin ())
  let new_mole () = new c_symbolunit (symbolunit_create_mole ())
  let new_candela () = new c_symbolunit (symbolunit_create_candela ())
  let new_hertz () = new c_symbolunit (symbolunit_create_hertz ())
  let new_newton () = new c_symbolunit (symbolunit_create_newton ())
  let new_pascal () = new c_symbolunit (symbolunit_create_pascal ())
  let new_joule () = new c_symbolunit (symbolunit_create_joule ())
  let new_watt () = new c_symbolunit (symbolunit_create_watt ())
  let new_coulomb () = new c_symbolunit (symbolunit_create_coulomb ())
  let new_volt () = new c_symbolunit (symbolunit_create_volt ())
  let new_farad () = new c_symbolunit (symbolunit_create_farad ())
  let new_ohm () = new c_symbolunit (symbolunit_create_ohm ())
  let new_siemens () = new c_symbolunit (symbolunit_create_siemens ())
  let new_weber () = new c_symbolunit (symbolunit_create_weber ())
  let new_tesla () = new c_symbolunit (symbolunit_create_tesla ())
  let new_henry () = new c_symbolunit (symbolunit_create_henry ())
  let new_minute () = new c_symbolunit (symbolunit_create_minute ())
  let new_hour () = new c_symbolunit (symbolunit_create_hour ())
  let new_electronvolt () = new c_symbolunit (symbolunit_create_electronvolt ())
  let new_celsius () = new c_symbolunit (symbolunit_create_celsius ())
  let new_fahrenheit () = new c_symbolunit (symbolunit_create_fahrenheit ())
  let new_dimensionless () = new c_symbolunit (symbolunit_create_dimensionless ())
  let new_percent () = new c_symbolunit (symbolunit_create_percent ())
  let new_radian () = new c_symbolunit (symbolunit_create_radian ())
  let new_kilometer () = new c_symbolunit (symbolunit_create_kilometer ())
  let new_millimeter () = new c_symbolunit (symbolunit_create_millimeter ())
  let new_millivolt () = new c_symbolunit (symbolunit_create_millivolt ())
  let new_kilovolt () = new c_symbolunit (symbolunit_create_kilovolt ())
  let new_milliampere () = new c_symbolunit (symbolunit_create_milliampere ())
  let new_microampere () = new c_symbolunit (symbolunit_create_microampere ())
  let new_nanoampere () = new c_symbolunit (symbolunit_create_nanoampere ())
  let new_picoampere () = new c_symbolunit (symbolunit_create_picoampere ())
  let new_millisecond () = new c_symbolunit (symbolunit_create_millisecond ())
  let new_microsecond () = new c_symbolunit (symbolunit_create_microsecond ())
  let new_nanosecond () = new c_symbolunit (symbolunit_create_nanosecond ())
  let new_picosecond () = new c_symbolunit (symbolunit_create_picosecond ())
  let new_milliohm () = new c_symbolunit (symbolunit_create_milliohm ())
  let new_kiloohm () = new c_symbolunit (symbolunit_create_kiloohm ())
  let new_megaohm () = new c_symbolunit (symbolunit_create_megaohm ())
  let new_millihertz () = new c_symbolunit (symbolunit_create_millihertz ())
  let new_kilohertz () = new c_symbolunit (symbolunit_create_kilohertz ())
  let new_megahertz () = new c_symbolunit (symbolunit_create_megahertz ())
  let new_gigahertz () = new c_symbolunit (symbolunit_create_gigahertz ())
  let new_meters_per_second () = new c_symbolunit (symbolunit_create_meters_per_second ())
  let new_meters_per_second_squared () = new c_symbolunit (symbolunit_create_meters_per_second_squared ())
  let new_newton_meter () = new c_symbolunit (symbolunit_create_newton_meter ())
  let new_newtons_per_meter () = new c_symbolunit (symbolunit_create_newtons_per_meter ())
  let new_volts_per_meter () = new c_symbolunit (symbolunit_create_volts_per_meter ())
  let new_volts_per_second () = new c_symbolunit (symbolunit_create_volts_per_second ())
  let new_amperes_per_meter () = new c_symbolunit (symbolunit_create_amperes_per_meter ())
  let new_volts_per_ampere () = new c_symbolunit (symbolunit_create_volts_per_ampere ())
  let new_watts_per_meter_kelvin () = new c_symbolunit (symbolunit_create_watts_per_meter_kelvin ())
  let copy handle = symbolunit_copy handle
  let equal handle other = symbolunit_equal handle other
  let not_equal handle other = symbolunit_not_equal handle other
  let to_json_string handle = symbolunit_to_json_string handle
  let symbol handle = symbolunit_symbol handle
  let name handle = symbolunit_name handle
  let multiplication handle other = symbolunit_multiplication handle other
  let division handle other = symbolunit_division handle other
  let power handle power = symbolunit_power handle power
  let with_prefix handle prefix = symbolunit_with_prefix handle prefix
  let convert_value_to handle value target = symbolunit_convert_value_to handle value target
  let is_compatible_with handle other = symbolunit_is_compatible_with handle other
end

class c_adjacency (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (adjacency_destroy raw_val)) self
end

module Adjacency = struct
  type t = c_adjacency
  let from_json_string json = new c_adjacency (adjacency_from_json_string json)
  let make data shape ndim indexes = new c_adjacency (adjacency_create data shape ndim indexes)
  let copy handle = adjacency_copy handle
  let equal handle other = adjacency_equal handle other
  let not_equal handle other = adjacency_not_equal handle other
  let to_json_string handle = adjacency_to_json_string handle
  let indexes handle = adjacency_indexes handle
  let indexes handle = adjacency_indexes handle
  let get_true_pairs handle = adjacency_get_true_pairs handle
  let size handle = adjacency_size handle
  let dimension handle = adjacency_dimension handle
  let shape handle out_buffer ndim = adjacency_shape handle out_buffer ndim
  let data handle out_buffer numdata = adjacency_data handle out_buffer numdata
  let times_equals_farray handle other = adjacency_times_equals_farray handle other
  let times_farray handle other = adjacency_times_farray handle other
  let sum handle = adjacency_sum handle
  let where handle value = adjacency_where handle value
  let flip handle axis = adjacency_flip handle axis
  let of_arrays ~data ~shape indexes =
    let ndim = Array.length shape in
    let data_ptr = Ctypes.allocate_n Ctypes.int ~count:(Array.length data) in
    Array.iteri (fun i v -> Ctypes.((data_ptr +@ i) <-@ v)) data;
    let shape_ptr = Ctypes.allocate_n Ctypes.size_t ~count:ndim in
    Array.iteri (fun i v -> Ctypes.((shape_ptr +@ i) <-@ Unsigned.Size_t.of_int v)) shape;
    make data_ptr shape_ptr (Unsigned.Size_t.of_int ndim) indexes#raw
end

class c_config (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (config_destroy raw_val)) self
end

module Config = struct
  type t = c_config
  let from_json_string json = new c_config (config_from_json_string json)
  let make screening_gates plunger_gates ohmics barrier_gates reservoir_gates groups wiring_DC constraints = new c_config (config_create screening_gates plunger_gates ohmics barrier_gates reservoir_gates groups wiring_DC constraints)
  let copy handle = config_copy handle
  let equal handle other = config_equal handle other
  let not_equal handle other = config_not_equal handle other
  let to_json_string handle = config_to_json_string handle
  let num_unique_channels handle = config_num_unique_channels handle
  let voltage_constraints handle = config_voltage_constraints handle
  let groups handle = config_groups handle
  let wiring_dc handle = config_wiring_dc handle
  let channels handle = config_channels handle
  let get_impedance handle connection = config_get_impedance handle connection
  let get_all_gnames handle = config_get_all_gnames handle
  let get_all_groups handle = config_get_all_groups handle
  let has_channel handle channel = config_has_channel handle channel
  let has_gname handle gname = config_has_gname handle gname
  let select_group handle gname = config_select_group handle gname
  let get_dot_number handle channel = config_get_dot_number handle channel
  let get_charge_sense_groups handle = config_get_charge_sense_groups handle
  let ohmic_in_charge_sensor handle ohmic = config_ohmic_in_charge_sensor handle ohmic
  let get_associated_ohmic handle reservoir_gate = config_get_associated_ohmic handle reservoir_gate
  let get_current_channels handle = config_get_current_channels handle
  let get_gname handle channel = config_get_gname handle channel
  let get_group_barrier_gates handle gname = config_get_group_barrier_gates handle gname
  let get_group_plunger_gates handle gname = config_get_group_plunger_gates handle gname
  let get_group_reservoir_gates handle gname = config_get_group_reservoir_gates handle gname
  let get_group_screening_gates handle gname = config_get_group_screening_gates handle gname
  let get_group_dot_gates handle gname = config_get_group_dot_gates handle gname
  let get_group_gates handle gname = config_get_group_gates handle gname
  let get_channel_barrier_gates handle channel = config_get_channel_barrier_gates handle channel
  let get_channel_plunger_gates handle channel = config_get_channel_plunger_gates handle channel
  let get_channel_reservoir_gates handle channel = config_get_channel_reservoir_gates handle channel
  let get_channel_screening_gates handle channel = config_get_channel_screening_gates handle channel
  let get_channel_dot_gates handle channel = config_get_channel_dot_gates handle channel
  let get_channel_gates handle channel = config_get_channel_gates handle channel
  let get_channel_ohmics handle channel = config_get_channel_ohmics handle channel
  let get_channel_order_no_ohmics handle channel = config_get_channel_order_no_ohmics handle channel
  let get_num_unique_channels handle = config_get_num_unique_channels handle
  let return_channels_from_gate handle gate = config_return_channels_from_gate handle gate
  let return_channel_from_gate handle gate = config_return_channel_from_gate handle gate
  let ohmic_in_channel handle ohmic channel = config_ohmic_in_channel handle ohmic channel
  let get_dot_channel_neighbors handle dot_gate = config_get_dot_channel_neighbors handle dot_gate
  let get_barrier_gate_dict handle = config_get_barrier_gate_dict handle
  let get_plunger_gate_dict handle = config_get_plunger_gate_dict handle
  let get_reservoir_gate_dict handle = config_get_reservoir_gate_dict handle
  let get_screening_gate_dict handle = config_get_screening_gate_dict handle
  let get_dot_gate_dict handle = config_get_dot_gate_dict handle
  let get_gate_dict handle = config_get_gate_dict handle
  let get_isolated_barrier_gates handle = config_get_isolated_barrier_gates handle
  let get_isolated_plunger_gates handle = config_get_isolated_plunger_gates handle
  let get_isolated_reservoir_gates handle = config_get_isolated_reservoir_gates handle
  let get_isolated_screening_gates handle = config_get_isolated_screening_gates handle
  let get_isolated_dot_gates handle = config_get_isolated_dot_gates handle
  let get_isolated_gates handle = config_get_isolated_gates handle
  let get_shared_barrier_gates handle = config_get_shared_barrier_gates handle
  let get_shared_plunger_gates handle = config_get_shared_plunger_gates handle
  let get_shared_reservoir_gates handle = config_get_shared_reservoir_gates handle
  let get_shared_screening_gates handle = config_get_shared_screening_gates handle
  let get_shared_dot_gates handle = config_get_shared_dot_gates handle
  let get_shared_gates handle = config_get_shared_gates handle
  let get_shared_channel_barrier_gates handle channel = config_get_shared_channel_barrier_gates handle channel
  let get_shared_channel_plunger_gates handle channel = config_get_shared_channel_plunger_gates handle channel
  let get_shared_channel_reservoir_gates handle channel = config_get_shared_channel_reservoir_gates handle channel
  let get_shared_channel_screening_gates handle channel = config_get_shared_channel_screening_gates handle channel
  let get_shared_channel_dot_gates handle channel = config_get_shared_channel_dot_gates handle channel
  let get_shared_channel_gates handle channel = config_get_shared_channel_gates handle channel
  let get_isolated_channel_barrier_gates handle channel = config_get_isolated_channel_barrier_gates handle channel
  let get_isolated_channel_plunger_gates handle channel = config_get_isolated_channel_plunger_gates handle channel
  let get_isolated_channel_reservoir_gates handle channel = config_get_isolated_channel_reservoir_gates handle channel
  let get_isolated_channel_screening_gates handle channel = config_get_isolated_channel_screening_gates handle channel
  let get_isolated_channel_dot_gates handle channel = config_get_isolated_channel_dot_gates handle channel
  let get_isolated_channel_gates handle channel = config_get_isolated_channel_gates handle channel
  let get_isolated_barrier_gates_by_channel handle = config_get_isolated_barrier_gates_by_channel handle
  let get_isolated_plunger_gates_by_channel handle = config_get_isolated_plunger_gates_by_channel handle
  let get_isolated_reservoir_gates_by_channel handle = config_get_isolated_reservoir_gates_by_channel handle
  let get_isolated_screening_gates_by_channel handle = config_get_isolated_screening_gates_by_channel handle
  let get_isolated_dot_gates_by_channel handle = config_get_isolated_dot_gates_by_channel handle
  let get_isolated_gates_by_channel handle = config_get_isolated_gates_by_channel handle
  let generate_gate_relations handle = config_generate_gate_relations handle
  let screening_gates handle = config_screening_gates handle
  let reservoir_gates handle = config_reservoir_gates handle
  let plunger_gates handle = config_plunger_gates handle
  let barrier_gates handle = config_barrier_gates handle
  let ohmics handle = config_ohmics handle
  let dot_gates handle = config_dot_gates handle
  let get_ohmic handle = config_get_ohmic handle
  let get_barrier_gate handle = config_get_barrier_gate handle
  let get_plunger_gate handle = config_get_plunger_gate handle
  let get_reservoir_gate handle = config_get_reservoir_gate handle
  let get_screening_gate handle = config_get_screening_gate handle
  let get_dot_gate handle = config_get_dot_gate handle
  let get_gate handle = config_get_gate handle
  let get_all_gates handle = config_get_all_gates handle
  let get_all_connections handle = config_get_all_connections handle
  let has_ohmic handle ohmic = config_has_ohmic handle ohmic
  let has_gate handle gate = config_has_gate handle gate
  let has_barrier_gate handle barrier_gate = config_has_barrier_gate handle barrier_gate
  let has_plunger_gate handle plunger_gate = config_has_plunger_gate handle plunger_gate
  let has_reservoir_gate handle reservoir_gate = config_has_reservoir_gate handle reservoir_gate
  let has_screening_gate handle screening_gate = config_has_screening_gate handle screening_gate
  let create ~screening_gates ~plunger_gates ~ohmics ~barrier_gates ~reservoir_gates ~groups ~wiring_dc ~constraints =
    make screening_gates#raw plunger_gates#raw ohmics#raw barrier_gates#raw reservoir_gates#raw groups#raw wiring_dc#raw constraints#raw
end

class c_group (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (group_destroy raw_val)) self
end

module Group = struct
  type t = c_group
  let from_json_string json = new c_group (group_from_json_string json)
  let make name num_dots screening_gates reservoir_gates plunger_gates barrier_gates order = new c_group (group_create name num_dots screening_gates reservoir_gates plunger_gates barrier_gates order)
  let copy handle = group_copy handle
  let equal handle other = group_equal handle other
  let not_equal handle other = group_not_equal handle other
  let to_json_string handle = group_to_json_string handle
  let name handle = group_name handle
  let num_dots handle = group_num_dots handle
  let order handle = group_order handle
  let has_channel handle channel = group_has_channel handle channel
  let is_charge_sensor handle = group_is_charge_sensor handle
  let get_all_channel_gates handle = group_get_all_channel_gates handle
  let screening_gates handle = group_screening_gates handle
  let reservoir_gates handle = group_reservoir_gates handle
  let plunger_gates handle = group_plunger_gates handle
  let barrier_gates handle = group_barrier_gates handle
  let ohmics handle = group_ohmics handle
  let dot_gates handle = group_dot_gates handle
  let get_ohmic handle = group_get_ohmic handle
  let get_barrier_gate handle = group_get_barrier_gate handle
  let get_plunger_gate handle = group_get_plunger_gate handle
  let get_reservoir_gate handle = group_get_reservoir_gate handle
  let get_screening_gate handle = group_get_screening_gate handle
  let get_dot_gate handle = group_get_dot_gate handle
  let get_gate handle = group_get_gate handle
  let get_all_gates handle = group_get_all_gates handle
  let get_all_connections handle = group_get_all_connections handle
  let has_ohmic handle ohmic = group_has_ohmic handle ohmic
  let has_gate handle gate = group_has_gate handle gate
  let has_barrier_gate handle barrier_gate = group_has_barrier_gate handle barrier_gate
  let has_plunger_gate handle plunger_gate = group_has_plunger_gate handle plunger_gate
  let has_reservoir_gate handle reservoir_gate = group_has_reservoir_gate handle reservoir_gate
  let has_screening_gate handle screening_gate = group_has_screening_gate handle screening_gate
end

class c_voltageconstraints (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (voltageconstraints_destroy raw_val)) self
end

module VoltageConstraints = struct
  type t = c_voltageconstraints
  let from_json_string json = new c_voltageconstraints (voltageconstraints_from_json_string json)
  let make adjacency max_safe_diff bounds = new c_voltageconstraints (voltageconstraints_create adjacency max_safe_diff bounds)
  let copy handle = voltageconstraints_copy handle
  let equal handle other = voltageconstraints_equal handle other
  let not_equal handle other = voltageconstraints_not_equal handle other
  let to_json_string handle = voltageconstraints_to_json_string handle
  let matrix handle = voltageconstraints_matrix handle
  let adjacency handle = voltageconstraints_adjacency handle
  let limits handle = voltageconstraints_limits handle
end

class c_dotgatewithneighbors (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (dotgatewithneighbors_destroy raw_val)) self
end

module DotGateWithNeighbors = struct
  type t = c_dotgatewithneighbors
  let from_json_string json = new c_dotgatewithneighbors (dotgatewithneighbors_from_json_string json)
  let new_plunger_gate_with_neighbors name left_neighbor right_neighbor = new c_dotgatewithneighbors (dotgatewithneighbors_create_plunger_gate_with_neighbors name left_neighbor right_neighbor)
  let new_barrier_gate_with_neighbors name left_neighbor right_neighbor = new c_dotgatewithneighbors (dotgatewithneighbors_create_barrier_gate_with_neighbors name left_neighbor right_neighbor)
  let copy handle = dotgatewithneighbors_copy handle
  let equal handle other = dotgatewithneighbors_equal handle other
  let not_equal handle other = dotgatewithneighbors_not_equal handle other
  let to_json_string handle = dotgatewithneighbors_to_json_string handle
  let name handle = dotgatewithneighbors_name handle
  let type_ handle = dotgatewithneighbors_type handle
  let left_neighbor handle = dotgatewithneighbors_left_neighbor handle
  let right_neighbor handle = dotgatewithneighbors_right_neighbor handle
  let is_barrier_gate handle = dotgatewithneighbors_is_barrier_gate handle
  let is_plunger_gate handle = dotgatewithneighbors_is_plunger_gate handle
end

class c_dotgateswithneighbors (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (dotgateswithneighbors_destroy raw_val)) self
end

module DotGatesWithNeighbors = struct
  type t = c_dotgateswithneighbors
  let from_json_string json = new c_dotgateswithneighbors (dotgateswithneighbors_from_json_string json)
  let new_empty () = new c_dotgateswithneighbors (dotgateswithneighbors_create_empty ())
  let make items = new c_dotgateswithneighbors (dotgateswithneighbors_create items)
  let copy handle = dotgateswithneighbors_copy handle
  let equal handle other = dotgateswithneighbors_equal handle other
  let not_equal handle other = dotgateswithneighbors_not_equal handle other
  let to_json_string handle = dotgateswithneighbors_to_json_string handle
  let is_plunger_gates handle = dotgateswithneighbors_is_plunger_gates handle
  let is_barrier_gates handle = dotgateswithneighbors_is_barrier_gates handle
  let intersection handle other = dotgateswithneighbors_intersection handle other
  let push_back handle value = dotgateswithneighbors_push_back handle value
  let size handle = dotgateswithneighbors_size handle
  let empty handle = dotgateswithneighbors_empty handle
  let erase_at handle idx = dotgateswithneighbors_erase_at handle idx
  let clear handle = dotgateswithneighbors_clear handle
  let at handle idx = dotgateswithneighbors_at handle idx
  let items handle = dotgateswithneighbors_items handle
  let contains handle value = dotgateswithneighbors_contains handle value
  let index handle value = dotgateswithneighbors_index handle value
end

class c_gategeometryarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (gategeometryarray1d_destroy raw_val)) self
end

module GateGeometryArray1D = struct
  type t = c_gategeometryarray1d
  let from_json_string json = new c_gategeometryarray1d (gategeometryarray1d_from_json_string json)
  let make lineararray screening_gates = new c_gategeometryarray1d (gategeometryarray1d_create lineararray screening_gates)
  let copy handle = gategeometryarray1d_copy handle
  let equal handle other = gategeometryarray1d_equal handle other
  let not_equal handle other = gategeometryarray1d_not_equal handle other
  let to_json_string handle = gategeometryarray1d_to_json_string handle
  let append_central_gate handle left_neighbor selected_gate right_neighbor = gategeometryarray1d_append_central_gate handle left_neighbor selected_gate right_neighbor
  let all_dot_gates handle = gategeometryarray1d_all_dot_gates handle
  let query_neighbors handle gate = gategeometryarray1d_query_neighbors handle gate
  let left_reservoir handle = gategeometryarray1d_left_reservoir handle
  let right_reservoir handle = gategeometryarray1d_right_reservoir handle
  let left_barrier handle = gategeometryarray1d_left_barrier handle
  let right_barrier handle = gategeometryarray1d_right_barrier handle
  let linear_array handle = gategeometryarray1d_linear_array handle
  let screening_gates handle = gategeometryarray1d_screening_gates handle
  let raw_central_gates handle = gategeometryarray1d_raw_central_gates handle
  let central_dot_gates handle = gategeometryarray1d_central_dot_gates handle
  let ohmics handle = gategeometryarray1d_ohmics handle
end

class c_leftreservoirwithimplantedohmic (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (leftreservoirwithimplantedohmic_destroy raw_val)) self
end

module LeftReservoirWithImplantedOhmic = struct
  type t = c_leftreservoirwithimplantedohmic
  let from_json_string json = new c_leftreservoirwithimplantedohmic (leftreservoirwithimplantedohmic_from_json_string json)
  let make name right_neighbor ohmic = new c_leftreservoirwithimplantedohmic (leftreservoirwithimplantedohmic_create name right_neighbor ohmic)
  let copy handle = leftreservoirwithimplantedohmic_copy handle
  let equal handle other = leftreservoirwithimplantedohmic_equal handle other
  let not_equal handle other = leftreservoirwithimplantedohmic_not_equal handle other
  let to_json_string handle = leftreservoirwithimplantedohmic_to_json_string handle
  let name handle = leftreservoirwithimplantedohmic_name handle
  let type_ handle = leftreservoirwithimplantedohmic_type handle
  let ohmic handle = leftreservoirwithimplantedohmic_ohmic handle
  let right_neighbor handle = leftreservoirwithimplantedohmic_right_neighbor handle
end

class c_rightreservoirwithimplantedohmic (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (rightreservoirwithimplantedohmic_destroy raw_val)) self
end

module RightReservoirWithImplantedOhmic = struct
  type t = c_rightreservoirwithimplantedohmic
  let from_json_string json = new c_rightreservoirwithimplantedohmic (rightreservoirwithimplantedohmic_from_json_string json)
  let make name left_neighbor ohmic = new c_rightreservoirwithimplantedohmic (rightreservoirwithimplantedohmic_create name left_neighbor ohmic)
  let copy handle = rightreservoirwithimplantedohmic_copy handle
  let equal handle other = rightreservoirwithimplantedohmic_equal handle other
  let not_equal handle other = rightreservoirwithimplantedohmic_not_equal handle other
  let to_json_string handle = rightreservoirwithimplantedohmic_to_json_string handle
  let name handle = rightreservoirwithimplantedohmic_name handle
  let type_ handle = rightreservoirwithimplantedohmic_type handle
  let ohmic handle = rightreservoirwithimplantedohmic_ohmic handle
  let left_neighbor handle = rightreservoirwithimplantedohmic_left_neighbor handle
end

class c_controlarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (controlarray1d_destroy raw_val)) self
end

module ControlArray1D = struct
  type t = c_controlarray1d
  let from_json_string json = new c_controlarray1d (controlarray1d_from_json_string json)
  let copy handle = controlarray1d_copy handle
  let equal handle other = controlarray1d_equal handle other
  let not_equal handle other = controlarray1d_not_equal handle other
  let to_json_string handle = controlarray1d_to_json_string handle
  let from_data data shape ndim = controlarray1d_from_data data shape ndim
  let from_farray farray = controlarray1d_from_farray farray
  let is_1d handle = controlarray1d_is_1d handle
  let as_1d handle = controlarray1d_as_1d handle
  let get_start handle = controlarray1d_get_start handle
  let get_end handle = controlarray1d_get_end handle
  let is_decreasing handle = controlarray1d_is_decreasing handle
  let is_increasing handle = controlarray1d_is_increasing handle
  let get_distance handle = controlarray1d_get_distance handle
  let get_mean handle = controlarray1d_get_mean handle
  let get_std handle = controlarray1d_get_std handle
  let reverse handle = controlarray1d_reverse handle
  let get_closest_index handle value = controlarray1d_get_closest_index handle value
  let even_divisions handle divisions = controlarray1d_even_divisions handle divisions
  let size handle = controlarray1d_size handle
  let dimension handle = controlarray1d_dimension handle
  let shape handle out_buffer ndim = controlarray1d_shape handle out_buffer ndim
  let data handle out_buffer numdata = controlarray1d_data handle out_buffer numdata
  let plus_equals_farray handle other = controlarray1d_plus_equals_farray handle other
  let plus_equals_double handle other = controlarray1d_plus_equals_double handle other
  let plus_equals_int handle other = controlarray1d_plus_equals_int handle other
  let plus_control_array handle other = controlarray1d_plus_control_array handle other
  let plus_farray handle other = controlarray1d_plus_farray handle other
  let plus_double handle other = controlarray1d_plus_double handle other
  let plus_int handle other = controlarray1d_plus_int handle other
  let minus_equals_farray handle other = controlarray1d_minus_equals_farray handle other
  let minus_equals_double handle other = controlarray1d_minus_equals_double handle other
  let minus_equals_int handle other = controlarray1d_minus_equals_int handle other
  let minus_control_array handle other = controlarray1d_minus_control_array handle other
  let minus_farray handle other = controlarray1d_minus_farray handle other
  let minus_double handle other = controlarray1d_minus_double handle other
  let minus_int handle other = controlarray1d_minus_int handle other
  let negation handle = controlarray1d_negation handle
  let times_equals_double handle other = controlarray1d_times_equals_double handle other
  let times_equals_int handle other = controlarray1d_times_equals_int handle other
  let times_double handle other = controlarray1d_times_double handle other
  let times_int handle other = controlarray1d_times_int handle other
  let divides_equals_double handle other = controlarray1d_divides_equals_double handle other
  let divides_equals_int handle other = controlarray1d_divides_equals_int handle other
  let divides_double handle other = controlarray1d_divides_double handle other
  let divides_int handle other = controlarray1d_divides_int handle other
  let pow handle other = controlarray1d_pow handle other
  let abs handle = controlarray1d_abs handle
  let min handle = controlarray1d_min handle
  let min_farray handle other = controlarray1d_min_farray handle other
  let min_control_array handle other = controlarray1d_min_control_array handle other
  let max handle = controlarray1d_max handle
  let max_farray handle other = controlarray1d_max_farray handle other
  let max_control_array handle other = controlarray1d_max_control_array handle other
  let greater_than handle value = controlarray1d_greater_than handle value
  let less_than handle value = controlarray1d_less_than handle value
  let remove_offset handle offset = controlarray1d_remove_offset handle offset
  let sum handle = controlarray1d_sum handle
  let where handle value = controlarray1d_where handle value
  let flip handle axis = controlarray1d_flip handle axis
  let full_gradient handle out_buffer buffer_size = controlarray1d_full_gradient handle out_buffer buffer_size
  let gradient handle axis = controlarray1d_gradient handle axis
  let get_sum_of_squares handle = controlarray1d_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = controlarray1d_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = controlarray1d_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = controlarray1d_get_summed_diff_array_of_squares handle other
end

class c_controlarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (controlarray_destroy raw_val)) self
end

module ControlArray = struct
  type t = c_controlarray
  let from_json_string json = new c_controlarray (controlarray_from_json_string json)
  let copy handle = controlarray_copy handle
  let equal handle other = controlarray_equal handle other
  let not_equal handle other = controlarray_not_equal handle other
  let to_json_string handle = controlarray_to_json_string handle
  let from_data data shape ndim = controlarray_from_data data shape ndim
  let from_farray farray = controlarray_from_farray farray
  let size handle = controlarray_size handle
  let dimension handle = controlarray_dimension handle
  let shape handle out_buffer ndim = controlarray_shape handle out_buffer ndim
  let data handle out_buffer numdata = controlarray_data handle out_buffer numdata
  let plus_equals_farray handle other = controlarray_plus_equals_farray handle other
  let plus_equals_double handle other = controlarray_plus_equals_double handle other
  let plus_equals_int handle other = controlarray_plus_equals_int handle other
  let plus_control_array handle other = controlarray_plus_control_array handle other
  let plus_farray handle other = controlarray_plus_farray handle other
  let plus_double handle other = controlarray_plus_double handle other
  let plus_int handle other = controlarray_plus_int handle other
  let minus_equals_farray handle other = controlarray_minus_equals_farray handle other
  let minus_equals_double handle other = controlarray_minus_equals_double handle other
  let minus_equals_int handle other = controlarray_minus_equals_int handle other
  let minus_control_array handle other = controlarray_minus_control_array handle other
  let minus_farray handle other = controlarray_minus_farray handle other
  let minus_double handle other = controlarray_minus_double handle other
  let minus_int handle other = controlarray_minus_int handle other
  let negation handle = controlarray_negation handle
  let times_equals_double handle other = controlarray_times_equals_double handle other
  let times_equals_int handle other = controlarray_times_equals_int handle other
  let times_double handle other = controlarray_times_double handle other
  let times_int handle other = controlarray_times_int handle other
  let divides_equals_double handle other = controlarray_divides_equals_double handle other
  let divides_equals_int handle other = controlarray_divides_equals_int handle other
  let divides_double handle other = controlarray_divides_double handle other
  let divides_int handle other = controlarray_divides_int handle other
  let pow handle other = controlarray_pow handle other
  let abs handle = controlarray_abs handle
  let min handle = controlarray_min handle
  let min_farray handle other = controlarray_min_farray handle other
  let min_control_array handle other = controlarray_min_control_array handle other
  let max handle = controlarray_max handle
  let max_farray handle other = controlarray_max_farray handle other
  let max_control_array handle other = controlarray_max_control_array handle other
  let greater_than handle value = controlarray_greater_than handle value
  let less_than handle value = controlarray_less_than handle value
  let remove_offset handle offset = controlarray_remove_offset handle offset
  let sum handle = controlarray_sum handle
  let where handle value = controlarray_where handle value
  let flip handle axis = controlarray_flip handle axis
  let full_gradient handle out_buffer buffer_size = controlarray_full_gradient handle out_buffer buffer_size
  let gradient handle axis = controlarray_gradient handle axis
  let get_sum_of_squares handle = controlarray_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = controlarray_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = controlarray_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = controlarray_get_summed_diff_array_of_squares handle other
end

class c_increasingalignment (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (increasingalignment_destroy raw_val)) self
end

module IncreasingAlignment = struct
  type t = c_increasingalignment
  let from_json_string json = new c_increasingalignment (increasingalignment_from_json_string json)
  let new_empty () = new c_increasingalignment (increasingalignment_create_empty ())
  let make alignment = new c_increasingalignment (increasingalignment_create alignment)
  let copy handle = increasingalignment_copy handle
  let equal handle other = increasingalignment_equal handle other
  let not_equal handle other = increasingalignment_not_equal handle other
  let to_json_string handle = increasingalignment_to_json_string handle
  let alignment handle = increasingalignment_alignment handle
end

class c_labelledcontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledcontrolarray1d_destroy raw_val)) self
end

module LabelledControlArray1D = struct
  type t = c_labelledcontrolarray1d
  let from_json_string json = new c_labelledcontrolarray1d (labelledcontrolarray1d_from_json_string json)
  let copy handle = labelledcontrolarray1d_copy handle
  let equal handle other = labelledcontrolarray1d_equal handle other
  let not_equal handle other = labelledcontrolarray1d_not_equal handle other
  let to_json_string handle = labelledcontrolarray1d_to_json_string handle
  let from_farray farray label = labelledcontrolarray1d_from_farray farray label
  let from_control_array controlarray label = labelledcontrolarray1d_from_control_array controlarray label
  let is_1d handle = labelledcontrolarray1d_is_1d handle
  let as_1d handle = labelledcontrolarray1d_as_1d handle
  let get_start handle = labelledcontrolarray1d_get_start handle
  let get_end handle = labelledcontrolarray1d_get_end handle
  let is_decreasing handle = labelledcontrolarray1d_is_decreasing handle
  let is_increasing handle = labelledcontrolarray1d_is_increasing handle
  let get_distance handle = labelledcontrolarray1d_get_distance handle
  let get_mean handle = labelledcontrolarray1d_get_mean handle
  let get_std handle = labelledcontrolarray1d_get_std handle
  let reverse handle = labelledcontrolarray1d_reverse handle
  let get_closest_index handle value = labelledcontrolarray1d_get_closest_index handle value
  let even_divisions handle divisions = labelledcontrolarray1d_even_divisions handle divisions
  let label handle = labelledcontrolarray1d_label handle
  let connection handle = labelledcontrolarray1d_connection handle
  let instrument_type handle = labelledcontrolarray1d_instrument_type handle
  let units handle = labelledcontrolarray1d_units handle
  let size handle = labelledcontrolarray1d_size handle
  let dimension handle = labelledcontrolarray1d_dimension handle
  let shape handle out_buffer ndim = labelledcontrolarray1d_shape handle out_buffer ndim
  let data handle out_buffer numdata = labelledcontrolarray1d_data handle out_buffer numdata
  let plus_equals_farray handle other = labelledcontrolarray1d_plus_equals_farray handle other
  let plus_equals_double handle other = labelledcontrolarray1d_plus_equals_double handle other
  let plus_equals_int handle other = labelledcontrolarray1d_plus_equals_int handle other
  let plus_control_array handle other = labelledcontrolarray1d_plus_control_array handle other
  let plus_farray handle other = labelledcontrolarray1d_plus_farray handle other
  let plus_double handle other = labelledcontrolarray1d_plus_double handle other
  let plus_int handle other = labelledcontrolarray1d_plus_int handle other
  let minus_equals_farray handle other = labelledcontrolarray1d_minus_equals_farray handle other
  let minus_equals_double handle other = labelledcontrolarray1d_minus_equals_double handle other
  let minus_equals_int handle other = labelledcontrolarray1d_minus_equals_int handle other
  let minus_control_array handle other = labelledcontrolarray1d_minus_control_array handle other
  let minus_farray handle other = labelledcontrolarray1d_minus_farray handle other
  let minus_double handle other = labelledcontrolarray1d_minus_double handle other
  let minus_int handle other = labelledcontrolarray1d_minus_int handle other
  let negation handle = labelledcontrolarray1d_negation handle
  let times_equals_double handle other = labelledcontrolarray1d_times_equals_double handle other
  let times_equals_int handle other = labelledcontrolarray1d_times_equals_int handle other
  let times_double handle other = labelledcontrolarray1d_times_double handle other
  let times_int handle other = labelledcontrolarray1d_times_int handle other
  let divides_equals_double handle other = labelledcontrolarray1d_divides_equals_double handle other
  let divides_equals_int handle other = labelledcontrolarray1d_divides_equals_int handle other
  let divides_double handle other = labelledcontrolarray1d_divides_double handle other
  let divides_int handle other = labelledcontrolarray1d_divides_int handle other
  let pow handle other = labelledcontrolarray1d_pow handle other
  let abs handle = labelledcontrolarray1d_abs handle
  let min handle = labelledcontrolarray1d_min handle
  let min_farray handle other = labelledcontrolarray1d_min_farray handle other
  let min_control_array handle other = labelledcontrolarray1d_min_control_array handle other
  let max handle = labelledcontrolarray1d_max handle
  let max_farray handle other = labelledcontrolarray1d_max_farray handle other
  let max_control_array handle other = labelledcontrolarray1d_max_control_array handle other
  let greater_than handle value = labelledcontrolarray1d_greater_than handle value
  let less_than handle value = labelledcontrolarray1d_less_than handle value
  let remove_offset handle offset = labelledcontrolarray1d_remove_offset handle offset
  let sum handle = labelledcontrolarray1d_sum handle
  let where handle value = labelledcontrolarray1d_where handle value
  let flip handle axis = labelledcontrolarray1d_flip handle axis
  let full_gradient handle out_buffer buffer_size = labelledcontrolarray1d_full_gradient handle out_buffer buffer_size
  let gradient handle axis = labelledcontrolarray1d_gradient handle axis
  let get_sum_of_squares handle = labelledcontrolarray1d_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = labelledcontrolarray1d_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = labelledcontrolarray1d_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = labelledcontrolarray1d_get_summed_diff_array_of_squares handle other
end

class c_labelledcontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledcontrolarray_destroy raw_val)) self
end

module LabelledControlArray = struct
  type t = c_labelledcontrolarray
  let from_json_string json = new c_labelledcontrolarray (labelledcontrolarray_from_json_string json)
  let copy handle = labelledcontrolarray_copy handle
  let equal handle other = labelledcontrolarray_equal handle other
  let not_equal handle other = labelledcontrolarray_not_equal handle other
  let to_json_string handle = labelledcontrolarray_to_json_string handle
  let from_farray farray label = labelledcontrolarray_from_farray farray label
  let from_control_array controlarray label = labelledcontrolarray_from_control_array controlarray label
  let label handle = labelledcontrolarray_label handle
  let connection handle = labelledcontrolarray_connection handle
  let instrument_type handle = labelledcontrolarray_instrument_type handle
  let units handle = labelledcontrolarray_units handle
  let size handle = labelledcontrolarray_size handle
  let dimension handle = labelledcontrolarray_dimension handle
  let shape handle out_buffer ndim = labelledcontrolarray_shape handle out_buffer ndim
  let data handle out_buffer numdata = labelledcontrolarray_data handle out_buffer numdata
  let plus_equals_farray handle other = labelledcontrolarray_plus_equals_farray handle other
  let plus_equals_double handle other = labelledcontrolarray_plus_equals_double handle other
  let plus_equals_int handle other = labelledcontrolarray_plus_equals_int handle other
  let plus_control_array handle other = labelledcontrolarray_plus_control_array handle other
  let plus_farray handle other = labelledcontrolarray_plus_farray handle other
  let plus_double handle other = labelledcontrolarray_plus_double handle other
  let plus_int handle other = labelledcontrolarray_plus_int handle other
  let minus_equals_control_array handle other = labelledcontrolarray_minus_equals_control_array handle other
  let minus_equals_farray handle other = labelledcontrolarray_minus_equals_farray handle other
  let minus_equals_double handle other = labelledcontrolarray_minus_equals_double handle other
  let minus_equals_int handle other = labelledcontrolarray_minus_equals_int handle other
  let minus_control_array handle other = labelledcontrolarray_minus_control_array handle other
  let minus_farray handle other = labelledcontrolarray_minus_farray handle other
  let minus_double handle other = labelledcontrolarray_minus_double handle other
  let minus_int handle other = labelledcontrolarray_minus_int handle other
  let negation handle = labelledcontrolarray_negation handle
  let times_equals_double handle other = labelledcontrolarray_times_equals_double handle other
  let times_equals_int handle other = labelledcontrolarray_times_equals_int handle other
  let times_double handle other = labelledcontrolarray_times_double handle other
  let times_int handle other = labelledcontrolarray_times_int handle other
  let divides_equals_double handle other = labelledcontrolarray_divides_equals_double handle other
  let divides_equals_int handle other = labelledcontrolarray_divides_equals_int handle other
  let divides_double handle other = labelledcontrolarray_divides_double handle other
  let divides_int handle other = labelledcontrolarray_divides_int handle other
  let pow handle other = labelledcontrolarray_pow handle other
  let abs handle = labelledcontrolarray_abs handle
  let min handle = labelledcontrolarray_min handle
  let min_farray handle other = labelledcontrolarray_min_farray handle other
  let min_control_array handle other = labelledcontrolarray_min_control_array handle other
  let max handle = labelledcontrolarray_max handle
  let max_farray handle other = labelledcontrolarray_max_farray handle other
  let max_control_array handle other = labelledcontrolarray_max_control_array handle other
  let greater_than handle value = labelledcontrolarray_greater_than handle value
  let less_than handle value = labelledcontrolarray_less_than handle value
  let remove_offset handle offset = labelledcontrolarray_remove_offset handle offset
  let sum handle = labelledcontrolarray_sum handle
  let where handle value = labelledcontrolarray_where handle value
  let flip handle axis = labelledcontrolarray_flip handle axis
  let full_gradient handle out_buffer buffer_size = labelledcontrolarray_full_gradient handle out_buffer buffer_size
  let gradient handle axis = labelledcontrolarray_gradient handle axis
  let get_sum_of_squares handle = labelledcontrolarray_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = labelledcontrolarray_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = labelledcontrolarray_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = labelledcontrolarray_get_summed_diff_array_of_squares handle other
end

class c_labelledmeasuredarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledmeasuredarray1d_destroy raw_val)) self
end

module LabelledMeasuredArray1D = struct
  type t = c_labelledmeasuredarray1d
  let from_json_string json = new c_labelledmeasuredarray1d (labelledmeasuredarray1d_from_json_string json)
  let copy handle = labelledmeasuredarray1d_copy handle
  let equal handle other = labelledmeasuredarray1d_equal handle other
  let not_equal handle other = labelledmeasuredarray1d_not_equal handle other
  let to_json_string handle = labelledmeasuredarray1d_to_json_string handle
  let from_farray farray label = labelledmeasuredarray1d_from_farray farray label
  let from_measured_array measuredarray label = labelledmeasuredarray1d_from_measured_array measuredarray label
  let is_1d handle = labelledmeasuredarray1d_is_1d handle
  let as_1d handle = labelledmeasuredarray1d_as_1d handle
  let get_start handle = labelledmeasuredarray1d_get_start handle
  let get_end handle = labelledmeasuredarray1d_get_end handle
  let is_decreasing handle = labelledmeasuredarray1d_is_decreasing handle
  let is_increasing handle = labelledmeasuredarray1d_is_increasing handle
  let get_distance handle = labelledmeasuredarray1d_get_distance handle
  let get_mean handle = labelledmeasuredarray1d_get_mean handle
  let get_std handle = labelledmeasuredarray1d_get_std handle
  let reverse handle = labelledmeasuredarray1d_reverse handle
  let get_closest_index handle value = labelledmeasuredarray1d_get_closest_index handle value
  let even_divisions handle divisions = labelledmeasuredarray1d_even_divisions handle divisions
  let label handle = labelledmeasuredarray1d_label handle
  let connection handle = labelledmeasuredarray1d_connection handle
  let instrument_type handle = labelledmeasuredarray1d_instrument_type handle
  let units handle = labelledmeasuredarray1d_units handle
  let size handle = labelledmeasuredarray1d_size handle
  let dimension handle = labelledmeasuredarray1d_dimension handle
  let shape handle out_buffer ndim = labelledmeasuredarray1d_shape handle out_buffer ndim
  let data handle out_buffer numdata = labelledmeasuredarray1d_data handle out_buffer numdata
  let plus_equals_farray handle other = labelledmeasuredarray1d_plus_equals_farray handle other
  let plus_equals_double handle other = labelledmeasuredarray1d_plus_equals_double handle other
  let plus_equals_int handle other = labelledmeasuredarray1d_plus_equals_int handle other
  let plus_measured_array handle other = labelledmeasuredarray1d_plus_measured_array handle other
  let plus_farray handle other = labelledmeasuredarray1d_plus_farray handle other
  let plus_double handle other = labelledmeasuredarray1d_plus_double handle other
  let plus_int handle other = labelledmeasuredarray1d_plus_int handle other
  let minus_equals_measured_array handle other = labelledmeasuredarray1d_minus_equals_measured_array handle other
  let minus_equals_farray handle other = labelledmeasuredarray1d_minus_equals_farray handle other
  let minus_equals_double handle other = labelledmeasuredarray1d_minus_equals_double handle other
  let minus_equals_int handle other = labelledmeasuredarray1d_minus_equals_int handle other
  let minus_measured_array handle other = labelledmeasuredarray1d_minus_measured_array handle other
  let minus_farray handle other = labelledmeasuredarray1d_minus_farray handle other
  let minus_double handle other = labelledmeasuredarray1d_minus_double handle other
  let minus_int handle other = labelledmeasuredarray1d_minus_int handle other
  let negation handle = labelledmeasuredarray1d_negation handle
  let times_equals_measured_array handle other = labelledmeasuredarray1d_times_equals_measured_array handle other
  let times_equals_farray handle other = labelledmeasuredarray1d_times_equals_farray handle other
  let times_equals_double handle other = labelledmeasuredarray1d_times_equals_double handle other
  let times_equals_int handle other = labelledmeasuredarray1d_times_equals_int handle other
  let times_measured_array handle other = labelledmeasuredarray1d_times_measured_array handle other
  let times_farray handle other = labelledmeasuredarray1d_times_farray handle other
  let times_double handle other = labelledmeasuredarray1d_times_double handle other
  let times_int handle other = labelledmeasuredarray1d_times_int handle other
  let divides_equals_measured_array handle other = labelledmeasuredarray1d_divides_equals_measured_array handle other
  let divides_equals_farray handle other = labelledmeasuredarray1d_divides_equals_farray handle other
  let divides_equals_double handle other = labelledmeasuredarray1d_divides_equals_double handle other
  let divides_equals_int handle other = labelledmeasuredarray1d_divides_equals_int handle other
  let divides_measured_array handle other = labelledmeasuredarray1d_divides_measured_array handle other
  let divides_farray handle other = labelledmeasuredarray1d_divides_farray handle other
  let divides_double handle other = labelledmeasuredarray1d_divides_double handle other
  let divides_int handle other = labelledmeasuredarray1d_divides_int handle other
  let pow handle other = labelledmeasuredarray1d_pow handle other
  let abs handle = labelledmeasuredarray1d_abs handle
  let min handle = labelledmeasuredarray1d_min handle
  let min_farray handle other = labelledmeasuredarray1d_min_farray handle other
  let min_measured_array handle other = labelledmeasuredarray1d_min_measured_array handle other
  let max handle = labelledmeasuredarray1d_max handle
  let max_farray handle other = labelledmeasuredarray1d_max_farray handle other
  let max_measured_array handle other = labelledmeasuredarray1d_max_measured_array handle other
  let greater_than handle value = labelledmeasuredarray1d_greater_than handle value
  let less_than handle value = labelledmeasuredarray1d_less_than handle value
  let remove_offset handle offset = labelledmeasuredarray1d_remove_offset handle offset
  let sum handle = labelledmeasuredarray1d_sum handle
  let reshape handle shape ndims = labelledmeasuredarray1d_reshape handle shape ndims
  let where handle value = labelledmeasuredarray1d_where handle value
  let flip handle axis = labelledmeasuredarray1d_flip handle axis
  let full_gradient handle out_buffer buffer_size = labelledmeasuredarray1d_full_gradient handle out_buffer buffer_size
  let gradient handle axis = labelledmeasuredarray1d_gradient handle axis
  let get_sum_of_squares handle = labelledmeasuredarray1d_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = labelledmeasuredarray1d_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = labelledmeasuredarray1d_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = labelledmeasuredarray1d_get_summed_diff_array_of_squares handle other
end

class c_labelledmeasuredarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledmeasuredarray_destroy raw_val)) self
end

module LabelledMeasuredArray = struct
  type t = c_labelledmeasuredarray
  let from_json_string json = new c_labelledmeasuredarray (labelledmeasuredarray_from_json_string json)
  let copy handle = labelledmeasuredarray_copy handle
  let equal handle other = labelledmeasuredarray_equal handle other
  let not_equal handle other = labelledmeasuredarray_not_equal handle other
  let to_json_string handle = labelledmeasuredarray_to_json_string handle
  let from_farray farray label = labelledmeasuredarray_from_farray farray label
  let from_measured_array measuredarray label = labelledmeasuredarray_from_measured_array measuredarray label
  let label handle = labelledmeasuredarray_label handle
  let connection handle = labelledmeasuredarray_connection handle
  let instrument_type handle = labelledmeasuredarray_instrument_type handle
  let units handle = labelledmeasuredarray_units handle
  let size handle = labelledmeasuredarray_size handle
  let dimension handle = labelledmeasuredarray_dimension handle
  let shape handle out_buffer ndim = labelledmeasuredarray_shape handle out_buffer ndim
  let data handle out_buffer numdata = labelledmeasuredarray_data handle out_buffer numdata
  let plus_equals_farray handle other = labelledmeasuredarray_plus_equals_farray handle other
  let plus_equals_double handle other = labelledmeasuredarray_plus_equals_double handle other
  let plus_equals_int handle other = labelledmeasuredarray_plus_equals_int handle other
  let plus_measured_array handle other = labelledmeasuredarray_plus_measured_array handle other
  let plus_farray handle other = labelledmeasuredarray_plus_farray handle other
  let plus_double handle other = labelledmeasuredarray_plus_double handle other
  let plus_int handle other = labelledmeasuredarray_plus_int handle other
  let minus_equals_measured_array handle other = labelledmeasuredarray_minus_equals_measured_array handle other
  let minus_equals_farray handle other = labelledmeasuredarray_minus_equals_farray handle other
  let minus_equals_double handle other = labelledmeasuredarray_minus_equals_double handle other
  let minus_equals_int handle other = labelledmeasuredarray_minus_equals_int handle other
  let minus_measured_array handle other = labelledmeasuredarray_minus_measured_array handle other
  let minus_farray handle other = labelledmeasuredarray_minus_farray handle other
  let minus_double handle other = labelledmeasuredarray_minus_double handle other
  let minus_int handle other = labelledmeasuredarray_minus_int handle other
  let negation handle = labelledmeasuredarray_negation handle
  let times_equals_measured_array handle other = labelledmeasuredarray_times_equals_measured_array handle other
  let times_equals_farray handle other = labelledmeasuredarray_times_equals_farray handle other
  let times_equals_double handle other = labelledmeasuredarray_times_equals_double handle other
  let times_equals_int handle other = labelledmeasuredarray_times_equals_int handle other
  let times_measured_array handle other = labelledmeasuredarray_times_measured_array handle other
  let times_farray handle other = labelledmeasuredarray_times_farray handle other
  let times_double handle other = labelledmeasuredarray_times_double handle other
  let times_int handle other = labelledmeasuredarray_times_int handle other
  let divides_equals_measured_array handle other = labelledmeasuredarray_divides_equals_measured_array handle other
  let divides_equals_farray handle other = labelledmeasuredarray_divides_equals_farray handle other
  let divides_equals_double handle other = labelledmeasuredarray_divides_equals_double handle other
  let divides_equals_int handle other = labelledmeasuredarray_divides_equals_int handle other
  let divides_measured_array handle other = labelledmeasuredarray_divides_measured_array handle other
  let divides_farray handle other = labelledmeasuredarray_divides_farray handle other
  let divides_double handle other = labelledmeasuredarray_divides_double handle other
  let divides_int handle other = labelledmeasuredarray_divides_int handle other
  let pow handle other = labelledmeasuredarray_pow handle other
  let abs handle = labelledmeasuredarray_abs handle
  let min handle = labelledmeasuredarray_min handle
  let min_farray handle other = labelledmeasuredarray_min_farray handle other
  let min_measured_array handle other = labelledmeasuredarray_min_measured_array handle other
  let max handle = labelledmeasuredarray_max handle
  let max_farray handle other = labelledmeasuredarray_max_farray handle other
  let max_measured_array handle other = labelledmeasuredarray_max_measured_array handle other
  let greater_than handle value = labelledmeasuredarray_greater_than handle value
  let less_than handle value = labelledmeasuredarray_less_than handle value
  let remove_offset handle offset = labelledmeasuredarray_remove_offset handle offset
  let sum handle = labelledmeasuredarray_sum handle
  let reshape handle shape ndims = labelledmeasuredarray_reshape handle shape ndims
  let where handle value = labelledmeasuredarray_where handle value
  let flip handle axis = labelledmeasuredarray_flip handle axis
  let full_gradient handle out_buffer buffer_size = labelledmeasuredarray_full_gradient handle out_buffer buffer_size
  let gradient handle axis = labelledmeasuredarray_gradient handle axis
  let get_sum_of_squares handle = labelledmeasuredarray_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = labelledmeasuredarray_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = labelledmeasuredarray_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = labelledmeasuredarray_get_summed_diff_array_of_squares handle other
end

class c_measuredarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (measuredarray1d_destroy raw_val)) self
end

module MeasuredArray1D = struct
  type t = c_measuredarray1d
  let from_json_string json = new c_measuredarray1d (measuredarray1d_from_json_string json)
  let copy handle = measuredarray1d_copy handle
  let equal handle other = measuredarray1d_equal handle other
  let not_equal handle other = measuredarray1d_not_equal handle other
  let to_json_string handle = measuredarray1d_to_json_string handle
  let from_data data shape ndim = measuredarray1d_from_data data shape ndim
  let from_farray farray = measuredarray1d_from_farray farray
  let is_1d handle = measuredarray1d_is_1d handle
  let as_1d handle = measuredarray1d_as_1d handle
  let get_start handle = measuredarray1d_get_start handle
  let get_end handle = measuredarray1d_get_end handle
  let is_decreasing handle = measuredarray1d_is_decreasing handle
  let is_increasing handle = measuredarray1d_is_increasing handle
  let get_distance handle = measuredarray1d_get_distance handle
  let get_mean handle = measuredarray1d_get_mean handle
  let get_std handle = measuredarray1d_get_std handle
  let reverse handle = measuredarray1d_reverse handle
  let get_closest_index handle value = measuredarray1d_get_closest_index handle value
  let even_divisions handle divisions = measuredarray1d_even_divisions handle divisions
  let size handle = measuredarray1d_size handle
  let dimension handle = measuredarray1d_dimension handle
  let shape handle out_buffer ndim = measuredarray1d_shape handle out_buffer ndim
  let data handle out_buffer numdata = measuredarray1d_data handle out_buffer numdata
  let plus_equals_farray handle other = measuredarray1d_plus_equals_farray handle other
  let plus_equals_double handle other = measuredarray1d_plus_equals_double handle other
  let plus_equals_int handle other = measuredarray1d_plus_equals_int handle other
  let plus_measured_array handle other = measuredarray1d_plus_measured_array handle other
  let plus_farray handle other = measuredarray1d_plus_farray handle other
  let plus_double handle other = measuredarray1d_plus_double handle other
  let plus_int handle other = measuredarray1d_plus_int handle other
  let minus_equals_farray handle other = measuredarray1d_minus_equals_farray handle other
  let minus_equals_double handle other = measuredarray1d_minus_equals_double handle other
  let minus_equals_int handle other = measuredarray1d_minus_equals_int handle other
  let minus_measured_array handle other = measuredarray1d_minus_measured_array handle other
  let minus_farray handle other = measuredarray1d_minus_farray handle other
  let minus_double handle other = measuredarray1d_minus_double handle other
  let minus_int handle other = measuredarray1d_minus_int handle other
  let negation handle = measuredarray1d_negation handle
  let times_equals_farray handle other = measuredarray1d_times_equals_farray handle other
  let times_equals_double handle other = measuredarray1d_times_equals_double handle other
  let times_equals_int handle other = measuredarray1d_times_equals_int handle other
  let times_measured_array handle other = measuredarray1d_times_measured_array handle other
  let times_farray handle other = measuredarray1d_times_farray handle other
  let times_double handle other = measuredarray1d_times_double handle other
  let times_int handle other = measuredarray1d_times_int handle other
  let divides_equals_measured_array handle other = measuredarray1d_divides_equals_measured_array handle other
  let divides_equals_farray handle other = measuredarray1d_divides_equals_farray handle other
  let divides_equals_double handle other = measuredarray1d_divides_equals_double handle other
  let divides_equals_int handle other = measuredarray1d_divides_equals_int handle other
  let divides_measured_array handle other = measuredarray1d_divides_measured_array handle other
  let divides_farray handle other = measuredarray1d_divides_farray handle other
  let divides_double handle other = measuredarray1d_divides_double handle other
  let divides_int handle other = measuredarray1d_divides_int handle other
  let pow handle other = measuredarray1d_pow handle other
  let abs handle = measuredarray1d_abs handle
  let min handle = measuredarray1d_min handle
  let min_farray handle other = measuredarray1d_min_farray handle other
  let min_measured_array handle other = measuredarray1d_min_measured_array handle other
  let max handle = measuredarray1d_max handle
  let max_farray handle other = measuredarray1d_max_farray handle other
  let max_measured_array handle other = measuredarray1d_max_measured_array handle other
  let greater_than handle value = measuredarray1d_greater_than handle value
  let less_than handle value = measuredarray1d_less_than handle value
  let remove_offset handle offset = measuredarray1d_remove_offset handle offset
  let sum handle = measuredarray1d_sum handle
  let reshape handle shape ndims = measuredarray1d_reshape handle shape ndims
  let where handle value = measuredarray1d_where handle value
  let flip handle axis = measuredarray1d_flip handle axis
  let full_gradient handle out_buffer buffer_size = measuredarray1d_full_gradient handle out_buffer buffer_size
  let gradient handle axis = measuredarray1d_gradient handle axis
  let get_sum_of_squares handle = measuredarray1d_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = measuredarray1d_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = measuredarray1d_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = measuredarray1d_get_summed_diff_array_of_squares handle other
end

class c_measuredarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (measuredarray_destroy raw_val)) self
end

module MeasuredArray = struct
  type t = c_measuredarray
  let from_json_string json = new c_measuredarray (measuredarray_from_json_string json)
  let copy handle = measuredarray_copy handle
  let equal handle other = measuredarray_equal handle other
  let not_equal handle other = measuredarray_not_equal handle other
  let to_json_string handle = measuredarray_to_json_string handle
  let from_data data shape ndim = measuredarray_from_data data shape ndim
  let from_farray farray = measuredarray_from_farray farray
  let size handle = measuredarray_size handle
  let dimension handle = measuredarray_dimension handle
  let shape handle out_buffer ndim = measuredarray_shape handle out_buffer ndim
  let data handle out_buffer numdata = measuredarray_data handle out_buffer numdata
  let plus_equals_farray handle other = measuredarray_plus_equals_farray handle other
  let plus_equals_double handle other = measuredarray_plus_equals_double handle other
  let plus_equals_int handle other = measuredarray_plus_equals_int handle other
  let plus_measured_array handle other = measuredarray_plus_measured_array handle other
  let plus_farray handle other = measuredarray_plus_farray handle other
  let plus_double handle other = measuredarray_plus_double handle other
  let plus_int handle other = measuredarray_plus_int handle other
  let minus_equals_farray handle other = measuredarray_minus_equals_farray handle other
  let minus_equals_double handle other = measuredarray_minus_equals_double handle other
  let minus_equals_int handle other = measuredarray_minus_equals_int handle other
  let minus_measured_array handle other = measuredarray_minus_measured_array handle other
  let minus_farray handle other = measuredarray_minus_farray handle other
  let minus_double handle other = measuredarray_minus_double handle other
  let minus_int handle other = measuredarray_minus_int handle other
  let negation handle = measuredarray_negation handle
  let times_equals_measured_array handle other = measuredarray_times_equals_measured_array handle other
  let times_equals_farray handle other = measuredarray_times_equals_farray handle other
  let times_equals_double handle other = measuredarray_times_equals_double handle other
  let times_equals_int handle other = measuredarray_times_equals_int handle other
  let times_measured_array handle other = measuredarray_times_measured_array handle other
  let times_farray handle other = measuredarray_times_farray handle other
  let times_double handle other = measuredarray_times_double handle other
  let times_int handle other = measuredarray_times_int handle other
  let divides_equals_measured_array handle other = measuredarray_divides_equals_measured_array handle other
  let divides_equals_farray handle other = measuredarray_divides_equals_farray handle other
  let divides_equals_double handle other = measuredarray_divides_equals_double handle other
  let divides_equals_int handle other = measuredarray_divides_equals_int handle other
  let divides_measured_array handle other = measuredarray_divides_measured_array handle other
  let divides_farray handle other = measuredarray_divides_farray handle other
  let divides_double handle other = measuredarray_divides_double handle other
  let divides_int handle other = measuredarray_divides_int handle other
  let pow handle other = measuredarray_pow handle other
  let abs handle = measuredarray_abs handle
  let min handle = measuredarray_min handle
  let min_farray handle other = measuredarray_min_farray handle other
  let min_measured_array handle other = measuredarray_min_measured_array handle other
  let max handle = measuredarray_max handle
  let max_farray handle other = measuredarray_max_farray handle other
  let max_measured_array handle other = measuredarray_max_measured_array handle other
  let greater_than handle value = measuredarray_greater_than handle value
  let less_than handle value = measuredarray_less_than handle value
  let remove_offset handle offset = measuredarray_remove_offset handle offset
  let sum handle = measuredarray_sum handle
  let reshape handle shape ndims = measuredarray_reshape handle shape ndims
  let where handle value = measuredarray_where handle value
  let flip handle axis = measuredarray_flip handle axis
  let full_gradient handle out_buffer buffer_size = measuredarray_full_gradient handle out_buffer buffer_size
  let gradient handle axis = measuredarray_gradient handle axis
  let get_sum_of_squares handle = measuredarray_get_sum_of_squares handle
  let get_summed_diff_int_of_squares handle other = measuredarray_get_summed_diff_int_of_squares handle other
  let get_summed_diff_double_of_squares handle other = measuredarray_get_summed_diff_double_of_squares handle other
  let get_summed_diff_array_of_squares handle other = measuredarray_get_summed_diff_array_of_squares handle other
end

class c_labelledarrayslabelledcontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledarrayslabelledcontrolarray_destroy raw_val)) self
end

module LabelledArraysLabelledControlArray = struct
  type t = c_labelledarrayslabelledcontrolarray
  let make arrays = new c_labelledarrayslabelledcontrolarray (labelledarrayslabelledcontrolarray_create arrays)
  let from_json_string json = new c_labelledarrayslabelledcontrolarray (labelledarrayslabelledcontrolarray_from_json_string json)
  let copy handle = labelledarrayslabelledcontrolarray_copy handle
  let arrays handle = labelledarrayslabelledcontrolarray_arrays handle
  let labels handle = labelledarrayslabelledcontrolarray_labels handle
  let is_control_arrays handle = labelledarrayslabelledcontrolarray_is_control_arrays handle
  let is_measured_arrays handle = labelledarrayslabelledcontrolarray_is_measured_arrays handle
  let push_back handle value = labelledarrayslabelledcontrolarray_push_back handle value
  let size handle = labelledarrayslabelledcontrolarray_size handle
  let empty handle = labelledarrayslabelledcontrolarray_empty handle
  let erase_at handle idx = labelledarrayslabelledcontrolarray_erase_at handle idx
  let clear handle = labelledarrayslabelledcontrolarray_clear handle
  let at handle idx = labelledarrayslabelledcontrolarray_at handle idx
  let contains handle value = labelledarrayslabelledcontrolarray_contains handle value
  let index handle value = labelledarrayslabelledcontrolarray_index handle value
  let intersection handle other = labelledarrayslabelledcontrolarray_intersection handle other
  let equal handle other = labelledarrayslabelledcontrolarray_equal handle other
  let not_equal handle other = labelledarrayslabelledcontrolarray_not_equal handle other
  let to_json_string handle = labelledarrayslabelledcontrolarray_to_json_string handle
end

class c_labelledarrayslabelledcontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledarrayslabelledcontrolarray1d_destroy raw_val)) self
end

module LabelledArraysLabelledControlArray1D = struct
  type t = c_labelledarrayslabelledcontrolarray1d
  let make arrays = new c_labelledarrayslabelledcontrolarray1d (labelledarrayslabelledcontrolarray1d_create arrays)
  let from_json_string json = new c_labelledarrayslabelledcontrolarray1d (labelledarrayslabelledcontrolarray1d_from_json_string json)
  let copy handle = labelledarrayslabelledcontrolarray1d_copy handle
  let arrays handle = labelledarrayslabelledcontrolarray1d_arrays handle
  let labels handle = labelledarrayslabelledcontrolarray1d_labels handle
  let is_control_arrays handle = labelledarrayslabelledcontrolarray1d_is_control_arrays handle
  let is_measured_arrays handle = labelledarrayslabelledcontrolarray1d_is_measured_arrays handle
  let push_back handle value = labelledarrayslabelledcontrolarray1d_push_back handle value
  let size handle = labelledarrayslabelledcontrolarray1d_size handle
  let empty handle = labelledarrayslabelledcontrolarray1d_empty handle
  let erase_at handle idx = labelledarrayslabelledcontrolarray1d_erase_at handle idx
  let clear handle = labelledarrayslabelledcontrolarray1d_clear handle
  let at handle idx = labelledarrayslabelledcontrolarray1d_at handle idx
  let contains handle value = labelledarrayslabelledcontrolarray1d_contains handle value
  let index handle value = labelledarrayslabelledcontrolarray1d_index handle value
  let intersection handle other = labelledarrayslabelledcontrolarray1d_intersection handle other
  let equal handle other = labelledarrayslabelledcontrolarray1d_equal handle other
  let not_equal handle other = labelledarrayslabelledcontrolarray1d_not_equal handle other
  let to_json_string handle = labelledarrayslabelledcontrolarray1d_to_json_string handle
end

class c_labelledarrayslabelledmeasuredarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledarrayslabelledmeasuredarray_destroy raw_val)) self
end

module LabelledArraysLabelledMeasuredArray = struct
  type t = c_labelledarrayslabelledmeasuredarray
  let make arrays = new c_labelledarrayslabelledmeasuredarray (labelledarrayslabelledmeasuredarray_create arrays)
  let from_json_string json = new c_labelledarrayslabelledmeasuredarray (labelledarrayslabelledmeasuredarray_from_json_string json)
  let copy handle = labelledarrayslabelledmeasuredarray_copy handle
  let arrays handle = labelledarrayslabelledmeasuredarray_arrays handle
  let labels handle = labelledarrayslabelledmeasuredarray_labels handle
  let is_control_arrays handle = labelledarrayslabelledmeasuredarray_is_control_arrays handle
  let is_measured_arrays handle = labelledarrayslabelledmeasuredarray_is_measured_arrays handle
  let push_back handle value = labelledarrayslabelledmeasuredarray_push_back handle value
  let size handle = labelledarrayslabelledmeasuredarray_size handle
  let empty handle = labelledarrayslabelledmeasuredarray_empty handle
  let erase_at handle idx = labelledarrayslabelledmeasuredarray_erase_at handle idx
  let clear handle = labelledarrayslabelledmeasuredarray_clear handle
  let at handle idx = labelledarrayslabelledmeasuredarray_at handle idx
  let contains handle value = labelledarrayslabelledmeasuredarray_contains handle value
  let index handle value = labelledarrayslabelledmeasuredarray_index handle value
  let intersection handle other = labelledarrayslabelledmeasuredarray_intersection handle other
  let equal handle other = labelledarrayslabelledmeasuredarray_equal handle other
  let not_equal handle other = labelledarrayslabelledmeasuredarray_not_equal handle other
  let to_json_string handle = labelledarrayslabelledmeasuredarray_to_json_string handle
end

class c_labelledarrayslabelledmeasuredarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelledarrayslabelledmeasuredarray1d_destroy raw_val)) self
end

module LabelledArraysLabelledMeasuredArray1D = struct
  type t = c_labelledarrayslabelledmeasuredarray1d
  let make arrays = new c_labelledarrayslabelledmeasuredarray1d (labelledarrayslabelledmeasuredarray1d_create arrays)
  let from_json_string json = new c_labelledarrayslabelledmeasuredarray1d (labelledarrayslabelledmeasuredarray1d_from_json_string json)
  let copy handle = labelledarrayslabelledmeasuredarray1d_copy handle
  let arrays handle = labelledarrayslabelledmeasuredarray1d_arrays handle
  let labels handle = labelledarrayslabelledmeasuredarray1d_labels handle
  let is_control_arrays handle = labelledarrayslabelledmeasuredarray1d_is_control_arrays handle
  let is_measured_arrays handle = labelledarrayslabelledmeasuredarray1d_is_measured_arrays handle
  let push_back handle value = labelledarrayslabelledmeasuredarray1d_push_back handle value
  let size handle = labelledarrayslabelledmeasuredarray1d_size handle
  let empty handle = labelledarrayslabelledmeasuredarray1d_empty handle
  let erase_at handle idx = labelledarrayslabelledmeasuredarray1d_erase_at handle idx
  let clear handle = labelledarrayslabelledmeasuredarray1d_clear handle
  let at handle idx = labelledarrayslabelledmeasuredarray1d_at handle idx
  let contains handle value = labelledarrayslabelledmeasuredarray1d_contains handle value
  let index handle value = labelledarrayslabelledmeasuredarray1d_index handle value
  let intersection handle other = labelledarrayslabelledmeasuredarray1d_intersection handle other
  let equal handle other = labelledarrayslabelledmeasuredarray1d_equal handle other
  let not_equal handle other = labelledarrayslabelledmeasuredarray1d_not_equal handle other
  let to_json_string handle = labelledarrayslabelledmeasuredarray1d_to_json_string handle
end

class c_discretespace (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (discretespace_destroy raw_val)) self
end

module DiscreteSpace = struct
  type t = c_discretespace
  let from_json_string json = new c_discretespace (discretespace_from_json_string json)
  let make space axes increasing = new c_discretespace (discretespace_create space axes increasing)
  let new_cartesian_discrete_space divisions axes increasing domain = new c_discretespace (discretespace_create_cartesian_discrete_space divisions axes increasing domain)
  let new_cartesian_discrete_space_1d division shared_domain increasing domain = new c_discretespace (discretespace_create_cartesian_discrete_space_1d division shared_domain increasing domain)
  let copy handle = discretespace_copy handle
  let equal handle other = discretespace_equal handle other
  let not_equal handle other = discretespace_not_equal handle other
  let to_json_string handle = discretespace_to_json_string handle
  let space handle = discretespace_space handle
  let axes handle = discretespace_axes handle
  let increasing handle = discretespace_increasing handle
  let knobs handle = discretespace_knobs handle
  let validate_unit_space_dimensionality_matches_knobs handle = discretespace_validate_unit_space_dimensionality_matches_knobs handle
  let validate_knob_uniqueness handle = discretespace_validate_knob_uniqueness handle
  let get_axis handle knob = discretespace_get_axis handle knob
  let get_domain handle knob = discretespace_get_domain handle knob
  let get_projection handle projection = discretespace_get_projection handle projection
end

class c_discretizer (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (discretizer_destroy raw_val)) self
end

module Discretizer = struct
  type t = c_discretizer
  let from_json_string json = new c_discretizer (discretizer_from_json_string json)
  let new_cartesian_discretizer delta = new c_discretizer (discretizer_create_cartesian_discretizer delta)
  let new_polar_discretizer delta = new c_discretizer (discretizer_create_polar_discretizer delta)
  let copy handle = discretizer_copy handle
  let equal handle other = discretizer_equal handle other
  let not_equal handle other = discretizer_not_equal handle other
  let to_json_string handle = discretizer_to_json_string handle
  let delta handle = discretizer_delta handle
  let set_delta handle delta = discretizer_set_delta handle delta
  let domain handle = discretizer_domain handle
  let is_cartesian handle = discretizer_is_cartesian handle
  let is_polar handle = discretizer_is_polar handle
end

class c_coupledlabelleddomain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (coupledlabelleddomain_destroy raw_val)) self
end

module CoupledLabelledDomain = struct
  type t = c_coupledlabelleddomain
  let from_json_string json = new c_coupledlabelleddomain (coupledlabelleddomain_from_json_string json)
  let new_empty () = new c_coupledlabelleddomain (coupledlabelleddomain_create_empty ())
  let make items = new c_coupledlabelleddomain (coupledlabelleddomain_create items)
  let copy handle = coupledlabelleddomain_copy handle
  let equal handle other = coupledlabelleddomain_equal handle other
  let not_equal handle other = coupledlabelleddomain_not_equal handle other
  let to_json_string handle = coupledlabelleddomain_to_json_string handle
  let domains handle = coupledlabelleddomain_domains handle
  let labels handle = coupledlabelleddomain_labels handle
  let get_domain handle search = coupledlabelleddomain_get_domain handle search
  let intersection handle other = coupledlabelleddomain_intersection handle other
  let push_back handle value = coupledlabelleddomain_push_back handle value
  let size handle = coupledlabelleddomain_size handle
  let empty handle = coupledlabelleddomain_empty handle
  let erase_at handle idx = coupledlabelleddomain_erase_at handle idx
  let clear handle = coupledlabelleddomain_clear handle
  let const_at handle idx = coupledlabelleddomain_const_at handle idx
  let at handle idx = coupledlabelleddomain_at handle idx
  let items handle = coupledlabelleddomain_items handle
  let contains handle value = coupledlabelleddomain_contains handle value
  let index handle value = coupledlabelleddomain_index handle value
end

class c_domain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (domain_destroy raw_val)) self
end

module Domain = struct
  type t = c_domain
  let from_json_string json = new c_domain (domain_from_json_string json)
  let make min_val max_val lesser_bound_contained greater_bound_contained = new c_domain (domain_create min_val max_val lesser_bound_contained greater_bound_contained)
  let copy handle = domain_copy handle
  let equal handle other = domain_equal handle other
  let not_equal handle other = domain_not_equal handle other
  let to_json_string handle = domain_to_json_string handle
  let lesser_bound handle = domain_lesser_bound handle
  let greater_bound handle = domain_greater_bound handle
  let lesser_bound_contained handle = domain_lesser_bound_contained handle
  let greater_bound_contained handle = domain_greater_bound_contained handle
  let in_ handle value = domain_in handle value
  let range handle = domain_range handle
  let center handle = domain_center handle
  let intersection handle other = domain_intersection handle other
  let union handle other = domain_union handle other
  let is_empty handle = domain_is_empty handle
  let contains_domain handle other = domain_contains_domain handle other
  let shift handle offset = domain_shift handle offset
  let scale handle scale = domain_scale handle scale
  let transform handle other value = domain_transform handle other value
end

class c_labelleddomain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (labelleddomain_destroy raw_val)) self
end

module LabelledDomain = struct
  type t = c_labelleddomain
  let from_json_string json = new c_labelleddomain (labelleddomain_from_json_string json)
  let new_primitive_knob default_name min_val max_val psuedo_name instrument_type lesser_bound_contained greater_bound_contained units description = new c_labelleddomain (labelleddomain_create_primitive_knob default_name min_val max_val psuedo_name instrument_type lesser_bound_contained greater_bound_contained units description)
  let new_primitive_meter default_name min_val max_val psuedo_name instrument_type lesser_bound_contained greater_bound_contained units description = new c_labelleddomain (labelleddomain_create_primitive_meter default_name min_val max_val psuedo_name instrument_type lesser_bound_contained greater_bound_contained units description)
  let new_primitive_port default_name min_val max_val psuedo_name instrument_type lesser_bound_contained greater_bound_contained units description = new c_labelleddomain (labelleddomain_create_primitive_port default_name min_val max_val psuedo_name instrument_type lesser_bound_contained greater_bound_contained units description)
  let new_from_port min_val max_val port lesser_bound_contained greater_bound_contained = new c_labelleddomain (labelleddomain_create_from_port min_val max_val port lesser_bound_contained greater_bound_contained)
  let new_from_port_and_domain port domain = new c_labelleddomain (labelleddomain_create_from_port_and_domain port domain)
  let new_from_domain domain default_name psuedo_name instrument_type units description = new c_labelleddomain (labelleddomain_create_from_domain domain default_name psuedo_name instrument_type units description)
  let copy handle = labelleddomain_copy handle
  let equal handle other = labelleddomain_equal handle other
  let not_equal handle other = labelleddomain_not_equal handle other
  let to_json_string handle = labelleddomain_to_json_string handle
  let port handle = labelleddomain_port handle
  let domain handle = labelleddomain_domain handle
  let matching_port handle port = labelleddomain_matching_port handle port
  let lesser_bound handle = labelleddomain_lesser_bound handle
  let greater_bound handle = labelleddomain_greater_bound handle
  let lesser_bound_contained handle = labelleddomain_lesser_bound_contained handle
  let greater_bound_contained handle = labelleddomain_greater_bound_contained handle
  let in_ handle value = labelleddomain_in handle value
  let range handle = labelleddomain_range handle
  let center handle = labelleddomain_center handle
  let intersection handle other = labelleddomain_intersection handle other
  let union handle other = labelleddomain_union handle other
  let is_empty handle = labelleddomain_is_empty handle
  let contains_domain handle other = labelleddomain_contains_domain handle other
  let shift handle offset = labelleddomain_shift handle offset
  let scale handle scale = labelleddomain_scale handle scale
  let transform handle other value = labelleddomain_transform handle other value
end

class c_instrumentport (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (instrumentport_destroy raw_val)) self
end

module InstrumentPort = struct
  type t = c_instrumentport
  let from_json_string json = new c_instrumentport (instrumentport_from_json_string json)
  let new_port default_name psuedo_name instrument_type units description = new c_instrumentport (instrumentport_create_port default_name psuedo_name instrument_type units description)
  let new_knob default_name psuedo_name instrument_type units description = new c_instrumentport (instrumentport_create_knob default_name psuedo_name instrument_type units description)
  let new_meter default_name psuedo_name instrument_type units description = new c_instrumentport (instrumentport_create_meter default_name psuedo_name instrument_type units description)
  let new_timer () = new c_instrumentport (instrumentport_create_timer ())
  let new_execution_clock () = new c_instrumentport (instrumentport_create_execution_clock ())
  let copy handle = instrumentport_copy handle
  let equal handle other = instrumentport_equal handle other
  let not_equal handle other = instrumentport_not_equal handle other
  let to_json_string handle = instrumentport_to_json_string handle
  let default_name handle = instrumentport_default_name handle
  let psuedo_name handle = instrumentport_psuedo_name handle
  let instrument_type handle = instrumentport_instrument_type handle
  let units handle = instrumentport_units handle
  let description handle = instrumentport_description handle
  let instrument_facing_name handle = instrumentport_instrument_facing_name handle
  let is_knob handle = instrumentport_is_knob handle
  let is_meter handle = instrumentport_is_meter handle
  let is_port handle = instrumentport_is_port handle
end

class c_ports (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (ports_destroy raw_val)) self
end

module Ports = struct
  type t = c_ports
  let from_json_string json = new c_ports (ports_from_json_string json)
  let new_empty () = new c_ports (ports_create_empty ())
  let make items = new c_ports (ports_create items)
  let copy handle = ports_copy handle
  let equal handle other = ports_equal handle other
  let not_equal handle other = ports_not_equal handle other
  let to_json_string handle = ports_to_json_string handle
  let ports handle = ports_ports handle
  let default_names handle = ports_default_names handle
  let get_psuedo_names handle = ports_get_psuedo_names handle
  let _get_raw_names handle = ports__get_raw_names handle
  let _get_instrument_facing_names handle = ports__get_instrument_facing_names handle
  let _get_psuedoname_matching_port handle name = ports__get_psuedoname_matching_port handle name
  let _get_instrument_type_matching_port handle insttype = ports__get_instrument_type_matching_port handle insttype
  let is_knobs handle = ports_is_knobs handle
  let is_meters handle = ports_is_meters handle
  let intersection handle other = ports_intersection handle other
  let push_back handle value = ports_push_back handle value
  let size handle = ports_size handle
  let empty handle = ports_empty handle
  let erase_at handle idx = ports_erase_at handle idx
  let clear handle = ports_clear handle
  let at handle idx = ports_at handle idx
  let items handle = ports_items handle
  let contains handle value = ports_contains handle value
  let index handle value = ports_index handle value
end

class c_porttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (porttransform_destroy raw_val)) self
end

module PortTransform = struct
  type t = c_porttransform
  let from_json_string json = new c_porttransform (porttransform_from_json_string json)
  let make port transform = new c_porttransform (porttransform_create port transform)
  let new_constant_transform port value = new c_porttransform (porttransform_create_constant_transform port value)
  let new_identity_transform port = new c_porttransform (porttransform_create_identity_transform port)
  let copy handle = porttransform_copy handle
  let equal handle other = porttransform_equal handle other
  let not_equal handle other = porttransform_not_equal handle other
  let to_json_string handle = porttransform_to_json_string handle
  let port handle = porttransform_port handle
  let labels handle = porttransform_labels handle
  let evaluate handle args time = porttransform_evaluate handle args time
  let evaluate_arraywise handle args deltaT maxTime = porttransform_evaluate_arraywise handle args deltaT maxTime
end

class c_porttransforms (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (porttransforms_destroy raw_val)) self
end

module PortTransforms = struct
  type t = c_porttransforms
  let from_json_string json = new c_porttransforms (porttransforms_from_json_string json)
  let new_empty () = new c_porttransforms (porttransforms_create_empty ())
  let make handle = new c_porttransforms (porttransforms_create handle)
  let copy handle = porttransforms_copy handle
  let equal handle other = porttransforms_equal handle other
  let not_equal handle other = porttransforms_not_equal handle other
  let to_json_string handle = porttransforms_to_json_string handle
  let transforms handle = porttransforms_transforms handle
  let push_back handle value = porttransforms_push_back handle value
  let size handle = porttransforms_size handle
  let empty handle = porttransforms_empty handle
  let erase_at handle idx = porttransforms_erase_at handle idx
  let clear handle = porttransforms_clear handle
  let at handle idx = porttransforms_at handle idx
  let items handle = porttransforms_items handle
  let contains handle value = porttransforms_contains handle value
  let index handle value = porttransforms_index handle value
  let intersection handle other = porttransforms_intersection handle other
end

class c_measurementrequest (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (measurementrequest_destroy raw_val)) self
end

module MeasurementRequest = struct
  type t = c_measurementrequest
  let from_json_string json = new c_measurementrequest (measurementrequest_from_json_string json)
  let make message measurement_name waveforms getters meter_transforms time_domain = new c_measurementrequest (measurementrequest_create message measurement_name waveforms getters meter_transforms time_domain)
  let copy handle = measurementrequest_copy handle
  let equal handle other = measurementrequest_equal handle other
  let not_equal handle other = measurementrequest_not_equal handle other
  let to_json_string handle = measurementrequest_to_json_string handle
  let measurement_name handle = measurementrequest_measurement_name handle
  let getters handle = measurementrequest_getters handle
  let waveforms handle = measurementrequest_waveforms handle
  let meter_transforms handle = measurementrequest_meter_transforms handle
  let time_domain handle = measurementrequest_time_domain handle
  let message handle = measurementrequest_message handle
end

class c_measurementresponse (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (measurementresponse_destroy raw_val)) self
end

module MeasurementResponse = struct
  type t = c_measurementresponse
  let from_json_string json = new c_measurementresponse (measurementresponse_from_json_string json)
  let make arrays = new c_measurementresponse (measurementresponse_create arrays)
  let copy handle = measurementresponse_copy handle
  let equal handle other = measurementresponse_equal handle other
  let not_equal handle other = measurementresponse_not_equal handle other
  let to_json_string handle = measurementresponse_to_json_string handle
  let arrays handle = measurementresponse_arrays handle
  let message handle = measurementresponse_message handle
end

class c_standardrequest (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (standardrequest_destroy raw_val)) self
end

module StandardRequest = struct
  type t = c_standardrequest
  let from_json_string json = new c_standardrequest (standardrequest_from_json_string json)
  let make message = new c_standardrequest (standardrequest_create message)
  let copy handle = standardrequest_copy handle
  let equal handle other = standardrequest_equal handle other
  let not_equal handle other = standardrequest_not_equal handle other
  let to_json_string handle = standardrequest_to_json_string handle
  let message handle = standardrequest_message handle
end

class c_standardresponse (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (standardresponse_destroy raw_val)) self
end

module StandardResponse = struct
  type t = c_standardresponse
  let from_json_string json = new c_standardresponse (standardresponse_from_json_string json)
  let make message = new c_standardresponse (standardresponse_create message)
  let copy handle = standardresponse_copy handle
  let equal handle other = standardresponse_equal handle other
  let not_equal handle other = standardresponse_not_equal handle other
  let to_json_string handle = standardresponse_to_json_string handle
  let message handle = standardresponse_message handle
end

class c_voltagestatesresponse (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (voltagestatesresponse_destroy raw_val)) self
end

module VoltageStatesResponse = struct
  type t = c_voltagestatesresponse
  let from_json_string json = new c_voltagestatesresponse (voltagestatesresponse_from_json_string json)
  let make message states = new c_voltagestatesresponse (voltagestatesresponse_create message states)
  let copy handle = voltagestatesresponse_copy handle
  let equal handle other = voltagestatesresponse_equal handle other
  let not_equal handle other = voltagestatesresponse_not_equal handle other
  let to_json_string handle = voltagestatesresponse_to_json_string handle
  let message handle = voltagestatesresponse_message handle
  let states handle = voltagestatesresponse_states handle
end

class c_devicevoltagestate (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (devicevoltagestate_destroy raw_val)) self
end

module DeviceVoltageState = struct
  type t = c_devicevoltagestate
  let make connection voltage unit = new c_devicevoltagestate (devicevoltagestate_create connection voltage unit)
  let from_json_string json = new c_devicevoltagestate (devicevoltagestate_from_json_string json)
  let connection handle = devicevoltagestate_connection handle
  let voltage handle = devicevoltagestate_voltage handle
  let value handle = devicevoltagestate_value handle
  let unit handle = devicevoltagestate_unit handle
  let convert_to handle target_unit = devicevoltagestate_convert_to handle target_unit
  let multiply_int handle other = devicevoltagestate_multiply_int handle other
  let multiply_double handle other = devicevoltagestate_multiply_double handle other
  let multiply_quantity handle other = devicevoltagestate_multiply_quantity handle other
  let multiply_equals_int handle other = devicevoltagestate_multiply_equals_int handle other
  let multiply_equals_double handle other = devicevoltagestate_multiply_equals_double handle other
  let multiply_equals_quantity handle other = devicevoltagestate_multiply_equals_quantity handle other
  let divide_int handle other = devicevoltagestate_divide_int handle other
  let divide_double handle other = devicevoltagestate_divide_double handle other
  let divide_quantity handle other = devicevoltagestate_divide_quantity handle other
  let divide_equals_int handle other = devicevoltagestate_divide_equals_int handle other
  let divide_equals_double handle other = devicevoltagestate_divide_equals_double handle other
  let divide_equals_quantity handle other = devicevoltagestate_divide_equals_quantity handle other
  let power handle other = devicevoltagestate_power handle other
  let add_quantity handle other = devicevoltagestate_add_quantity handle other
  let add_equals_quantity handle other = devicevoltagestate_add_equals_quantity handle other
  let subtract_quantity handle other = devicevoltagestate_subtract_quantity handle other
  let subtract_equals_quantity handle other = devicevoltagestate_subtract_equals_quantity handle other
  let negate handle = devicevoltagestate_negate handle
  let abs handle = devicevoltagestate_abs handle
  let equal a b = devicevoltagestate_equal a b
  let not_equal a b = devicevoltagestate_not_equal a b
  let to_json_string handle = devicevoltagestate_to_json_string handle
end

class c_devicevoltagestates (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (devicevoltagestates_destroy raw_val)) self
end

module DeviceVoltageStates = struct
  type t = c_devicevoltagestates
  let new_empty () = new c_devicevoltagestates (devicevoltagestates_create_empty ())
  let make items = new c_devicevoltagestates (devicevoltagestates_create items)
  let from_json_string json = new c_devicevoltagestates (devicevoltagestates_from_json_string json)
  let states handle = devicevoltagestates_states handle
  let add_state handle state = devicevoltagestates_add_state handle state
  let find_state handle connection = devicevoltagestates_find_state handle connection
  let to_point handle = devicevoltagestates_to_point handle
  let intersection handle other = devicevoltagestates_intersection handle other
  let push_back handle value = devicevoltagestates_push_back handle value
  let size handle = devicevoltagestates_size handle
  let empty handle = devicevoltagestates_empty handle
  let erase_at handle idx = devicevoltagestates_erase_at handle idx
  let clear handle = devicevoltagestates_clear handle
  let at handle idx = devicevoltagestates_at handle idx
  let items handle = devicevoltagestates_items handle
  let contains handle value = devicevoltagestates_contains handle value
  let index handle value = devicevoltagestates_index handle value
  let equal a b = devicevoltagestates_equal a b
  let not_equal a b = devicevoltagestates_not_equal a b
  let to_json_string handle = devicevoltagestates_to_json_string handle
end

class c_acquisitioncontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (acquisitioncontext_destroy raw_val)) self
end

module AcquisitionContext = struct
  type t = c_acquisitioncontext
  let from_json_string json = new c_acquisitioncontext (acquisitioncontext_from_json_string json)
  let make connection instrument_type units = new c_acquisitioncontext (acquisitioncontext_create connection instrument_type units)
  let new_from_port port = new c_acquisitioncontext (acquisitioncontext_create_from_port port)
  let copy handle = acquisitioncontext_copy handle
  let equal handle other = acquisitioncontext_equal handle other
  let not_equal handle other = acquisitioncontext_not_equal handle other
  let to_json_string handle = acquisitioncontext_to_json_string handle
  let connection handle = acquisitioncontext_connection handle
  let instrument_type handle = acquisitioncontext_instrument_type handle
  let units handle = acquisitioncontext_units handle
  let division_unit handle other = acquisitioncontext_division_unit handle other
  let division handle other = acquisitioncontext_division handle other
  let match_connection handle other = acquisitioncontext_match_connection handle other
  let match_instrument_type handle other = acquisitioncontext_match_instrument_type handle other
end

class c_measurementcontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (measurementcontext_destroy raw_val)) self
end

module MeasurementContext = struct
  type t = c_measurementcontext
  let from_json_string json = new c_measurementcontext (measurementcontext_from_json_string json)
  let make connection instrument_type = new c_measurementcontext (measurementcontext_create connection instrument_type)
  let new_from_port port = new c_measurementcontext (measurementcontext_create_from_port port)
  let copy handle = measurementcontext_copy handle
  let equal handle other = measurementcontext_equal handle other
  let not_equal handle other = measurementcontext_not_equal handle other
  let to_json_string handle = measurementcontext_to_json_string handle
  let connection handle = measurementcontext_connection handle
  let instrument_type handle = measurementcontext_instrument_type handle
end

class c_interpretationcontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (interpretationcontext_destroy raw_val)) self
end

module InterpretationContext = struct
  type t = c_interpretationcontext
  let from_json_string json = new c_interpretationcontext (interpretationcontext_from_json_string json)
  let make independant_variables dependant_variables unit = new c_interpretationcontext (interpretationcontext_create independant_variables dependant_variables unit)
  let copy handle = interpretationcontext_copy handle
  let equal handle other = interpretationcontext_equal handle other
  let not_equal handle other = interpretationcontext_not_equal handle other
  let to_json_string handle = interpretationcontext_to_json_string handle
  let independent_variables handle = interpretationcontext_independent_variables handle
  let dependent_variables handle = interpretationcontext_dependent_variables handle
  let unit handle = interpretationcontext_unit handle
  let dimension handle = interpretationcontext_dimension handle
  let add_dependent_variable handle variable = interpretationcontext_add_dependent_variable handle variable
  let replace_dependent_variable handle index variable = interpretationcontext_replace_dependent_variable handle index variable
  let get_independent_variables handle index = interpretationcontext_get_independent_variables handle index
  let with_unit handle unit = interpretationcontext_with_unit handle unit
end

class c_interpretationcontainerdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (interpretationcontainerdouble_destroy raw_val)) self
end

module InterpretationContainerDouble = struct
  type t = c_interpretationcontainerdouble
  let make contextDoubleMap = new c_interpretationcontainerdouble (interpretationcontainerdouble_create contextDoubleMap)
  let from_json_string json = new c_interpretationcontainerdouble (interpretationcontainerdouble_from_json_string json)
  let copy handle = interpretationcontainerdouble_copy handle
  let unit handle = interpretationcontainerdouble_unit handle
  let select_by_connection handle connection = interpretationcontainerdouble_select_by_connection handle connection
  let select_by_connections handle connections = interpretationcontainerdouble_select_by_connections handle connections
  let select_by_independent_connection handle connection = interpretationcontainerdouble_select_by_independent_connection handle connection
  let select_by_dependent_connection handle connection = interpretationcontainerdouble_select_by_dependent_connection handle connection
  let select_contexts handle independent_connections dependent_connections = interpretationcontainerdouble_select_contexts handle independent_connections dependent_connections
  let insert_or_assign handle key value = interpretationcontainerdouble_insert_or_assign handle key value
  let insert handle key value = interpretationcontainerdouble_insert handle key value
  let at handle key = interpretationcontainerdouble_at handle key
  let erase handle key = interpretationcontainerdouble_erase handle key
  let size handle = interpretationcontainerdouble_size handle
  let empty handle = interpretationcontainerdouble_empty handle
  let clear handle = interpretationcontainerdouble_clear handle
  let contains handle key = interpretationcontainerdouble_contains handle key
  let keys handle = interpretationcontainerdouble_keys handle
  let values handle = interpretationcontainerdouble_values handle
  let items handle = interpretationcontainerdouble_items handle
  let equal handle other = interpretationcontainerdouble_equal handle other
  let not_equal handle other = interpretationcontainerdouble_not_equal handle other
  let to_json_string handle = interpretationcontainerdouble_to_json_string handle
end

class c_interpretationcontainerstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (interpretationcontainerstring_destroy raw_val)) self
end

module InterpretationContainerString = struct
  type t = c_interpretationcontainerstring
  let make contextDoubleMap = new c_interpretationcontainerstring (interpretationcontainerstring_create contextDoubleMap)
  let from_json_string json = new c_interpretationcontainerstring (interpretationcontainerstring_from_json_string json)
  let copy handle = interpretationcontainerstring_copy handle
  let unit handle = interpretationcontainerstring_unit handle
  let select_by_connection handle connection = interpretationcontainerstring_select_by_connection handle connection
  let select_by_connections handle connections = interpretationcontainerstring_select_by_connections handle connections
  let select_by_independent_connection handle connection = interpretationcontainerstring_select_by_independent_connection handle connection
  let select_by_dependent_connection handle connection = interpretationcontainerstring_select_by_dependent_connection handle connection
  let select_contexts handle independent_connections dependent_connections = interpretationcontainerstring_select_contexts handle independent_connections dependent_connections
  let insert_or_assign handle key value = interpretationcontainerstring_insert_or_assign handle key value
  let insert handle key value = interpretationcontainerstring_insert handle key value
  let at handle key = interpretationcontainerstring_at handle key
  let erase handle key = interpretationcontainerstring_erase handle key
  let size handle = interpretationcontainerstring_size handle
  let empty handle = interpretationcontainerstring_empty handle
  let clear handle = interpretationcontainerstring_clear handle
  let contains handle key = interpretationcontainerstring_contains handle key
  let keys handle = interpretationcontainerstring_keys handle
  let values handle = interpretationcontainerstring_values handle
  let items handle = interpretationcontainerstring_items handle
  let equal handle other = interpretationcontainerstring_equal handle other
  let not_equal handle other = interpretationcontainerstring_not_equal handle other
  let to_json_string handle = interpretationcontainerstring_to_json_string handle
end

class c_interpretationcontainerquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (interpretationcontainerquantity_destroy raw_val)) self
end

module InterpretationContainerQuantity = struct
  type t = c_interpretationcontainerquantity
  let make contextDoubleMap = new c_interpretationcontainerquantity (interpretationcontainerquantity_create contextDoubleMap)
  let from_json_string json = new c_interpretationcontainerquantity (interpretationcontainerquantity_from_json_string json)
  let copy handle = interpretationcontainerquantity_copy handle
  let unit handle = interpretationcontainerquantity_unit handle
  let select_by_connection handle connection = interpretationcontainerquantity_select_by_connection handle connection
  let select_by_connections handle connections = interpretationcontainerquantity_select_by_connections handle connections
  let select_by_independent_connection handle connection = interpretationcontainerquantity_select_by_independent_connection handle connection
  let select_by_dependent_connection handle connection = interpretationcontainerquantity_select_by_dependent_connection handle connection
  let select_contexts handle independent_connections dependent_connections = interpretationcontainerquantity_select_contexts handle independent_connections dependent_connections
  let insert_or_assign handle key value = interpretationcontainerquantity_insert_or_assign handle key value
  let insert handle key value = interpretationcontainerquantity_insert handle key value
  let at handle key = interpretationcontainerquantity_at handle key
  let erase handle key = interpretationcontainerquantity_erase handle key
  let size handle = interpretationcontainerquantity_size handle
  let empty handle = interpretationcontainerquantity_empty handle
  let clear handle = interpretationcontainerquantity_clear handle
  let contains handle key = interpretationcontainerquantity_contains handle key
  let keys handle = interpretationcontainerquantity_keys handle
  let values handle = interpretationcontainerquantity_values handle
  let items handle = interpretationcontainerquantity_items handle
  let equal handle other = interpretationcontainerquantity_equal handle other
  let not_equal handle other = interpretationcontainerquantity_not_equal handle other
  let to_json_string handle = interpretationcontainerquantity_to_json_string handle
end

class c_channel (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (channel_destroy raw_val)) self
end

module Channel = struct
  type t = c_channel
  let from_json_string json = new c_channel (channel_from_json_string json)
  let make name = new c_channel (channel_create name)
  let copy handle = channel_copy handle
  let equal handle other = channel_equal handle other
  let not_equal handle other = channel_not_equal handle other
  let to_json_string handle = channel_to_json_string handle
  let name handle = channel_name handle
  let of_string s = make (String.wrap s)
end

class c_channels (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (channels_destroy raw_val)) self
end

module Channels = struct
  type t = c_channels
  let from_json_string json = new c_channels (channels_from_json_string json)
  let new_empty () = new c_channels (channels_create_empty ())
  let make items = new c_channels (channels_create items)
  let copy handle = channels_copy handle
  let equal handle other = channels_equal handle other
  let not_equal handle other = channels_not_equal handle other
  let to_json_string handle = channels_to_json_string handle
  let intersection handle other = channels_intersection handle other
  let push_back handle value = channels_push_back handle value
  let size handle = channels_size handle
  let empty handle = channels_empty handle
  let erase_at handle idx = channels_erase_at handle idx
  let clear handle = channels_clear handle
  let at handle idx = channels_at handle idx
  let items handle = channels_items handle
  let contains handle value = channels_contains handle value
  let index handle value = channels_index handle value
end

class c_gname (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ -> ignore (gname_destroy raw_val)) self
end

module Gname = struct
  type t = c_gname
  let from_json_string json = new c_gname (gname_from_json_string json)
  let new_from_num num = new c_gname (gname_create_from_num num)
  let make name = new c_gname (gname_create name)
  let copy handle = gname_copy handle
  let equal handle other = gname_equal handle other
  let not_equal handle other = gname_not_equal handle other
  let to_json_string handle = gname_to_json_string handle
  let gname handle = gname_gname handle
  let of_string s = make (String.wrap s)
end

module List = struct
  type 'a t = list_handle handle

  type _ ty = 
    | SizeT : Unsigned.size_t ty
    | String : ListString.t ty
    | Bool : bool ty
    | PairSizeTSizeT : ListPairSizeTSizeT.t ty
    | PairStringDouble : ListPairStringDouble.t ty
    | ListSizeT : ListListSizeT.t ty
    | FArrayDouble : ListFArrayDouble.t ty
    | Int : int ty
    | Float : float ty
    | Double : float ty
    | PairQuantityQuantity : ListPairQuantityQuantity.t ty
    | Connection : ListConnection.t ty
    | Channel : ListChannel.t ty
    | Quantity : ListQuantity.t ty
    | DeviceVoltageState : ListDeviceVoltageState.t ty
    | LabelledDomain : ListLabelledDomain.t ty
    | InstrumentPort : ListInstrumentPort.t ty
    | Connections : ListConnections.t ty
    | Impedance : ListImpedance.t ty
    | PairIntInt : ListPairIntInt.t ty
    | PairFloatFloat : ListPairFloatFloat.t ty
    | PairIntFloat : ListPairIntFloat.t ty
    | PairConnectionFloat : ListPairConnectionFloat.t ty
    | PairConnectionDouble : ListPairConnectionDouble.t ty
    | PairConnectionConnections : ListPairConnectionConnections.t ty
    | PairConnectionQuantity : ListPairConnectionQuantity.t ty
    | PairConnectionPairQuantityQuantity : ListPairConnectionPairQuantityQuantity.t ty
    | Discretizer : ListDiscretizer.t ty
    | ControlArray : ListControlArray.t ty
    | ControlArray1D : ListControlArray1D.t ty
    | CoupledLabelledDomain : ListCoupledLabelledDomain.t ty
    | PairStringBool : ListPairStringBool.t ty
    | MapStringBool : ListMapStringBool.t ty
    | DotGateWithNeighbors : ListDotGateWithNeighbors.t ty
    | Group : ListGroup.t ty
    | Gname : ListGname.t ty
    | PairChannelConnections : ListPairChannelConnections.t ty
    | PairGnameGroup : ListPairGnameGroup.t ty
    | MeasurementContext : ListMeasurementContext.t ty
    | PortTransform : ListPortTransform.t ty
    | Waveform : ListWaveform.t ty
    | PairInstrumentPortPortTransform : ListPairInstrumentPortPortTransform.t ty
    | LabelledControlArray : ListLabelledControlArray.t ty
    | AcquisitionContext : ListAcquisitionContext.t ty
    | LabelledControlArray1D : ListLabelledControlArray1D.t ty
    | LabelledMeasuredArray : ListLabelledMeasuredArray.t ty
    | LabelledMeasuredArray1D : ListLabelledMeasuredArray1D.t ty
    | PairStringString : ListPairStringString.t ty
    | InterpretationContext : ListInterpretationContext.t ty
    | PairInterpretationContextDouble : ListPairInterpretationContextDouble.t ty
    | PairInterpretationContextString : ListPairInterpretationContextString.t ty
    | PairInterpretationContextQuantity : ListPairInterpretationContextQuantity.t ty

  let push_back (type a) (ty : a ty) (l : a t) (v : a) = 
    match ty with
    | SizeT -> listsizet_push_back l.raw v
    | String -> liststring_push_back l.raw (v : c_liststring)#raw
    | Bool -> listbool_push_back l.raw v
    | PairSizeTSizeT -> listpairsizetsizet_push_back l.raw (v : c_listpairsizetsizet)#raw
    | PairStringDouble -> listpairstringdouble_push_back l.raw (v : c_listpairstringdouble)#raw
    | ListSizeT -> listlistsizet_push_back l.raw (v : c_listlistsizet)#raw
    | FArrayDouble -> listfarraydouble_push_back l.raw (v : c_listfarraydouble)#raw
    | Int -> listint_push_back l.raw v
    | Float -> listfloat_push_back l.raw v
    | Double -> listdouble_push_back l.raw v
    | PairQuantityQuantity -> listpairquantityquantity_push_back l.raw (v : c_listpairquantityquantity)#raw
    | Connection -> listconnection_push_back l.raw (v : c_listconnection)#raw
    | Channel -> listchannel_push_back l.raw (v : c_listchannel)#raw
    | Quantity -> listquantity_push_back l.raw (v : c_listquantity)#raw
    | DeviceVoltageState -> listdevicevoltagestate_push_back l.raw (v : c_listdevicevoltagestate)#raw
    | LabelledDomain -> listlabelleddomain_push_back l.raw (v : c_listlabelleddomain)#raw
    | InstrumentPort -> listinstrumentport_push_back l.raw (v : c_listinstrumentport)#raw
    | Connections -> listconnections_push_back l.raw (v : c_listconnections)#raw
    | Impedance -> listimpedance_push_back l.raw (v : c_listimpedance)#raw
    | PairIntInt -> listpairintint_push_back l.raw (v : c_listpairintint)#raw
    | PairFloatFloat -> listpairfloatfloat_push_back l.raw (v : c_listpairfloatfloat)#raw
    | PairIntFloat -> listpairintfloat_push_back l.raw (v : c_listpairintfloat)#raw
    | PairConnectionFloat -> listpairconnectionfloat_push_back l.raw (v : c_listpairconnectionfloat)#raw
    | PairConnectionDouble -> listpairconnectiondouble_push_back l.raw (v : c_listpairconnectiondouble)#raw
    | PairConnectionConnections -> listpairconnectionconnections_push_back l.raw (v : c_listpairconnectionconnections)#raw
    | PairConnectionQuantity -> listpairconnectionquantity_push_back l.raw (v : c_listpairconnectionquantity)#raw
    | PairConnectionPairQuantityQuantity -> listpairconnectionpairquantityquantity_push_back l.raw (v : c_listpairconnectionpairquantityquantity)#raw
    | Discretizer -> listdiscretizer_push_back l.raw (v : c_listdiscretizer)#raw
    | ControlArray -> listcontrolarray_push_back l.raw (v : c_listcontrolarray)#raw
    | ControlArray1D -> listcontrolarray1d_push_back l.raw (v : c_listcontrolarray1d)#raw
    | CoupledLabelledDomain -> listcoupledlabelleddomain_push_back l.raw (v : c_listcoupledlabelleddomain)#raw
    | PairStringBool -> listpairstringbool_push_back l.raw (v : c_listpairstringbool)#raw
    | MapStringBool -> listmapstringbool_push_back l.raw (v : c_listmapstringbool)#raw
    | DotGateWithNeighbors -> listdotgatewithneighbors_push_back l.raw (v : c_listdotgatewithneighbors)#raw
    | Group -> listgroup_push_back l.raw (v : c_listgroup)#raw
    | Gname -> listgname_push_back l.raw (v : c_listgname)#raw
    | PairChannelConnections -> listpairchannelconnections_push_back l.raw (v : c_listpairchannelconnections)#raw
    | PairGnameGroup -> listpairgnamegroup_push_back l.raw (v : c_listpairgnamegroup)#raw
    | MeasurementContext -> listmeasurementcontext_push_back l.raw (v : c_listmeasurementcontext)#raw
    | PortTransform -> listporttransform_push_back l.raw (v : c_listporttransform)#raw
    | Waveform -> listwaveform_push_back l.raw (v : c_listwaveform)#raw
    | PairInstrumentPortPortTransform -> listpairinstrumentportporttransform_push_back l.raw (v : c_listpairinstrumentportporttransform)#raw
    | LabelledControlArray -> listlabelledcontrolarray_push_back l.raw (v : c_listlabelledcontrolarray)#raw
    | AcquisitionContext -> listacquisitioncontext_push_back l.raw (v : c_listacquisitioncontext)#raw
    | LabelledControlArray1D -> listlabelledcontrolarray1d_push_back l.raw (v : c_listlabelledcontrolarray1d)#raw
    | LabelledMeasuredArray -> listlabelledmeasuredarray_push_back l.raw (v : c_listlabelledmeasuredarray)#raw
    | LabelledMeasuredArray1D -> listlabelledmeasuredarray1d_push_back l.raw (v : c_listlabelledmeasuredarray1d)#raw
    | PairStringString -> listpairstringstring_push_back l.raw (v : c_listpairstringstring)#raw
    | InterpretationContext -> listinterpretationcontext_push_back l.raw (v : c_listinterpretationcontext)#raw
    | PairInterpretationContextDouble -> listpairinterpretationcontextdouble_push_back l.raw (v : c_listpairinterpretationcontextdouble)#raw
    | PairInterpretationContextString -> listpairinterpretationcontextstring_push_back l.raw (v : c_listpairinterpretationcontextstring)#raw
    | PairInterpretationContextQuantity -> listpairinterpretationcontextquantity_push_back l.raw (v : c_listpairinterpretationcontextquantity)#raw

end

module Pair = struct
  type 'a t = pair_handle handle

  type _ ty = 
    | StringDouble : PairStringDouble.t ty
    | StringBool : PairStringBool.t ty
    | SizeTSizeT : PairSizeTSizeT.t ty
    | IntInt : PairIntInt.t ty
    | FloatFloat : PairFloatFloat.t ty
    | DoubleDouble : PairDoubleDouble.t ty
    | IntFloat : PairIntFloat.t ty
    | QuantityQuantity : PairQuantityQuantity.t ty
    | ConnectionFloat : PairConnectionFloat.t ty
    | ConnectionDouble : PairConnectionDouble.t ty
    | ConnectionConnection : PairConnectionConnection.t ty
    | ConnectionConnections : PairConnectionConnections.t ty
    | ConnectionQuantity : PairConnectionQuantity.t ty
    | ConnectionPairQuantityQuantity : PairConnectionPairQuantityQuantity.t ty
    | ChannelConnections : PairChannelConnections.t ty
    | GnameGroup : PairGnameGroup.t ty
    | InstrumentPortPortTransform : PairInstrumentPortPortTransform.t ty
    | StringString : PairStringString.t ty
    | MeasurementResponseMeasurementRequest : PairMeasurementResponseMeasurementRequest.t ty
    | InterpretationContextDouble : PairInterpretationContextDouble.t ty
    | InterpretationContextString : PairInterpretationContextString.t ty
    | InterpretationContextQuantity : PairInterpretationContextQuantity.t ty

end

module FArray = struct
  type 'a t = farray_handle handle

  type _ ty = 
    | Double : float ty
    | Int : int ty

end

module Map = struct
  type 'a t = map_handle handle

  type _ ty = 
    | StringDouble : MapStringDouble.t ty
    | IntInt : MapIntInt.t ty
    | FloatFloat : MapFloatFloat.t ty
    | ConnectionFloat : MapConnectionFloat.t ty
    | ConnectionDouble : MapConnectionDouble.t ty
    | ConnectionQuantity : MapConnectionQuantity.t ty
    | StringBool : MapStringBool.t ty
    | ChannelConnections : MapChannelConnections.t ty
    | GnameGroup : MapGnameGroup.t ty
    | InstrumentPortPortTransform : MapInstrumentPortPortTransform.t ty
    | StringString : MapStringString.t ty
    | InterpretationContextDouble : MapInterpretationContextDouble.t ty
    | InterpretationContextString : MapInterpretationContextString.t ty
    | InterpretationContextQuantity : MapInterpretationContextQuantity.t ty

end

module Axes = struct
  type 'a t = axes_handle handle

  type _ ty = 
    | Double : float ty
    | Int : int ty
    | Discretizer : AxesDiscretizer.t ty
    | ControlArray : AxesControlArray.t ty
    | ControlArray1D : AxesControlArray1D.t ty
    | CoupledLabelledDomain : AxesCoupledLabelledDomain.t ty
    | InstrumentPort : AxesInstrumentPort.t ty
    | MapStringBool : AxesMapStringBool.t ty
    | MeasurementContext : AxesMeasurementContext.t ty
    | LabelledControlArray : AxesLabelledControlArray.t ty
    | LabelledControlArray1D : AxesLabelledControlArray1D.t ty
    | LabelledMeasuredArray : AxesLabelledMeasuredArray.t ty
    | LabelledMeasuredArray1D : AxesLabelledMeasuredArray1D.t ty

end
