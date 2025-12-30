cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .domain cimport Domain, _domain_from_capi

cdef class Discretizer:
    def __cinit__(self):
        self.handle = <_c_api.DiscretizerHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DiscretizerHandle>0 and self.owned:
            _c_api.Discretizer_destroy(self.handle)
        self.handle = <_c_api.DiscretizerHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.DiscretizerHandle h_ret = _c_api.Discretizer_copy(self.handle)
        if h_ret == <_c_api.DiscretizerHandle>0:
            return None
        return _discretizer_from_capi(h_ret)

    def equal(self, Discretizer other):
        return _c_api.Discretizer_equal(self.handle, other.handle if other is not None else <_c_api.DiscretizerHandle>0)

    def __eq__(self, Discretizer other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Discretizer other):
        return _c_api.Discretizer_not_equal(self.handle, other.handle if other is not None else <_c_api.DiscretizerHandle>0)

    def __ne__(self, Discretizer other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Discretizer_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def delta(self, ):
        return _c_api.Discretizer_delta(self.handle)

    def set_delta(self, double delta):
        _c_api.Discretizer_set_delta(self.handle, delta)

    def domain(self, ):
        cdef _c_api.DomainHandle h_ret = _c_api.Discretizer_domain(self.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return _domain_from_capi(h_ret)

    def is_cartesian(self, ):
        return _c_api.Discretizer_is_cartesian(self.handle)

    def is_polar(self, ):
        return _c_api.Discretizer_is_polar(self.handle)

cdef Discretizer _discretizer_from_capi(_c_api.DiscretizerHandle h, bint owned=True):
    if h == <_c_api.DiscretizerHandle>0:
        return None
    cdef Discretizer obj = Discretizer.__new__(Discretizer)
    obj.handle = h
    obj.owned = owned
    return obj
