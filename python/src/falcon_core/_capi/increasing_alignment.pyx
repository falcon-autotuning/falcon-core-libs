cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class IncreasingAlignment:
    def __cinit__(self):
        self.handle = <_c_api.IncreasingAlignmentHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.IncreasingAlignmentHandle>0 and self.owned:
            _c_api.IncreasingAlignment_destroy(self.handle)
        self.handle = <_c_api.IncreasingAlignmentHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.IncreasingAlignmentHandle h
        try:
            h = _c_api.IncreasingAlignment_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.IncreasingAlignmentHandle h
        h = _c_api.IncreasingAlignment_create_empty()
        if h == <_c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, bint alignment):
        cdef _c_api.IncreasingAlignmentHandle h
        h = _c_api.IncreasingAlignment_create(alignment)
        if h == <_c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.IncreasingAlignmentHandle h_ret = _c_api.IncreasingAlignment_copy(self.handle)
        if h_ret == <_c_api.IncreasingAlignmentHandle>0:
            return None
        return _increasing_alignment_from_capi(h_ret, owned=(h_ret != <_c_api.IncreasingAlignmentHandle>self.handle))

    def equal(self, IncreasingAlignment other):
        return _c_api.IncreasingAlignment_equal(self.handle, other.handle if other is not None else <_c_api.IncreasingAlignmentHandle>0)

    def __eq__(self, IncreasingAlignment other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, IncreasingAlignment other):
        return _c_api.IncreasingAlignment_not_equal(self.handle, other.handle if other is not None else <_c_api.IncreasingAlignmentHandle>0)

    def __ne__(self, IncreasingAlignment other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.IncreasingAlignment_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def alignment(self, ):
        return _c_api.IncreasingAlignment_alignment(self.handle)

cdef IncreasingAlignment _increasing_alignment_from_capi(_c_api.IncreasingAlignmentHandle h, bint owned=True):
    if h == <_c_api.IncreasingAlignmentHandle>0:
        return None
    cdef IncreasingAlignment obj = IncreasingAlignment.__new__(IncreasingAlignment)
    obj.handle = h
    obj.owned = owned
    return obj
