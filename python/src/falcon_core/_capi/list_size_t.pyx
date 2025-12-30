cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class ListSizeT:
    def __cinit__(self):
        self.handle = <_c_api.ListSizeTHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListSizeTHandle>0 and self.owned:
            _c_api.ListSizeT_destroy(self.handle)
        self.handle = <_c_api.ListSizeTHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListSizeTHandle h
        h = _c_api.ListSizeT_create_empty()
        if h == <_c_api.ListSizeTHandle>0:
            raise MemoryError("Failed to create ListSizeT")
        cdef ListSizeT obj = <ListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.ListSizeTHandle h
        h = _c_api.ListSizeT_create(&data[0], count)
        if h == <_c_api.ListSizeTHandle>0:
            raise MemoryError("Failed to create ListSizeT")
        cdef ListSizeT obj = <ListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListSizeTHandle h
        try:
            h = _c_api.ListSizeT_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListSizeTHandle>0:
            raise MemoryError("Failed to create ListSizeT")
        cdef ListSizeT obj = <ListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListSizeT_copy(self.handle)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return _list_size_t_from_capi(h_ret)

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListSizeT_allocate(count)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return _list_size_t_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, size_t value):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListSizeT_fill_value(count, value)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return _list_size_t_from_capi(h_ret)

    def push_back(self, size_t value):
        _c_api.ListSizeT_push_back(self.handle, value)

    def size(self, ):
        return _c_api.ListSizeT_size(self.handle)

    def empty(self, ):
        return _c_api.ListSizeT_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListSizeT_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListSizeT_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.ListSizeT_at(self.handle, idx)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.ListSizeT_items(self.handle, &out_buffer[0], buffer_size)

    def contains(self, size_t value):
        return _c_api.ListSizeT_contains(self.handle, value)

    def index(self, size_t value):
        return _c_api.ListSizeT_index(self.handle, value)

    def intersection(self, ListSizeT other):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListSizeT_intersection(self.handle, other.handle if other is not None else <_c_api.ListSizeTHandle>0)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return _list_size_t_from_capi(h_ret)

    def equal(self, ListSizeT other):
        return _c_api.ListSizeT_equal(self.handle, other.handle if other is not None else <_c_api.ListSizeTHandle>0)

    def __eq__(self, ListSizeT other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, ListSizeT other):
        return _c_api.ListSizeT_not_equal(self.handle, other.handle if other is not None else <_c_api.ListSizeTHandle>0)

    def __ne__(self, ListSizeT other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.ListSizeT_to_json_string(self.handle)
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
        cdef ListSizeT obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef ListSizeT _list_size_t_from_capi(_c_api.ListSizeTHandle h, bint owned=True):
    if h == <_c_api.ListSizeTHandle>0:
        return None
    cdef ListSizeT obj = ListSizeT.__new__(ListSizeT)
    obj.handle = h
    obj.owned = owned
    return obj
