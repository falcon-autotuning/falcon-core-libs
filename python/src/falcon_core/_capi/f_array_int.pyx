cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .f_array_double cimport FArrayDouble, _f_array_double_from_capi
from .list_list_size_t cimport ListListSizeT, _list_list_size_t_from_capi

cdef class FArrayInt:
    def __cinit__(self):
        self.handle = <_c_api.FArrayIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.FArrayIntHandle>0 and self.owned:
            _c_api.FArrayInt_destroy(self.handle)
        self.handle = <_c_api.FArrayIntHandle>0


    @classmethod
    def new_empty(cls, size_t[:] shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h
        h = _c_api.FArrayInt_create_empty(&shape[0], ndim)
        if h == <_c_api.FArrayIntHandle>0:
            raise MemoryError("Failed to create FArrayInt")
        cdef FArrayInt obj = <FArrayInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_zeros(cls, size_t[:] shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h
        h = _c_api.FArrayInt_create_zeros(&shape[0], ndim)
        if h == <_c_api.FArrayIntHandle>0:
            raise MemoryError("Failed to create FArrayInt")
        cdef FArrayInt obj = <FArrayInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.FArrayIntHandle h
        try:
            h = _c_api.FArrayInt_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.FArrayIntHandle>0:
            raise MemoryError("Failed to create FArrayInt")
        cdef FArrayInt obj = <FArrayInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_copy(self.handle)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    @staticmethod
    def from_shape(size_t[:] shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_from_shape(&shape[0], ndim)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret)

    @staticmethod
    def from_data(int[:] data, size_t[:] shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_from_data(&data[0], &shape[0], ndim)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret)

    def size(self):
        return _c_api.FArrayInt_size(self.handle)

    def dimension(self):
        return _c_api.FArrayInt_dimension(self.handle)

    def shape(self, size_t[:] out_buffer, size_t ndim):
        return _c_api.FArrayInt_shape(self.handle, &out_buffer[0], ndim)

    def data(self, int[:] out_buffer, size_t numdata):
        return _c_api.FArrayInt_data(self.handle, &out_buffer[0], numdata)

    def plus_equals_farray(self, FArrayInt other):
        _c_api.FArrayInt_plus_equals_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def plus_equals_double(self, double other):
        _c_api.FArrayInt_plus_equals_double(self.handle, other)

    def plus_equals_int(self, int other):
        _c_api.FArrayInt_plus_equals_int(self.handle, other)

    def plus_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_plus_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def plus_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_plus_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def plus_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_plus_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def minus_equals_farray(self, FArrayInt other):
        _c_api.FArrayInt_minus_equals_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def minus_equals_double(self, double other):
        _c_api.FArrayInt_minus_equals_double(self.handle, other)

    def minus_equals_int(self, int other):
        _c_api.FArrayInt_minus_equals_int(self.handle, other)

    def minus_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_minus_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def minus_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_minus_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def minus_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_minus_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def negation(self):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_negation(self.handle)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def __neg__(self):
        return self.negation()

    def times_equals_farray(self, FArrayInt other):
        _c_api.FArrayInt_times_equals_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def times_equals_double(self, double other):
        _c_api.FArrayInt_times_equals_double(self.handle, other)

    def times_equals_int(self, int other):
        _c_api.FArrayInt_times_equals_int(self.handle, other)

    def times_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_times_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def times_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_times_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def times_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_times_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def divides_equals_farray(self, FArrayInt other):
        _c_api.FArrayInt_divides_equals_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def divides_equals_double(self, double other):
        _c_api.FArrayInt_divides_equals_double(self.handle, other)

    def divides_equals_int(self, int other):
        _c_api.FArrayInt_divides_equals_int(self.handle, other)

    def divides_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_divides_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def divides_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_divides_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def divides_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_divides_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def pow(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_pow(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def double_pow(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayInt_double_pow(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0: return None
        return _f_array_double_from_capi(h_ret, owned=True)

    def pow_inplace(self, int other):
        _c_api.FArrayInt_pow_inplace(self.handle, other)

    def abs(self):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_abs(self.handle)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def min(self):
        return _c_api.FArrayInt_min(self.handle)

    def min_arraywise(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_min_arraywise(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def max(self):
        return _c_api.FArrayInt_max(self.handle)

    def max_arraywise(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_max_arraywise(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def equal(self, FArrayInt other):
        return _c_api.FArrayInt_equal(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def __eq__(self, FArrayInt other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, FArrayInt other):
        return _c_api.FArrayInt_not_equal(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def __ne__(self, FArrayInt other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def greater_than(self, int value):
        return _c_api.FArrayInt_greater_than(self.handle, value)

    def __gt__(self, int value):
        return self.greater_than(value)

    def less_than(self, int value):
        return _c_api.FArrayInt_less_than(self.handle, value)

    def __lt__(self, int value):
        return self.less_than(value)

    def remove_offset(self, int offset):
        _c_api.FArrayInt_remove_offset(self.handle, offset)

    def sum(self):
        return _c_api.FArrayInt_sum(self.handle)

    def reshape(self, size_t[:] shape, size_t ndims):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_reshape(self.handle, &shape[0], ndims)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def where(self, int value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.FArrayInt_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0: return None
        return _list_list_size_t_from_capi(h_ret, owned=True)

    def flip(self, size_t axis):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_flip(self.handle, axis)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def full_gradient(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.FArrayInt_full_gradient(self.handle, <_c_api.FArrayIntHandle*>&out_buffer[0], buffer_size)

    def gradient(self, size_t axis):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_gradient(self.handle, axis)
        if h_ret == <_c_api.FArrayIntHandle>0: return None
        return _f_array_int_from_capi(h_ret, owned=(h_ret != <_c_api.FArrayIntHandle>self.handle))

    def get_sum_of_squares(self):
        return _c_api.FArrayInt_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, int other):
        return _c_api.FArrayInt_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, double other):
        return _c_api.FArrayInt_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, FArrayInt other):
        return _c_api.FArrayInt_get_summed_diff_array_of_squares(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.FArrayInt_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef FArrayInt _f_array_int_from_capi(_c_api.FArrayIntHandle h, bint owned=True):
    if h == <_c_api.FArrayIntHandle>0:
        return None
    cdef FArrayInt obj = FArrayInt.__new__(FArrayInt)
    obj.handle = h
    obj.owned = owned
    return obj
