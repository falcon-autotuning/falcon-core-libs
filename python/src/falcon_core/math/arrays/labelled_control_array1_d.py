from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.labelled_control_array1_d import LabelledControlArray1D as _CLabelledControlArray1D
from falcon_core.autotuner_interfaces.contexts.acquisition_context import AcquisitionContext
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.math.arrays.control_array import ControlArray
from falcon_core.generic.f_array import FArray
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
    def from_json(cls, json: str) -> LabelledControlArray1D:
        return cls(_CLabelledControlArray1D.from_json(json))

    @classmethod
    def from_farray(cls, farray: FArray, label: AcquisitionContext) -> LabelledControlArray1D:
        ret = _CLabelledControlArray1D.from_farray(farray._c if farray is not None else None, label._c if label is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    @classmethod
    def from_control_array(cls, controlarray: ControlArray, label: AcquisitionContext) -> LabelledControlArray1D:
        ret = _CLabelledControlArray1D.from_control_array(controlarray._c if controlarray is not None else None, label._c if label is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def is_1D(self, ) -> None:
        ret = self._c.is_1D()
        return ret

    def as_1D(self, ) -> FArray:
        ret = self._c.as_1D()
        if ret is None: return None
        return FArray(ret)

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

    def plus_equals_farray(self, other: FArray) -> None:
        ret = self._c.plus_equals_farray(other._c if other is not None else None)
        return ret

    def plus_equals_double(self, other: Any) -> None:
        ret = self._c.plus_equals_double(other)
        return ret

    def plus_equals_int(self, other: Any) -> None:
        ret = self._c.plus_equals_int(other)
        return ret

    def plus_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.plus_control_array(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def plus_farray(self, other: FArray) -> LabelledControlArray1D:
        ret = self._c.plus_farray(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def plus_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.plus_double(other)
        return LabelledControlArray1D._from_capi(ret)

    def plus_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.plus_int(other)
        return LabelledControlArray1D._from_capi(ret)

    def minus_equals_farray(self, other: FArray) -> None:
        ret = self._c.minus_equals_farray(other._c if other is not None else None)
        return ret

    def minus_equals_double(self, other: Any) -> None:
        ret = self._c.minus_equals_double(other)
        return ret

    def minus_equals_int(self, other: Any) -> None:
        ret = self._c.minus_equals_int(other)
        return ret

    def minus_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.minus_control_array(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def minus_farray(self, other: FArray) -> LabelledControlArray1D:
        ret = self._c.minus_farray(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def minus_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.minus_double(other)
        return LabelledControlArray1D._from_capi(ret)

    def minus_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.minus_int(other)
        return LabelledControlArray1D._from_capi(ret)

    def negation(self, ) -> LabelledControlArray1D:
        ret = self._c.negation()
        return LabelledControlArray1D._from_capi(ret)

    def times_equals_double(self, other: Any) -> None:
        ret = self._c.times_equals_double(other)
        return ret

    def times_equals_int(self, other: Any) -> None:
        ret = self._c.times_equals_int(other)
        return ret

    def times_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.times_double(other)
        return LabelledControlArray1D._from_capi(ret)

    def times_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.times_int(other)
        return LabelledControlArray1D._from_capi(ret)

    def divides_equals_double(self, other: Any) -> None:
        ret = self._c.divides_equals_double(other)
        return ret

    def divides_equals_int(self, other: Any) -> None:
        ret = self._c.divides_equals_int(other)
        return ret

    def divides_double(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.divides_double(other)
        return LabelledControlArray1D._from_capi(ret)

    def divides_int(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.divides_int(other)
        return LabelledControlArray1D._from_capi(ret)

    def pow(self, other: Any) -> LabelledControlArray1D:
        ret = self._c.pow(other)
        return LabelledControlArray1D._from_capi(ret)

    def abs(self, ) -> LabelledControlArray1D:
        ret = self._c.abs()
        return LabelledControlArray1D._from_capi(ret)

    def min(self, ) -> None:
        ret = self._c.min()
        return ret

    def min_farray(self, other: FArray) -> LabelledControlArray1D:
        ret = self._c.min_farray(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def min_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.min_control_array(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def max(self, ) -> None:
        ret = self._c.max()
        return ret

    def max_farray(self, other: FArray) -> LabelledControlArray1D:
        ret = self._c.max_farray(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def max_control_array(self, other: LabelledControlArray1D) -> LabelledControlArray1D:
        ret = self._c.max_control_array(other._c if other is not None else None)
        return LabelledControlArray1D._from_capi(ret)

    def equal(self, other: LabelledControlArray1D) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: LabelledControlArray1D) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def greater_than(self, value: Any) -> None:
        ret = self._c.greater_than(value)
        return ret

    def less_than(self, value: Any) -> None:
        ret = self._c.less_than(value)
        return ret

    def remove_offset(self, offset: Any) -> None:
        ret = self._c.remove_offset(offset)
        return ret

    def sum(self, ) -> None:
        ret = self._c.sum()
        return ret

    def where(self, value: Any) -> List:
        ret = self._c.where(value)
        if ret is None: return None
        return List(ret)

    def flip(self, axis: Any) -> LabelledControlArray1D:
        ret = self._c.flip(axis)
        return LabelledControlArray1D._from_capi(ret)

    def full_gradient(self, out_buffer: FArray, buffer_size: Any) -> None:
        ret = self._c.full_gradient(out_buffer._c if out_buffer is not None else None, buffer_size)
        return ret

    def gradient(self, axis: Any) -> FArray:
        ret = self._c.gradient(axis)
        if ret is None: return None
        return FArray(ret)

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
        ret = self._c.get_summed_diff_array_of_squares(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __len__(self):
        return self.size()

    def __add__(self, other):
        """Operator overload for +"""
        if hasattr(other, "_c") and type(other).__name__ == "EqualsFarray":
            return self.plus_equals_farray(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsDouble":
            return self.plus_equals_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsInt":
            return self.plus_equals_int(other)
        if isinstance(other, LabelledControlArray1D):
            return self.plus_control_array(other)
        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:
            return self.plus_farray(other)
        if isinstance(other, float):
            return self.plus_double(other)
        if isinstance(other, int):
            return self.plus_int(other)
        return NotImplemented

    def __sub__(self, other):
        """Operator overload for -"""
        if hasattr(other, "_c") and type(other).__name__ == "EqualsFarray":
            return self.minus_equals_farray(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsDouble":
            return self.minus_equals_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsInt":
            return self.minus_equals_int(other)
        if isinstance(other, LabelledControlArray1D):
            return self.minus_control_array(other)
        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:
            return self.minus_farray(other)
        if isinstance(other, float):
            return self.minus_double(other)
        if isinstance(other, int):
            return self.minus_int(other)
        return NotImplemented

    def __mul__(self, other):
        """Operator overload for *"""
        if hasattr(other, "_c") and type(other).__name__ == "EqualsDouble":
            return self.times_equals_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsInt":
            return self.times_equals_int(other)
        if isinstance(other, float):
            return self.times_double(other)
        if isinstance(other, int):
            return self.times_int(other)
        return NotImplemented

    def __truediv__(self, other):
        """Operator overload for /"""
        if hasattr(other, "_c") and type(other).__name__ == "EqualsDouble":
            return self.divides_equals_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsInt":
            return self.divides_equals_int(other)
        if isinstance(other, float):
            return self.divides_double(other)
        if isinstance(other, int):
            return self.divides_int(other)
        return NotImplemented

    def __neg__(self):
        """Operator overload for unary -"""
        return self.negation()

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, LabelledControlArray1D):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, LabelledControlArray1D):
            return NotImplemented
        return self.not_equal(other)
