cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_measurement_context
from . cimport measurement_context

cdef class AxesMeasurementContext:
    def __cinit__(self):
        self.handle = <_c_api.AxesMeasurementContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesMeasurementContextHandle>0 and self.owned:
            _c_api.AxesMeasurementContext_destroy(self.handle)
        self.handle = <_c_api.AxesMeasurementContextHandle>0


cdef AxesMeasurementContext _axes_measurement_context_from_capi(_c_api.AxesMeasurementContextHandle h):
    if h == <_c_api.AxesMeasurementContextHandle>0:
        return None
    cdef AxesMeasurementContext obj = AxesMeasurementContext.__new__(AxesMeasurementContext)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.AxesMeasurementContextHandle h
        h = _c_api.AxesMeasurementContext_create_empty()
        if h == <_c_api.AxesMeasurementContextHandle>0:
            raise MemoryError("Failed to create AxesMeasurementContext")
        cdef AxesMeasurementContext obj = <AxesMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def raw(cls, MeasurementContext data, size_t count):
        cdef _c_api.AxesMeasurementContextHandle h
        h = _c_api.AxesMeasurementContext_create_raw(data.handle, count)
        if h == <_c_api.AxesMeasurementContextHandle>0:
            raise MemoryError("Failed to create AxesMeasurementContext")
        cdef AxesMeasurementContext obj = <AxesMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, ListMeasurementContext data):
        cdef _c_api.AxesMeasurementContextHandle h
        h = _c_api.AxesMeasurementContext_create(data.handle)
        if h == <_c_api.AxesMeasurementContextHandle>0:
            raise MemoryError("Failed to create AxesMeasurementContext")
        cdef AxesMeasurementContext obj = <AxesMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesMeasurementContextHandle h
        try:
            h = _c_api.AxesMeasurementContext_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesMeasurementContextHandle>0:
            raise MemoryError("Failed to create AxesMeasurementContext")
        cdef AxesMeasurementContext obj = <AxesMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, MeasurementContext value):
        _c_api.AxesMeasurementContext_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesMeasurementContext_size(self.handle)

    def empty(self, ):
        return _c_api.AxesMeasurementContext_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesMeasurementContext_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesMeasurementContext_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.MeasurementContextHandle h_ret = _c_api.AxesMeasurementContext_at(self.handle, idx)
        if h_ret == <_c_api.MeasurementContextHandle>0:
            return None
        return measurement_context._measurement_context_from_capi(h_ret)

    def items(self, MeasurementContext out_buffer, size_t buffer_size):
        return _c_api.AxesMeasurementContext_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, MeasurementContext value):
        return _c_api.AxesMeasurementContext_contains(self.handle, value.handle)

    def index(self, MeasurementContext value):
        return _c_api.AxesMeasurementContext_index(self.handle, value.handle)

    def intersection(self, AxesMeasurementContext other):
        cdef _c_api.AxesMeasurementContextHandle h_ret = _c_api.AxesMeasurementContext_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesMeasurementContextHandle>0:
            return None
        return _axes_measurement_context_from_capi(h_ret)

    def equal(self, AxesMeasurementContext b):
        return _c_api.AxesMeasurementContext_equal(self.handle, b.handle)

    def __eq__(self, AxesMeasurementContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesMeasurementContext b):
        return _c_api.AxesMeasurementContext_not_equal(self.handle, b.handle)

    def __ne__(self, AxesMeasurementContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
