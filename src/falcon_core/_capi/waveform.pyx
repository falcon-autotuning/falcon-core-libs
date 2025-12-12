cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport axes_coupled_labelled_domain
from . cimport axes_int
from . cimport axes_map_string_bool
from . cimport coupled_labelled_domain
from . cimport discrete_space
from . cimport domain
from . cimport list_port_transform
from . cimport map_string_bool
from . cimport port_transform

cdef class Waveform:
    def __cinit__(self):
        self.handle = <_c_api.WaveformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.WaveformHandle>0 and self.owned:
            _c_api.Waveform_destroy(self.handle)
        self.handle = <_c_api.WaveformHandle>0


cdef Waveform _waveform_from_capi(_c_api.WaveformHandle h):
    if h == <_c_api.WaveformHandle>0:
        return None
    cdef Waveform obj = Waveform.__new__(Waveform)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, DiscreteSpace space, ListPortTransform transforms):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create(space.handle, transforms.handle)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianwaveform(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, ListPortTransform transforms, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesianwaveform(divisions.handle, axes.handle, increasing.handle, transforms.handle, domain.handle)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianidentitywaveform(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesianidentitywaveform(divisions.handle, axes.handle, increasing.handle, domain.handle)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianwaveform2D(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, ListPortTransform transforms, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesianwaveform2D(divisions.handle, axes.handle, increasing.handle, transforms.handle, domain.handle)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianidentitywaveform2D(cls, AxesInt divisions, AxesCoupledLabelledDomain axes, AxesMapStringBool increasing, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesianidentitywaveform2D(divisions.handle, axes.handle, increasing.handle, domain.handle)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianwaveform1D(cls, int division, CoupledLabelledDomain shared_domain, MapStringBool increasing, ListPortTransform transforms, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesianwaveform1D(division, shared_domain.handle, increasing.handle, transforms.handle, domain.handle)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianidentitywaveform1D(cls, int division, CoupledLabelledDomain shared_domain, MapStringBool increasing, Domain domain):
        cdef _c_api.WaveformHandle h
        h = _c_api.Waveform_create_cartesianidentitywaveform1D(division, shared_domain.handle, increasing.handle, domain.handle)
        if h == <_c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def space(self, ):
        cdef _c_api.DiscreteSpaceHandle h_ret = _c_api.Waveform_space(self.handle)
        if h_ret == <_c_api.DiscreteSpaceHandle>0:
            return None
        return discrete_space._discrete_space_from_capi(h_ret)

    def transforms(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.Waveform_transforms(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return list_port_transform._list_port_transform_from_capi(h_ret)

    def push_back(self, PortTransform value):
        _c_api.Waveform_push_back(self.handle, value.handle)

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
        return port_transform._port_transform_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPortTransformHandle h_ret = _c_api.Waveform_items(self.handle)
        if h_ret == <_c_api.ListPortTransformHandle>0:
            return None
        return list_port_transform._list_port_transform_from_capi(h_ret)

    def contains(self, PortTransform value):
        return _c_api.Waveform_contains(self.handle, value.handle)

    def index(self, PortTransform value):
        return _c_api.Waveform_index(self.handle, value.handle)

    def intersection(self, Waveform other):
        cdef _c_api.WaveformHandle h_ret = _c_api.Waveform_intersection(self.handle, other.handle)
        if h_ret == <_c_api.WaveformHandle>0:
            return None
        return _waveform_from_capi(h_ret)

    def equal(self, Waveform other):
        return _c_api.Waveform_equal(self.handle, other.handle)

    def __eq__(self, Waveform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Waveform other):
        return _c_api.Waveform_not_equal(self.handle, other.handle)

    def __ne__(self, Waveform other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
