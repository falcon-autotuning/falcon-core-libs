cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .axes_coupled_labelled_domain cimport AxesCoupledLabelledDomain, _axes_coupled_labelled_domain_from_capi
from .axes_int cimport AxesInt, _axes_int_from_capi
from .axes_map_string_bool cimport AxesMapStringBool, _axes_map_string_bool_from_capi
from .coupled_labelled_domain cimport CoupledLabelledDomain, _coupled_labelled_domain_from_capi
from .discrete_space cimport DiscreteSpace, _discrete_space_from_capi
from .domain cimport Domain, _domain_from_capi
from .list_port_transform cimport ListPortTransform, _list_port_transform_from_capi
from .map_string_bool cimport MapStringBool, _map_string_bool_from_capi
from .port_transform cimport PortTransform, _port_transform_from_capi

cdef class Waveform:
    def __cinit__(self):
        self.handle = <_c_api.WaveformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.WaveformHandle>0 and self.owned:
            _c_api.Waveform_destroy(self.handle)
        self.handle = <_c_api.WaveformHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.WaveformHandle h
        try:
            h = _c_api.Waveform_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, DiscreteSpace space, ListPortTransform transforms):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create(space.handle if space is not None else <_c_api.DiscreteSpaceHandle>0, transforms.handle if transforms is not None else <_c_api.ListPortTransformHandle>0)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_waveform(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, ListPortTransform transforms, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesian_waveform(divisions.handle if divisions is not None else <_c_api.AxesIntHandle>0, axes.handle if axes is not None else <_c_api.AxesCoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.AxesMapStringBoolHandle>0, transforms.handle if transforms is not None else <_c_api.ListPortTransformHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_identity_waveform(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesian_identity_waveform(divisions.handle if divisions is not None else <_c_api.AxesIntHandle>0, axes.handle if axes is not None else <_c_api.AxesCoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.AxesMapStringBoolHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_waveform_2D(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, ListPortTransform transforms, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesian_waveform_2D(divisions.handle if divisions is not None else <_c_api.AxesIntHandle>0, axes.handle if axes is not None else <_c_api.AxesCoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.AxesMapStringBoolHandle>0, transforms.handle if transforms is not None else <_c_api.ListPortTransformHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_identity_waveform_2D(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesian_identity_waveform_2D(divisions.handle if divisions is not None else <_c_api.AxesIntHandle>0, axes.handle if axes is not None else <_c_api.AxesCoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.AxesMapStringBoolHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_waveform_1D(cls, int division, CoupledLabelledDomain shared_domain, MapStringBool increasing, ListPortTransform transforms, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesian_waveform_1D(division, shared_domain.handle if shared_domain is not None else <_c_api.CoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.MapStringBoolHandle>0, transforms.handle if transforms is not None else <_c_api.ListPortTransformHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_identity_waveform_1D(cls, int division, CoupledLabelledDomain shared_domain, MapStringBool increasing, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesian_identity_waveform_1D(division, shared_domain.handle if shared_domain is not None else <_c_api.CoupledLabelledDomainHandle>0, increasing.handle if increasing is not None else <_c_api.MapStringBoolHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.WaveformHandle h_ret = _c_api.Waveform_copy(self.handle)
        if h_ret == <_c_api.WaveformHandle>0:
            return None
        return _waveform_from_capi(h_ret)

    def equal(self, Waveform other):
        return _c_api.Waveform_equal(self.handle, other.handle if other is not None else <_c_api.WaveformHandle>0)

    def __eq__(self, Waveform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Waveform other):
        return _c_api.Waveform_not_equal(self.handle, other.handle if other is not None else <_c_api.WaveformHandle>0)

    def __ne__(self, Waveform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Waveform_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def space(self, ):
        cdef _c_api.DiscreteSpaceHandle h_ret = _c_api.Waveform_space(self.handle)
        if h_ret == <_c_api.DiscreteSpaceHandle>0:
            return None
        return _discrete_space_from_capi(h_ret)

    def transforms(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.Waveform_transforms(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return _list_port_transform_from_capi(h_ret)

    def push_back(self, PortTransform value):
        _c_api.Waveform_push_back(self.handle, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def size(self, ):
        return _c_api.Waveform_size(self.handle)

    def empty(self, ):
        return _c_api.Waveform_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.Waveform_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.Waveform_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PortTransformHandle h_ret = _c_api.Waveform_at(self.handle, idx)
        if h_ret == <_c_api.PortTransformHandle>0:
            return None
        return _port_transform_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.Waveform_items(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return _list_port_transform_from_capi(h_ret)

    def contains(self, PortTransform value):
        return _c_api.Waveform_contains(self.handle, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def index(self, PortTransform value):
        return _c_api.Waveform_index(self.handle, value.handle if value is not None else <_c_api.PortTransformHandle>0)

    def intersection(self, Waveform other):
        cdef _c_api.WaveformHandle h_ret = _c_api.Waveform_intersection(self.handle, other.handle if other is not None else <_c_api.WaveformHandle>0)
        if h_ret == <_c_api.WaveformHandle>0:
            return None
        return _waveform_from_capi(h_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

    def append(self, value):
        self.push_back(value)

    @classmethod
    def from_list(cls, items):
        cdef Waveform obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef Waveform _waveform_from_capi(_c_api.WaveformHandle h, bint owned=True):
    if h == <_c_api.WaveformHandle>0:
        return None
    cdef Waveform obj = Waveform.__new__(Waveform)
    obj.handle = h
    obj.owned = owned
    return obj
