cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport gname
from . cimport group

cdef class PairGnameGroup:
    def __cinit__(self):
        self.handle = <_c_api.PairGnameGroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairGnameGroupHandle>0 and self.owned:
            _c_api.PairGnameGroup_destroy(self.handle)
        self.handle = <_c_api.PairGnameGroupHandle>0


cdef PairGnameGroup _pair_gname_group_from_capi(_c_api.PairGnameGroupHandle h):
    if h == <_c_api.PairGnameGroupHandle>0:
        return None
    cdef PairGnameGroup obj = PairGnameGroup.__new__(PairGnameGroup)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Gname first, Group second):
        cdef _c_api.PairGnameGroupHandle h
        h = _c_api.PairGnameGroup_create(first.handle, second.handle)
        if h == <_c_api.PairGnameGroupHandle>0:
            raise MemoryError("Failed to create PairGnameGroup")
        cdef PairGnameGroup obj = <PairGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def first(self, ):
        cdef _c_api.GnameHandle h_ret = _c_api.PairGnameGroup_first(self.handle)
        if h_ret == <_c_api.GnameHandle>0:
            return None
        return gname._gname_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.GroupHandle h_ret = _c_api.PairGnameGroup_second(self.handle)
        if h_ret == <_c_api.GroupHandle>0:
            return None
        return group._group_from_capi(h_ret)

    def equal(self, PairGnameGroup b):
        return _c_api.PairGnameGroup_equal(self.handle, b.handle)

    def __eq__(self, PairGnameGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairGnameGroup b):
        return _c_api.PairGnameGroup_not_equal(self.handle, b.handle)

    def __ne__(self, PairGnameGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
