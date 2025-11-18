# cython: language_level=3
from cpython.bytes cimport PyBytes_FromStringAndSize
from . cimport c_api
from libc.stddef cimport size_t

cdef class PairIntInt:
    """Manages a PairIntIntHandle and its lifecycle."""
    cdef c_api.PairIntIntHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairIntIntHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairIntIntHandle>0 and self.owned:
            c_api.PairIntInt_destroy(self.handle)
        self.handle = <c_api.PairIntIntHandle>0

    @classmethod
    def new(cls, int first, int second):
        cdef PairIntInt p = <PairIntInt>cls.__new__(cls)
        cdef c_api.PairIntIntHandle h = c_api.PairIntInt_create(first, second)
        if h == <c_api.PairIntIntHandle>0:
            raise MemoryError("failed to create PairIntInt")
        p.handle = h
        p.owned = True
        return p

    @classmethod
    def from_json(cls, json_str):
        b = json_str.encode("utf-8")
        cdef const char* raw = b
        cdef size_t l = len(b)
        cdef c_api.StringHandle s = c_api.String_create(raw, l)
        try:
            h = c_api.PairIntInt_from_json_string(s)
        finally:
            c_api.String_destroy(s)
        if h == <c_api.PairIntIntHandle>0:
            raise ValueError("failed to parse PairIntInt from json")
        p = <PairIntInt>cls.__new__(cls)
        p.handle = h
        p.owned = True
        return p

    def first(self):
        if self.handle == <c_api.PairIntIntHandle>0:
            raise ValueError("Pair is closed")
        return c_api.PairIntInt_first(self.handle)

    def second(self):
        if self.handle == <c_api.PairIntIntHandle>0:
            raise ValueError("Pair is closed")
        return c_api.PairIntInt_second(self.handle)

    def to_json(self):
        if self.handle == <c_api.PairIntIntHandle>0:
            return ""
        cdef c_api.StringHandle s = c_api.PairIntInt_to_json_string(self.handle)
        if s == <c_api.StringHandle>0:
            return ""
        cdef const char* raw = s.raw
        cdef size_t ln = s.length
        try:
            b = PyBytes_FromStringAndSize(raw, ln)
            return b.decode("utf-8")
        finally:
            c_api.String_destroy(s)

    def __richcmp__(self, other, int op):
        if not isinstance(other, PairIntInt):
            return NotImplemented
        cdef PairIntInt o = <PairIntInt>other
        if op == 2:  # ==
            return bool(c_api.PairIntInt_equal(self.handle, o.handle))
        elif op == 3:  # !=
            return bool(c_api.PairIntInt_not_equal(self.handle, o.handle))
        return NotImplemented

    cdef PairIntInt from_capi(cls, c_api.PairIntIntHandle h):
        cdef PairIntInt p = <PairIntInt>cls.__new__(cls)
        p.handle = h
        p.owned = False
        return p

# Module-level C factory for PairIntInt
cdef PairIntInt _pairintint_from_capi(c_api.PairIntIntHandle h):
    cdef PairIntInt p = <PairIntInt>PairIntInt.__new__(PairIntInt)
    p.handle = h
    p.owned = False
    return p
