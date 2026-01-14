cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class Gname:
    def __cinit__(self):
        self.handle = <_c_api.GnameHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GnameHandle>0 and self.owned:
            _c_api.Gname_destroy(self.handle)
        self.handle = <_c_api.GnameHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.GnameHandle h
        try:
            h = _c_api.Gname_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.GnameHandle>0:
            raise MemoryError("Failed to create Gname")
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_num(cls, int num):
        cdef _c_api.GnameHandle h
        h = _c_api.Gname_create_from_num(num)
        if h == <_c_api.GnameHandle>0:
            raise MemoryError("Failed to create Gname")
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.GnameHandle h
        try:
            h = _c_api.Gname_create(s_name)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.GnameHandle>0:
            raise MemoryError("Failed to create Gname")
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self):
        cdef _c_api.GnameHandle h_ret = _c_api.Gname_copy(self.handle)
        if h_ret == <_c_api.GnameHandle>0: return None
        return _gname_from_capi(h_ret, owned=(h_ret != <_c_api.GnameHandle>self.handle))

    def equal(self, Gname other):
        return _c_api.Gname_equal(self.handle, other.handle if other is not None else <_c_api.GnameHandle>0)

    def __eq__(self, Gname other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, Gname other):
        return _c_api.Gname_not_equal(self.handle, other.handle if other is not None else <_c_api.GnameHandle>0)

    def __ne__(self, Gname other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Gname_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def gname(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Gname_gname(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef Gname _gname_from_capi(_c_api.GnameHandle h, bint owned=True):
    if h == <_c_api.GnameHandle>0:
        return None
    cdef Gname obj = Gname.__new__(Gname)
    obj.handle = h
    obj.owned = owned
    return obj
