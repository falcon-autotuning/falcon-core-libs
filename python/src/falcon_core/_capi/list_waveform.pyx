cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport waveform

cdef class ListWaveform:
    def __cinit__(self):
        self.handle = <_c_api.ListWaveformHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListWaveformHandle>0 and self.owned:
            _c_api.ListWaveform_destroy(self.handle)
        self.handle = <_c_api.ListWaveformHandle>0


cdef ListWaveform _list_waveform_from_capi(_c_api.ListWaveformHandle h):
    if h == <_c_api.ListWaveformHandle>0:
        return None
    cdef ListWaveform obj = ListWaveform.__new__(ListWaveform)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListWaveformHandle h
        h = _c_api.ListWaveform_create_empty()
        if h == <_c_api.ListWaveformHandle>0:
            raise MemoryError("Failed to create ListWaveform")
        cdef ListWaveform obj = <ListWaveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, Waveform data, size_t count):
        cdef _c_api.ListWaveformHandle h
        h = _c_api.ListWaveform_create(data.handle, count)
        if h == <_c_api.ListWaveformHandle>0:
            raise MemoryError("Failed to create ListWaveform")
        cdef ListWaveform obj = <ListWaveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListWaveformHandle h
        try:
            h = _c_api.ListWaveform_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListWaveformHandle>0:
            raise MemoryError("Failed to create ListWaveform")
        cdef ListWaveform obj = <ListWaveform>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, Waveform value):
        cdef _c_api.ListWaveformHandle h_ret = _c_api.ListWaveform_fill_value(count, value.handle)
        if h_ret == <_c_api.ListWaveformHandle>0:
            return None
        return _list_waveform_from_capi(h_ret)

    def push_back(self, Waveform value):
        _c_api.ListWaveform_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListWaveform_size(self.handle)

    def empty(self, ):
        return _c_api.ListWaveform_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListWaveform_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListWaveform_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.WaveformHandle h_ret = _c_api.ListWaveform_at(self.handle, idx)
        if h_ret == <_c_api.WaveformHandle>0:
            return None
        return waveform._waveform_from_capi(h_ret)

    def items(self, Waveform out_buffer, size_t buffer_size):
        return _c_api.ListWaveform_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Waveform value):
        return _c_api.ListWaveform_contains(self.handle, value.handle)

    def index(self, Waveform value):
        return _c_api.ListWaveform_index(self.handle, value.handle)

    def intersection(self, ListWaveform other):
        cdef _c_api.ListWaveformHandle h_ret = _c_api.ListWaveform_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListWaveformHandle>0:
            return None
        return _list_waveform_from_capi(h_ret)

    def equal(self, ListWaveform b):
        return _c_api.ListWaveform_equal(self.handle, b.handle)

    def __eq__(self, ListWaveform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListWaveform b):
        return _c_api.ListWaveform_not_equal(self.handle, b.handle)

    def __ne__(self, ListWaveform b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
