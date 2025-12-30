cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class ListBool:
    def __cinit__(self):
        self.handle = <_c_api.ListBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListBoolHandle>0 and self.owned:
            _c_api.ListBool_destroy(self.handle)
        self.handle = <_c_api.ListBoolHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListBoolHandle h
        h = _c_api.ListBool_create_empty()
        if h == <_c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, uint8_t[:] data, size_t count):
        cdef _c_api.ListBoolHandle h
        h = _c_api.ListBool_create(<bool*>&data[0], count)
        if h == <_c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListBoolHandle h
        try:
            h = _c_api.ListBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.ListBoolHandle h_ret = _c_api.ListBool_copy(self.handle)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return _list_bool_from_capi(h_ret, owned=(h_ret != <_c_api.ListBoolHandle>self.handle))

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListBoolHandle h_ret = _c_api.ListBool_allocate(count)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return _list_bool_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, bint value):
        cdef _c_api.ListBoolHandle h_ret = _c_api.ListBool_fill_value(count, value)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return _list_bool_from_capi(h_ret)

    def push_back(self, bint value):
        _c_api.ListBool_push_back(self.handle, value)

    def size(self, ):
        return _c_api.ListBool_size(self.handle)

    def empty(self, ):
        return _c_api.ListBool_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListBool_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListBool_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.ListBool_at(self.handle, idx)

    def items(self, uint8_t[:] out_buffer, size_t buffer_size):
        return _c_api.ListBool_items(self.handle, <bool*>&out_buffer[0], buffer_size)

    def contains(self, bint value):
        return _c_api.ListBool_contains(self.handle, value)

    def index(self, bint value):
        return _c_api.ListBool_index(self.handle, value)

    def intersection(self, ListBool other):
        cdef _c_api.ListBoolHandle h_ret = _c_api.ListBool_intersection(self.handle, other.handle if other is not None else <_c_api.ListBoolHandle>0)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return _list_bool_from_capi(h_ret, owned=(h_ret != <_c_api.ListBoolHandle>self.handle))

    def equal(self, ListBool other):
        return _c_api.ListBool_equal(self.handle, other.handle if other is not None else <_c_api.ListBoolHandle>0)

    def __eq__(self, ListBool other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, ListBool other):
        return _c_api.ListBool_not_equal(self.handle, other.handle if other is not None else <_c_api.ListBoolHandle>0)

    def __ne__(self, ListBool other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.ListBool_to_json_string(self.handle)
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
        cdef ListBool obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef ListBool _list_bool_from_capi(_c_api.ListBoolHandle h, bint owned=True):
    if h == <_c_api.ListBoolHandle>0:
        return None
    cdef ListBool obj = ListBool.__new__(ListBool)
    obj.handle = h
    obj.owned = owned
    return obj
