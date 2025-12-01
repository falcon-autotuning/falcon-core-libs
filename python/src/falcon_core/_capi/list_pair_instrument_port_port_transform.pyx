cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_instrument_port_port_transform

cdef class ListPairInstrumentPortPortTransform:
    def __cinit__(self):
        self.handle = <_c_api.ListPairInstrumentPortPortTransformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairInstrumentPortPortTransformHandle>0 and self.owned:
            _c_api.ListPairInstrumentPortPortTransform_destroy(self.handle)
        self.handle = <_c_api.ListPairInstrumentPortPortTransformHandle>0


cdef ListPairInstrumentPortPortTransform _list_pair_instrument_port_port_transform_from_capi(_c_api.ListPairInstrumentPortPortTransformHandle h):
    if h == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
        return None
    cdef ListPairInstrumentPortPortTransform obj = ListPairInstrumentPortPortTransform.__new__(ListPairInstrumentPortPortTransform)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairInstrumentPortPortTransformHandle h
        h = _c_api.ListPairInstrumentPortPortTransform_create_empty()
        if h == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create ListPairInstrumentPortPortTransform")
        cdef ListPairInstrumentPortPortTransform obj = <ListPairInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairInstrumentPortPortTransform data, size_t count):
        cdef _c_api.ListPairInstrumentPortPortTransformHandle h
        h = _c_api.ListPairInstrumentPortPortTransform_create(data.handle, count)
        if h == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create ListPairInstrumentPortPortTransform")
        cdef ListPairInstrumentPortPortTransform obj = <ListPairInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairInstrumentPortPortTransformHandle h
        try:
            h = _c_api.ListPairInstrumentPortPortTransform_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create ListPairInstrumentPortPortTransform")
        cdef ListPairInstrumentPortPortTransform obj = <ListPairInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairInstrumentPortPortTransform value):
        cdef _c_api.ListPairInstrumentPortPortTransformHandle h_ret = _c_api.ListPairInstrumentPortPortTransform_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
            return None
        return _list_pair_instrument_port_port_transform_from_capi(h_ret)

    def push_back(self, PairInstrumentPortPortTransform value):
        _c_api.ListPairInstrumentPortPortTransform_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairInstrumentPortPortTransform_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairInstrumentPortPortTransform_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairInstrumentPortPortTransform_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairInstrumentPortPortTransform_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairInstrumentPortPortTransformHandle h_ret = _c_api.ListPairInstrumentPortPortTransform_at(self.handle, idx)
        if h_ret == <_c_api.PairInstrumentPortPortTransformHandle>0:
            return None
        return pair_instrument_port_port_transform._pair_instrument_port_port_transform_from_capi(h_ret)

    def items(self, PairInstrumentPortPortTransform out_buffer, size_t buffer_size):
        return _c_api.ListPairInstrumentPortPortTransform_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairInstrumentPortPortTransform value):
        return _c_api.ListPairInstrumentPortPortTransform_contains(self.handle, value.handle)

    def index(self, PairInstrumentPortPortTransform value):
        return _c_api.ListPairInstrumentPortPortTransform_index(self.handle, value.handle)

    def intersection(self, ListPairInstrumentPortPortTransform other):
        cdef _c_api.ListPairInstrumentPortPortTransformHandle h_ret = _c_api.ListPairInstrumentPortPortTransform_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
            return None
        return _list_pair_instrument_port_port_transform_from_capi(h_ret)

    def equal(self, ListPairInstrumentPortPortTransform b):
        return _c_api.ListPairInstrumentPortPortTransform_equal(self.handle, b.handle)

    def __eq__(self, ListPairInstrumentPortPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairInstrumentPortPortTransform b):
        return _c_api.ListPairInstrumentPortPortTransform_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairInstrumentPortPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
