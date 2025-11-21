# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .instrument_port cimport InstrumentPort
from .list_connection cimport ListConnection
from .list_instrument_port cimport ListInstrumentPort
from .list_string cimport ListString
from .const _instrument_port cimport const InstrumentPort

cdef class Ports:
    cdef c_api.PortsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PortsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PortsHandle>0 and self.owned:
            c_api.Ports_destroy(self.handle)
        self.handle = <c_api.PortsHandle>0

    cdef Ports from_capi(cls, c_api.PortsHandle h):
        cdef Ports obj = <Ports>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.PortsHandle h
        h = c_api.Ports_create_empty()
        if h == <c_api.PortsHandle>0:
            raise MemoryError("Failed to create Ports")
        cdef Ports obj = <Ports>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.PortsHandle h
        h = c_api.Ports_create(<c_api.ListInstrumentPortHandle>items.handle)
        if h == <c_api.PortsHandle>0:
            raise MemoryError("Failed to create Ports")
        cdef Ports obj = <Ports>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PortsHandle h
        try:
            h = c_api.Ports_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PortsHandle>0:
            raise MemoryError("Failed to create Ports")
        cdef Ports obj = <Ports>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def ports(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInstrumentPortHandle h_ret
        h_ret = c_api.Ports_ports(self.handle)
        if h_ret == <c_api.ListInstrumentPortHandle>0:
            return None
        return ListInstrumentPort.from_capi(ListInstrumentPort, h_ret)

    def default_names(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.Ports_default_names(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def get_psuedo_names(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.Ports_get_psuedo_names(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def _get_raw_names(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.Ports__get_raw_names(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def _get_instrument_facing_names(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.Ports__get_instrument_facing_names(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def _get_psuedoname_matching_port(self, name):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InstrumentPortHandle h_ret
        h_ret = c_api.Ports__get_psuedoname_matching_port(self.handle, <c_api.ConnectionHandle>name.handle)
        if h_ret == <c_api.InstrumentPortHandle>0:
            return None
        return InstrumentPort.from_capi(InstrumentPort, h_ret)

    def _get_instrument_type_matching_port(self, type):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        type_bytes = type.encode("utf-8")
        cdef const char* raw_type = type_bytes
        cdef size_t len_type = len(type_bytes)
        cdef c_api.StringHandle s_type = c_api.String_create(raw_type, len_type)
        cdef c_api.InstrumentPortHandle h_ret
        try:
            h_ret = c_api.Ports__get_instrument_type_matching_port(self.handle, s_type)
        finally:
            c_api.String_destroy(s_type)
        if h_ret == <c_api.InstrumentPortHandle>0:
            return None
        return InstrumentPort.from_capi(InstrumentPort, h_ret)

    def is_knobs(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_is_knobs(self.handle)

    def is_meters(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_is_meters(self.handle)

    def intersection(self, other):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortsHandle h_ret
        h_ret = c_api.Ports_intersection(self.handle, <c_api.PortsHandle>other.handle)
        if h_ret == <c_api.PortsHandle>0:
            return None
        return Ports.from_capi(Ports, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Ports_push_back(self.handle, <c_api.InstrumentPortHandle>value.handle)

    def size(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_size(self.handle)

    def empty(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Ports_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Ports_clear(self.handle)

    def const_at(self, idx):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.const InstrumentPortHandle h_ret
        h_ret = c_api.Ports_const_at(self.handle, idx)
        if h_ret == <c_api.const InstrumentPortHandle>0:
            return None
        return const InstrumentPort.from_capi(const InstrumentPort, h_ret)

    def at(self, idx):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InstrumentPortHandle h_ret
        h_ret = c_api.Ports_at(self.handle, idx)
        if h_ret == <c_api.InstrumentPortHandle>0:
            return None
        return InstrumentPort.from_capi(InstrumentPort, h_ret)

    def items(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.Ports_items(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def contains(self, value):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_contains(self.handle, <c_api.InstrumentPortHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_index(self.handle, <c_api.InstrumentPortHandle>value.handle)

    def equal(self, b):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_equal(self.handle, <c_api.PortsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Ports_not_equal(self.handle, <c_api.PortsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PortsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Ports_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Ports _ports_from_capi(c_api.PortsHandle h):
    cdef Ports obj = <Ports>Ports.__new__(Ports)
    obj.handle = h