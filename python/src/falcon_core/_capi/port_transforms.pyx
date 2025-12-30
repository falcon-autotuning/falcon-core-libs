cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .list_port_transform cimport ListPortTransform, _list_port_transform_from_capi
from .port_transform cimport PortTransform, _port_transform_from_capi

cdef class PortTransforms:
    def __cinit__(self):
        self.handle = <_c_api.PortTransformsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PortTransformsHandle>0 and self.owned:
            _c_api.PortTransforms_destroy(self.handle)
        self.handle = <_c_api.PortTransformsHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PortTransformsHandle h
        try:
            h = _c_api.PortTransforms_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.PortTransformsHandle h
        h = _c_api.PortTransforms_create_empty()
        if h == <_c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListPortTransform handle):
        cdef _c_api.PortTransformsHandle h
        h = _c_api.PortTransforms_create(handle.handle if handle is not None else <_c_api.ListPortTransformHandle>0)
        if h == <_c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.PortTransformsHandle h_ret = _c_api.PortTransforms_copy(self.handle)
        if h_ret == <_c_api.PortTransformsHandle>0:
            return None
        return _port_transforms_from_capi(h_ret)

    def equal(self, PortTransforms other):
        return _c_api.PortTransforms_equal(self.handle, other.handle if other is not None else <_c_api.PortTransformsHandle>0)

    def __eq__(self, PortTransforms other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, PortTransforms other):
        return _c_api.PortTransforms_not_equal(self.handle, other.handle if other is not None else <_c_api.PortTransformsHandle>0)

    def __ne__(self, PortTransforms other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PortTransforms_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def transforms(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.PortTransforms_transforms(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return _list_port_transform_from_capi(h_ret)

    def push_back(self, PortTransform value):
        _c_api.PortTransforms_push_back(self.handle, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def size(self, ):
        return _c_api.PortTransforms_size(self.handle)

    def empty(self, ):
        return _c_api.PortTransforms_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.PortTransforms_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.PortTransforms_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PortTransformHandle h_ret = _c_api.PortTransforms_at(self.handle, idx)
        if h_ret == <_c_api.PortTransformHandle>0:
            return None
        return _port_transform_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.PortTransforms_items(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return _list_port_transform_from_capi(h_ret)

    def contains(self, PortTransform value):
        return _c_api.PortTransforms_contains(self.handle, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def index(self, PortTransform value):
        return _c_api.PortTransforms_index(self.handle, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def intersection(self, PortTransforms other):
        cdef _c_api.PortTransformsHandle h_ret = _c_api.PortTransforms_intersection(self.handle, other.handle if other is not None else <_c_api.PortTransformsHandle>0)
        if h_ret == <_c_api.PortTransformsHandle>0:
            return None
        return _port_transforms_from_capi(h_ret)

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
        cdef PortTransforms obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef PortTransforms _port_transforms_from_capi(_c_api.PortTransformsHandle h, bint owned=True):
    if h == <_c_api.PortTransformsHandle>0:
        return None
    cdef PortTransforms obj = PortTransforms.__new__(PortTransforms)
    obj.handle = h
    obj.owned = owned
    return obj
