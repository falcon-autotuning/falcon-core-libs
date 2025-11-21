# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .config cimport Config

cdef class Loader:
    cdef c_api.LoaderHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.LoaderHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.LoaderHandle>0 and self.owned:
            c_api.Loader_destroy(self.handle)
        self.handle = <c_api.LoaderHandle>0

    cdef Loader from_capi(cls, c_api.LoaderHandle h):
        cdef Loader obj = <Loader>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, config_path):
        config_path_bytes = config_path.encode("utf-8")
        cdef const char* raw_config_path = config_path_bytes
        cdef size_t len_config_path = len(config_path_bytes)
        cdef c_api.StringHandle s_config_path = c_api.String_create(raw_config_path, len_config_path)
        cdef c_api.LoaderHandle h
        try:
            h = c_api.Loader_create(s_config_path)
        finally:
            c_api.String_destroy(s_config_path)
        if h == <c_api.LoaderHandle>0:
            raise MemoryError("Failed to create Loader")
        cdef Loader obj = <Loader>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def config(self):
        if self.handle == <c_api.LoaderHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConfigHandle h_ret
        h_ret = c_api.Loader_config(self.handle)
        if h_ret == <c_api.ConfigHandle>0:
            return None
        return Config.from_capi(Config, h_ret)

cdef Loader _loader_from_capi(c_api.LoaderHandle h):
    cdef Loader obj = <Loader>Loader.__new__(Loader)
    obj.handle = h