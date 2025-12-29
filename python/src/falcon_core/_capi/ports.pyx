cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .instrument_port cimport InstrumentPort, _instrument_port_from_capi
from .list_connection cimport ListConnection, _list_connection_from_capi
from .list_instrument_port cimport ListInstrumentPort, _list_instrument_port_from_capi
from .list_string cimport ListString, _list_string_from_capi

cdef class Ports:
    def __cinit__(self):
        self.handle = <_c_api.PortsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PortsHandle>0 and self.owned:
            _c_api.Ports_destroy(self.handle)
        self.handle = <_c_api.PortsHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.PortsHandle h
        h = _c_api.Ports_create_empty()
        if h == <_c_api.PortsHandle>0:
            raise MemoryError("Failed to create Ports")
        cdef Ports obj = <Ports>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListInstrumentPort items):
        cdef _c_api.PortsHandle h
        h = _c_api.Ports_create(items.handle if items is not None else <_c_api.ListInstrumentPortHandle>0)
        if h == <_c_api.PortsHandle>0:
            raise MemoryError("Failed to create Ports")
        cdef Ports obj = <Ports>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PortsHandle h
        try:
            h = _c_api.Ports_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PortsHandle>0:
            raise MemoryError("Failed to create Ports")
        cdef Ports obj = <Ports>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def ports(self, ):
        cdef _c_api.ListInstrumentPortHandle h_ret = _c_api.Ports_ports(self.handle)
        if h_ret == <_c_api.ListInstrumentPortHandle>0:
            return None
        return _list_instrument_port_from_capi(h_ret)

    def default_names(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.Ports_default_names(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def get_psuedo_names(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Ports_get_psuedo_names(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret, owned=False)

    def _get_raw_names(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.Ports__get_raw_names(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def _get_instrument_facing_names(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.Ports__get_instrument_facing_names(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def _get_psuedoname_matching_port(self, Connection name):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.Ports__get_psuedoname_matching_port(self.handle, name.handle if name is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return _instrument_port_from_capi(h_ret)

    def _get_instrument_type_matching_port(self, str insttype):
        cdef bytes b_insttype = insttype.encode("utf-8")
        cdef _c_api.StringHandle s_insttype = _c_api.String_create(b_insttype, len(b_insttype))
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.Ports__get_instrument_type_matching_port(self.handle, s_insttype)
        _c_api.String_destroy(s_insttype)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return _instrument_port_from_capi(h_ret)

    def is_knobs(self, ):
        return _c_api.Ports_is_knobs(self.handle)

    def is_meters(self, ):
        return _c_api.Ports_is_meters(self.handle)

    def intersection(self, Ports other):
        cdef _c_api.PortsHandle h_ret = _c_api.Ports_intersection(self.handle, other.handle if other is not None else <_c_api.PortsHandle>0)
        if h_ret == <_c_api.PortsHandle>0:
            return None
        return _ports_from_capi(h_ret)

    def push_back(self, InstrumentPort value):
        _c_api.Ports_push_back(self.handle, value.handle if value is not None else <_c_api.InstrumentPortHandle>0)

    def size(self, ):
        return _c_api.Ports_size(self.handle)

    def empty(self, ):
        return _c_api.Ports_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.Ports_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.Ports_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.InstrumentPortHandle h_ret = _c_api.Ports_at(self.handle, idx)
        if h_ret == <_c_api.InstrumentPortHandle>0:
            return None
        return _instrument_port_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.Ports_items(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def contains(self, InstrumentPort value):
        return _c_api.Ports_contains(self.handle, value.handle if value is not None else <_c_api.InstrumentPortHandle>0)

    def index(self, InstrumentPort value):
        return _c_api.Ports_index(self.handle, value.handle if value is not None else <_c_api.InstrumentPortHandle>0)

    def equal(self, Ports b):
        return _c_api.Ports_equal(self.handle, b.handle if b is not None else <_c_api.PortsHandle>0)

    def __eq__(self, Ports b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Ports b):
        return _c_api.Ports_not_equal(self.handle, b.handle if b is not None else <_c_api.PortsHandle>0)

    def __ne__(self, Ports b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Ports_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

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
        cdef Ports obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef Ports _ports_from_capi(_c_api.PortsHandle h, bint owned=True):
    if h == <_c_api.PortsHandle>0:
        return None
    cdef Ports obj = Ports.__new__(Ports)
    obj.handle = h
    obj.owned = owned
    return obj
