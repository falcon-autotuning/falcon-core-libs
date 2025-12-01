cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class IncreasingAlignment:
    def __cinit__(self):
        self.handle = <_c_api.IncreasingAlignmentHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.IncreasingAlignmentHandle>0 and self.owned:
            _c_api.IncreasingAlignment_destroy(self.handle)
        self.handle = <_c_api.IncreasingAlignmentHandle>0


cdef IncreasingAlignment _increasing_alignment_from_capi(_c_api.IncreasingAlignmentHandle h):
    if h == <_c_api.IncreasingAlignmentHandle>0:
        return None
    cdef IncreasingAlignment obj = IncreasingAlignment.__new__(IncreasingAlignment)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.IncreasingAlignmentHandle h
        h = _c_api.IncreasingAlignment_create_empty()
        if h == <_c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, bool alignment):
        cdef _c_api.IncreasingAlignmentHandle h
        h = _c_api.IncreasingAlignment_create(alignment)
        if h == <_c_api.IncreasingAlignmentHandle>0:
            raise MemoryError("Failed to create IncreasingAlignment")
        cdef IncreasingAlignment obj = <IncreasingAlignment>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def alignment(self, ):
        return _c_api.IncreasingAlignment_alignment(self.handle)

    def equal(self, IncreasingAlignment b):
        return _c_api.IncreasingAlignment_equal(self.handle, b.handle)

    def __eq__(self, IncreasingAlignment b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, IncreasingAlignment b):
        return _c_api.IncreasingAlignment_not_equal(self.handle, b.handle)

    def __ne__(self, IncreasingAlignment b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
