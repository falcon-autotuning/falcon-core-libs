cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport instrument_port
from . cimport port_transform

cdef class PairInstrumentPortPortTransform:
    def __cinit__(self):
        self.handle = <_c_api.PairInstrumentPortPortTransformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairInstrumentPortPortTransformHandle>0 and self.owned:
            _c_api.PairInstrumentPortPortTransform_destroy(self.handle)
        self.handle = <_c_api.PairInstrumentPortPortTransformHandle>0


cdef PairInstrumentPortPortTransform _pair_instrument_port_port_transform_from_capi(_c_api.PairInstrumentPortPortTransformHandle h):
    if h == <_c_api.PairInstrumentPortPortTransformHandle>0:
        return None
    cdef PairInstrumentPortPortTransform obj = PairInstrumentPortPortTransform.__new__(PairInstrumentPortPortTransform)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, InstrumentPort first, PortTransform second):
        cdef _c_api.PairInstrumentPortPortTransformHandle h
        h = _c_api.PairInstrumentPortPortTransform_create(first.handle, second.handle)
        if h == <_c_api.PairInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create PairInstrumentPortPortTransform")
        cdef PairInstrumentPortPortTransform obj = <PairInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairInstrumentPortPortTransformHandle h
        try:
            h = _c_api.PairInstrumentPortPortTransform_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairInstrumentPortPortTransformHandle>0:
            raise MemoryError("Failed to create PairInstrumentPortPortTransform")
        cdef PairInstrumentPortPortTransform obj = <PairInstrumentPortPortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.PairInstrumentPortPortTransform_first(self.handle)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return instrument_port._instrument_port_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.PortTransformHandle h_ret = _c_api.PairInstrumentPortPortTransform_second(self.handle)
        if h_ret == <_c_api.PortTransformHandle>0:
            return None
        return port_transform._port_transform_from_capi(h_ret)

    def equal(self, PairInstrumentPortPortTransform b):
        return _c_api.PairInstrumentPortPortTransform_equal(self.handle, b.handle)

    def __eq__(self, PairInstrumentPortPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairInstrumentPortPortTransform b):
        return _c_api.PairInstrumentPortPortTransform_not_equal(self.handle, b.handle)

    def __ne__(self, PairInstrumentPortPortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
