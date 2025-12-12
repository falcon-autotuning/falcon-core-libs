cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport domain

cdef class Discretizer:
    def __cinit__(self):
        self.handle = <_c_api.DiscretizerHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DiscretizerHandle>0 and self.owned:
            _c_api.Discretizer_destroy(self.handle)
        self.handle = <_c_api.DiscretizerHandle>0


cdef Discretizer _discretizer_from_capi(_c_api.DiscretizerHandle h):
    if h == <_c_api.DiscretizerHandle>0:
        return None
    cdef Discretizer obj = Discretizer.__new__(Discretizer)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_cartesian_discretizer(cls, double delta):
        cdef _c_api.DiscretizerHandle h
        h = _c_api.Discretizer_create_cartesian_discretizer(delta)
        if h == <_c_api.DiscretizerHandle>0:
            raise MemoryError("Failed to create Discretizer")
        cdef Discretizer obj = <Discretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_polar_discretizer(cls, double delta):
        cdef _c_api.DiscretizerHandle h
        h = _c_api.Discretizer_create_polar_discretizer(delta)
        if h == <_c_api.DiscretizerHandle>0:
            raise MemoryError("Failed to create Discretizer")
        cdef Discretizer obj = <Discretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.DiscretizerHandle h
        try:
            h = _c_api.Discretizer_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.DiscretizerHandle>0:
            raise MemoryError("Failed to create Discretizer")
        cdef Discretizer obj = <Discretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def delta(self, ):
        return _c_api.Discretizer_delta(self.handle)

    def set_delta(self, double delta):
        _c_api.Discretizer_set_delta(self.handle, delta)

    def domain(self, ):
        cdef _c_api.DomainHandle h_ret = _c_api.Discretizer_domain(self.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return domain._domain_from_capi(h_ret)

    def is_cartesian(self, ):
        return _c_api.Discretizer_is_cartesian(self.handle)

    def is_polar(self, ):
        return _c_api.Discretizer_is_polar(self.handle)

    def equal(self, Discretizer b):
        return _c_api.Discretizer_equal(self.handle, b.handle)

    def __eq__(self, Discretizer b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Discretizer b):
        return _c_api.Discretizer_not_equal(self.handle, b.handle)

    def __ne__(self, Discretizer b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
