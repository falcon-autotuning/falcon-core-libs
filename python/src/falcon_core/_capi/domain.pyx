cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class Domain:
    def __cinit__(self):
        self.handle = <_c_api.DomainHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DomainHandle>0 and self.owned:
            _c_api.Domain_destroy(self.handle)
        self.handle = <_c_api.DomainHandle>0


cdef Domain _domain_from_capi(_c_api.DomainHandle h):
    if h == <_c_api.DomainHandle>0:
        return None
    cdef Domain obj = Domain.__new__(Domain)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, double min_val, double max_val, bool lesser_bound_contained, bool greater_bound_contained):
        cdef _c_api.DomainHandle h
        h = _c_api.Domain_create(min_val, max_val, lesser_bound_contained, greater_bound_contained)
        if h == <_c_api.DomainHandle>0:
            raise MemoryError("Failed to create Domain")
        cdef Domain obj = <Domain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.DomainHandle h
        try:
            h = _c_api.Domain_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.DomainHandle>0:
            raise MemoryError("Failed to create Domain")
        cdef Domain obj = <Domain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def lesser_bound(self, ):
        return _c_api.Domain_lesser_bound(self.handle)

    def greater_bound(self, ):
        return _c_api.Domain_greater_bound(self.handle)

    def lesser_bound_contained(self, ):
        return _c_api.Domain_lesser_bound_contained(self.handle)

    def greater_bound_contained(self, ):
        return _c_api.Domain_greater_bound_contained(self.handle)

    def contains(self, double value):
        return _c_api.Domain_in(self.handle, value)

    def get_range(self, ):
        return _c_api.Domain_range(self.handle)

    def center(self, ):
        return _c_api.Domain_center(self.handle)

    def intersection(self, Domain other):
        cdef _c_api.DomainHandle h_ret = _c_api.Domain_intersection(self.handle, other.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return _domain_from_capi(h_ret)

    def union(self, Domain other):
        cdef _c_api.DomainHandle h_ret = _c_api.Domain_union(self.handle, other.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return _domain_from_capi(h_ret)

    def is_empty(self, ):
        return _c_api.Domain_is_empty(self.handle)

    def contains_domain(self, Domain other):
        return _c_api.Domain_contains_domain(self.handle, other.handle)

    def shift(self, double offset):
        cdef _c_api.DomainHandle h_ret = _c_api.Domain_shift(self.handle, offset)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return _domain_from_capi(h_ret)

    def scale(self, double scale):
        cdef _c_api.DomainHandle h_ret = _c_api.Domain_scale(self.handle, scale)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return _domain_from_capi(h_ret)

    def transform(self, Domain other, double value):
        return _c_api.Domain_transform(self.handle, other.handle, value)

    def equal(self, Domain other):
        return _c_api.Domain_equal(self.handle, other.handle)

    def __eq__(self, Domain other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Domain other):
        return _c_api.Domain_not_equal(self.handle, other.handle)

    def __ne__(self, Domain other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
