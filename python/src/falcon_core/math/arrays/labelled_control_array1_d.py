from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.labelled_control_array1_d import LabelledControlArray1D as _CLabelledControlArray1D
from falcon_core.autotuner_interfaces.contexts.acquisition_context import AcquisitionContext
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.math.arrays.control_array import ControlArray
from falcon_core.generic.f_array_double import FArrayDouble
from falcon_core.generic.list import List
from falcon_core.generic.list import List
from falcon_core.physics.units.symbol_unit import SymbolUnit

class LabelledControlArray1D:
    """Python wrapper for LabelledControlArray1D."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def LabelledControlArray1D_from_json_string(cls, json: str) -> LabelledControlArray1D:
        return cls(_CLabelledControlArray1D.LabelledControlArray1D_from_json_string(json))

    @classmethod
    def from_farray(cls, farray: FArrayDouble, label: AcquisitionContext) -> LabelledControlArray1D:
        ret = _CLabelledControlArray1D.from_farray(farray._c, label._c)
        return cls._from_capi(ret)

    @classmethod
    def from_control_array(cls, controlarray: ControlArray, label: AcquisitionContext) -> LabelledControlArray1D:
        ret = _CLabelledControlArray1D.from_control_array(controlarray._c, label._c)
        return cls._from_capi(ret)

    def is_1D(self, ) -> None:
        ret = self._c.is_1D()
        return ret

    def as_1D(self, ) -> FArrayDouble:
        ret = self._c.as_1D()
        if ret is None: return None
        return FArrayDouble._from_capi(ret)

    def get_start(self, ) -> None:
        ret = self._c.get_start()
        return ret

    def get_end(self, ) -> None:
        ret = self._c.get_end()
        return ret

    def is_decreasing(self, ) -> None:
        ret = self._c.is_decreasing()
        return ret

    def is_increasing(self, ) -> None:
        ret = self._c.is_increasing()
        return ret

    def get_distance(self, ) -> None:
        ret = self._c.get_distance()
        return ret

    def get_mean(self, ) -> None:
        ret = self._c.get_mean()
        return ret

    def get_std(self, ) -> None:
        ret = self._c.get_std()
        return ret

    def reverse(self, ) -> None:
        ret = self._c.reverse()
        return ret

    def get_closest_index(self, value: Any) -> None:
        ret = self._c.get_closest_index(value)
        return ret

    def even_divisions(self, divisions: Any) -> List:
        ret = self._c.even_divisions(divisions)
        if ret is None: return None
        return List(ret)

    def label(self, ) -> AcquisitionContext:
        ret = self._c.label()
        if ret is None: return None
        return AcquisitionContext._from_capi(ret)

    def connection(self, ) -> Connection:
        ret = self._c.connection()
        if ret is None: return None
        return Connection._from_capi(ret)

    def instrument_type(self, ) -> str:
        ret = self._c.instrument_type()
        return ret

    def units(self, ) -> SymbolUnit:
        ret = self._c.units()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def size(self, ) -> None:
        ret = self._c.size()
        return ret

    def dimension(self, ) -> None:
        ret = self._c.dimension()
        return ret

    def shape(self, out_buffer: Any, ndim: Any) -> None:
        ret = self._c.shape(out_buffer, ndim)
        return ret

    def data(self, out_buffer: Any, numdata: Any) -> None:
        ret = self._c.data(out_buffer, numdata)
        return ret

    def plusequals_farray(self, other: FArrayDouble) -> None:
        ret = self._c.plusequals_farray(other._c)
        return ret

    def plusequals_double(self, other: Any) -> None:
        ret = self._c.plusequals_double(other)
        return ret

    def plusequals_int(self, other: Any) -> None:
        ret = self._c.plusequals_int(other)
        return ret

    def plus_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.plus_control_array(other._c)
        return cls._from_capi(ret)

    def plus_farray(self, other: FArrayDouble) -> LabelledControlArray1D:
        ret = self._c.plus_farray(other._c)
        return cls._from_capi(ret)

    def plus_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.plus_double(other)
        return cls._from_capi(ret)

    def plus_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.plus_int(other)
        return cls._from_capi(ret)

    def minusequals_farray(self, other: FArrayDouble) -> None:
        ret = self._c.minusequals_farray(other._c)
        return ret

    def minusequals_double(self, other: Any) -> None:
        ret = self._c.minusequals_double(other)
        return ret

    def minusequals_int(self, other: Any) -> None:
        ret = self._c.minusequals_int(other)
        return ret

    def minus_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.minus_control_array(other._c)
        return cls._from_capi(ret)

    def minus_farray(self, other: FArrayDouble) -> LabelledControlArray1D:
        ret = self._c.minus_farray(other._c)
        return cls._from_capi(ret)

    def minus_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.minus_double(other)
        return cls._from_capi(ret)

    def minus_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.minus_int(other)
        return cls._from_capi(ret)

    def negation(self, ) -> LabelledControlArray1D:
        ret = self._c.negation()
        return cls._from_capi(ret)

    def __neg__(self, ) -> LabelledControlArray1D:
        return self.negation()

    def timesequals_double(self, other: Any) -> None:
        ret = self._c.timesequals_double(other)
        return ret

    def timesequals_int(self, other: Any) -> None:
        ret = self._c.timesequals_int(other)
        return ret

    def times_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.times_double(other)
        return cls._from_capi(ret)

    def times_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.times_int(other)
        return cls._from_capi(ret)

    def dividesequals_double(self, other: Any) -> None:
        ret = self._c.dividesequals_double(other)
        return ret

    def dividesequals_int(self, other: Any) -> None:
        ret = self._c.dividesequals_int(other)
        return ret

    def divides_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.divides_double(other)
        return cls._from_capi(ret)

    def divides_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.divides_int(other)
        return cls._from_capi(ret)

    def pow(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.pow(other)
        return cls._from_capi(ret)

    def abs(self, ) -> LabelledControlArray1D:
        ret = self._c.abs()
        return cls._from_capi(ret)

    def min_farray(self, other: FArrayDouble) -> LabelledControlArray1D:
        ret = self._c.min_farray(other._c)
        return cls._from_capi(ret)

    def min_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.min_control_array(other._c)
        return cls._from_capi(ret)

    def max_farray(self, other: FArrayDouble) -> LabelledControlArray1D:
        ret = self._c.max_farray(other._c)
        return cls._from_capi(ret)

    def max_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.max_control_array(other._c)
        return cls._from_capi(ret)

    def equality(self, other: LabelledControlArray1D) -> None:
        ret = self._c.equality(other._c)
        return ret

    def notequality(self, other: LabelledControlArray1D) -> None:
        ret = self._c.notequality(other._c)
        return ret

    def greaterthan(self, value: Any) -> None:
        ret = self._c.greaterthan(value)
        return ret

    def lessthan(self, value: Any) -> None:
        ret = self._c.lessthan(value)
        return ret

    def remove_offset(self, offset: Any) -> None:
        ret = self._c.remove_offset(offset)
        return ret

    def sum(self, ) -> None:
        ret = self._c.sum()
        return ret

    def reshape(self, shape: Any, ndims: Any) -> LabelledControlArray1D:
        ret = self._c.reshape(shape, ndims)
        return cls._from_capi(ret)

    def where(self, value: Any) -> List:
        ret = self._c.where(value)
        if ret is None: return None
        return List(ret)

    def flip(self, axis: Any) -> LabelledControlArray1D:
        ret = self._c.flip(axis)
        return cls._from_capi(ret)

    def full_gradient(self, out_buffer: FArrayDouble, buffer_size: Any) -> None:
        ret = self._c.full_gradient(out_buffer._c, buffer_size)
        return ret

    def gradient(self, axis: Any) -> FArrayDouble:
        ret = self._c.gradient(axis)
        if ret is None: return None
        return FArrayDouble._from_capi(ret)

    def get_sum_of_squares(self, ) -> None:
        ret = self._c.get_sum_of_squares()
        return ret

    def get_summed_diff_int_of_squares(self, other: Any) -> None:
        ret = self._c.get_summed_diff_int_of_squares(other)
        return ret

    def get_summed_diff_double_of_squares(self, other: Any) -> None:
        ret = self._c.get_summed_diff_double_of_squares(other)
        return ret

    def get_summed_diff_array_of_squares(self, other: LabelledControlArray1D) -> None:
        ret = self._c.get_summed_diff_array_of_squares(other._c)
        return ret

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
