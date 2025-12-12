cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport instrument_port
from . cimport labelled_domain
from . cimport list_labelled_domain
from . cimport ports

cdef class CoupledLabelledDomain:
    def __cinit__(self):
        self.handle = <_c_api.CoupledLabelledDomainHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.CoupledLabelledDomainHandle>0 and self.owned:
            _c_api.CoupledLabelledDomain_destroy(self.handle)
        self.handle = <_c_api.CoupledLabelledDomainHandle>0


cdef CoupledLabelledDomain _coupled_labelled_domain_from_capi(_c_api.CoupledLabelledDomainHandle h):
    if h == <_c_api.CoupledLabelledDomainHandle>0:
        return None
    cdef CoupledLabelledDomain obj = CoupledLabelledDomain.__new__(CoupledLabelledDomain)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.CoupledLabelledDomainHandle h
        h = _c_api.CoupledLabelledDomain_create_empty()
        if h == <_c_api.CoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create CoupledLabelledDomain")
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListLabelledDomain items):
        cdef _c_api.CoupledLabelledDomainHandle h
        h = _c_api.CoupledLabelledDomain_create(items.handle)
        if h == <_c_api.CoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create CoupledLabelledDomain")
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.CoupledLabelledDomainHandle h
        try:
            h = _c_api.CoupledLabelledDomain_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.CoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create CoupledLabelledDomain")
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def domains(self, ):
        cdef _c_api.ListLabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_domains(self.handle)
        if h_ret == <_c_api.ListLabelledDomainHandle>0:
            return None
        return list_labelled_domain._list_labelled_domain_from_capi(h_ret)

    def labels(self, ):
        cdef _c_api.PortsHandle h_ret = _c_api.CoupledLabelledDomain_labels(self.handle)
        if h_ret == <_c_api.PortsHandle>0:
            return None
        return ports._ports_from_capi(h_ret)

    def get_domain(self, InstrumentPort search):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_get_domain(self.handle, search.handle)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return labelled_domain._labelled_domain_from_capi(h_ret)

    def intersection(self, CoupledLabelledDomain other):
        cdef _c_api.CoupledLabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_intersection(self.handle, other.handle)
        if h_ret == <_c_api.CoupledLabelledDomainHandle>0:
            return None
        return _coupled_labelled_domain_from_capi(h_ret)

    def push_back(self, LabelledDomain value):
        _c_api.CoupledLabelledDomain_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.CoupledLabelledDomain_size(self.handle)

    def empty(self, ):
        return _c_api.CoupledLabelledDomain_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.CoupledLabelledDomain_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.CoupledLabelledDomain_clear(self.handle)

    def const_at(self, size_t idx):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_const_at(self.handle, idx)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return labelled_domain._labelled_domain_from_capi(h_ret)

    def at(self, size_t idx):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_at(self.handle, idx)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return labelled_domain._labelled_domain_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListLabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_items(self.handle)
        if h_ret == <_c_api.ListLabelledDomainHandle>0:
            return None
        return list_labelled_domain._list_labelled_domain_from_capi(h_ret)

    def contains(self, LabelledDomain value):
        return _c_api.CoupledLabelledDomain_contains(self.handle, value.handle)

    def index(self, LabelledDomain value):
        return _c_api.CoupledLabelledDomain_index(self.handle, value.handle)

    def equal(self, CoupledLabelledDomain b):
        return _c_api.CoupledLabelledDomain_equal(self.handle, b.handle)

    def __eq__(self, CoupledLabelledDomain b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, CoupledLabelledDomain b):
        return _c_api.CoupledLabelledDomain_not_equal(self.handle, b.handle)

    def __ne__(self, CoupledLabelledDomain b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
