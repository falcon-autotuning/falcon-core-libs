cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .config cimport Config, _config_from_capi

cdef class Loader:
    def __cinit__(self):
        self.handle = <_c_api.LoaderHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LoaderHandle>0 and self.owned:
            _c_api.Loader_destroy(self.handle)
        self.handle = <_c_api.LoaderHandle>0


    @classmethod
    def new(cls, str config_path):
        cdef bytes b_config_path = config_path.encode("utf-8")
        cdef _c_api.StringHandle s_config_path = _c_api.String_create(b_config_path, len(b_config_path))
        cdef _c_api.LoaderHandle h
        try:
            h = _c_api.Loader_create(s_config_path)
        finally:
            _c_api.String_destroy(s_config_path)
        if h == <_c_api.LoaderHandle>0:
            raise MemoryError("Failed to create Loader")
        cdef Loader obj = <Loader>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def config(self):
        cdef _c_api.ConfigHandle h_ret = _c_api.Loader_config(self.handle)
        if h_ret == <_c_api.ConfigHandle>0: return None
        return _config_from_capi(h_ret, owned=True)

cdef Loader _loader_from_capi(_c_api.LoaderHandle h, bint owned=True):
    if h == <_c_api.LoaderHandle>0:
        return None
    cdef Loader obj = Loader.__new__(Loader)
    obj.handle = h
    obj.owned = owned
    return obj
