# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .domain cimport Domain

cdef class Discretizer:
    cdef c_api.DiscretizerHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.DiscretizerHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.DiscretizerHandle>0 and self.owned:
            c_api.Discretizer_destroy(self.handle)
        self.handle = <c_api.DiscretizerHandle>0

    cdef Discretizer from_capi(cls, c_api.DiscretizerHandle h):
        cdef Discretizer obj = <Discretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_cartesian_discretizer(cls, delta):
        cdef c_api.DiscretizerHandle h
        h = c_api.Discretizer_create_cartesian_discretizer(delta)
        if h == <c_api.DiscretizerHandle>0:
            raise MemoryError("Failed to create Discretizer")
        cdef Discretizer obj = <Discretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_polar_discretizer(cls, delta):
        cdef c_api.DiscretizerHandle h
        h = c_api.Discretizer_create_polar_discretizer(delta)
        if h == <c_api.DiscretizerHandle>0:
            raise MemoryError("Failed to create Discretizer")
        cdef Discretizer obj = <Discretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.DiscretizerHandle h
        try:
            h = c_api.Discretizer_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.DiscretizerHandle>0:
            raise MemoryError("Failed to create Discretizer")
        cdef Discretizer obj = <Discretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def delta(self):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Discretizer_delta(self.handle)

    def set_delta(self, delta):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Discretizer_set_delta(self.handle, delta)

    def domain(self):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.Discretizer_domain(self.handle)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def is_cartesian(self):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Discretizer_is_cartesian(self.handle)

    def is_polar(self):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Discretizer_is_polar(self.handle)

    def equal(self, b):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Discretizer_equal(self.handle, <c_api.DiscretizerHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Discretizer_not_equal(self.handle, <c_api.DiscretizerHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.DiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Discretizer_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Discretizer _discretizer_from_capi(c_api.DiscretizerHandle h):
    cdef Discretizer obj = <Discretizer>Discretizer.__new__(Discretizer)
    obj.handle = h