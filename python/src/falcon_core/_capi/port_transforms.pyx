# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_port_transform cimport ListPortTransform
from .port_transform cimport PortTransform

cdef class PortTransforms:
    cdef c_api.PortTransformsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PortTransformsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PortTransformsHandle>0 and self.owned:
            c_api.PortTransforms_destroy(self.handle)
        self.handle = <c_api.PortTransformsHandle>0

    cdef PortTransforms from_capi(cls, c_api.PortTransformsHandle h):
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.PortTransformsHandle h
        h = c_api.PortTransforms_create_empty()
        if h == <c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, data, count):
        cdef c_api.PortTransformsHandle h
        h = c_api.PortTransforms_create_raw(<c_api.PortTransformHandle>data.handle, count)
        if h == <c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, handle):
        cdef c_api.PortTransformsHandle h
        h = c_api.PortTransforms_create(<c_api.ListPortTransformHandle>handle.handle)
        if h == <c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PortTransformsHandle h
        try:
            h = c_api.PortTransforms_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PortTransformsHandle>0:
            raise MemoryError("Failed to create PortTransforms")
        cdef PortTransforms obj = <PortTransforms>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def transforms(self):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPortTransformHandle h_ret
        h_ret = c_api.PortTransforms_transforms(self.handle)
        if h_ret == <c_api.ListPortTransformHandle>0:
            return None
        return ListPortTransform.from_capi(ListPortTransform, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.PortTransforms_push_back(self.handle, <c_api.PortTransformHandle>value.handle)

    def size(self):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransforms_size(self.handle)

    def empty(self):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransforms_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.PortTransforms_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.PortTransforms_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortTransformHandle h_ret
        h_ret = c_api.PortTransforms_at(self.handle, idx)
        if h_ret == <c_api.PortTransformHandle>0:
            return None
        return PortTransform.from_capi(PortTransform, h_ret)

    def items(self):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPortTransformHandle h_ret
        h_ret = c_api.PortTransforms_items(self.handle)
        if h_ret == <c_api.ListPortTransformHandle>0:
            return None
        return ListPortTransform.from_capi(ListPortTransform, h_ret)

    def contains(self, value):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransforms_contains(self.handle, <c_api.PortTransformHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransforms_index(self.handle, <c_api.PortTransformHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortTransformsHandle h_ret
        h_ret = c_api.PortTransforms_intersection(self.handle, <c_api.PortTransformsHandle>other.handle)
        if h_ret == <c_api.PortTransformsHandle>0:
            return None
        return PortTransforms.from_capi(PortTransforms, h_ret)

    def equal(self, b):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransforms_equal(self.handle, <c_api.PortTransformsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransforms_not_equal(self.handle, <c_api.PortTransformsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PortTransformsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PortTransforms_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PortTransforms _porttransforms_from_capi(c_api.PortTransformsHandle h):
    cdef PortTransforms obj = <PortTransforms>PortTransforms.__new__(PortTransforms)
    obj.handle = h