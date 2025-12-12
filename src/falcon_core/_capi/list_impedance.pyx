cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport impedance

cdef class ListImpedance:
    def __cinit__(self):
        self.handle = <_c_api.ListImpedanceHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListImpedanceHandle>0 and self.owned:
            _c_api.ListImpedance_destroy(self.handle)
        self.handle = <_c_api.ListImpedanceHandle>0


cdef ListImpedance _list_impedance_from_capi(_c_api.ListImpedanceHandle h):
    if h == <_c_api.ListImpedanceHandle>0:
        return None
    cdef ListImpedance obj = ListImpedance.__new__(ListImpedance)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListImpedanceHandle h
        h = _c_api.ListImpedance_create_empty()
        if h == <_c_api.ListImpedanceHandle>0:
            raise MemoryError("Failed to create ListImpedance")
        cdef ListImpedance obj = <ListImpedance>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, Impedance data, size_t count):
        cdef _c_api.ListImpedanceHandle h
        h = _c_api.ListImpedance_create(data.handle, count)
        if h == <_c_api.ListImpedanceHandle>0:
            raise MemoryError("Failed to create ListImpedance")
        cdef ListImpedance obj = <ListImpedance>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListImpedanceHandle h
        try:
            h = _c_api.ListImpedance_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListImpedanceHandle>0:
            raise MemoryError("Failed to create ListImpedance")
        cdef ListImpedance obj = <ListImpedance>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, Impedance value):
        cdef _c_api.ListImpedanceHandle h_ret = _c_api.ListImpedance_fill_value(count, value.handle)
        if h_ret == <_c_api.ListImpedanceHandle>0:
            return None
        return _list_impedance_from_capi(h_ret)

    def push_back(self, Impedance value):
        _c_api.ListImpedance_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListImpedance_size(self.handle)

    def empty(self, ):
        return _c_api.ListImpedance_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListImpedance_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListImpedance_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ImpedanceHandle h_ret = _c_api.ListImpedance_at(self.handle, idx)
        if h_ret == <_c_api.ImpedanceHandle>0:
            return None
        return impedance._impedance_from_capi(h_ret)

    def items(self, Impedance out_buffer, size_t buffer_size):
        return _c_api.ListImpedance_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Impedance value):
        return _c_api.ListImpedance_contains(self.handle, value.handle)

    def index(self, Impedance value):
        return _c_api.ListImpedance_index(self.handle, value.handle)

    def intersection(self, ListImpedance other):
        cdef _c_api.ListImpedanceHandle h_ret = _c_api.ListImpedance_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListImpedanceHandle>0:
            return None
        return _list_impedance_from_capi(h_ret)

    def equal(self, ListImpedance b):
        return _c_api.ListImpedance_equal(self.handle, b.handle)

    def __eq__(self, ListImpedance b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListImpedance b):
        return _c_api.ListImpedance_not_equal(self.handle, b.handle)

    def __ne__(self, ListImpedance b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
