cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport analytic_function
from . cimport f_array_double
from . cimport instrument_port
from . cimport list_string
from . cimport map_string_double

cdef class PortTransform:
    def __cinit__(self):
        self.handle = <_c_api.PortTransformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PortTransformHandle>0 and self.owned:
            _c_api.PortTransform_destroy(self.handle)
        self.handle = <_c_api.PortTransformHandle>0


cdef PortTransform _port_transform_from_capi(_c_api.PortTransformHandle h):
    if h == <_c_api.PortTransformHandle>0:
        return None
    cdef PortTransform obj = PortTransform.__new__(PortTransform)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, InstrumentPort port, AnalyticFunction transform):
        cdef _c_api.PortTransformHandle h
        h = _c_api.PortTransform_create(port.handle, transform.handle)
        if h == <_c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def constant_transform(cls, InstrumentPort port, double value):
        cdef _c_api.PortTransformHandle h
        h = _c_api.PortTransform_create_constant_transform(port.handle, value)
        if h == <_c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def identity_transform(cls, InstrumentPort port):
        cdef _c_api.PortTransformHandle h
        h = _c_api.PortTransform_create_identity_transform(port.handle)
        if h == <_c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PortTransformHandle h
        try:
            h = _c_api.PortTransform_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def port(self, ):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.PortTransform_port(self.handle)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return instrument_port._instrument_port_from_capi(h_ret)

    def labels(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.PortTransform_labels(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return list_string._list_string_from_capi(h_ret)

    def evaluate(self, MapStringDouble args, double time):
        return _c_api.PortTransform_evaluate(self.handle, args.handle, time)

    def evaluate_arraywise(self, MapStringDouble args, double deltaT, double maxTime):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.PortTransform_evaluate_arraywise(self.handle, args.handle, deltaT, maxTime)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def equal(self, PortTransform b):
        return _c_api.PortTransform_equal(self.handle, b.handle)

    def __eq__(self, PortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PortTransform b):
        return _c_api.PortTransform_not_equal(self.handle, b.handle)

    def __ne__(self, PortTransform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
