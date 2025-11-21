# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class IncreasingAlignment:
    cdef c_api.IncreasingAlignmentHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.IncreasingAlignmentHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.IncreasingAlignmentHandle>0 and self.owned:
            c_api.IncreasingAlignment_destroy(self.handle)
        self.handle = <c_api.IncreasingAlignmentHandle>0

    cdef IncreasingAlignment from_capi(cls, c_api.IncreasingAlignmentHandle h):
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.IncreasingAlignmentHandle h
        h = c_api.IncreasingAlignment_create_empty()
        if h == <c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, alignment):
        cdef c_api.IncreasingAlignmentHandle h
        h = c_api.IncreasingAlignment_create(alignment)
        if h == <c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.IncreasingAlignmentHandle h
        try:
            h = c_api.IncreasingAlignment_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def alignment(self):
        if self.handle == <c_api.IncreasingAlignmentHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.IncreasingAlignment_alignment(self.handle)

    def equal(self, b):
        if self.handle == <c_api.IncreasingAlignmentHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.IncreasingAlignment_equal(self.handle, <c_api.IncreasingAlignmentHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.IncreasingAlignmentHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.IncreasingAlignment_not_equal(self.handle, <c_api.IncreasingAlignmentHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.IncreasingAlignmentHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.IncreasingAlignment_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef IncreasingAlignment _increasingalignment_from_capi(c_api.IncreasingAlignmentHandle h):
    cdef IncreasingAlignment obj = <IncreasingAlignment>IncreasingAlignment.__new__(IncreasingAlignment)
    obj.handle = h