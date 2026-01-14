cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .impedance cimport Impedance, _impedance_from_capi
from .list_impedance cimport ListImpedance, _list_impedance_from_capi

cdef class Impedances:
    def __cinit__(self):
        self.handle = <_c_api.ImpedancesHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ImpedancesHandle>0 and self.owned:
            _c_api.Impedances_destroy(self.handle)
        self.handle = <_c_api.ImpedancesHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ImpedancesHandle h
        try:
            h = _c_api.Impedances_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ImpedancesHandle>0:
            raise MemoryError("Failed to create Impedances")
        cdef Impedances obj = <Impedances>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ImpedancesHandle h
        h = _c_api.Impedances_create_empty()
        if h == <_c_api.ImpedancesHandle>0:
            raise MemoryError("Failed to create Impedances")
        cdef Impedances obj = <Impedances>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListImpedance items):
        cdef _c_api.ImpedancesHandle h
        h = _c_api.Impedances_create(items.handle if items is not None else <_c_api.ListImpedanceHandle>0)
        if h == <_c_api.ImpedancesHandle>0:
            raise MemoryError("Failed to create Impedances")
        cdef Impedances obj = <Impedances>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self):
        cdef _c_api.ImpedancesHandle h_ret = _c_api.Impedances_copy(self.handle)
        if h_ret == <_c_api.ImpedancesHandle>0: return None
        return _impedances_from_capi(h_ret, owned=(h_ret != <_c_api.ImpedancesHandle>self.handle))

    def equal(self, Impedances other):
        return _c_api.Impedances_equal(self.handle, other.handle if other is not None else <_c_api.ImpedancesHandle>0)

    def __eq__(self, Impedances other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, Impedances other):
        return _c_api.Impedances_not_equal(self.handle, other.handle if other is not None else <_c_api.ImpedancesHandle>0)

    def __ne__(self, Impedances other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Impedances_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def push_back(self, Impedance value):
        _c_api.Impedances_push_back(self.handle, value.handle if value is not None else <_c_api.ImpedanceHandle>0)

    def size(self):
        return _c_api.Impedances_size(self.handle)

    def empty(self):
        return _c_api.Impedances_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.Impedances_erase_at(self.handle, idx)

    def clear(self):
        _c_api.Impedances_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ImpedanceHandle h_ret = _c_api.Impedances_at(self.handle, idx)
        if h_ret == <_c_api.ImpedanceHandle>0: return None
        return _impedance_from_capi(h_ret, owned=False)

    def items(self):
        cdef _c_api.ListImpedanceHandle h_ret = _c_api.Impedances_items(self.handle)
        if h_ret == <_c_api.ListImpedanceHandle>0: return None
        return _list_impedance_from_capi(h_ret, owned=False)

    def contains(self, Impedance value):
        return _c_api.Impedances_contains(self.handle, value.handle if value is not None else <_c_api.ImpedanceHandle>0)

    def intersection(self, Impedances other):
        cdef _c_api.ImpedancesHandle h_ret = _c_api.Impedances_intersection(self.handle, other.handle if other is not None else <_c_api.ImpedancesHandle>0)
        if h_ret == <_c_api.ImpedancesHandle>0: return None
        return _impedances_from_capi(h_ret, owned=(h_ret != <_c_api.ImpedancesHandle>self.handle))

    def index(self, Impedance value):
        return _c_api.Impedances_index(self.handle, value.handle if value is not None else <_c_api.ImpedanceHandle>0)

    def __len__(self):
        return self.size

    def __getitem__(self, key):
        ret = self.at(key)
        if ret is None:
            raise IndexError(f"{key} not found in {self.__class__.__name__}")
        return ret

    def __iter__(self):
        for i in range(len(self)):
            yield self[i]

    def append(self, value):
        self.push_back(value)

    @classmethod
    def from_list(cls, items):
        cdef Impedances obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef Impedances _impedances_from_capi(_c_api.ImpedancesHandle h, bint owned=True):
    if h == <_c_api.ImpedancesHandle>0:
        return None
    cdef Impedances obj = Impedances.__new__(Impedances)
    obj.handle = h
    obj.owned = owned
    return obj
