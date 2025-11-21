# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class Domain:
    cdef c_api.DomainHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.DomainHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.DomainHandle>0 and self.owned:
            c_api.Domain_destroy(self.handle)
        self.handle = <c_api.DomainHandle>0

    cdef Domain from_capi(cls, c_api.DomainHandle h):
        cdef Domain obj = <Domain>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, min_val, max_val, lesser_bound_contained, greater_bound_contained):
        cdef c_api.DomainHandle h
        h = c_api.Domain_create(min_val, max_val, lesser_bound_contained, greater_bound_contained)
        if h == <c_api.DomainHandle>0:
            raise MemoryError("Failed to create Domain")
        cdef Domain obj = <Domain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.DomainHandle h
        try:
            h = c_api.Domain_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.DomainHandle>0:
            raise MemoryError("Failed to create Domain")
        cdef Domain obj = <Domain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def lesser_bound(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_lesser_bound(self.handle)

    def greater_bound(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_greater_bound(self.handle)

    def lesser_bound_contained(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_lesser_bound_contained(self.handle)

    def greater_bound_contained(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_greater_bound_contained(self.handle)

    def in(self, value):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_in(self.handle, value)

    def range(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_range(self.handle)

    def center(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_center(self.handle)

    def intersection(self, other):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.Domain_intersection(self.handle, <c_api.DomainHandle>other.handle)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def union(self, other):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.Domain_union(self.handle, <c_api.DomainHandle>other.handle)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def is_empty(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_is_empty(self.handle)

    def contains_domain(self, other):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_contains_domain(self.handle, <c_api.DomainHandle>other.handle)

    def shift(self, offset):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.Domain_shift(self.handle, offset)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def scale(self, scale):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.Domain_scale(self.handle, scale)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def transform(self, other, value):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_transform(self.handle, <c_api.DomainHandle>other.handle, value)

    def equal(self, other):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_equal(self.handle, <c_api.DomainHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Domain_not_equal(self.handle, <c_api.DomainHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.DomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Domain_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Domain _domain_from_capi(c_api.DomainHandle h):
    cdef Domain obj = <Domain>Domain.__new__(Domain)
    obj.handle = h