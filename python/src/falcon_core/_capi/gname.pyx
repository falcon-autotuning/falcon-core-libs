cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class Gname:
    def __cinit__(self):
        self.handle = <_c_api.GnameHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GnameHandle>0 and self.owned:
            _c_api.Gname_destroy(self.handle)
        self.handle = <_c_api.GnameHandle>0


cdef Gname _gname_from_capi(_c_api.GnameHandle h):
    if h == <_c_api.GnameHandle>0:
        return None
    cdef Gname obj = Gname.__new__(Gname)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def from_num(cls, int num):
        cdef _c_api.GnameHandle h
        h = _c_api.Gname_create_from_num(num)
        if h == <_c_api.GnameHandle>0:
            raise MemoryError("Failed to create Gname")
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
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

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def gname(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.Gname_gname(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, Gname b):
        return _c_api.Gname_equal(self.handle, b.handle)

    def __eq__(self, Gname b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Gname b):
        return _c_api.Gname_not_equal(self.handle, b.handle)

    def __ne__(self, Gname b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
