# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .instrument_port cimport InstrumentPort
from .list_instrument_port cimport ListInstrumentPort

cdef class AxesInstrumentPort:
    cdef c_api.AxesInstrumentPortHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AxesInstrumentPortHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AxesInstrumentPortHandle>0 and self.owned:
            c_api.AxesInstrumentPort_destroy(self.handle)
        self.handle = <c_api.AxesInstrumentPortHandle>0

    cdef AxesInstrumentPort from_capi(cls, c_api.AxesInstrumentPortHandle h):
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.AxesInstrumentPortHandle h
        h = c_api.AxesInstrumentPort_create_empty()
        if h == <c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, data, count):
        cdef c_api.AxesInstrumentPortHandle h
        h = c_api.AxesInstrumentPort_create_raw(<c_api.InstrumentPortHandle>data.handle, count)
        if h == <c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data):
        cdef c_api.AxesInstrumentPortHandle h
        h = c_api.AxesInstrumentPort_create(<c_api.ListInstrumentPortHandle>data.handle)
        if h == <c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AxesInstrumentPortHandle h
        try:
            h = c_api.AxesInstrumentPort_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AxesInstrumentPortHandle>0:
            raise MemoryError("Failed to create AxesInstrumentPort")
        cdef AxesInstrumentPort obj = <AxesInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, value):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesInstrumentPort_push_back(self.handle, <c_api.InstrumentPortHandle>value.handle)

    def size(self):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInstrumentPort_size(self.handle)

    def empty(self):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInstrumentPort_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesInstrumentPort_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesInstrumentPort_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InstrumentPortHandle h_ret
        h_ret = c_api.AxesInstrumentPort_at(self.handle, idx)
        if h_ret == <c_api.InstrumentPortHandle>0:
            return None
        return InstrumentPort.from_capi(InstrumentPort, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInstrumentPort_items(self.handle, <c_api.InstrumentPortHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInstrumentPort_contains(self.handle, <c_api.InstrumentPortHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInstrumentPort_index(self.handle, <c_api.InstrumentPortHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesInstrumentPortHandle h_ret
        h_ret = c_api.AxesInstrumentPort_intersection(self.handle, <c_api.AxesInstrumentPortHandle>other.handle)
        if h_ret == <c_api.AxesInstrumentPortHandle>0:
            return None
        return AxesInstrumentPort.from_capi(AxesInstrumentPort, h_ret)

    def equal(self, b):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInstrumentPort_equal(self.handle, <c_api.AxesInstrumentPortHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInstrumentPort_not_equal(self.handle, <c_api.AxesInstrumentPortHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AxesInstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AxesInstrumentPort_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AxesInstrumentPort _axesinstrumentport_from_capi(c_api.AxesInstrumentPortHandle h):
    cdef AxesInstrumentPort obj = <AxesInstrumentPort>AxesInstrumentPort.__new__(AxesInstrumentPort)
    obj.handle = h