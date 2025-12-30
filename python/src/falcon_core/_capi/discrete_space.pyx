cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .axes_coupled_labelled_domain cimport AxesCoupledLabelledDomain, _axes_coupled_labelled_domain_from_capi
from .axes_instrument_port cimport AxesInstrumentPort, _axes_instrument_port_from_capi
from .axes_int cimport AxesInt, _axes_int_from_capi
from .axes_labelled_control_array cimport AxesLabelledControlArray, _axes_labelled_control_array_from_capi
from .axes_map_string_bool cimport AxesMapStringBool, _axes_map_string_bool_from_capi
from .coupled_labelled_domain cimport CoupledLabelledDomain, _coupled_labelled_domain_from_capi
from .domain cimport Domain, _domain_from_capi
from .instrument_port cimport InstrumentPort, _instrument_port_from_capi
from .map_string_bool cimport MapStringBool, _map_string_bool_from_capi
from .ports cimport Ports, _ports_from_capi
from .unit_space cimport UnitSpace, _unit_space_from_capi

cdef class DiscreteSpace:
    def __cinit__(self):
        self.handle = <_c_api.DiscreteSpaceHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DiscreteSpaceHandle>0 and self.owned:
            _c_api.DiscreteSpace_destroy(self.handle)
        self.handle = <_c_api.DiscreteSpaceHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    @classmethod
    def new(cls, UnitSpace space, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing):
        cdef _c_api.DiscreteSpaceHandle h
        h = _c_api.DiscreteSpace_create(space.handle if space is not None else <_c_api.UnitSpaceHandle>0, axes.handle if axes is not None else <_c_api.AxesCoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.AxesMapStringBoolHandle>0)
        if h == <_c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_discrete_space(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, Domain domain):
        cdef _c_api.DiscreteSpaceHandle h
        h = _c_api.DiscreteSpace_create_cartesian_discrete_space(divisions.handle if divisions is not None else <_c_api.AxesIntHandle>0, axes.handle if axes is not None else <_c_api.AxesCoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.AxesMapStringBoolHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_discrete_space_1D(cls, int division, CoupledLabelledDomain shared_domain, MapStringBool increasing, Domain domain):
        cdef _c_api.DiscreteSpaceHandle h
        h = _c_api.DiscreteSpace_create_cartesian_discrete_space_1D(division, shared_domain.handle if shared_domain is not None else <_c_api.CoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.MapStringBoolHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.DiscreteSpaceHandle>0:
            raise MemoryError("Failed to create DiscreteSpace")
        cdef DiscreteSpace obj = <DiscreteSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.DiscreteSpaceHandle h_ret = _c_api.DiscreteSpace_copy(self.handle)
        if h_ret == <_c_api.DiscreteSpaceHandle>0:
            return None
        return _discrete_space_from_capi(h_ret, owned=(h_ret != <_c_api.DiscreteSpaceHandle>self.handle))

    def equal(self, DiscreteSpace other):
        return _c_api.DiscreteSpace_equal(self.handle, other.handle if other is not None else <_c_api.DiscreteSpaceHandle>0)

    def __eq__(self, DiscreteSpace other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, DiscreteSpace other):
        return _c_api.DiscreteSpace_not_equal(self.handle, other.handle if other is not None else <_c_api.DiscreteSpaceHandle>0)

    def __ne__(self, DiscreteSpace other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.DiscreteSpace_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def space(self, ):
        cdef _c_api.UnitSpaceHandle h_ret = _c_api.DiscreteSpace_space(self.handle)
        if h_ret == <_c_api.UnitSpaceHandle>0:
            return None
        return _unit_space_from_capi(h_ret)

    def axes(self, ):
        cdef _c_api.AxesCoupledLabelledDomainHandle h_ret = _c_api.DiscreteSpace_axes(self.handle)
        if h_ret == <_c_api.AxesCoupledLabelledDomainHandle>0:
            return None
        return _axes_coupled_labelled_domain_from_capi(h_ret)

    def increasing(self, ):
        cdef _c_api.AxesMapStringBoolHandle h_ret = _c_api.DiscreteSpace_increasing(self.handle)
        if h_ret == <_c_api.AxesMapStringBoolHandle>0:
            return None
        return _axes_map_string_bool_from_capi(h_ret)

    def knobs(self, ):
        cdef _c_api.PortsHandle h_ret = _c_api.DiscreteSpace_knobs(self.handle)
        if h_ret == <_c_api.PortsHandle>0:
            return None
        return _ports_from_capi(h_ret)

    def validate_unit_space_dimensionality_matches_knobs(self, ):
        _c_api.DiscreteSpace_validate_unit_space_dimensionality_matches_knobs(self.handle)

    def validate_knob_uniqueness(self, ):
        _c_api.DiscreteSpace_validate_knob_uniqueness(self.handle)

    def get_axis(self, InstrumentPort knob):
        return _c_api.DiscreteSpace_get_axis(self.handle, knob.handle if knob is not None else <_c_api.InstrumentPortHandle>0)

    def get_domain(self, InstrumentPort knob):
        cdef _c_api.DomainHandle h_ret = _c_api.DiscreteSpace_get_domain(self.handle, knob.handle if knob is not None else <_c_api.InstrumentPortHandle>0)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return _domain_from_capi(h_ret, owned=False)

    def get_projection(self, AxesInstrumentPort projection):
        cdef _c_api.AxesLabelledControlArrayHandle h_ret = _c_api.DiscreteSpace_get_projection(self.handle, projection.handle if projection is not None else <_c_api.AxesInstrumentPortHandle>0)
        if h_ret == <_c_api.AxesLabelledControlArrayHandle>0:
            return None
        return _axes_labelled_control_array_from_capi(h_ret, owned=False)

cdef DiscreteSpace _discrete_space_from_capi(_c_api.DiscreteSpaceHandle h, bint owned=True):
    if h == <_c_api.DiscreteSpaceHandle>0:
        return None
    cdef DiscreteSpace obj = DiscreteSpace.__new__(DiscreteSpace)
    obj.handle = h
    obj.owned = owned
    return obj
