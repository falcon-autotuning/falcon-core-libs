cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .instrument_port cimport InstrumentPort, _instrument_port_from_capi
from .list_instrument_port cimport ListInstrumentPort, _list_instrument_port_from_capi
from .list_pair_instrument_port_port_transform cimport ListPairInstrumentPortPortTransform, _list_pair_instrument_port_port_transform_from_capi
from .list_port_transform cimport ListPortTransform, _list_port_transform_from_capi
from .pair_instrument_port_port_transform cimport PairInstrumentPortPortTransform, _pair_instrument_port_port_transform_from_capi
from .port_transform cimport PortTransform, _port_transform_from_capi

cdef class MapInstrumentPortPortTransform:
    def __cinit__(self):
        self.handle = <_c_api.MapInstrumentPortPortTransformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapInstrumentPortPortTransformHandle>0 and self.owned:
            _c_api.MapInstrumentPortPortTransform_destroy(self.handle)
        self.handle = <_c_api.MapInstrumentPortPortTransformHandle>0


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
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.MapInstrumentPortPortTransformHandle h
        h = _c_api.MapInstrumentPortPortTransform_create(<_c_api.PairInstrumentPortPortTransformHandle*>&data[0], count)
        if h == <_c_api.MapInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create MapInstrumentPortPortTransform")
        cdef MapInstrumentPortPortTransform obj = <MapInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.MapInstrumentPortPortTransformHandle h_ret = _c_api.MapInstrumentPortPortTransform_copy(self.handle)
        if h_ret == <_c_api.MapInstrumentPortPortTransformHandle>0:
            return None
        return _map_instrument_port_port_transform_from_capi(h_ret, owned=(h_ret != <_c_api.MapInstrumentPortPortTransformHandle>self.handle))

    def insert_or_assign(self, InstrumentPort key, PortTransform value):
        _c_api.MapInstrumentPortPortTransform_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.InstrumentPortHandle>0, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def insert(self, InstrumentPort key, PortTransform value):
        _c_api.MapInstrumentPortPortTransform_insert(self.handle, key.handle if key is not None else <_c_api.InstrumentPortHandle>0, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def at(self, InstrumentPort key):
        cdef _c_api.PortTransformHandle h_ret = _c_api.MapInstrumentPortPortTransform_at(self.handle, key.handle if key is not None else <_c_api.InstrumentPortHandle>0)
        if h_ret == <_c_api.PortTransformHandle>0:
            return None
        return _port_transform_from_capi(h_ret, owned=False)

    def erase(self, InstrumentPort key):
        _c_api.MapInstrumentPortPortTransform_erase(self.handle, key.handle if key is not None else <_c_api.InstrumentPortHandle>0)

    def size(self, ):
        return _c_api.MapInstrumentPortPortTransform_size(self.handle)

    def empty(self, ):
        return _c_api.MapInstrumentPortPortTransform_empty(self.handle)

    def clear(self, ):
        _c_api.MapInstrumentPortPortTransform_clear(self.handle)

    def contains(self, InstrumentPort key):
        return _c_api.MapInstrumentPortPortTransform_contains(self.handle, key.handle if key is not None else <_c_api.InstrumentPortHandle>0)

    def keys(self, ):
        cdef _c_api.ListInstrumentPortHandle h_ret = _c_api.MapInstrumentPortPortTransform_keys(self.handle)
        if h_ret == <_c_api.ListInstrumentPortHandle>0:
            return None
        return _list_instrument_port_from_capi(h_ret, owned=False)

    def values(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.MapInstrumentPortPortTransform_values(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return _list_port_transform_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListPairInstrumentPortPortTransformHandle h_ret = _c_api.MapInstrumentPortPortTransform_items(self.handle)
        if h_ret == <_c_api.ListPairInstrumentPortPortTransformHandle>0:
            return None
        return _list_pair_instrument_port_port_transform_from_capi(h_ret, owned=False)

    def equal(self, MapInstrumentPortPortTransform other):
        return _c_api.MapInstrumentPortPortTransform_equal(self.handle, other.handle if other is not None else <_c_api.MapInstrumentPortPortTransformHandle>0)

    def __eq__(self, MapInstrumentPortPortTransform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MapInstrumentPortPortTransform other):
        return _c_api.MapInstrumentPortPortTransform_not_equal(self.handle, other.handle if other is not None else <_c_api.MapInstrumentPortPortTransformHandle>0)

    def __ne__(self, MapInstrumentPortPortTransform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.MapInstrumentPortPortTransform_to_json_string(self.handle)
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

cdef MapInstrumentPortPortTransform _map_instrument_port_port_transform_from_capi(_c_api.MapInstrumentPortPortTransformHandle h, bint owned=True):
    if h == <_c_api.MapInstrumentPortPortTransformHandle>0:
        return None
    cdef MapInstrumentPortPortTransform obj = MapInstrumentPortPortTransform.__new__(MapInstrumentPortPortTransform)
    obj.handle = h
    obj.owned = owned
    return obj
