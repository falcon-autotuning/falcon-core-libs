# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .symbol_unit cimport SymbolUnit

cdef class InstrumentPort:
    cdef c_api.InstrumentPortHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.InstrumentPortHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.InstrumentPortHandle>0 and self.owned:
            c_api.InstrumentPort_destroy(self.handle)
        self.handle = <c_api.InstrumentPortHandle>0

    cdef InstrumentPort from_capi(cls, c_api.InstrumentPortHandle h):
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_port(cls, default_name, psuedo_name, instrument_type, units, description):
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
        cdef c_api.InstrumentPortHandle h
        try:
            h = c_api.InstrumentPort_create_port(s_default_name, <c_api.ConnectionHandle>psuedo_name.handle, s_instrument_type, <c_api.SymbolUnitHandle>units.handle, s_description)
        finally:
            c_api.String_destroy(s_default_name)
            c_api.String_destroy(s_instrument_type)
            c_api.String_destroy(s_description)
        if h == <c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_knob(cls, default_name, psuedo_name, instrument_type, units, description):
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
        cdef c_api.InstrumentPortHandle h
        try:
            h = c_api.InstrumentPort_create_knob(s_default_name, <c_api.ConnectionHandle>psuedo_name.handle, s_instrument_type, <c_api.SymbolUnitHandle>units.handle, s_description)
        finally:
            c_api.String_destroy(s_default_name)
            c_api.String_destroy(s_instrument_type)
            c_api.String_destroy(s_description)
        if h == <c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_meter(cls, default_name, psuedo_name, instrument_type, units, description):
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
        cdef c_api.InstrumentPortHandle h
        try:
            h = c_api.InstrumentPort_create_meter(s_default_name, <c_api.ConnectionHandle>psuedo_name.handle, s_instrument_type, <c_api.SymbolUnitHandle>units.handle, s_description)
        finally:
            c_api.String_destroy(s_default_name)
            c_api.String_destroy(s_instrument_type)
            c_api.String_destroy(s_description)
        if h == <c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_timer(cls, ):
        cdef c_api.InstrumentPortHandle h
        h = c_api.InstrumentPort_create_timer()
        if h == <c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_execution_clock(cls, ):
        cdef c_api.InstrumentPortHandle h
        h = c_api.InstrumentPort_create_execution_clock()
        if h == <c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.InstrumentPortHandle h
        try:
            h = c_api.InstrumentPort_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def default_name(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InstrumentPort_default_name(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def psuedo_name(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.InstrumentPort_psuedo_name(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def instrument_type(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InstrumentPort_instrument_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def units(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.InstrumentPort_units(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def description(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InstrumentPort_description(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def instrument_facing_name(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InstrumentPort_instrument_facing_name(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def is_knob(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InstrumentPort_is_knob(self.handle)

    def is_meter(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InstrumentPort_is_meter(self.handle)

    def is_port(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InstrumentPort_is_port(self.handle)

    def equal(self, other):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InstrumentPort_equal(self.handle, <c_api.InstrumentPortHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InstrumentPort_not_equal(self.handle, <c_api.InstrumentPortHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.InstrumentPortHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InstrumentPort_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef InstrumentPort _instrumentport_from_capi(c_api.InstrumentPortHandle h):
    cdef InstrumentPort obj = <InstrumentPort>InstrumentPort.__new__(InstrumentPort)
    obj.handle = h