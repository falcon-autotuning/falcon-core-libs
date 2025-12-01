cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport instrument_port

cdef class ListInstrumentPort:
    def __cinit__(self):
        self.handle = <_c_api.ListInstrumentPortHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListInstrumentPortHandle>0 and self.owned:
            _c_api.ListInstrumentPort_destroy(self.handle)
        self.handle = <_c_api.ListInstrumentPortHandle>0


cdef ListInstrumentPort _list_instrument_port_from_capi(_c_api.ListInstrumentPortHandle h):
    if h == <_c_api.ListInstrumentPortHandle>0:
        return None
    cdef ListInstrumentPort obj = ListInstrumentPort.__new__(ListInstrumentPort)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListInstrumentPortHandle h
        h = _c_api.ListInstrumentPort_create_empty()
        if h == <_c_api.ListInstrumentPortHandle>0:
            raise MemoryError("Failed to create ListInstrumentPort")
        cdef ListInstrumentPort obj = <ListInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, InstrumentPort data, size_t count):
        cdef _c_api.ListInstrumentPortHandle h
        h = _c_api.ListInstrumentPort_create(data.handle, count)
        if h == <_c_api.ListInstrumentPortHandle>0:
            raise MemoryError("Failed to create ListInstrumentPort")
        cdef ListInstrumentPort obj = <ListInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListInstrumentPortHandle h
        try:
            h = _c_api.ListInstrumentPort_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListInstrumentPortHandle>0:
            raise MemoryError("Failed to create ListInstrumentPort")
        cdef ListInstrumentPort obj = <ListInstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, InstrumentPort value):
        cdef _c_api.ListInstrumentPortHandle h_ret = _c_api.ListInstrumentPort_fill_value(count, value.handle)
        if h_ret == <_c_api.ListInstrumentPortHandle>0:
            return None
        return _list_instrument_port_from_capi(h_ret)

    def push_back(self, InstrumentPort value):
        _c_api.ListInstrumentPort_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListInstrumentPort_size(self.handle)

    def empty(self, ):
        return _c_api.ListInstrumentPort_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListInstrumentPort_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListInstrumentPort_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.ListInstrumentPort_at(self.handle, idx)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return instrument_port._instrument_port_from_capi(h_ret)

    def items(self, InstrumentPort out_buffer, size_t buffer_size):
        return _c_api.ListInstrumentPort_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, InstrumentPort value):
        return _c_api.ListInstrumentPort_contains(self.handle, value.handle)

    def index(self, InstrumentPort value):
        return _c_api.ListInstrumentPort_index(self.handle, value.handle)

    def intersection(self, ListInstrumentPort other):
        cdef _c_api.ListInstrumentPortHandle h_ret = _c_api.ListInstrumentPort_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListInstrumentPortHandle>0:
            return None
        return _list_instrument_port_from_capi(h_ret)

    def equal(self, ListInstrumentPort b):
        return _c_api.ListInstrumentPort_equal(self.handle, b.handle)

    def __eq__(self, ListInstrumentPort b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListInstrumentPort b):
        return _c_api.ListInstrumentPort_not_equal(self.handle, b.handle)

    def __ne__(self, ListInstrumentPort b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
