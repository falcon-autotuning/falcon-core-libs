cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .labelled_control_array cimport LabelledControlArray, _labelled_control_array_from_capi

cdef class ListLabelledControlArray:
    def __cinit__(self):
        self.handle = <_c_api.ListLabelledControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListLabelledControlArrayHandle>0 and self.owned:
            _c_api.ListLabelledControlArray_destroy(self.handle)
        self.handle = <_c_api.ListLabelledControlArrayHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListLabelledControlArrayHandle h
        h = _c_api.ListLabelledControlArray_create_empty()
        if h == <_c_api.ListLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledControlArray")
        cdef ListLabelledControlArray obj = <ListLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.ListLabelledControlArrayHandle h
        h = _c_api.ListLabelledControlArray_create(<_c_api.LabelledControlArrayHandle*>&data[0], count)
        if h == <_c_api.ListLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledControlArray")
        cdef ListLabelledControlArray obj = <ListLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListLabelledControlArrayHandle h
        try:
            h = _c_api.ListLabelledControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledControlArray")
        cdef ListLabelledControlArray obj = <ListLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.ListLabelledControlArrayHandle h_ret = _c_api.ListLabelledControlArray_copy(self.handle)
        if h_ret == <_c_api.ListLabelledControlArrayHandle>0:
            return None
        return _list_labelled_control_array_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, LabelledControlArray value):
        cdef _c_api.ListLabelledControlArrayHandle h_ret = _c_api.ListLabelledControlArray_fill_value(count, value.handle if value is not None else <_c_api.LabelledControlArrayHandle>0)
        if h_ret == <_c_api.ListLabelledControlArrayHandle>0:
            return None
        return _list_labelled_control_array_from_capi(h_ret)

    def push_back(self, LabelledControlArray value):
        _c_api.ListLabelledControlArray_push_back(self.handle, value.handle if value is not None else <_c_api.LabelledControlArrayHandle>0)

    def size(self, ):
        return _c_api.ListLabelledControlArray_size(self.handle)

    def empty(self, ):
        return _c_api.ListLabelledControlArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListLabelledControlArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListLabelledControlArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.ListLabelledControlArray_at(self.handle, idx)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=False)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.ListLabelledControlArray_items(self.handle, <_c_api.LabelledControlArrayHandle*>&out_buffer[0], buffer_size)

    def contains(self, LabelledControlArray value):
        return _c_api.ListLabelledControlArray_contains(self.handle, value.handle if value is not None else <_c_api.LabelledControlArrayHandle>0)

    def index(self, LabelledControlArray value):
        return _c_api.ListLabelledControlArray_index(self.handle, value.handle if value is not None else <_c_api.LabelledControlArrayHandle>0)

    def intersection(self, ListLabelledControlArray other):
        cdef _c_api.ListLabelledControlArrayHandle h_ret = _c_api.ListLabelledControlArray_intersection(self.handle, other.handle if other is not None else <_c_api.ListLabelledControlArrayHandle>0)
        if h_ret == <_c_api.ListLabelledControlArrayHandle>0:
            return None
        return _list_labelled_control_array_from_capi(h_ret)

    def equal(self, ListLabelledControlArray other):
        return _c_api.ListLabelledControlArray_equal(self.handle, other.handle if other is not None else <_c_api.ListLabelledControlArrayHandle>0)

    def __eq__(self, ListLabelledControlArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, ListLabelledControlArray other):
        return _c_api.ListLabelledControlArray_not_equal(self.handle, other.handle if other is not None else <_c_api.ListLabelledControlArrayHandle>0)

    def __ne__(self, ListLabelledControlArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.ListLabelledControlArray_to_json_string(self.handle)
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
        cdef ListLabelledControlArray obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef ListLabelledControlArray _list_labelled_control_array_from_capi(_c_api.ListLabelledControlArrayHandle h, bint owned=True):
    if h == <_c_api.ListLabelledControlArrayHandle>0:
        return None
    cdef ListLabelledControlArray obj = ListLabelledControlArray.__new__(ListLabelledControlArray)
    obj.handle = h
    obj.owned = owned
    return obj
