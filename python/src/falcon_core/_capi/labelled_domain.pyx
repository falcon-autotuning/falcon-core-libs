# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .domain cimport Domain
from .instrument_port cimport InstrumentPort
from .symbol_unit cimport SymbolUnit

cdef class LabelledDomain:
    cdef c_api.LabelledDomainHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.LabelledDomainHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.LabelledDomainHandle>0 and self.owned:
            c_api.LabelledDomain_destroy(self.handle)
        self.handle = <c_api.LabelledDomainHandle>0

    cdef LabelledDomain from_capi(cls, c_api.LabelledDomainHandle h):
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_primitive_knob(cls, default_name, min_val, max_val, psuedo_name, instrument_type, lesser_bound_contained, greater_bound_contained, units, description):
        default_name_bytes = default_name.encode("utf-8")
        cdef const char* raw_default_name = default_name_bytes
        cdef size_t len_default_name = len(default_name_bytes)
        cdef c_api.StringHandle s_default_name = c_api.String_create(raw_default_name, len_default_name)
        instrument_type_bytes = instrument_type.encode("utf-8")
        cdef const char* raw_instrument_type = instrument_type_bytes
        cdef size_t len_instrument_type = len(instrument_type_bytes)
        cdef c_api.StringHandle s_instrument_type = c_api.String_create(raw_instrument_type, len_instrument_type)
        description_bytes = description.encode("utf-8")
        cdef const char* raw_description = description_bytes
        cdef size_t len_description = len(description_bytes)
        cdef c_api.StringHandle s_description = c_api.String_create(raw_description, len_description)
        cdef c_api.LabelledDomainHandle h
        try:
            h = c_api.LabelledDomain_create_primitive_knob(s_default_name, min_val, max_val, <c_api.ConnectionHandle>psuedo_name.handle, s_instrument_type, lesser_bound_contained, greater_bound_contained, <c_api.SymbolUnitHandle>units.handle, s_description)
        finally:
            c_api.String_destroy(s_default_name)
            c_api.String_destroy(s_instrument_type)
            c_api.String_destroy(s_description)
        if h == <c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_primitive_meter(cls, default_name, min_val, max_val, psuedo_name, instrument_type, lesser_bound_contained, greater_bound_contained, units, description):
        default_name_bytes = default_name.encode("utf-8")
        cdef const char* raw_default_name = default_name_bytes
        cdef size_t len_default_name = len(default_name_bytes)
        cdef c_api.StringHandle s_default_name = c_api.String_create(raw_default_name, len_default_name)
        instrument_type_bytes = instrument_type.encode("utf-8")
        cdef const char* raw_instrument_type = instrument_type_bytes
        cdef size_t len_instrument_type = len(instrument_type_bytes)
        cdef c_api.StringHandle s_instrument_type = c_api.String_create(raw_instrument_type, len_instrument_type)
        description_bytes = description.encode("utf-8")
        cdef const char* raw_description = description_bytes
        cdef size_t len_description = len(description_bytes)
        cdef c_api.StringHandle s_description = c_api.String_create(raw_description, len_description)
        cdef c_api.LabelledDomainHandle h
        try:
            h = c_api.LabelledDomain_create_primitive_meter(s_default_name, min_val, max_val, <c_api.ConnectionHandle>psuedo_name.handle, s_instrument_type, lesser_bound_contained, greater_bound_contained, <c_api.SymbolUnitHandle>units.handle, s_description)
        finally:
            c_api.String_destroy(s_default_name)
            c_api.String_destroy(s_instrument_type)
            c_api.String_destroy(s_description)
        if h == <c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_primitive_port(cls, default_name, min_val, max_val, psuedo_name, instrument_type, lesser_bound_contained, greater_bound_contained, units, description):
        default_name_bytes = default_name.encode("utf-8")
        cdef const char* raw_default_name = default_name_bytes
        cdef size_t len_default_name = len(default_name_bytes)
        cdef c_api.StringHandle s_default_name = c_api.String_create(raw_default_name, len_default_name)
        instrument_type_bytes = instrument_type.encode("utf-8")
        cdef const char* raw_instrument_type = instrument_type_bytes
        cdef size_t len_instrument_type = len(instrument_type_bytes)
        cdef c_api.StringHandle s_instrument_type = c_api.String_create(raw_instrument_type, len_instrument_type)
        description_bytes = description.encode("utf-8")
        cdef const char* raw_description = description_bytes
        cdef size_t len_description = len(description_bytes)
        cdef c_api.StringHandle s_description = c_api.String_create(raw_description, len_description)
        cdef c_api.LabelledDomainHandle h
        try:
            h = c_api.LabelledDomain_create_primitive_port(s_default_name, min_val, max_val, <c_api.ConnectionHandle>psuedo_name.handle, s_instrument_type, lesser_bound_contained, greater_bound_contained, <c_api.SymbolUnitHandle>units.handle, s_description)
        finally:
            c_api.String_destroy(s_default_name)
            c_api.String_destroy(s_instrument_type)
            c_api.String_destroy(s_description)
        if h == <c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port(cls, min_val, max_val, instrument_type, port, lesser_bound_contained, greater_bound_contained):
        instrument_type_bytes = instrument_type.encode("utf-8")
        cdef const char* raw_instrument_type = instrument_type_bytes
        cdef size_t len_instrument_type = len(instrument_type_bytes)
        cdef c_api.StringHandle s_instrument_type = c_api.String_create(raw_instrument_type, len_instrument_type)
        cdef c_api.LabelledDomainHandle h
        try:
            h = c_api.LabelledDomain_create_from_port(min_val, max_val, s_instrument_type, <c_api.InstrumentPortHandle>port.handle, lesser_bound_contained, greater_bound_contained)
        finally:
            c_api.String_destroy(s_instrument_type)
        if h == <c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port_and_domain(cls, port, domain):
        cdef c_api.LabelledDomainHandle h
        h = c_api.LabelledDomain_create_from_port_and_domain(<c_api.InstrumentPortHandle>port.handle, <c_api.DomainHandle>domain.handle)
        if h == <c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_domain(cls, domain, default_name, psuedo_name, instrument_type, units, description):
        default_name_bytes = default_name.encode("utf-8")
        cdef const char* raw_default_name = default_name_bytes
        cdef size_t len_default_name = len(default_name_bytes)
        cdef c_api.StringHandle s_default_name = c_api.String_create(raw_default_name, len_default_name)
        instrument_type_bytes = instrument_type.encode("utf-8")
        cdef const char* raw_instrument_type = instrument_type_bytes
        cdef size_t len_instrument_type = len(instrument_type_bytes)
        cdef c_api.StringHandle s_instrument_type = c_api.String_create(raw_instrument_type, len_instrument_type)
        description_bytes = description.encode("utf-8")
        cdef const char* raw_description = description_bytes
        cdef size_t len_description = len(description_bytes)
        cdef c_api.StringHandle s_description = c_api.String_create(raw_description, len_description)
        cdef c_api.LabelledDomainHandle h
        try:
            h = c_api.LabelledDomain_create_from_domain(<c_api.DomainHandle>domain.handle, s_default_name, <c_api.ConnectionHandle>psuedo_name.handle, s_instrument_type, <c_api.SymbolUnitHandle>units.handle, s_description)
        finally:
            c_api.String_destroy(s_default_name)
            c_api.String_destroy(s_instrument_type)
            c_api.String_destroy(s_description)
        if h == <c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.LabelledDomainHandle h
        try:
            h = c_api.LabelledDomain_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.LabelledDomainHandle>0:
            raise MemoryError("Failed to create LabelledDomain")
        cdef LabelledDomain obj = <LabelledDomain>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def port(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InstrumentPortHandle h_ret
        h_ret = c_api.LabelledDomain_port(self.handle)
        if h_ret == <c_api.InstrumentPortHandle>0:
            return None
        return InstrumentPort.from_capi(InstrumentPort, h_ret)

    def domain(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DomainHandle h_ret
        h_ret = c_api.LabelledDomain_domain(self.handle)
        if h_ret == <c_api.DomainHandle>0:
            return None
        return Domain.from_capi(Domain, h_ret)

    def matching_port(self, port):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_matching_port(self.handle, <c_api.InstrumentPortHandle>port.handle)

    def lesser_bound(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_lesser_bound(self.handle)

    def greater_bound(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_greater_bound(self.handle)

    def lesser_bound_contained(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_lesser_bound_contained(self.handle)

    def greater_bound_contained(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_greater_bound_contained(self.handle)

    def in(self, value):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_in(self.handle, value)

    def range(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_range(self.handle)

    def center(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_center(self.handle)

    def intersection(self, other):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.LabelledDomain_intersection(self.handle, <c_api.LabelledDomainHandle>other.handle)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def union(self, other):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.LabelledDomain_union(self.handle, <c_api.LabelledDomainHandle>other.handle)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def is_empty(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_is_empty(self.handle)

    def contains_domain(self, other):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_contains_domain(self.handle, <c_api.LabelledDomainHandle>other.handle)

    def shift(self, offset):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.LabelledDomain_shift(self.handle, offset)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def scale(self, scale):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.LabelledDomain_scale(self.handle, scale)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def transform(self, other, value):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_transform(self.handle, <c_api.LabelledDomainHandle>other.handle, value)

    def equal(self, other):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_equal(self.handle, <c_api.LabelledDomainHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledDomain_not_equal(self.handle, <c_api.LabelledDomainHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.LabelledDomainHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.LabelledDomain_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef LabelledDomain _labelleddomain_from_capi(c_api.LabelledDomainHandle h):
    cdef LabelledDomain obj = <LabelledDomain>LabelledDomain.__new__(LabelledDomain)
    obj.handle = h