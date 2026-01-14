cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class String:
    def __cinit__(self):
        self.handle = <_c_api.StringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.StringHandle>0 and self.owned:
            _c_api.String_destroy(self.handle)
        self.handle = <_c_api.StringHandle>0


    @classmethod
    def new(cls, char[:] raw, size_t length):
        cdef _c_api.StringHandle h
        h = _c_api.String_create(&raw[0], length)
        if h == <_c_api.StringHandle>0:
            raise MemoryError("Failed to create String")
        cdef String obj = <String>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def wrap(char[:] raw):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.String_wrap(&raw[0])
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

cdef String _string_from_capi(_c_api.StringHandle h, bint owned=True):
    if h == <_c_api.StringHandle>0:
        return None
    cdef String obj = String.__new__(String)
    obj.handle = h
    obj.owned = owned
    return obj
