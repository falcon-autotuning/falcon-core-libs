cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport axes_coupled_labelled_domain
from . cimport axes_instrument_port
from . cimport axes_int
from . cimport axes_labelled_control_array
from . cimport axes_map_string_bool
from . cimport coupled_labelled_domain
from . cimport domain
from . cimport instrument_port
from . cimport map_string_bool
from . cimport ports
from . cimport unit_space

cdef class DiscreteSpace:
    def __cinit__(self):
        self.handle = <_c_api.DiscreteSpaceHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DiscreteSpaceHandle>0 and self.owned:
            _c_api.DiscreteSpace_destroy(self.handle)
        self.handle = <_c_api.DiscreteSpaceHandle>0


cdef DiscreteSpace _discrete_space_from_capi(_c_api.DiscreteSpaceHandle h):
    if h == <_c_api.DiscreteSpaceHandle>0:
        return None
    cdef DiscreteSpace obj = DiscreteSpace.__new__(DiscreteSpace)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, UnitSpace space, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing):
        cdef _c_api.DiscreteSpaceHandle h
        h = _c_api.DiscreteSpace_create(space.handle, axes.handle, increasing.handle)
        if h == <_c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def cartesiandiscretespace(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, Domain domain):
        cdef _c_api.DiscreteSpaceHandle h
        h = _c_api.DiscreteSpace_create_cartesiandiscretespace(divisions.handle, axes.handle, increasing.handle, domain.handle)
        if h == <_c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def cartesiandiscretespace1D(cls, int division, CoupledLabelledDomain shared_domain, MapStringBool increasing, Domain domain):
        cdef _c_api.DiscreteSpaceHandle h
        h = _c_api.DiscreteSpace_create_cartesiandiscretespace1D(division, shared_domain.handle, increasing.handle, domain.handle)
        if h == <_c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.DiscreteSpaceHandle h
        try:
            h = _c_api.DiscreteSpace_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def space(self, ):
        cdef _c_api.UnitSpaceHandle h_ret = _c_api.DiscreteSpace_space(self.handle)
        if h_ret == <_c_api.UnitSpaceHandle>0:
            return None
        return unit_space._unit_space_from_capi(h_ret)

    def axes(self, ):
        cdef _c_api.AxesCoupledLabelledDomainHandle h_ret = _c_api.DiscreteSpace_axes(self.handle)
        if h_ret == <_c_api.AxesCoupledLabelledDomainHandle>0:
            return None
        return axes_coupled_labelled_domain._axes_coupled_labelled_domain_from_capi(h_ret)

    def increasing(self, ):
        cdef _c_api.AxesMapStringBoolHandle h_ret = _c_api.DiscreteSpace_increasing(self.handle)
        if h_ret == <_c_api.AxesMapStringBoolHandle>0:
            return None
        return axes_map_string_bool._axes_map_string_bool_from_capi(h_ret)

    def knobs(self, ):
        cdef _c_api.PortsHandle h_ret = _c_api.DiscreteSpace_knobs(self.handle)
        if h_ret == <_c_api.PortsHandle>0:
            return None
        return ports._ports_from_capi(h_ret)

    def validate_unit_space_dimensionality_matches_knobs(self, ):
        _c_api.DiscreteSpace_validate_unit_space_dimensionality_matches_knobs(self.handle)

    def validate_knob_uniqueness(self, ):
        _c_api.DiscreteSpace_validate_knob_uniqueness(self.handle)

    def get_axis(self, InstrumentPort knob):
        return _c_api.DiscreteSpace_get_axis(self.handle, knob.handle)

    def get_domain(self, InstrumentPort knob):
        cdef _c_api.DomainHandle h_ret = _c_api.DiscreteSpace_get_domain(self.handle, knob.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return domain._domain_from_capi(h_ret)

    def get_projection(self, AxesInstrumentPort projection):
        cdef _c_api.AxesLabelledControlArrayHandle h_ret = _c_api.DiscreteSpace_get_projection(self.handle, projection.handle)
        if h_ret == <_c_api.AxesLabelledControlArrayHandle>0:
            return None
        return axes_labelled_control_array._axes_labelled_control_array_from_capi(h_ret)

    def equal(self, DiscreteSpace other):
        return _c_api.DiscreteSpace_equal(self.handle, other.handle)

    def __eq__(self, DiscreteSpace other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, DiscreteSpace other):
        return _c_api.DiscreteSpace_not_equal(self.handle, other.handle)

    def __ne__(self, DiscreteSpace other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
