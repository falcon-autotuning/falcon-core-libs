cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .analytic_function cimport AnalyticFunction, _analytic_function_from_capi
from .f_array_double cimport FArrayDouble, _f_array_double_from_capi
from .instrument_port cimport InstrumentPort, _instrument_port_from_capi
from .list_string cimport ListString, _list_string_from_capi
from .map_string_double cimport MapStringDouble, _map_string_double_from_capi

cdef class PortTransform:
    def __cinit__(self):
        self.handle = <_c_api.PortTransformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PortTransformHandle>0 and self.owned:
            _c_api.PortTransform_destroy(self.handle)
        self.handle = <_c_api.PortTransformHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    @classmethod
    def new(cls, InstrumentPort port, AnalyticFunction transform):
        cdef _c_api.PortTransformHandle h
        h = _c_api.PortTransform_create(port.handle if port is not None else <_c_api.InstrumentPortHandle>0, transform.handle if transform is not None else <_c_api.AnalyticFunctionHandle>0)
        if h == <_c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_constant_transform(cls, InstrumentPort port, double value):
        cdef _c_api.PortTransformHandle h
        h = _c_api.PortTransform_create_constant_transform(port.handle if port is not None else <_c_api.InstrumentPortHandle>0, value)
        if h == <_c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_identity_transform(cls, InstrumentPort port):
        cdef _c_api.PortTransformHandle h
        h = _c_api.PortTransform_create_identity_transform(port.handle if port is not None else <_c_api.InstrumentPortHandle>0)
        if h == <_c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.PortTransformHandle h_ret = _c_api.PortTransform_copy(self.handle)
        if h_ret == <_c_api.PortTransformHandle>0:
            return None
        return _port_transform_from_capi(h_ret, owned=(h_ret != <_c_api.PortTransformHandle>self.handle))

    def equal(self, PortTransform other):
        return _c_api.PortTransform_equal(self.handle, other.handle if other is not None else <_c_api.PortTransformHandle>0)

    def __eq__(self, PortTransform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, PortTransform other):
        return _c_api.PortTransform_not_equal(self.handle, other.handle if other is not None else <_c_api.PortTransformHandle>0)

    def __ne__(self, PortTransform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PortTransform_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def port(self, ):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.PortTransform_port(self.handle)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return _instrument_port_from_capi(h_ret, owned=True)

    def labels(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.PortTransform_labels(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret, owned=True)

    def evaluate(self, MapStringDouble args, double time):
        return _c_api.PortTransform_evaluate(self.handle, args.handle if args is not None else <_c_api.MapStringDoubleHandle>0, time)

    def evaluate_arraywise(self, MapStringDouble args, double deltaT, double maxTime):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.PortTransform_evaluate_arraywise(self.handle, args.handle if args is not None else <_c_api.MapStringDoubleHandle>0, deltaT, maxTime)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret, owned=True)

cdef PortTransform _port_transform_from_capi(_c_api.PortTransformHandle h, bint owned=True):
    if h == <_c_api.PortTransformHandle>0:
        return None
    cdef PortTransform obj = PortTransform.__new__(PortTransform)
    obj.handle = h
    obj.owned = owned
    return obj
