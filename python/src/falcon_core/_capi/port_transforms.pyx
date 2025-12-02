cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_port_transform
from . cimport port_transform

cdef class PortTransforms:
    def __cinit__(self):
        self.handle = <_c_api.PortTransformsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PortTransformsHandle>0 and self.owned:
            _c_api.PortTransforms_destroy(self.handle)
        self.handle = <_c_api.PortTransformsHandle>0


cdef PortTransforms _port_transforms_from_capi(_c_api.PortTransformsHandle h):
    if h == <_c_api.PortTransformsHandle>0:
        return None
    cdef PortTransforms obj = PortTransforms.__new__(PortTransforms)
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
    def new_raw(cls, PortTransform data, size_t count):
        cdef _c_api.PortTransformsHandle h
        h = _c_api.PortTransforms_create_raw(data.handle, count)
        if h == <_c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListPortTransform handle):
        cdef _c_api.PortTransformsHandle h
        h = _c_api.PortTransforms_create(handle.handle)
        if h == <_c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def transforms(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.PortTransforms_transforms(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return list_port_transform._list_port_transform_from_capi(h_ret)

    def push_back(self, PortTransform value):
        _c_api.PortTransforms_push_back(self.handle, value.handle)

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
        return port_transform._port_transform_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.PortTransforms_items(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return list_port_transform._list_port_transform_from_capi(h_ret)

    def contains(self, PortTransform value):
        return _c_api.PortTransforms_contains(self.handle, value.handle)

    def index(self, PortTransform value):
        return _c_api.PortTransforms_index(self.handle, value.handle)

    def intersection(self, PortTransforms other):
        cdef _c_api.PortTransformsHandle h_ret = _c_api.PortTransforms_intersection(self.handle, other.handle)
        if h_ret == <_c_api.PortTransformsHandle>0:
            return None
        return _port_transforms_from_capi(h_ret)

    def equal(self, PortTransforms b):
        return _c_api.PortTransforms_equal(self.handle, b.handle)

    def __eq__(self, PortTransforms b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PortTransforms b):
        return _c_api.PortTransforms_not_equal(self.handle, b.handle)

    def __ne__(self, PortTransforms b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
