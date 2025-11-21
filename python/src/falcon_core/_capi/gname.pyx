# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class Gname:
    cdef c_api.GnameHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.GnameHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.GnameHandle>0 and self.owned:
            c_api.Gname_destroy(self.handle)
        self.handle = <c_api.GnameHandle>0

    cdef Gname from_capi(cls, c_api.GnameHandle h):
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_from_num(cls, num):
        cdef c_api.GnameHandle h
        h = c_api.Gname_create_from_num(num)
        if h == <c_api.GnameHandle>0:
            raise MemoryError("Failed to create Gname")
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, name):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.GnameHandle h
        try:
            h = c_api.Gname_create(s_name)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.GnameHandle>0:
            raise MemoryError("Failed to create Gname")
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.GnameHandle h
        try:
            h = c_api.Gname_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.GnameHandle>0:
            raise MemoryError("Failed to create Gname")
        cdef Gname obj = <Gname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def gname(self):
        if self.handle == <c_api.GnameHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Gname_gname(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, b):
        if self.handle == <c_api.GnameHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Gname_equal(self.handle, <c_api.GnameHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.GnameHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Gname_not_equal(self.handle, <c_api.GnameHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.GnameHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Gname_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Gname _gname_from_capi(c_api.GnameHandle h):
    cdef Gname obj = <Gname>Gname.__new__(Gname)
    obj.handle = h