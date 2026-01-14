cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .control_array cimport ControlArray, _control_array_from_capi
from .list_control_array cimport ListControlArray, _list_control_array_from_capi

cdef class AxesControlArray:
    def __cinit__(self):
        self.handle = <_c_api.AxesControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesControlArrayHandle>0 and self.owned:
            _c_api.AxesControlArray_destroy(self.handle)
        self.handle = <_c_api.AxesControlArrayHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesControlArrayHandle h
        h = _c_api.AxesControlArray_create_empty()
        if h == <_c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListControlArray data):
        cdef _c_api.AxesControlArrayHandle h
        h = _c_api.AxesControlArray_create(data.handle if data is not None else <_c_api.ListControlArrayHandle>0)
        if h == <_c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesControlArrayHandle h
        try:
            h = _c_api.AxesControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self):
        cdef _c_api.AxesControlArrayHandle h_ret = _c_api.AxesControlArray_copy(self.handle)
        if h_ret == <_c_api.AxesControlArrayHandle>0: return None
        return _axes_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.AxesControlArrayHandle>self.handle))

    def push_back(self, ControlArray value):
        _c_api.AxesControlArray_push_back(self.handle, value.handle if value is not None else <_c_api.ControlArrayHandle>0)

    def size(self):
        return _c_api.AxesControlArray_size(self.handle)

    def empty(self):
        return _c_api.AxesControlArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesControlArray_erase_at(self.handle, idx)

    def clear(self):
        _c_api.AxesControlArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ControlArrayHandle h_ret = _c_api.AxesControlArray_at(self.handle, idx)
        if h_ret == <_c_api.ControlArrayHandle>0: return None
        return _control_array_from_capi(h_ret, owned=False)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.AxesControlArray_items(self.handle, <_c_api.ControlArrayHandle*>&out_buffer[0], buffer_size)

    def contains(self, ControlArray value):
        return _c_api.AxesControlArray_contains(self.handle, value.handle if value is not None else <_c_api.ControlArrayHandle>0)

    def index(self, ControlArray value):
        return _c_api.AxesControlArray_index(self.handle, value.handle if value is not None else <_c_api.ControlArrayHandle>0)

    def intersection(self, AxesControlArray other):
        cdef _c_api.AxesControlArrayHandle h_ret = _c_api.AxesControlArray_intersection(self.handle, other.handle if other is not None else <_c_api.AxesControlArrayHandle>0)
        if h_ret == <_c_api.AxesControlArrayHandle>0: return None
        return _axes_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.AxesControlArrayHandle>self.handle))

    def equal(self, AxesControlArray other):
        return _c_api.AxesControlArray_equal(self.handle, other.handle if other is not None else <_c_api.AxesControlArrayHandle>0)

    def __eq__(self, AxesControlArray other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, AxesControlArray other):
        return _c_api.AxesControlArray_not_equal(self.handle, other.handle if other is not None else <_c_api.AxesControlArrayHandle>0)

    def __ne__(self, AxesControlArray other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.AxesControlArray_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size

    def __getitem__(self, key):
        ret = self.at(key)
        if ret is None:
            raise IndexError(f"{key} not found in {self.__class__.__name__}")
        return ret

    def __iter__(self):
        for i in range(len(self)):
            yield self[i]

    def append(self, value):
        self.push_back(value)

    @classmethod
    def from_list(cls, items):
        cdef AxesControlArray obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef AxesControlArray _axes_control_array_from_capi(_c_api.AxesControlArrayHandle h, bint owned=True):
    if h == <_c_api.AxesControlArrayHandle>0:
        return None
    cdef AxesControlArray obj = AxesControlArray.__new__(AxesControlArray)
    obj.handle = h
    obj.owned = owned
    return obj
