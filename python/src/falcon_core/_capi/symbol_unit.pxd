cimport _c_api

cdef class SymbolUnit:
    cdef _c_api.SymbolUnitHandle handle
    cdef bint owned

cdef SymbolUnit _symbol_unit_from_capi(_c_api.SymbolUnitHandle h)