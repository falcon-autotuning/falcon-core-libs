# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .axes_coupled_labelled_domain cimport AxesCoupledLabelledDomain
from .axes_instrument_port cimport AxesInstrumentPort
from .axes_int cimport AxesInt
from .axes_labelled_control_array cimport AxesLabelledControlArray
from .axes_map_string_bool cimport AxesMapStringBool
from .coupled_labelled_domain cimport CoupledLabelledDomain
from .domain cimport Domain
from .instrument_port cimport InstrumentPort
from .map_string_bool cimport MapStringBool
from .ports cimport Ports
from .unit_space cimport UnitSpace

cdef class DiscreteSpace:
    cdef c_api.DiscreteSpaceHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.DiscreteSpaceHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.DiscreteSpaceHandle>0 and self.owned:
            c_api.DiscreteSpace_destroy(self.handle)
        self.handle = <c_api.DiscreteSpaceHandle>0

    cdef DiscreteSpace from_capi(cls, c_api.DiscreteSpaceHandle h):
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, space, axes, increasing):
        cdef c_api.DiscreteSpaceHandle h
        h = c_api.DiscreteSpace_create(<c_api.UnitSpaceHandle>space.handle, <c_api.AxesCoupledLabelledDomainHandle>axes.handle, <c_api.AxesMapStringBoolHandle>increasing.handle)
        if h == <c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesiandiscretespace(cls, divisions, axes, increasing, domain):
        cdef c_api.DiscreteSpaceHandle h
        h = c_api.DiscreteSpace_create_cartesiandiscretespace(<c_api.AxesIntHandle>divisions.handle, <c_api.AxesCoupledLabelledDomainHandle>axes.handle, <c_api.AxesMapStringBoolHandle>increasing.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesiandiscretespace1D(cls, division, shared_domain, increasing, domain):
        cdef c_api.DiscreteSpaceHandle h
        h = c_api.DiscreteSpace_create_cartesiandiscretespace1D(division, <c_api.CoupledLabelledDomainHandle>shared_domain.handle, <c_api.MapStringBoolHandle>increasing.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.DiscreteSpaceHandle h
        try:
            h = c_api.DiscreteSpace_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def space(self):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.UnitSpaceHandle h_ret
        h_ret = c_api.DiscreteSpace_space(self.handle)
        if h_ret == <c_api.UnitSpaceHandle>0:
            return None
        return UnitSpace.from_capi(UnitSpace, h_ret)

    def axes(self):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesCoupledLabelledDomainHandle h_ret
        h_ret = c_api.DiscreteSpace_axes(self.handle)
        if h_ret == <c_api.AxesCoupledLabelledDomainHandle>0:
            return None
        return AxesCoupledLabelledDomain.from_capi(AxesCoupledLabelledDomain, h_ret)

    def increasing(self):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesMapStringBoolHandle h_ret
        h_ret = c_api.DiscreteSpace_increasing(self.handle)
        if h_ret == <c_api.AxesMapStringBoolHandle>0:
            return None
        return AxesMapStringBool.from_capi(AxesMapStringBool, h_ret)

    def knobs(self):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortsHandle h_ret
        h_ret = c_api.DiscreteSpace_knobs(self.handle)
        if h_ret == <c_api.PortsHandle>0:
            return None
        return Ports.from_capi(Ports, h_ret)

    def validate_unit_space_dimensionality_matches_knobs(self):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DiscreteSpace_validate_unit_space_dimensionality_matches_knobs(self.handle)

    def validate_knob_uniqueness(self):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DiscreteSpace_validate_knob_uniqueness(self.handle)

    def get_axis(self, knob):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DiscreteSpace_get_axis(self.handle, <c_api.InstrumentPortHandle>knob.handle)

    def get_domain(self, knob):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.DiscreteSpace_get_domain(self.handle, <c_api.InstrumentPortHandle>knob.handle)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def get_projection(self, projection):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesLabelledControlArrayHandle h_ret
        h_ret = c_api.DiscreteSpace_get_projection(self.handle, <c_api.AxesInstrumentPortHandle>projection.handle)
        if h_ret == <c_api.AxesLabelledControlArrayHandle>0:
            return None
        return AxesLabelledControlArray.from_capi(AxesLabelledControlArray, h_ret)

    def equal(self, other):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DiscreteSpace_equal(self.handle, <c_api.DiscreteSpaceHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DiscreteSpace_not_equal(self.handle, <c_api.DiscreteSpaceHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.DiscreteSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.DiscreteSpace_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef DiscreteSpace _discretespace_from_capi(c_api.DiscreteSpaceHandle h):
    cdef DiscreteSpace obj = <DiscreteSpace>DiscreteSpace.__new__(DiscreteSpace)
    obj.handle = h