cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .axes_discretizer cimport AxesDiscretizer, _axes_discretizer_from_capi
from .axes_double cimport AxesDouble, _axes_double_from_capi
from .axes_int cimport AxesInt, _axes_int_from_capi
from .discretizer cimport Discretizer, _discretizer_from_capi
from .domain cimport Domain, _domain_from_capi
from .f_array_double cimport FArrayDouble, _f_array_double_from_capi
from .list_int cimport ListInt, _list_int_from_capi

cdef class UnitSpace:
    def __cinit__(self):
        self.handle = <_c_api.UnitSpaceHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.UnitSpaceHandle>0 and self.owned:
            _c_api.UnitSpace_destroy(self.handle)
        self.handle = <_c_api.UnitSpaceHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.UnitSpaceHandle h
        try:
            h = _c_api.UnitSpace_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, AxesDiscretizer axes, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create(axes.handle if axes is not None else <_c_api.AxesDiscretizerHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_ray_space(cls, double dr, double dtheta, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_ray_space(dr, dtheta, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_space(cls, AxesDouble deltas, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_cartesian_space(deltas.handle if deltas is not None else <_c_api.AxesDoubleHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_1D_space(cls, double delta, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_cartesian_1D_space(delta, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_cartesian_2D_space(cls, AxesDouble deltas, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_cartesian_2D_space(deltas.handle if deltas is not None else <_c_api.AxesDoubleHandle>0, domain.handle if domain is not None else <_c_api.DomainHandle>0)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_array(cls, UnitSpace handle, AxesInt axes):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_array(handle.handle if handle is not None else <_c_api.UnitSpaceHandle>0, axes.handle if axes is not None else <_c_api.AxesIntHandle>0)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.UnitSpaceHandle h_ret = _c_api.UnitSpace_copy(self.handle)
        if h_ret == <_c_api.UnitSpaceHandle>0:
            return None
        return _unit_space_from_capi(h_ret, owned=(h_ret != <_c_api.UnitSpaceHandle>self.handle))

    def equal(self, UnitSpace other):
        return _c_api.UnitSpace_equal(self.handle, other.handle if other is not None else <_c_api.UnitSpaceHandle>0)

    def __eq__(self, UnitSpace other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, UnitSpace other):
        return _c_api.UnitSpace_not_equal(self.handle, other.handle if other is not None else <_c_api.UnitSpaceHandle>0)

    def __ne__(self, UnitSpace other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.UnitSpace_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def axes(self, ):
        cdef _c_api.AxesDiscretizerHandle h_ret = _c_api.UnitSpace_axes(self.handle)
        if h_ret == <_c_api.AxesDiscretizerHandle>0:
            return None
        return _axes_discretizer_from_capi(h_ret, owned=True)

    def domain(self, ):
        cdef _c_api.DomainHandle h_ret = _c_api.UnitSpace_domain(self.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return _domain_from_capi(h_ret, owned=False)

    def space(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.UnitSpace_space(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret, owned=True)

    def shape(self, ):
        cdef _c_api.ListIntHandle h_ret = _c_api.UnitSpace_shape(self.handle)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return _list_int_from_capi(h_ret, owned=True)

    def dimension(self, ):
        return _c_api.UnitSpace_dimension(self.handle)

    def compile(self, ):
        _c_api.UnitSpace_compile(self.handle)

    def push_back(self, Discretizer value):
        _c_api.UnitSpace_push_back(self.handle, value.handle if value is not None else <_c_api.DiscretizerHandle>0)

    def size(self, ):
        return _c_api.UnitSpace_size(self.handle)

    def empty(self, ):
        return _c_api.UnitSpace_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.UnitSpace_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.UnitSpace_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.DiscretizerHandle h_ret = _c_api.UnitSpace_at(self.handle, idx)
        if h_ret == <_c_api.DiscretizerHandle>0:
            return None
        return _discretizer_from_capi(h_ret, owned=False)

    def items(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.UnitSpace_items(self.handle, <_c_api.DiscretizerHandle*>&out_buffer[0], buffer_size)

    def contains(self, Discretizer value):
        return _c_api.UnitSpace_contains(self.handle, value.handle if value is not None else <_c_api.DiscretizerHandle>0)

    def index(self, Discretizer value):
        return _c_api.UnitSpace_index(self.handle, value.handle if value is not None else <_c_api.DiscretizerHandle>0)

    def intersection(self, UnitSpace other):
        cdef _c_api.UnitSpaceHandle h_ret = _c_api.UnitSpace_intersection(self.handle, other.handle if other is not None else <_c_api.UnitSpaceHandle>0)
        if h_ret == <_c_api.UnitSpaceHandle>0:
            return None
        return _unit_space_from_capi(h_ret, owned=(h_ret != <_c_api.UnitSpaceHandle>self.handle))

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

    def append(self, value):
        self.push_back(value)

cdef UnitSpace _unit_space_from_capi(_c_api.UnitSpaceHandle h, bint owned=True):
    if h == <_c_api.UnitSpaceHandle>0:
        return None
    cdef UnitSpace obj = UnitSpace.__new__(UnitSpace)
    obj.handle = h
    obj.owned = owned
    return obj
