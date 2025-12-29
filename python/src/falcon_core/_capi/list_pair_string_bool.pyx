cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .pair_string_bool cimport PairStringBool, _pair_string_bool_from_capi

cdef class ListPairStringBool:
    def __cinit__(self):
        self.handle = <_c_api.ListPairStringBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairStringBoolHandle>0 and self.owned:
            _c_api.ListPairStringBool_destroy(self.handle)
        self.handle = <_c_api.ListPairStringBoolHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairStringBoolHandle h
        h = _c_api.ListPairStringBool_create_empty()
        if h == <_c_api.ListPairStringBoolHandle>0:
            raise MemoryError("Failed to create ListPairStringBool")
        cdef ListPairStringBool obj = <ListPairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.ListPairStringBoolHandle h
        h = _c_api.ListPairStringBool_create(<_c_api.PairStringBoolHandle*>&data[0], count)
        if h == <_c_api.ListPairStringBoolHandle>0:
            raise MemoryError("Failed to create ListPairStringBool")
        cdef ListPairStringBool obj = <ListPairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairStringBoolHandle h
        try:
            h = _c_api.ListPairStringBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairStringBoolHandle>0:
            raise MemoryError("Failed to create ListPairStringBool")
        cdef ListPairStringBool obj = <ListPairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairStringBool value):
        cdef _c_api.ListPairStringBoolHandle h_ret = _c_api.ListPairStringBool_fill_value(count, value.handle if value is not None else <_c_api.PairStringBoolHandle>0)
        if h_ret == <_c_api.ListPairStringBoolHandle>0:
            return None
        return _list_pair_string_bool_from_capi(h_ret)

    def push_back(self, PairStringBool value):
        _c_api.ListPairStringBool_push_back(self.handle, value.handle if value is not None else <_c_api.PairStringBoolHandle>0)

    def size(self, ):
        return _c_api.ListPairStringBool_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairStringBool_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairStringBool_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairStringBool_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairStringBoolHandle h_ret = _c_api.ListPairStringBool_at(self.handle, idx)
        if h_ret == <_c_api.PairStringBoolHandle>0:
            return None
        return _pair_string_bool_from_capi(h_ret, owned=False)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.ListPairStringBool_items(self.handle, <_c_api.PairStringBoolHandle*>&out_buffer[0], buffer_size)

    def contains(self, PairStringBool value):
        return _c_api.ListPairStringBool_contains(self.handle, value.handle if value is not None else <_c_api.PairStringBoolHandle>0)

    def index(self, PairStringBool value):
        return _c_api.ListPairStringBool_index(self.handle, value.handle if value is not None else <_c_api.PairStringBoolHandle>0)

    def intersection(self, ListPairStringBool other):
        cdef _c_api.ListPairStringBoolHandle h_ret = _c_api.ListPairStringBool_intersection(self.handle, other.handle if other is not None else <_c_api.ListPairStringBoolHandle>0)
        if h_ret == <_c_api.ListPairStringBoolHandle>0:
            return None
        return _list_pair_string_bool_from_capi(h_ret)

    def equal(self, ListPairStringBool b):
        return _c_api.ListPairStringBool_equal(self.handle, b.handle if b is not None else <_c_api.ListPairStringBoolHandle>0)

    def __eq__(self, ListPairStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairStringBool b):
        return _c_api.ListPairStringBool_not_equal(self.handle, b.handle if b is not None else <_c_api.ListPairStringBoolHandle>0)

    def __ne__(self, ListPairStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.ListPairStringBool_to_json_string(self.handle)
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

    def append(self, value):
        self.push_back(value)

    @classmethod
    def from_list(cls, items):
        cdef ListPairStringBool obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef ListPairStringBool _list_pair_string_bool_from_capi(_c_api.ListPairStringBoolHandle h, bint owned=True):
    if h == <_c_api.ListPairStringBoolHandle>0:
        return None
    cdef ListPairStringBool obj = ListPairStringBool.__new__(ListPairStringBool)
    obj.handle = h
    obj.owned = owned
    return obj
