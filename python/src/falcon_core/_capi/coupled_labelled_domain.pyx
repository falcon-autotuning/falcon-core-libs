cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .instrument_port cimport InstrumentPort, _instrument_port_from_capi
from .labelled_domain cimport LabelledDomain, _labelled_domain_from_capi
from .list_labelled_domain cimport ListLabelledDomain, _list_labelled_domain_from_capi
from .ports cimport Ports, _ports_from_capi

cdef class CoupledLabelledDomain:
    def __cinit__(self):
        self.handle = <_c_api.CoupledLabelledDomainHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.CoupledLabelledDomainHandle>0 and self.owned:
            _c_api.CoupledLabelledDomain_destroy(self.handle)
        self.handle = <_c_api.CoupledLabelledDomainHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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
        h = _c_api.CoupledLabelledDomain_create(items.handle if items is not None else <_c_api.ListLabelledDomainHandle>0)
        if h == <_c_api.CoupledLabelledDomainHandle>0:
            raise MemoryError("Failed to create CoupledLabelledDomain")
        cdef CoupledLabelledDomain obj = <CoupledLabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.CoupledLabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_copy(self.handle)
        if h_ret == <_c_api.CoupledLabelledDomainHandle>0:
            return None
        return _coupled_labelled_domain_from_capi(h_ret, owned=(h_ret != <_c_api.CoupledLabelledDomainHandle>self.handle))

    def equal(self, CoupledLabelledDomain other):
        return _c_api.CoupledLabelledDomain_equal(self.handle, other.handle if other is not None else <_c_api.CoupledLabelledDomainHandle>0)

    def __eq__(self, CoupledLabelledDomain other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, CoupledLabelledDomain other):
        return _c_api.CoupledLabelledDomain_not_equal(self.handle, other.handle if other is not None else <_c_api.CoupledLabelledDomainHandle>0)

    def __ne__(self, CoupledLabelledDomain other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.CoupledLabelledDomain_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def domains(self, ):
        cdef _c_api.ListLabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_domains(self.handle)
        if h_ret == <_c_api.ListLabelledDomainHandle>0:
            return None
        return _list_labelled_domain_from_capi(h_ret, owned=True)

    def labels(self, ):
        cdef _c_api.PortsHandle h_ret = _c_api.CoupledLabelledDomain_labels(self.handle)
        if h_ret == <_c_api.PortsHandle>0:
            return None
        return _ports_from_capi(h_ret, owned=True)

    def get_domain(self, InstrumentPort search):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_get_domain(self.handle, search.handle if search is not None else <_c_api.InstrumentPortHandle>0)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return _labelled_domain_from_capi(h_ret, owned=False)

    def intersection(self, CoupledLabelledDomain other):
        cdef _c_api.CoupledLabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_intersection(self.handle, other.handle if other is not None else <_c_api.CoupledLabelledDomainHandle>0)
        if h_ret == <_c_api.CoupledLabelledDomainHandle>0:
            return None
        return _coupled_labelled_domain_from_capi(h_ret, owned=(h_ret != <_c_api.CoupledLabelledDomainHandle>self.handle))

    def push_back(self, LabelledDomain value):
        _c_api.CoupledLabelledDomain_push_back(self.handle, value.handle if value is not None else <_c_api.LabelledDomainHandle>0)

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
        return _labelled_domain_from_capi(h_ret, owned=True)

    def at(self, size_t idx):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_at(self.handle, idx)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return _labelled_domain_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListLabelledDomainHandle h_ret = _c_api.CoupledLabelledDomain_items(self.handle)
        if h_ret == <_c_api.ListLabelledDomainHandle>0:
            return None
        return _list_labelled_domain_from_capi(h_ret, owned=False)

    def contains(self, LabelledDomain value):
        return _c_api.CoupledLabelledDomain_contains(self.handle, value.handle if value is not None else <_c_api.LabelledDomainHandle>0)

    def index(self, LabelledDomain value):
        return _c_api.CoupledLabelledDomain_index(self.handle, value.handle if value is not None else <_c_api.LabelledDomainHandle>0)

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
        cdef CoupledLabelledDomain obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef CoupledLabelledDomain _coupled_labelled_domain_from_capi(_c_api.CoupledLabelledDomainHandle h, bint owned=True):
    if h == <_c_api.CoupledLabelledDomainHandle>0:
        return None
    cdef CoupledLabelledDomain obj = CoupledLabelledDomain.__new__(CoupledLabelledDomain)
    obj.handle = h
    obj.owned = owned
    return obj
