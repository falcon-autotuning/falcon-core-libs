cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport coupled_labelled_domain
from . cimport list_coupled_labelled_domain

cdef class AxesCoupledLabelledDomain:
    def __cinit__(self):
        self.handle = <_c_api.AxesCoupledLabelledDomainHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesCoupledLabelledDomainHandle>0 and self.owned:
            _c_api.AxesCoupledLabelledDomain_destroy(self.handle)
        self.handle = <_c_api.AxesCoupledLabelledDomainHandle>0


cdef AxesCoupledLabelledDomain _axes_coupled_labelled_domain_from_capi(_c_api.AxesCoupledLabelledDomainHandle h):
    if h == <_c_api.AxesCoupledLabelledDomainHandle>0:
        return None
    cdef AxesCoupledLabelledDomain obj = AxesCoupledLabelledDomain.__new__(AxesCoupledLabelledDomain)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesCoupledLabelledDomainHandle h
        h = _c_api.AxesCoupledLabelledDomain_create_empty()
        if h == <_c_api.AxesCoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create AxesCoupledLabelledDomain")
        cdef AxesCoupledLabelledDomain obj = <AxesCoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, CoupledLabelledDomain data, size_t count):
        cdef _c_api.AxesCoupledLabelledDomainHandle h
        h = _c_api.AxesCoupledLabelledDomain_create_raw(data.handle, count)
        if h == <_c_api.AxesCoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create AxesCoupledLabelledDomain")
        cdef AxesCoupledLabelledDomain obj = <AxesCoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListCoupledLabelledDomain data):
        cdef _c_api.AxesCoupledLabelledDomainHandle h
        h = _c_api.AxesCoupledLabelledDomain_create(data.handle)
        if h == <_c_api.AxesCoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create AxesCoupledLabelledDomain")
        cdef AxesCoupledLabelledDomain obj = <AxesCoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesCoupledLabelledDomainHandle h
        try:
            h = _c_api.AxesCoupledLabelledDomain_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesCoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create AxesCoupledLabelledDomain")
        cdef AxesCoupledLabelledDomain obj = <AxesCoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, CoupledLabelledDomain value):
        _c_api.AxesCoupledLabelledDomain_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesCoupledLabelledDomain_size(self.handle)

    def empty(self, ):
        return _c_api.AxesCoupledLabelledDomain_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesCoupledLabelledDomain_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesCoupledLabelledDomain_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.CoupledLabelledDomainHandle h_ret = _c_api.AxesCoupledLabelledDomain_at(self.handle, idx)
        if h_ret == <_c_api.CoupledLabelledDomainHandle>0:
            return None
        return coupled_labelled_domain._coupled_labelled_domain_from_capi(h_ret)

    def items(self, CoupledLabelledDomain out_buffer, size_t buffer_size):
        return _c_api.AxesCoupledLabelledDomain_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, CoupledLabelledDomain value):
        return _c_api.AxesCoupledLabelledDomain_contains(self.handle, value.handle)

    def index(self, CoupledLabelledDomain value):
        return _c_api.AxesCoupledLabelledDomain_index(self.handle, value.handle)

    def intersection(self, AxesCoupledLabelledDomain other):
        cdef _c_api.AxesCoupledLabelledDomainHandle h_ret = _c_api.AxesCoupledLabelledDomain_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesCoupledLabelledDomainHandle>0:
            return None
        return _axes_coupled_labelled_domain_from_capi(h_ret)

    def equal(self, AxesCoupledLabelledDomain b):
        return _c_api.AxesCoupledLabelledDomain_equal(self.handle, b.handle)

    def __eq__(self, AxesCoupledLabelledDomain b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesCoupledLabelledDomain b):
        return _c_api.AxesCoupledLabelledDomain_not_equal(self.handle, b.handle)

    def __ne__(self, AxesCoupledLabelledDomain b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
