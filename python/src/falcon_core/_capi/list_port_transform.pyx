cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport port_transform

cdef class ListPortTransform:
    def __cinit__(self):
        self.handle = <_c_api.ListPortTransformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPortTransformHandle>0 and self.owned:
            _c_api.ListPortTransform_destroy(self.handle)
        self.handle = <_c_api.ListPortTransformHandle>0


cdef ListPortTransform _list_port_transform_from_capi(_c_api.ListPortTransformHandle h):
    if h == <_c_api.ListPortTransformHandle>0:
        return None
    cdef ListPortTransform obj = ListPortTransform.__new__(ListPortTransform)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPortTransformHandle h
        h = _c_api.ListPortTransform_create_empty()
        if h == <_c_api.ListPortTransformHandle>0:
            raise MemoryError("Failed to create ListPortTransform")
        cdef ListPortTransform obj = <ListPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PortTransform data, size_t count):
        cdef _c_api.ListPortTransformHandle h
        h = _c_api.ListPortTransform_create(data.handle, count)
        if h == <_c_api.ListPortTransformHandle>0:
            raise MemoryError("Failed to create ListPortTransform")
        cdef ListPortTransform obj = <ListPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPortTransformHandle h
        try:
            h = _c_api.ListPortTransform_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPortTransformHandle>0:
            raise MemoryError("Failed to create ListPortTransform")
        cdef ListPortTransform obj = <ListPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PortTransform value):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.ListPortTransform_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return _list_port_transform_from_capi(h_ret)

    def push_back(self, PortTransform value):
        _c_api.ListPortTransform_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPortTransform_size(self.handle)

    def empty(self, ):
        return _c_api.ListPortTransform_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPortTransform_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPortTransform_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PortTransformHandle h_ret = _c_api.ListPortTransform_at(self.handle, idx)
        if h_ret == <_c_api.PortTransformHandle>0:
            return None
        return port_transform._port_transform_from_capi(h_ret)

    def items(self, PortTransform out_buffer, size_t buffer_size):
        return _c_api.ListPortTransform_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PortTransform value):
        return _c_api.ListPortTransform_contains(self.handle, value.handle)

    def index(self, PortTransform value):
        return _c_api.ListPortTransform_index(self.handle, value.handle)

    def intersection(self, ListPortTransform other):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.ListPortTransform_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return _list_port_transform_from_capi(h_ret)

    def equal(self, ListPortTransform b):
        return _c_api.ListPortTransform_equal(self.handle, b.handle)

    def __eq__(self, ListPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPortTransform b):
        return _c_api.ListPortTransform_not_equal(self.handle, b.handle)

    def __ne__(self, ListPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
