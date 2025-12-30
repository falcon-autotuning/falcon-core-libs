cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .list_pair_string_string cimport ListPairStringString, _list_pair_string_string_from_capi
from .list_string cimport ListString, _list_string_from_capi
from .pair_string_string cimport PairStringString, _pair_string_string_from_capi

cdef class MapStringString:
    def __cinit__(self):
        self.handle = <_c_api.MapStringStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapStringStringHandle>0 and self.owned:
            _c_api.MapStringString_destroy(self.handle)
        self.handle = <_c_api.MapStringStringHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapStringStringHandle h
        h = _c_api.MapStringString_create_empty()
        if h == <_c_api.MapStringStringHandle>0:
            raise MemoryError("Failed to create MapStringString")
        cdef MapStringString obj = <MapStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.MapStringStringHandle h
        h = _c_api.MapStringString_create(<_c_api.PairStringStringHandle*>&data[0], count)
        if h == <_c_api.MapStringStringHandle>0:
            raise MemoryError("Failed to create MapStringString")
        cdef MapStringString obj = <MapStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapStringStringHandle h
        try:
            h = _c_api.MapStringString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapStringStringHandle>0:
            raise MemoryError("Failed to create MapStringString")
        cdef MapStringString obj = <MapStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.MapStringStringHandle h_ret = _c_api.MapStringString_copy(self.handle)
        if h_ret == <_c_api.MapStringStringHandle>0:
            return None
        return _map_string_string_from_capi(h_ret, owned=(h_ret != <_c_api.MapStringStringHandle>self.handle))

    def insert_or_assign(self, str key, str value):
        cdef bytes b_key = key.encode("utf-8")
        cdef _c_api.StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef bytes b_value = value.encode("utf-8")
        cdef _c_api.StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        _c_api.MapStringString_insert_or_assign(self.handle, s_key, s_value)
        _c_api.String_destroy(s_key)
        _c_api.String_destroy(s_value)

    def insert(self, str key, str value):
        cdef bytes b_key = key.encode("utf-8")
        cdef _c_api.StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef bytes b_value = value.encode("utf-8")
        cdef _c_api.StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        _c_api.MapStringString_insert(self.handle, s_key, s_value)
        _c_api.String_destroy(s_key)
        _c_api.String_destroy(s_value)

    def at(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef _c_api.StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef _c_api.StringHandle s_ret
        try:
            s_ret = _c_api.MapStringString_at(self.handle, s_key)
        finally:
            _c_api.String_destroy(s_key)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def erase(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef _c_api.StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        _c_api.MapStringString_erase(self.handle, s_key)
        _c_api.String_destroy(s_key)

    def size(self, ):
        return _c_api.MapStringString_size(self.handle)

    def empty(self, ):
        return _c_api.MapStringString_empty(self.handle)

    def clear(self, ):
        _c_api.MapStringString_clear(self.handle)

    def contains(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef _c_api.StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef bint ret_val
        try:
            ret_val = _c_api.MapStringString_contains(self.handle, s_key)
        finally:
            _c_api.String_destroy(s_key)
        return ret_val

    def keys(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.MapStringString_keys(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.MapStringString_values(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairStringStringHandle h_ret = _c_api.MapStringString_items(self.handle)
        if h_ret == <_c_api.ListPairStringStringHandle>0:
            return None
        return _list_pair_string_string_from_capi(h_ret)

    def equal(self, MapStringString other):
        return _c_api.MapStringString_equal(self.handle, other.handle if other is not None else <_c_api.MapStringStringHandle>0)

    def __eq__(self, MapStringString other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MapStringString other):
        return _c_api.MapStringString_not_equal(self.handle, other.handle if other is not None else <_c_api.MapStringStringHandle>0)

    def __ne__(self, MapStringString other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.MapStringString_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

cdef MapStringString _map_string_string_from_capi(_c_api.MapStringStringHandle h, bint owned=True):
    if h == <_c_api.MapStringStringHandle>0:
        return None
    cdef MapStringString obj = MapStringString.__new__(MapStringString)
    obj.handle = h
    obj.owned = owned
    return obj
