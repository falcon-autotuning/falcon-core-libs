# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .instrument_port cimport InstrumentPort
from .labelled_domain cimport LabelledDomain
from .list_labelled_domain cimport ListLabelledDomain
from .ports cimport Ports

cdef class CoupledLabelledDomain:
    cdef c_api.CoupledLabelledDomainHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.CoupledLabelledDomainHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.CoupledLabelledDomainHandle>0 and self.owned:
            c_api.CoupledLabelledDomain_destroy(self.handle)
        self.handle = <c_api.CoupledLabelledDomainHandle>0

    cdef CoupledLabelledDomain from_capi(cls, c_api.CoupledLabelledDomainHandle h):
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.CoupledLabelledDomainHandle h
        h = c_api.CoupledLabelledDomain_create_empty()
        if h == <c_api.CoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create CoupledLabelledDomain")
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.CoupledLabelledDomainHandle h
        h = c_api.CoupledLabelledDomain_create(<c_api.ListLabelledDomainHandle>items.handle)
        if h == <c_api.CoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create CoupledLabelledDomain")
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.CoupledLabelledDomainHandle h
        try:
            h = c_api.CoupledLabelledDomain_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.CoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create CoupledLabelledDomain")
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def domains(self):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListLabelledDomainHandle h_ret
        h_ret = c_api.CoupledLabelledDomain_domains(self.handle)
        if h_ret == <c_api.ListLabelledDomainHandle>0:
            return None
        return ListLabelledDomain.from_capi(ListLabelledDomain, h_ret)

    def labels(self):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortsHandle h_ret
        h_ret = c_api.CoupledLabelledDomain_labels(self.handle)
        if h_ret == <c_api.PortsHandle>0:
            return None
        return Ports.from_capi(Ports, h_ret)

    def get_domain(self, search):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.CoupledLabelledDomain_get_domain(self.handle, <c_api.InstrumentPortHandle>search.handle)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def intersection(self, other):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.CoupledLabelledDomainHandle h_ret
        h_ret = c_api.CoupledLabelledDomain_intersection(self.handle, <c_api.CoupledLabelledDomainHandle>other.handle)
        if h_ret == <c_api.CoupledLabelledDomainHandle>0:
            return None
        return CoupledLabelledDomain.from_capi(CoupledLabelledDomain, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        c_api.CoupledLabelledDomain_push_back(self.handle, <c_api.LabelledDomainHandle>value.handle)

    def size(self):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.CoupledLabelledDomain_size(self.handle)

    def empty(self):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.CoupledLabelledDomain_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        c_api.CoupledLabelledDomain_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        c_api.CoupledLabelledDomain_clear(self.handle)

    def const_at(self, idx):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.CoupledLabelledDomain_const_at(self.handle, idx)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def at(self, idx):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.CoupledLabelledDomain_at(self.handle, idx)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def items(self):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListLabelledDomainHandle h_ret
        h_ret = c_api.CoupledLabelledDomain_items(self.handle)
        if h_ret == <c_api.ListLabelledDomainHandle>0:
            return None
        return ListLabelledDomain.from_capi(ListLabelledDomain, h_ret)

    def contains(self, value):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.CoupledLabelledDomain_contains(self.handle, <c_api.LabelledDomainHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.CoupledLabelledDomain_index(self.handle, <c_api.LabelledDomainHandle>value.handle)

    def equal(self, b):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.CoupledLabelledDomain_equal(self.handle, <c_api.CoupledLabelledDomainHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.CoupledLabelledDomain_not_equal(self.handle, <c_api.CoupledLabelledDomainHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.CoupledLabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.CoupledLabelledDomain_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef CoupledLabelledDomain _coupledlabelleddomain_from_capi(c_api.CoupledLabelledDomainHandle h):
    cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>CoupledLabelledDomain.__new__(CoupledLabelledDomain)
    obj.handle = h