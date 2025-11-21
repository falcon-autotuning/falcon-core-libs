# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .analytic_function cimport AnalyticFunction
from .f_array_double cimport FArrayDouble
from .instrument_port cimport InstrumentPort
from .list_string cimport ListString
from .map_string_double cimport MapStringDouble

cdef class PortTransform:
    cdef c_api.PortTransformHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PortTransformHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PortTransformHandle>0 and self.owned:
            c_api.PortTransform_destroy(self.handle)
        self.handle = <c_api.PortTransformHandle>0

    cdef PortTransform from_capi(cls, c_api.PortTransformHandle h):
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, port, transform):
        cdef c_api.PortTransformHandle h
        h = c_api.PortTransform_create(<c_api.InstrumentPortHandle>port.handle, <c_api.AnalyticFunctionHandle>transform.handle)
        if h == <c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_constant_transform(cls, port, value):
        cdef c_api.PortTransformHandle h
        h = c_api.PortTransform_create_constant_transform(<c_api.InstrumentPortHandle>port.handle, value)
        if h == <c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_identity_transform(cls, port):
        cdef c_api.PortTransformHandle h
        h = c_api.PortTransform_create_identity_transform(<c_api.InstrumentPortHandle>port.handle)
        if h == <c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PortTransformHandle h
        try:
            h = c_api.PortTransform_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PortTransformHandle>0:
            raise MemoryError("Failed to create PortTransform")
        cdef PortTransform obj = <PortTransform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def port(self):
        if self.handle == <c_api.PortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InstrumentPortHandle h_ret
        h_ret = c_api.PortTransform_port(self.handle)
        if h_ret == <c_api.InstrumentPortHandle>0:
            return None
        return InstrumentPort.from_capi(InstrumentPort, h_ret)

    def labels(self):
        if self.handle == <c_api.PortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.PortTransform_labels(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def evaluate(self, args, time):
        if self.handle == <c_api.PortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransform_evaluate(self.handle, <c_api.MapStringDoubleHandle>args.handle, time)

    def evaluate_arraywise(self, args, deltaT, maxTime):
        if self.handle == <c_api.PortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.PortTransform_evaluate_arraywise(self.handle, <c_api.MapStringDoubleHandle>args.handle, deltaT, maxTime)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def equal(self, b):
        if self.handle == <c_api.PortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransform_equal(self.handle, <c_api.PortTransformHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PortTransformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PortTransform_not_equal(self.handle, <c_api.PortTransformHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PortTransformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PortTransform_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PortTransform _porttransform_from_capi(c_api.PortTransformHandle h):
    cdef PortTransform obj = <PortTransform>PortTransform.__new__(PortTransform)
    obj.handle = h