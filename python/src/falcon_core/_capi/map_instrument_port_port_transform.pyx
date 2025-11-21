# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .instrument_port cimport InstrumentPort
from .list_instrument_port cimport ListInstrumentPort
from .list_pair_instrument_port_port_transform cimport ListPairInstrumentPortPortTransform
from .list_port_transform cimport ListPortTransform
from .pair_instrument_port_port_transform cimport PairInstrumentPortPortTransform
from .port_transform cimport PortTransform

cdef class MapInstrumentPortPortTransform:
    cdef c_api.MapInstrumentPortPortTransformHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapInstrumentPortPortTransformHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapInstrumentPortPortTransformHandle>0 and self.owned:
            c_api.MapInstrumentPortPortTransform_destroy(self.handle)
        self.handle = <c_api.MapInstrumentPortPortTransformHandle>0

    cdef MapInstrumentPortPortTransform from_capi(cls, c_api.MapInstrumentPortPortTransformHandle h):
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapInstrumentPortPortTransformHandle h
        h = c_api.MapInstrumentPortPortTransform_create_empty()
        if h == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create MapInstrumentPortPortTransform")
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapInstrumentPortPortTransformHandle h
        h = c_api.MapInstrumentPortPortTransform_create(<c_api.PairInstrumentPortPortTransformHandle>data.handle, count)
        if h == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create MapInstrumentPortPortTransform")
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapInstrumentPortPortTransformHandle h
        try:
            h = c_api.MapInstrumentPortPortTransform_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create MapInstrumentPortPortTransform")
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInstrumentPortPortTransform_insert_or_assign(self.handle, <c_api.InstrumentPortHandle>key.handle, <c_api.PortTransformHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInstrumentPortPortTransform_insert(self.handle, <c_api.InstrumentPortHandle>key.handle, <c_api.PortTransformHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortTransformHandle h_ret
        h_ret = c_api.MapInstrumentPortPortTransform_at(self.handle, <c_api.InstrumentPortHandle>key.handle)
        if h_ret == <c_api.PortTransformHandle>0:
            return None
        return PortTransform.from_capi(PortTransform, h_ret)

    def erase(self, key):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInstrumentPortPortTransform_erase(self.handle, <c_api.InstrumentPortHandle>key.handle)

    def size(self):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInstrumentPortPortTransform_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInstrumentPortPortTransform_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInstrumentPortPortTransform_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInstrumentPortPortTransform_contains(self.handle, <c_api.InstrumentPortHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInstrumentPortHandle h_ret
        h_ret = c_api.MapInstrumentPortPortTransform_keys(self.handle)
        if h_ret == <c_api.ListInstrumentPortHandle>0:
            return None
        return ListInstrumentPort.from_capi(ListInstrumentPort, h_ret)

    def values(self):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPortTransformHandle h_ret
        h_ret = c_api.MapInstrumentPortPortTransform_values(self.handle)
        if h_ret == <c_api.ListPortTransformHandle>0:
            return None
        return ListPortTransform.from_capi(ListPortTransform, h_ret)

    def items(self):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairInstrumentPortPortTransformHandle h_ret
        h_ret = c_api.MapInstrumentPortPortTransform_items(self.handle)
        if h_ret == <c_api.ListPairInstrumentPortPortTransformHandle>0:
            return None
        return ListPairInstrumentPortPortTransform.from_capi(ListPairInstrumentPortPortTransform, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInstrumentPortPortTransform_equal(self.handle, <c_api.MapInstrumentPortPortTransformHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInstrumentPortPortTransform_not_equal(self.handle, <c_api.MapInstrumentPortPortTransformHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapInstrumentPortPortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapInstrumentPortPortTransform_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapInstrumentPortPortTransform _mapinstrumentportporttransform_from_capi(c_api.MapInstrumentPortPortTransformHandle h):
    cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>MapInstrumentPortPortTransform.__new__(MapInstrumentPortPortTransform)
    obj.handle = h