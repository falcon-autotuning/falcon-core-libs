# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .axes_coupled_labelled_domain cimport AxesCoupledLabelledDomain
from .axes_int cimport AxesInt
from .axes_map_string_bool cimport AxesMapStringBool
from .coupled_labelled_domain cimport CoupledLabelledDomain
from .discrete_space cimport DiscreteSpace
from .domain cimport Domain
from .list_port_transform cimport ListPortTransform
from .map_string_bool cimport MapStringBool
from .port_transform cimport PortTransform

cdef class Waveform:
    cdef c_api.WaveformHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.WaveformHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.WaveformHandle>0 and self.owned:
            c_api.Waveform_destroy(self.handle)
        self.handle = <c_api.WaveformHandle>0

    cdef Waveform from_capi(cls, c_api.WaveformHandle h):
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, space, transforms):
        cdef c_api.WaveformHandle h
        h = c_api.Waveform_create(<c_api.DiscreteSpaceHandle>space.handle, <c_api.ListPortTransformHandle>transforms.handle)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianwaveform(cls, divisions, axes, increasing, transforms, domain):
        cdef c_api.WaveformHandle h
        h = c_api.Waveform_create_cartesianwaveform(<c_api.AxesIntHandle>divisions.handle, <c_api.AxesCoupledLabelledDomainHandle>axes.handle, <c_api.AxesMapStringBoolHandle>increasing.handle, <c_api.ListPortTransformHandle>transforms.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianidentitywaveform(cls, divisions, axes, increasing, domain):
        cdef c_api.WaveformHandle h
        h = c_api.Waveform_create_cartesianidentitywaveform(<c_api.AxesIntHandle>divisions.handle, <c_api.AxesCoupledLabelledDomainHandle>axes.handle, <c_api.AxesMapStringBoolHandle>increasing.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianwaveform2D(cls, divisions, axes, increasing, transforms, domain):
        cdef c_api.WaveformHandle h
        h = c_api.Waveform_create_cartesianwaveform2D(<c_api.AxesIntHandle>divisions.handle, <c_api.AxesCoupledLabelledDomainHandle>axes.handle, <c_api.AxesMapStringBoolHandle>increasing.handle, <c_api.ListPortTransformHandle>transforms.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianidentitywaveform2D(cls, divisions, axes, increasing, domain):
        cdef c_api.WaveformHandle h
        h = c_api.Waveform_create_cartesianidentitywaveform2D(<c_api.AxesIntHandle>divisions.handle, <c_api.AxesCoupledLabelledDomainHandle>axes.handle, <c_api.AxesMapStringBoolHandle>increasing.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianwaveform1D(cls, division, shared_domain, increasing, transforms, domain):
        cdef c_api.WaveformHandle h
        h = c_api.Waveform_create_cartesianwaveform1D(division, <c_api.CoupledLabelledDomainHandle>shared_domain.handle, <c_api.MapStringBoolHandle>increasing.handle, <c_api.ListPortTransformHandle>transforms.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianidentitywaveform1D(cls, division, shared_domain, increasing, domain):
        cdef c_api.WaveformHandle h
        h = c_api.Waveform_create_cartesianidentitywaveform1D(division, <c_api.CoupledLabelledDomainHandle>shared_domain.handle, <c_api.MapStringBoolHandle>increasing.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.WaveformHandle h
        try:
            h = c_api.Waveform_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.WaveformHandle>0:
            raise MemoryError("Failed to create Waveform")
        cdef Waveform obj = <Waveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def space(self):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DiscreteSpaceHandle h_ret
        h_ret = c_api.Waveform_space(self.handle)
        if h_ret == <c_api.DiscreteSpaceHandle>0:
            return None
        return DiscreteSpace.from_capi(DiscreteSpace, h_ret)

    def transforms(self):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPortTransformHandle h_ret
        h_ret = c_api.Waveform_transforms(self.handle)
        if h_ret == <c_api.ListPortTransformHandle>0:
            return None
        return ListPortTransform.from_capi(ListPortTransform, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Waveform_push_back(self.handle, <c_api.PortTransformHandle>value.handle)

    def size(self):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Waveform_size(self.handle)

    def empty(self):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Waveform_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Waveform_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Waveform_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortTransformHandle h_ret
        h_ret = c_api.Waveform_at(self.handle, idx)
        if h_ret == <c_api.PortTransformHandle>0:
            return None
        return PortTransform.from_capi(PortTransform, h_ret)

    def items(self):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPortTransformHandle h_ret
        h_ret = c_api.Waveform_items(self.handle)
        if h_ret == <c_api.ListPortTransformHandle>0:
            return None
        return ListPortTransform.from_capi(ListPortTransform, h_ret)

    def contains(self, value):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Waveform_contains(self.handle, <c_api.PortTransformHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Waveform_index(self.handle, <c_api.PortTransformHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.WaveformHandle h_ret
        h_ret = c_api.Waveform_intersection(self.handle, <c_api.WaveformHandle>other.handle)
        if h_ret == <c_api.WaveformHandle>0:
            return None
        return Waveform.from_capi(Waveform, h_ret)

    def equal(self, other):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Waveform_equal(self.handle, <c_api.WaveformHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Waveform_not_equal(self.handle, <c_api.WaveformHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.WaveformHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Waveform_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Waveform _waveform_from_capi(c_api.WaveformHandle h):
    cdef Waveform obj = <Waveform>Waveform.__new__(Waveform)
    obj.handle = h