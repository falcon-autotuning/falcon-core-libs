cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport instrument_port
from . cimport list_instrument_port

cdef class AxesInstrumentPort:
    def __cinit__(self):
        self.handle = <_c_api.AxesInstrumentPortHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesInstrumentPortHandle>0 and self.owned:
            _c_api.AxesInstrumentPort_destroy(self.handle)
        self.handle = <_c_api.AxesInstrumentPortHandle>0


cdef AxesInstrumentPort _axes_instrument_port_from_capi(_c_api.AxesInstrumentPortHandle h):
    if h == <_c_api.AxesInstrumentPortHandle>0:
        return None
    cdef AxesInstrumentPort obj = AxesInstrumentPort.__new__(AxesInstrumentPort)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesInstrumentPortHandle h
        h = _c_api.AxesInstrumentPort_create_empty()
        if h == <_c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, InstrumentPort data, size_t count):
        cdef _c_api.AxesInstrumentPortHandle h
        h = _c_api.AxesInstrumentPort_create_raw(data.handle, count)
        if h == <_c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListInstrumentPort data):
        cdef _c_api.AxesInstrumentPortHandle h
        h = _c_api.AxesInstrumentPort_create(data.handle)
        if h == <_c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesInstrumentPortHandle h
        try:
            h = _c_api.AxesInstrumentPort_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, InstrumentPort value):
        _c_api.AxesInstrumentPort_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesInstrumentPort_size(self.handle)

    def empty(self, ):
        return _c_api.AxesInstrumentPort_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesInstrumentPort_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesInstrumentPort_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.AxesInstrumentPort_at(self.handle, idx)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return instrument_port._instrument_port_from_capi(h_ret)

    def items(self, InstrumentPort out_buffer, size_t buffer_size):
        return _c_api.AxesInstrumentPort_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, InstrumentPort value):
        return _c_api.AxesInstrumentPort_contains(self.handle, value.handle)

    def index(self, InstrumentPort value):
        return _c_api.AxesInstrumentPort_index(self.handle, value.handle)

    def intersection(self, AxesInstrumentPort other):
        cdef _c_api.AxesInstrumentPortHandle h_ret = _c_api.AxesInstrumentPort_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesInstrumentPortHandle>0:
            return None
        return _axes_instrument_port_from_capi(h_ret)

    def equal(self, AxesInstrumentPort b):
        return _c_api.AxesInstrumentPort_equal(self.handle, b.handle)

    def __eq__(self, AxesInstrumentPort b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesInstrumentPort b):
        return _c_api.AxesInstrumentPort_not_equal(self.handle, b.handle)

    def __ne__(self, AxesInstrumentPort b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
