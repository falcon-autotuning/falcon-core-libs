cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .list_map_string_bool cimport ListMapStringBool, _list_map_string_bool_from_capi
from .map_string_bool cimport MapStringBool, _map_string_bool_from_capi

cdef class AxesMapStringBool:
    def __cinit__(self):
        self.handle = <_c_api.AxesMapStringBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesMapStringBoolHandle>0 and self.owned:
            _c_api.AxesMapStringBool_destroy(self.handle)
        self.handle = <_c_api.AxesMapStringBoolHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesMapStringBoolHandle h
        h = _c_api.AxesMapStringBool_create_empty()
        if h == <_c_api.AxesMapStringBoolHandle>0:
            raise MemoryError("Failed to create AxesMapStringBool")
        cdef AxesMapStringBool obj = <AxesMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListMapStringBool data):
        cdef _c_api.AxesMapStringBoolHandle h
        h = _c_api.AxesMapStringBool_create(data.handle if data is not None else <_c_api.ListMapStringBoolHandle>0)
        if h == <_c_api.AxesMapStringBoolHandle>0:
            raise MemoryError("Failed to create AxesMapStringBool")
        cdef AxesMapStringBool obj = <AxesMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesMapStringBoolHandle h
        try:
            h = _c_api.AxesMapStringBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesMapStringBoolHandle>0:
            raise MemoryError("Failed to create AxesMapStringBool")
        cdef AxesMapStringBool obj = <AxesMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self):
        cdef _c_api.AxesMapStringBoolHandle h_ret = _c_api.AxesMapStringBool_copy(self.handle)
        if h_ret == <_c_api.AxesMapStringBoolHandle>0: return None
        return _axes_map_string_bool_from_capi(h_ret, owned=(h_ret != <_c_api.AxesMapStringBoolHandle>self.handle))

    def push_back(self, MapStringBool value):
        _c_api.AxesMapStringBool_push_back(self.handle, value.handle if value is not None else <_c_api.MapStringBoolHandle>0)

    def size(self):
        return _c_api.AxesMapStringBool_size(self.handle)

    def empty(self):
        return _c_api.AxesMapStringBool_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesMapStringBool_erase_at(self.handle, idx)

    def clear(self):
        _c_api.AxesMapStringBool_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.MapStringBoolHandle h_ret = _c_api.AxesMapStringBool_at(self.handle, idx)
        if h_ret == <_c_api.MapStringBoolHandle>0: return None
        return _map_string_bool_from_capi(h_ret, owned=False)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.AxesMapStringBool_items(self.handle, <_c_api.MapStringBoolHandle*>&out_buffer[0], buffer_size)

    def contains(self, MapStringBool value):
        return _c_api.AxesMapStringBool_contains(self.handle, value.handle if value is not None else <_c_api.MapStringBoolHandle>0)

    def index(self, MapStringBool value):
        return _c_api.AxesMapStringBool_index(self.handle, value.handle if value is not None else <_c_api.MapStringBoolHandle>0)

    def intersection(self, AxesMapStringBool other):
        cdef _c_api.AxesMapStringBoolHandle h_ret = _c_api.AxesMapStringBool_intersection(self.handle, other.handle if other is not None else <_c_api.AxesMapStringBoolHandle>0)
        if h_ret == <_c_api.AxesMapStringBoolHandle>0: return None
        return _axes_map_string_bool_from_capi(h_ret, owned=(h_ret != <_c_api.AxesMapStringBoolHandle>self.handle))

    def equal(self, AxesMapStringBool other):
        return _c_api.AxesMapStringBool_equal(self.handle, other.handle if other is not None else <_c_api.AxesMapStringBoolHandle>0)

    def __eq__(self, AxesMapStringBool other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, AxesMapStringBool other):
        return _c_api.AxesMapStringBool_not_equal(self.handle, other.handle if other is not None else <_c_api.AxesMapStringBoolHandle>0)

    def __ne__(self, AxesMapStringBool other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.AxesMapStringBool_to_json_string(self.handle)
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
        cdef AxesMapStringBool obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef AxesMapStringBool _axes_map_string_bool_from_capi(_c_api.AxesMapStringBoolHandle h, bint owned=True):
    if h == <_c_api.AxesMapStringBoolHandle>0:
        return None
    cdef AxesMapStringBool obj = AxesMapStringBool.__new__(AxesMapStringBool)
    obj.handle = h
    obj.owned = owned
    return obj
