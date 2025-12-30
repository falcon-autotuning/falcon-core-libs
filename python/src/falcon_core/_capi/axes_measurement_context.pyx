cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .list_measurement_context cimport ListMeasurementContext, _list_measurement_context_from_capi
from .measurement_context cimport MeasurementContext, _measurement_context_from_capi

cdef class AxesMeasurementContext:
    def __cinit__(self):
        self.handle = <_c_api.AxesMeasurementContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesMeasurementContextHandle>0 and self.owned:
            _c_api.AxesMeasurementContext_destroy(self.handle)
        self.handle = <_c_api.AxesMeasurementContextHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesMeasurementContextHandle h
        h = _c_api.AxesMeasurementContext_create_empty()
        if h == <_c_api.AxesMeasurementContextHandle>0:
            raise MemoryError("Failed to create AxesMeasurementContext")
        cdef AxesMeasurementContext obj = <AxesMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListMeasurementContext data):
        cdef _c_api.AxesMeasurementContextHandle h
        h = _c_api.AxesMeasurementContext_create(data.handle if data is not None else <_c_api.ListMeasurementContextHandle>0)
        if h == <_c_api.AxesMeasurementContextHandle>0:
            raise MemoryError("Failed to create AxesMeasurementContext")
        cdef AxesMeasurementContext obj = <AxesMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.AxesMeasurementContextHandle h_ret = _c_api.AxesMeasurementContext_copy(self.handle)
        if h_ret == <_c_api.AxesMeasurementContextHandle>0:
            return None
        return _axes_measurement_context_from_capi(h_ret, owned=(h_ret != <_c_api.AxesMeasurementContextHandle>self.handle))

    def push_back(self, MeasurementContext value):
        _c_api.AxesMeasurementContext_push_back(self.handle, value.handle if value is not None else <_c_api.MeasurementContextHandle>0)

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
        return _measurement_context_from_capi(h_ret, owned=False)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.AxesMeasurementContext_items(self.handle, <_c_api.MeasurementContextHandle*>&out_buffer[0], buffer_size)

    def contains(self, MeasurementContext value):
        return _c_api.AxesMeasurementContext_contains(self.handle, value.handle if value is not None else <_c_api.MeasurementContextHandle>0)

    def index(self, MeasurementContext value):
        return _c_api.AxesMeasurementContext_index(self.handle, value.handle if value is not None else <_c_api.MeasurementContextHandle>0)

    def intersection(self, AxesMeasurementContext other):
        cdef _c_api.AxesMeasurementContextHandle h_ret = _c_api.AxesMeasurementContext_intersection(self.handle, other.handle if other is not None else <_c_api.AxesMeasurementContextHandle>0)
        if h_ret == <_c_api.AxesMeasurementContextHandle>0:
            return None
        return _axes_measurement_context_from_capi(h_ret, owned=(h_ret != <_c_api.AxesMeasurementContextHandle>self.handle))

    def equal(self, AxesMeasurementContext other):
        return _c_api.AxesMeasurementContext_equal(self.handle, other.handle if other is not None else <_c_api.AxesMeasurementContextHandle>0)

    def __eq__(self, AxesMeasurementContext other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, AxesMeasurementContext other):
        return _c_api.AxesMeasurementContext_not_equal(self.handle, other.handle if other is not None else <_c_api.AxesMeasurementContextHandle>0)

    def __ne__(self, AxesMeasurementContext other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.AxesMeasurementContext_to_json_string(self.handle)
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
        cdef AxesMeasurementContext obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef AxesMeasurementContext _axes_measurement_context_from_capi(_c_api.AxesMeasurementContextHandle h, bint owned=True):
    if h == <_c_api.AxesMeasurementContextHandle>0:
        return None
    cdef AxesMeasurementContext obj = AxesMeasurementContext.__new__(AxesMeasurementContext)
    obj.handle = h
    obj.owned = owned
    return obj
