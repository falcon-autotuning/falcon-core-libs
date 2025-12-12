cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport instrument_port
from . cimport list_instrument_port
from . cimport list_pair_instrument_port_port_transform
from . cimport list_port_transform
from . cimport pair_instrument_port_port_transform
from . cimport port_transform

cdef class MapInstrumentPortPortTransform:
    def __cinit__(self):
        self.handle = <_c_api.MapInstrumentPortPortTransformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapInstrumentPortPortTransformHandle>0 and self.owned:
            _c_api.MapInstrumentPortPortTransform_destroy(self.handle)
        self.handle = <_c_api.MapInstrumentPortPortTransformHandle>0


cdef MapInstrumentPortPortTransform _map_instrument_port_port_transform_from_capi(_c_api.MapInstrumentPortPortTransformHandle h):
    if h == <_c_api.MapInstrumentPortPortTransformHandle>0:
        return None
    cdef MapInstrumentPortPortTransform obj = MapInstrumentPortPortTransform.__new__(MapInstrumentPortPortTransform)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapInstrumentPortPortTransformHandle h
        h = _c_api.MapInstrumentPortPortTransform_create_empty()
        if h == <_c_api.MapInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create MapInstrumentPortPortTransform")
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairInstrumentPortPortTransform data, size_t count):
        cdef _c_api.MapInstrumentPortPortTransformHandle h
        h = _c_api.MapInstrumentPortPortTransform_create(data.handle, count)
        if h == <_c_api.MapInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create MapInstrumentPortPortTransform")
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapInstrumentPortPortTransformHandle h
        try:
            h = _c_api.MapInstrumentPortPortTransform_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create MapInstrumentPortPortTransform")
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, InstrumentPort key, PortTransform value):
        _c_api.MapInstrumentPortPortTransform_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, InstrumentPort key, PortTransform value):
        _c_api.MapInstrumentPortPortTransform_insert(self.handle, key.handle, value.handle)

    def at(self, InstrumentPort key):
        cdef _c_api.PortTransformHandle h_ret = _c_api.MapInstrumentPortPortTransform_at(self.handle, key.handle)
        if h_ret == <_c_api.PortTransformHandle>0:
            return None
        return port_transform._port_transform_from_capi(h_ret)

    def erase(self, InstrumentPort key):
        _c_api.MapInstrumentPortPortTransform_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapInstrumentPortPortTransform_size(self.handle)

    def empty(self, ):
        return _c_api.MapInstrumentPortPortTransform_empty(self.handle)

    def clear(self, ):
        _c_api.MapInstrumentPortPortTransform_clear(self.handle)

    def contains(self, InstrumentPort key):
        return _c_api.MapInstrumentPortPortTransform_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListInstrumentPortHandle h_ret = _c_api.MapInstrumentPortPortTransform_keys(self.handle)
        if h_ret == <_c_api.ListInstrumentPortHandle>0:
            return None
        return list_instrument_port._list_instrument_port_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.MapInstrumentPortPortTransform_values(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return list_port_transform._list_port_transform_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairInstrumentPortPortTransformHandle h_ret = _c_api.MapInstrumentPortPortTransform_items(self.handle)
        if h_ret == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
            return None
        return list_pair_instrument_port_port_transform._list_pair_instrument_port_port_transform_from_capi(h_ret)

    def equal(self, MapInstrumentPortPortTransform b):
        return _c_api.MapInstrumentPortPortTransform_equal(self.handle, b.handle)

    def __eq__(self, MapInstrumentPortPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapInstrumentPortPortTransform b):
        return _c_api.MapInstrumentPortPortTransform_not_equal(self.handle, b.handle)

    def __ne__(self, MapInstrumentPortPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
