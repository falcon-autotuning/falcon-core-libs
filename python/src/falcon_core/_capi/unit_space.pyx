# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .axes_discretizer cimport AxesDiscretizer
from .axes_double cimport AxesDouble
from .axes_int cimport AxesInt
from .discretizer cimport Discretizer
from .domain cimport Domain
from .f_array_double cimport FArrayDouble
from .list_int cimport ListInt

cdef class UnitSpace:
    cdef c_api.UnitSpaceHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.UnitSpaceHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.UnitSpaceHandle>0 and self.owned:
            c_api.UnitSpace_destroy(self.handle)
        self.handle = <c_api.UnitSpaceHandle>0

    cdef UnitSpace from_capi(cls, c_api.UnitSpaceHandle h):
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, axes, domain):
        cdef c_api.UnitSpaceHandle h
        h = c_api.UnitSpace_create(<c_api.AxesDiscretizerHandle>axes.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_rayspace(cls, dr, dtheta, domain):
        cdef c_api.UnitSpaceHandle h
        h = c_api.UnitSpace_create_rayspace(dr, dtheta, <c_api.DomainHandle>domain.handle)
        if h == <c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesianspace(cls, deltas, domain):
        cdef c_api.UnitSpaceHandle h
        h = c_api.UnitSpace_create_cartesianspace(<c_api.AxesDoubleHandle>deltas.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian1Dspace(cls, delta, domain):
        cdef c_api.UnitSpaceHandle h
        h = c_api.UnitSpace_create_cartesian1Dspace(delta, <c_api.DomainHandle>domain.handle)
        if h == <c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian2Dspace(cls, deltas, domain):
        cdef c_api.UnitSpaceHandle h
        h = c_api.UnitSpace_create_cartesian2Dspace(<c_api.AxesDoubleHandle>deltas.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_array(cls, handle, axes):
        cdef c_api.UnitSpaceHandle h
        h = c_api.UnitSpace_create_array(<c_api.UnitSpaceHandle>handle.handle, <c_api.AxesIntHandle>axes.handle)
        if h == <c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.UnitSpaceHandle h
        try:
            h = c_api.UnitSpace_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def axes(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesDiscretizerHandle h_ret
        h_ret = c_api.UnitSpace_axes(self.handle)
        if h_ret == <c_api.AxesDiscretizerHandle>0:
            return None
        return AxesDiscretizer.from_capi(AxesDiscretizer, h_ret)

    def domain(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.UnitSpace_domain(self.handle)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def space(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.UnitSpace_space(self.handle)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def shape(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListIntHandle h_ret
        h_ret = c_api.UnitSpace_shape(self.handle)
        if h_ret == <c_api.ListIntHandle>0:
            return None
        return ListInt.from_capi(ListInt, h_ret)

    def dimension(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_dimension(self.handle)

    def compile(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        c_api.UnitSpace_compile(self.handle)

    def push_back(self, value):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        c_api.UnitSpace_push_back(self.handle, <c_api.DiscretizerHandle>value.handle)

    def size(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_size(self.handle)

    def empty(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        c_api.UnitSpace_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        c_api.UnitSpace_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DiscretizerHandle h_ret
        h_ret = c_api.UnitSpace_at(self.handle, idx)
        if h_ret == <c_api.DiscretizerHandle>0:
            return None
        return Discretizer.from_capi(Discretizer, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_items(self.handle, <c_api.DiscretizerHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_contains(self.handle, <c_api.DiscretizerHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_index(self.handle, <c_api.DiscretizerHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.UnitSpaceHandle h_ret
        h_ret = c_api.UnitSpace_intersection(self.handle, <c_api.UnitSpaceHandle>other.handle)
        if h_ret == <c_api.UnitSpaceHandle>0:
            return None
        return UnitSpace.from_capi(UnitSpace, h_ret)

    def equal(self, b):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_equal(self.handle, <c_api.UnitSpaceHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.UnitSpace_not_equal(self.handle, <c_api.UnitSpaceHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.UnitSpaceHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.UnitSpace_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef UnitSpace _unitspace_from_capi(c_api.UnitSpaceHandle h):
    cdef UnitSpace obj = <UnitSpace>UnitSpace.__new__(UnitSpace)
    obj.handle = h