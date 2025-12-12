cimport _c_api

cdef class GateRelations:
    cdef _c_api.GateRelationsHandle handle
    cdef bint owned

cdef GateRelations _gate_relations_from_capi(_c_api.GateRelationsHandle h)