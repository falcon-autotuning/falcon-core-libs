cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .pair_size_t_size_t cimport PairSizeTSizeT, _pair_size_t_size_t_from_capi

cdef class ListPairSizeTSizeT:
    def __cinit__(self):
        self.handle = <_c_api.ListPairSizeTSizeTHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairSizeTSizeTHandle>0 and self.owned:
            _c_api.ListPairSizeTSizeT_destroy(self.handle)
        self.handle = <_c_api.ListPairSizeTSizeTHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairSizeTSizeTHandle h
        h = _c_api.ListPairSizeTSizeT_create_empty()
        if h == <_c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.ListPairSizeTSizeTHandle h
        h = _c_api.ListPairSizeTSizeT_create(<_c_api.PairSizeTSizeTHandle*>&data[0], count)
        if h == <_c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairSizeTSizeTHandle h
        try:
            h = _c_api.ListPairSizeTSizeT_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairSizeTSizeT value):
        cdef _c_api.ListPairSizeTSizeTHandle h_ret = _c_api.ListPairSizeTSizeT_fill_value(count, value.handle if value is not None else <_c_api.PairSizeTSizeTHandle>0)
        if h_ret == <_c_api.ListPairSizeTSizeTHandle>0:
            return None
        return _list_pair_size_t_size_t_from_capi(h_ret)

    def push_back(self, PairSizeTSizeT value):
        _c_api.ListPairSizeTSizeT_push_back(self.handle, value.handle if value is not None else <_c_api.PairSizeTSizeTHandle>0)

    def size(self, ):
        return _c_api.ListPairSizeTSizeT_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairSizeTSizeT_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairSizeTSizeT_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairSizeTSizeT_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairSizeTSizeTHandle h_ret = _c_api.ListPairSizeTSizeT_at(self.handle, idx)
        if h_ret == <_c_api.PairSizeTSizeTHandle>0:
            return None
        return _pair_size_t_size_t_from_capi(h_ret, owned=False)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.ListPairSizeTSizeT_items(self.handle, <_c_api.PairSizeTSizeTHandle*>&out_buffer[0], buffer_size)

    def contains(self, PairSizeTSizeT value):
        return _c_api.ListPairSizeTSizeT_contains(self.handle, value.handle if value is not None else <_c_api.PairSizeTSizeTHandle>0)

    def index(self, PairSizeTSizeT value):
        return _c_api.ListPairSizeTSizeT_index(self.handle, value.handle if value is not None else <_c_api.PairSizeTSizeTHandle>0)

    def intersection(self, ListPairSizeTSizeT other):
        cdef _c_api.ListPairSizeTSizeTHandle h_ret = _c_api.ListPairSizeTSizeT_intersection(self.handle, other.handle if other is not None else <_c_api.ListPairSizeTSizeTHandle>0)
        if h_ret == <_c_api.ListPairSizeTSizeTHandle>0:
            return None
        return _list_pair_size_t_size_t_from_capi(h_ret)

    def equal(self, ListPairSizeTSizeT b):
        return _c_api.ListPairSizeTSizeT_equal(self.handle, b.handle if b is not None else <_c_api.ListPairSizeTSizeTHandle>0)

    def __eq__(self, ListPairSizeTSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairSizeTSizeT b):
        return _c_api.ListPairSizeTSizeT_not_equal(self.handle, b.handle if b is not None else <_c_api.ListPairSizeTSizeTHandle>0)

    def __ne__(self, ListPairSizeTSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.ListPairSizeTSizeT_to_json_string(self.handle)
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
        cdef ListPairSizeTSizeT obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef ListPairSizeTSizeT _list_pair_size_t_size_t_from_capi(_c_api.ListPairSizeTSizeTHandle h, bint owned=True):
    if h == <_c_api.ListPairSizeTSizeTHandle>0:
        return None
    cdef ListPairSizeTSizeT obj = ListPairSizeTSizeT.__new__(ListPairSizeTSizeT)
    obj.handle = h
    obj.owned = owned
    return obj
