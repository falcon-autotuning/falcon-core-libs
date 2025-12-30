cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .gname cimport Gname, _gname_from_capi
from .group cimport Group, _group_from_capi

cdef class PairGnameGroup:
    def __cinit__(self):
        self.handle = <_c_api.PairGnameGroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairGnameGroupHandle>0 and self.owned:
            _c_api.PairGnameGroup_destroy(self.handle)
        self.handle = <_c_api.PairGnameGroupHandle>0


    @classmethod
    def new(cls, Gname first, Group second):
        cdef _c_api.PairGnameGroupHandle h
        h = _c_api.PairGnameGroup_create(first.handle if first is not None else <_c_api.GnameHandle>0, second.handle if second is not None else <_c_api.GroupHandle>0)
        if h == <_c_api.PairGnameGroupHandle>0:
            raise MemoryError("Failed to create PairGnameGroup")
        cdef PairGnameGroup obj = <PairGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairGnameGroupHandle h
        try:
            h = _c_api.PairGnameGroup_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairGnameGroupHandle>0:
            raise MemoryError("Failed to create PairGnameGroup")
        cdef PairGnameGroup obj = <PairGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.PairGnameGroupHandle h_ret = _c_api.PairGnameGroup_copy(self.handle)
        if h_ret == <_c_api.PairGnameGroupHandle>0:
            return None
        return _pair_gname_group_from_capi(h_ret)

    def first(self, ):
        cdef _c_api.GnameHandle h_ret = _c_api.PairGnameGroup_first(self.handle)
        if h_ret == <_c_api.GnameHandle>0:
            return None
        return _gname_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.GroupHandle h_ret = _c_api.PairGnameGroup_second(self.handle)
        if h_ret == <_c_api.GroupHandle>0:
            return None
        return _group_from_capi(h_ret)

    def equal(self, PairGnameGroup other):
        return _c_api.PairGnameGroup_equal(self.handle, other.handle if other is not None else <_c_api.PairGnameGroupHandle>0)

    def __eq__(self, PairGnameGroup other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, PairGnameGroup other):
        return _c_api.PairGnameGroup_not_equal(self.handle, other.handle if other is not None else <_c_api.PairGnameGroupHandle>0)

    def __ne__(self, PairGnameGroup other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairGnameGroup_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef PairGnameGroup _pair_gname_group_from_capi(_c_api.PairGnameGroupHandle h, bint owned=True):
    if h == <_c_api.PairGnameGroupHandle>0:
        return None
    cdef PairGnameGroup obj = PairGnameGroup.__new__(PairGnameGroup)
    obj.handle = h
    obj.owned = owned
    return obj
