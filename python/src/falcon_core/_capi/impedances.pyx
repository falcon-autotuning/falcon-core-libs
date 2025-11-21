# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .impedance cimport Impedance
from .list_impedance cimport ListImpedance

cdef class Impedances:
    cdef c_api.ImpedancesHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ImpedancesHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ImpedancesHandle>0 and self.owned:
            c_api.Impedances_destroy(self.handle)
        self.handle = <c_api.ImpedancesHandle>0

    cdef Impedances from_capi(cls, c_api.ImpedancesHandle h):
        cdef Impedances obj = <Impedances>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ImpedancesHandle h
        h = c_api.Impedances_create_empty()
        if h == <c_api.ImpedancesHandle>0:
            raise MemoryError("Failed to create Impedances")
        cdef Impedances obj = <Impedances>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.ImpedancesHandle h
        h = c_api.Impedances_create(<c_api.ListImpedanceHandle>items.handle)
        if h == <c_api.ImpedancesHandle>0:
            raise MemoryError("Failed to create Impedances")
        cdef Impedances obj = <Impedances>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ImpedancesHandle h
        try:
            h = c_api.Impedances_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ImpedancesHandle>0:
            raise MemoryError("Failed to create Impedances")
        cdef Impedances obj = <Impedances>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, value):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Impedances_push_back(self.handle, <c_api.ImpedanceHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Impedances_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Impedances_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Impedances_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Impedances_clear(self.handle)

    def const_at(self, idx):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ImpedanceHandle h_ret
        h_ret = c_api.Impedances_const_at(self.handle, idx)
        if h_ret == <c_api.ImpedanceHandle>0:
            return None
        return Impedance.from_capi(Impedance, h_ret)

    def at(self, idx):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ImpedanceHandle h_ret
        h_ret = c_api.Impedances_at(self.handle, idx)
        if h_ret == <c_api.ImpedanceHandle>0:
            return None
        return Impedance.from_capi(Impedance, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Impedances_items(self.handle, <c_api.ImpedanceHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Impedances_contains(self.handle, <c_api.ImpedanceHandle>value.handle)

    def intersection(self, b):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ImpedancesHandle h_ret
        h_ret = c_api.Impedances_intersection(self.handle, <c_api.ImpedancesHandle>b.handle)
        if h_ret == <c_api.ImpedancesHandle>0:
            return None
        return Impedances.from_capi(Impedances, h_ret)

    def index(self, value):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Impedances_index(self.handle, <c_api.ImpedanceHandle>value.handle)

    def equal(self, b):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Impedances_equal(self.handle, <c_api.ImpedancesHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Impedances_not_equal(self.handle, <c_api.ImpedancesHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ImpedancesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Impedances_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Impedances _impedances_from_capi(c_api.ImpedancesHandle h):
    cdef Impedances obj = <Impedances>Impedances.__new__(Impedances)
    obj.handle = h