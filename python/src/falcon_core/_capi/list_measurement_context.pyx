cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport measurement_context

cdef class ListMeasurementContext:
    def __cinit__(self):
        self.handle = <_c_api.ListMeasurementContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListMeasurementContextHandle>0 and self.owned:
            _c_api.ListMeasurementContext_destroy(self.handle)
        self.handle = <_c_api.ListMeasurementContextHandle>0


cdef ListMeasurementContext _list_measurement_context_from_capi(_c_api.ListMeasurementContextHandle h):
    if h == <_c_api.ListMeasurementContextHandle>0:
        return None
    cdef ListMeasurementContext obj = ListMeasurementContext.__new__(ListMeasurementContext)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListMeasurementContextHandle h
        h = _c_api.ListMeasurementContext_create_empty()
        if h == <_c_api.ListMeasurementContextHandle>0:
            raise MemoryError("Failed to create ListMeasurementContext")
        cdef ListMeasurementContext obj = <ListMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, MeasurementContext data, size_t count):
        cdef _c_api.ListMeasurementContextHandle h
        h = _c_api.ListMeasurementContext_create(data.handle, count)
        if h == <_c_api.ListMeasurementContextHandle>0:
            raise MemoryError("Failed to create ListMeasurementContext")
        cdef ListMeasurementContext obj = <ListMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListMeasurementContextHandle h
        try:
            h = _c_api.ListMeasurementContext_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListMeasurementContextHandle>0:
            raise MemoryError("Failed to create ListMeasurementContext")
        cdef ListMeasurementContext obj = <ListMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, MeasurementContext value):
        cdef _c_api.ListMeasurementContextHandle h_ret = _c_api.ListMeasurementContext_fill_value(count, value.handle)
        if h_ret == <_c_api.ListMeasurementContextHandle>0:
            return None
        return _list_measurement_context_from_capi(h_ret)

    def push_back(self, MeasurementContext value):
        _c_api.ListMeasurementContext_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListMeasurementContext_size(self.handle)

    def empty(self, ):
        return _c_api.ListMeasurementContext_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListMeasurementContext_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListMeasurementContext_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.MeasurementContextHandle h_ret = _c_api.ListMeasurementContext_at(self.handle, idx)
        if h_ret == <_c_api.MeasurementContextHandle>0:
            return None
        return measurement_context._measurement_context_from_capi(h_ret)

    def items(self, MeasurementContext out_buffer, size_t buffer_size):
        return _c_api.ListMeasurementContext_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, MeasurementContext value):
        return _c_api.ListMeasurementContext_contains(self.handle, value.handle)

    def index(self, MeasurementContext value):
        return _c_api.ListMeasurementContext_index(self.handle, value.handle)

    def intersection(self, ListMeasurementContext other):
        cdef _c_api.ListMeasurementContextHandle h_ret = _c_api.ListMeasurementContext_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListMeasurementContextHandle>0:
            return None
        return _list_measurement_context_from_capi(h_ret)

    def equal(self, ListMeasurementContext b):
        return _c_api.ListMeasurementContext_equal(self.handle, b.handle)

    def __eq__(self, ListMeasurementContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListMeasurementContext b):
        return _c_api.ListMeasurementContext_not_equal(self.handle, b.handle)

    def __ne__(self, ListMeasurementContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
