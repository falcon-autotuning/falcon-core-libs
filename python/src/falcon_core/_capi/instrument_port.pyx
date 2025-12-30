cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class InstrumentPort:
    def __cinit__(self):
        self.handle = <_c_api.InstrumentPortHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.InstrumentPortHandle>0 and self.owned:
            _c_api.InstrumentPort_destroy(self.handle)
        self.handle = <_c_api.InstrumentPortHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.InstrumentPortHandle h
        try:
            h = _c_api.InstrumentPort_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_port(cls, str default_name, Connection psuedo_name, str instrument_type, SymbolUnit units, str description):
        cdef bytes b_default_name = default_name.encode("utf-8")
        cdef _c_api.StringHandle s_default_name = _c_api.String_create(b_default_name, len(b_default_name))
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef _c_api.StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef bytes b_description = description.encode("utf-8")
        cdef _c_api.StringHandle s_description = _c_api.String_create(b_description, len(b_description))
        cdef _c_api.InstrumentPortHandle h
        try:
            h = _c_api.InstrumentPort_create_port(s_default_name, psuedo_name.handle if psuedo_name is not None else <_c_api.ConnectionHandle>0, s_instrument_type, units.handle if units is not None else <_c_api.SymbolUnitHandle>0, s_description)
        finally:
            _c_api.String_destroy(s_default_name)
            _c_api.String_destroy(s_instrument_type)
            _c_api.String_destroy(s_description)
        if h == <_c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_knob(cls, str default_name, Connection psuedo_name, str instrument_type, SymbolUnit units, str description):
        cdef bytes b_default_name = default_name.encode("utf-8")
        cdef _c_api.StringHandle s_default_name = _c_api.String_create(b_default_name, len(b_default_name))
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef _c_api.StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef bytes b_description = description.encode("utf-8")
        cdef _c_api.StringHandle s_description = _c_api.String_create(b_description, len(b_description))
        cdef _c_api.InstrumentPortHandle h
        try:
            h = _c_api.InstrumentPort_create_knob(s_default_name, psuedo_name.handle if psuedo_name is not None else <_c_api.ConnectionHandle>0, s_instrument_type, units.handle if units is not None else <_c_api.SymbolUnitHandle>0, s_description)
        finally:
            _c_api.String_destroy(s_default_name)
            _c_api.String_destroy(s_instrument_type)
            _c_api.String_destroy(s_description)
        if h == <_c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_meter(cls, str default_name, Connection psuedo_name, str instrument_type, SymbolUnit units, str description):
        cdef bytes b_default_name = default_name.encode("utf-8")
        cdef _c_api.StringHandle s_default_name = _c_api.String_create(b_default_name, len(b_default_name))
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef _c_api.StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef bytes b_description = description.encode("utf-8")
        cdef _c_api.StringHandle s_description = _c_api.String_create(b_description, len(b_description))
        cdef _c_api.InstrumentPortHandle h
        try:
            h = _c_api.InstrumentPort_create_meter(s_default_name, psuedo_name.handle if psuedo_name is not None else <_c_api.ConnectionHandle>0, s_instrument_type, units.handle if units is not None else <_c_api.SymbolUnitHandle>0, s_description)
        finally:
            _c_api.String_destroy(s_default_name)
            _c_api.String_destroy(s_instrument_type)
            _c_api.String_destroy(s_description)
        if h == <_c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_timer(cls, ):
        cdef _c_api.InstrumentPortHandle h
        h = _c_api.InstrumentPort_create_timer()
        if h == <_c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_execution_clock(cls, ):
        cdef _c_api.InstrumentPortHandle h
        h = _c_api.InstrumentPort_create_execution_clock()
        if h == <_c_api.InstrumentPortHandle>0:
            raise MemoryError("Failed to create InstrumentPort")
        cdef InstrumentPort obj = <InstrumentPort>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.InstrumentPort_copy(self.handle)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return _instrument_port_from_capi(h_ret, owned=(h_ret != <_c_api.InstrumentPortHandle>self.handle))

    def equal(self, InstrumentPort other):
        return _c_api.InstrumentPort_equal(self.handle, other.handle if other is not None else <_c_api.InstrumentPortHandle>0)

    def __eq__(self, InstrumentPort other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, InstrumentPort other):
        return _c_api.InstrumentPort_not_equal(self.handle, other.handle if other is not None else <_c_api.InstrumentPortHandle>0)

    def __ne__(self, InstrumentPort other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InstrumentPort_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def default_name(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InstrumentPort_default_name(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def psuedo_name(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.InstrumentPort_psuedo_name(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret)

    def instrument_type(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InstrumentPort_instrument_type(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def units(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.InstrumentPort_units(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def description(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InstrumentPort_description(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def instrument_facing_name(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InstrumentPort_instrument_facing_name(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def is_knob(self, ):
        return _c_api.InstrumentPort_is_knob(self.handle)

    def is_meter(self, ):
        return _c_api.InstrumentPort_is_meter(self.handle)

    def is_port(self, ):
        return _c_api.InstrumentPort_is_port(self.handle)

cdef InstrumentPort _instrument_port_from_capi(_c_api.InstrumentPortHandle h, bint owned=True):
    if h == <_c_api.InstrumentPortHandle>0:
        return None
    cdef InstrumentPort obj = InstrumentPort.__new__(InstrumentPort)
    obj.handle = h
    obj.owned = owned
    return obj
