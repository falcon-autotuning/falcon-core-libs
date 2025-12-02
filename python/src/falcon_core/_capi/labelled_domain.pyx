cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport domain
from . cimport instrument_port
from . cimport symbol_unit

cdef class LabelledDomain:
    def __cinit__(self):
        self.handle = <_c_api.LabelledDomainHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LabelledDomainHandle>0 and self.owned:
            _c_api.LabelledDomain_destroy(self.handle)
        self.handle = <_c_api.LabelledDomainHandle>0


cdef LabelledDomain _labelled_domain_from_capi(_c_api.LabelledDomainHandle h):
    if h == <_c_api.LabelledDomainHandle>0:
        return None
    cdef LabelledDomain obj = LabelledDomain.__new__(LabelledDomain)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_primitive_knob(cls, str default_name, double min_val, double max_val, Connection psuedo_name, str instrument_type, bool lesser_bound_contained, bool greater_bound_contained, SymbolUnit units, str description):
        cdef bytes b_default_name = default_name.encode("utf-8")
        cdef StringHandle s_default_name = _c_api.String_create(b_default_name, len(b_default_name))
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef bytes b_description = description.encode("utf-8")
        cdef StringHandle s_description = _c_api.String_create(b_description, len(b_description))
        cdef _c_api.LabelledDomainHandle h
        try:
            h = _c_api.LabelledDomain_create_primitive_knob(s_default_name, min_val, max_val, psuedo_name.handle, s_instrument_type, lesser_bound_contained, greater_bound_contained, units.handle, s_description)
        finally:
            _c_api.String_destroy(s_default_name)
            _c_api.String_destroy(s_instrument_type)
            _c_api.String_destroy(s_description)
        if h == <_c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_primitive_meter(cls, str default_name, double min_val, double max_val, Connection psuedo_name, str instrument_type, bool lesser_bound_contained, bool greater_bound_contained, SymbolUnit units, str description):
        cdef bytes b_default_name = default_name.encode("utf-8")
        cdef StringHandle s_default_name = _c_api.String_create(b_default_name, len(b_default_name))
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef bytes b_description = description.encode("utf-8")
        cdef StringHandle s_description = _c_api.String_create(b_description, len(b_description))
        cdef _c_api.LabelledDomainHandle h
        try:
            h = _c_api.LabelledDomain_create_primitive_meter(s_default_name, min_val, max_val, psuedo_name.handle, s_instrument_type, lesser_bound_contained, greater_bound_contained, units.handle, s_description)
        finally:
            _c_api.String_destroy(s_default_name)
            _c_api.String_destroy(s_instrument_type)
            _c_api.String_destroy(s_description)
        if h == <_c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_primitive_port(cls, str default_name, double min_val, double max_val, Connection psuedo_name, str instrument_type, bool lesser_bound_contained, bool greater_bound_contained, SymbolUnit units, str description):
        cdef bytes b_default_name = default_name.encode("utf-8")
        cdef StringHandle s_default_name = _c_api.String_create(b_default_name, len(b_default_name))
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef bytes b_description = description.encode("utf-8")
        cdef StringHandle s_description = _c_api.String_create(b_description, len(b_description))
        cdef _c_api.LabelledDomainHandle h
        try:
            h = _c_api.LabelledDomain_create_primitive_port(s_default_name, min_val, max_val, psuedo_name.handle, s_instrument_type, lesser_bound_contained, greater_bound_contained, units.handle, s_description)
        finally:
            _c_api.String_destroy(s_default_name)
            _c_api.String_destroy(s_instrument_type)
            _c_api.String_destroy(s_description)
        if h == <_c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port(cls, double min_val, double max_val, str instrument_type, InstrumentPort port, bool lesser_bound_contained, bool greater_bound_contained):
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef _c_api.LabelledDomainHandle h
        try:
            h = _c_api.LabelledDomain_create_from_port(min_val, max_val, s_instrument_type, port.handle, lesser_bound_contained, greater_bound_contained)
        finally:
            _c_api.String_destroy(s_instrument_type)
        if h == <_c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port_and_domain(cls, InstrumentPort port, Domain domain):
        cdef _c_api.LabelledDomainHandle h
        h = _c_api.LabelledDomain_create_from_port_and_domain(port.handle, domain.handle)
        if h == <_c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_domain(cls, Domain domain, str default_name, Connection psuedo_name, str instrument_type, SymbolUnit units, str description):
        cdef bytes b_default_name = default_name.encode("utf-8")
        cdef StringHandle s_default_name = _c_api.String_create(b_default_name, len(b_default_name))
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef bytes b_description = description.encode("utf-8")
        cdef StringHandle s_description = _c_api.String_create(b_description, len(b_description))
        cdef _c_api.LabelledDomainHandle h
        try:
            h = _c_api.LabelledDomain_create_from_domain(domain.handle, s_default_name, psuedo_name.handle, s_instrument_type, units.handle, s_description)
        finally:
            _c_api.String_destroy(s_default_name)
            _c_api.String_destroy(s_instrument_type)
            _c_api.String_destroy(s_description)
        if h == <_c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.LabelledDomainHandle h
        try:
            h = _c_api.LabelledDomain_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def port(self, ):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.LabelledDomain_port(self.handle)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return instrument_port._instrument_port_from_capi(h_ret)

    def domain(self, ):
        cdef _c_api.DomainHandle h_ret = _c_api.LabelledDomain_domain(self.handle)
        if h_ret == <_c_api.DomainHandle>0:
            return None
        return domain._domain_from_capi(h_ret)

    def matching_port(self, InstrumentPort port):
        return _c_api.LabelledDomain_matching_port(self.handle, port.handle)

    def lesser_bound(self, ):
        return _c_api.LabelledDomain_lesser_bound(self.handle)

    def greater_bound(self, ):
        return _c_api.LabelledDomain_greater_bound(self.handle)

    def lesser_bound_contained(self, ):
        return _c_api.LabelledDomain_lesser_bound_contained(self.handle)

    def greater_bound_contained(self, ):
        return _c_api.LabelledDomain_greater_bound_contained(self.handle)

    def contains(self, double value):
        return _c_api.LabelledDomain_in(self.handle, value)

    def get_range(self, ):
        return _c_api.LabelledDomain_range(self.handle)

    def center(self, ):
        return _c_api.LabelledDomain_center(self.handle)

    def intersection(self, LabelledDomain other):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.LabelledDomain_intersection(self.handle, other.handle)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return _labelled_domain_from_capi(h_ret)

    def union(self, LabelledDomain other):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.LabelledDomain_union(self.handle, other.handle)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return _labelled_domain_from_capi(h_ret)

    def is_empty(self, ):
        return _c_api.LabelledDomain_is_empty(self.handle)

    def contains_domain(self, LabelledDomain other):
        return _c_api.LabelledDomain_contains_domain(self.handle, other.handle)

    def shift(self, double offset):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.LabelledDomain_shift(self.handle, offset)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return _labelled_domain_from_capi(h_ret)

    def scale(self, double scale):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.LabelledDomain_scale(self.handle, scale)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return _labelled_domain_from_capi(h_ret)

    def transform(self, LabelledDomain other, double value):
        return _c_api.LabelledDomain_transform(self.handle, other.handle, value)

    def equal(self, LabelledDomain other):
        return _c_api.LabelledDomain_equal(self.handle, other.handle)

    def __eq__(self, LabelledDomain other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, LabelledDomain other):
        return _c_api.LabelledDomain_not_equal(self.handle, other.handle)

    def __ne__(self, LabelledDomain other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
