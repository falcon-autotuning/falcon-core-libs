cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport pair_quantity_quantity

cdef class PairConnectionPairQuantityQuantity:
    def __cinit__(self):
        self.handle = <_c_api.PairConnectionPairQuantityQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairConnectionPairQuantityQuantityHandle>0 and self.owned:
            _c_api.PairConnectionPairQuantityQuantity_destroy(self.handle)
        self.handle = <_c_api.PairConnectionPairQuantityQuantityHandle>0


cdef PairConnectionPairQuantityQuantity _pair_connection_pair_quantity_quantity_from_capi(_c_api.PairConnectionPairQuantityQuantityHandle h):
    if h == <_c_api.PairConnectionPairQuantityQuantityHandle>0:
        return None
    cdef PairConnectionPairQuantityQuantity obj = PairConnectionPairQuantityQuantity.__new__(PairConnectionPairQuantityQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, Connection first, PairQuantityQuantity second):
        cdef _c_api.PairConnectionPairQuantityQuantityHandle h
        h = _c_api.PairConnectionPairQuantityQuantity_create(first.handle, second.handle)
        if h == <_c_api.PairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create PairConnectionPairQuantityQuantity")
        cdef PairConnectionPairQuantityQuantity obj = <PairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairConnectionPairQuantityQuantityHandle h
        try:
            h = _c_api.PairConnectionPairQuantityQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create PairConnectionPairQuantityQuantity")
        cdef PairConnectionPairQuantityQuantity obj = <PairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.PairConnectionPairQuantityQuantity_first(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.PairQuantityQuantityHandle h_ret = _c_api.PairConnectionPairQuantityQuantity_second(self.handle)
        if h_ret == <_c_api.PairQuantityQuantityHandle>0:
            return None
        return pair_quantity_quantity._pair_quantity_quantity_from_capi(h_ret)

    def equal(self, PairConnectionPairQuantityQuantity b):
        return _c_api.PairConnectionPairQuantityQuantity_equal(self.handle, b.handle)

    def __eq__(self, PairConnectionPairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairConnectionPairQuantityQuantity b):
        return _c_api.PairConnectionPairQuantityQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, PairConnectionPairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
