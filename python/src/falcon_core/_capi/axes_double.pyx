cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .list_double cimport ListDouble, _list_double_from_capi

cdef class AxesDouble:
    def __cinit__(self):
        self.handle = <_c_api.AxesDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesDoubleHandle>0 and self.owned:
            _c_api.AxesDouble_destroy(self.handle)
        self.handle = <_c_api.AxesDoubleHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesDoubleHandle h
        h = _c_api.AxesDouble_create_empty()
        if h == <_c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListDouble data):
        cdef _c_api.AxesDoubleHandle h
        h = _c_api.AxesDouble_create(data.handle if data is not None else <_c_api.ListDoubleHandle>0)
        if h == <_c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesDoubleHandle h
        try:
            h = _c_api.AxesDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, double value):
        _c_api.AxesDouble_push_back(self.handle, value)

    def size(self, ):
        return _c_api.AxesDouble_size(self.handle)

    def empty(self, ):
        return _c_api.AxesDouble_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesDouble_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesDouble_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.AxesDouble_at(self.handle, idx)

    def items(self, double[:] out_buffer, size_t buffer_size):
        return _c_api.AxesDouble_items(self.handle, &out_buffer[0], buffer_size)

    def contains(self, double value):
        return _c_api.AxesDouble_contains(self.handle, value)

    def index(self, double value):
        return _c_api.AxesDouble_index(self.handle, value)

    def intersection(self, AxesDouble other):
        cdef _c_api.AxesDoubleHandle h_ret = _c_api.AxesDouble_intersection(self.handle, other.handle if other is not None else <_c_api.AxesDoubleHandle>0)
        if h_ret == <_c_api.AxesDoubleHandle>0:
            return None
        return _axes_double_from_capi(h_ret)

    def equal(self, AxesDouble b):
        return _c_api.AxesDouble_equal(self.handle, b.handle if b is not None else <_c_api.AxesDoubleHandle>0)

    def __eq__(self, AxesDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesDouble b):
        return _c_api.AxesDouble_not_equal(self.handle, b.handle if b is not None else <_c_api.AxesDoubleHandle>0)

    def __ne__(self, AxesDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.AxesDouble_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

    def append(self, value):
        self.push_back(value)

    @classmethod
    def from_list(cls, items):
        cdef AxesDouble obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef AxesDouble _axes_double_from_capi(_c_api.AxesDoubleHandle h, bint owned=True):
    if h == <_c_api.AxesDoubleHandle>0:
        return None
    cdef AxesDouble obj = AxesDouble.__new__(AxesDouble)
    obj.handle = h
    obj.owned = owned
    return obj
