cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport axes_discretizer
from . cimport axes_double
from . cimport axes_int
from . cimport discretizer
from . cimport domain
from . cimport f_array_double
from . cimport list_int

cdef class UnitSpace:
    def __cinit__(self):
        self.handle = <_c_api.UnitSpaceHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.UnitSpaceHandle>0 and self.owned:
            _c_api.UnitSpace_destroy(self.handle)
        self.handle = <_c_api.UnitSpaceHandle>0


cdef UnitSpace _unit_space_from_capi(_c_api.UnitSpaceHandle h):
    if h == <_c_api.UnitSpaceHandle>0:
        return None
    cdef UnitSpace obj = UnitSpace.__new__(UnitSpace)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, AxesDiscretizer axes, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create(axes.handle, domain.handle)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def rayspace(cls, double dr, double dtheta, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_rayspace(dr, dtheta, domain.handle)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def cartesianspace(cls, AxesDouble deltas, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_cartesianspace(deltas.handle, domain.handle)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def cartesian1Dspace(cls, double delta, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_cartesian1Dspace(delta, domain.handle)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def cartesian2Dspace(cls, AxesDouble deltas, Domain domain):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_cartesian2Dspace(deltas.handle, domain.handle)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def array(cls, UnitSpace handle, AxesInt axes):
        cdef _c_api.UnitSpaceHandle h
        h = _c_api.UnitSpace_create_array(handle.handle, axes.handle)
        if h == <_c_api.UnitSpaceHandle>0:
            raise MemoryError("Failed to create UnitSpace")
        cdef UnitSpace obj = <UnitSpace>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def axes(self, ):
        cdef _c_api.AxesDiscretizerHandle h_ret = _c_api.UnitSpace_axes(self.handle)
        if h_ret == <_c_api.AxesDiscretizerHandle>0:
            return None
        return axes_discretizer._axes_discretizer_from_capi(h_ret)

    def domain(self, ):
        cdef _c_api.DomainHandle h_ret = _c_api.UnitSpace_domain(self.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return domain._domain_from_capi(h_ret)

    def space(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.UnitSpace_space(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def shape(self, ):
        cdef _c_api.ListIntHandle h_ret = _c_api.UnitSpace_shape(self.handle)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return list_int._list_int_from_capi(h_ret)

    def dimension(self, ):
        return _c_api.UnitSpace_dimension(self.handle)

    def compile(self, ):
        _c_api.UnitSpace_compile(self.handle)

    def push_back(self, Discretizer value):
        _c_api.UnitSpace_push_back(self.handle, value.handle)

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
        return discretizer._discretizer_from_capi(h_ret)

    def items(self, Discretizer out_buffer, size_t buffer_size):
        return _c_api.UnitSpace_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Discretizer value):
        return _c_api.UnitSpace_contains(self.handle, value.handle)

    def index(self, Discretizer value):
        return _c_api.UnitSpace_index(self.handle, value.handle)

    def intersection(self, UnitSpace other):
        cdef _c_api.UnitSpaceHandle h_ret = _c_api.UnitSpace_intersection(self.handle, other.handle)
        if h_ret == <_c_api.UnitSpaceHandle>0:
            return None
        return _unit_space_from_capi(h_ret)

    def equal(self, UnitSpace b):
        return _c_api.UnitSpace_equal(self.handle, b.handle)

    def __eq__(self, UnitSpace b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, UnitSpace b):
        return _c_api.UnitSpace_not_equal(self.handle, b.handle)

    def __ne__(self, UnitSpace b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
