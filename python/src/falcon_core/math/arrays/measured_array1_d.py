from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.measured_array1_d import MeasuredArray1D as _CMeasuredArray1D
from falcon_core.generic.f_array import FArray
from falcon_core.generic.list import List
from falcon_core.generic.list import List

class MeasuredArray1D:
    """Python wrapper for MeasuredArray1D."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> MeasuredArray1D:
        return cls(_CMeasuredArray1D.from_json(json))

    def copy(self, ) -> MeasuredArray1D:
        ret = self._c.copy()
        return MeasuredArray1D._from_capi(ret)

    def equal(self, other: MeasuredArray1D) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: MeasuredArray1D) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    @classmethod
    def from_data(cls, data: Any, shape: Any, ndim: Any) -> MeasuredArray1D:
        ret = _CMeasuredArray1D.from_data(data, shape, ndim)
        return MeasuredArray1D._from_capi(ret)

    @classmethod
    def from_farray(cls, farray: FArray) -> MeasuredArray1D:
        ret = _CMeasuredArray1D.from_farray(farray._c if farray is not None else None)
        return MeasuredArray1D._from_capi(ret)

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

    def plus_measured_array(self, other: MeasuredArray1D) -> MeasuredArray1D:
        ret = self._c.plus_measured_array(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def plus_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.plus_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def plus_double(self, other: Any) -> MeasuredArray1D:
        ret = self._c.plus_double(other)
        return MeasuredArray1D._from_capi(ret)

    def plus_int(self, other: Any) -> MeasuredArray1D:
        ret = self._c.plus_int(other)
        return MeasuredArray1D._from_capi(ret)

    def minus_equals_farray(self, other: FArray) -> None:
        ret = self._c.minus_equals_farray(other._c if other is not None else None)
        return ret

    def minus_equals_double(self, other: Any) -> None:
        ret = self._c.minus_equals_double(other)
        return ret

    def minus_equals_int(self, other: Any) -> None:
        ret = self._c.minus_equals_int(other)
        return ret

    def minus_measured_array(self, other: MeasuredArray1D) -> MeasuredArray1D:
        ret = self._c.minus_measured_array(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def minus_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.minus_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def minus_double(self, other: Any) -> MeasuredArray1D:
        ret = self._c.minus_double(other)
        return MeasuredArray1D._from_capi(ret)

    def minus_int(self, other: Any) -> MeasuredArray1D:
        ret = self._c.minus_int(other)
        return MeasuredArray1D._from_capi(ret)

    def negation(self, ) -> MeasuredArray1D:
        ret = self._c.negation()
        return MeasuredArray1D._from_capi(ret)

    def times_equals_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.times_equals_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def times_equals_double(self, other: Any) -> None:
        ret = self._c.times_equals_double(other)
        return ret

    def times_equals_int(self, other: Any) -> None:
        ret = self._c.times_equals_int(other)
        return ret

    def times_measured_array(self, other: MeasuredArray1D) -> MeasuredArray1D:
        ret = self._c.times_measured_array(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def times_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.times_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def times_double(self, other: Any) -> MeasuredArray1D:
        ret = self._c.times_double(other)
        return MeasuredArray1D._from_capi(ret)

    def times_int(self, other: Any) -> MeasuredArray1D:
        ret = self._c.times_int(other)
        return MeasuredArray1D._from_capi(ret)

    def divides_equals_measured_array(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.divides_equals_measured_array(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def divides_equals_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.divides_equals_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def divides_equals_double(self, other: Any) -> None:
        ret = self._c.divides_equals_double(other)
        return ret

    def divides_equals_int(self, other: Any) -> None:
        ret = self._c.divides_equals_int(other)
        return ret

    def divides_measured_array(self, other: MeasuredArray1D) -> MeasuredArray1D:
        ret = self._c.divides_measured_array(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def divides_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.divides_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def divides_double(self, other: Any) -> MeasuredArray1D:
        ret = self._c.divides_double(other)
        return MeasuredArray1D._from_capi(ret)

    def divides_int(self, other: Any) -> MeasuredArray1D:
        ret = self._c.divides_int(other)
        return MeasuredArray1D._from_capi(ret)

    def pow(self, other: Any) -> MeasuredArray1D:
        ret = self._c.pow(other)
        return MeasuredArray1D._from_capi(ret)

    def abs(self, ) -> MeasuredArray1D:
        ret = self._c.abs()
        return MeasuredArray1D._from_capi(ret)

    def min(self, ) -> None:
        ret = self._c.min()
        return ret

    def min_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.min_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def min_measured_array(self, other: MeasuredArray1D) -> MeasuredArray1D:
        ret = self._c.min_measured_array(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def max(self, ) -> None:
        ret = self._c.max()
        return ret

    def max_farray(self, other: FArray) -> MeasuredArray1D:
        ret = self._c.max_farray(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

    def max_measured_array(self, other: MeasuredArray1D) -> MeasuredArray1D:
        ret = self._c.max_measured_array(other._c if other is not None else None)
        return MeasuredArray1D._from_capi(ret)

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

    def reshape(self, shape: Any, ndims: Any) -> MeasuredArray1D:
        ret = self._c.reshape(shape, ndims)
        return MeasuredArray1D._from_capi(ret)

    def where(self, value: Any) -> List:
        ret = self._c.where(value)
        if ret is None: return None
        return List(ret)

    def flip(self, axis: Any) -> MeasuredArray1D:
        ret = self._c.flip(axis)
        return MeasuredArray1D._from_capi(ret)

    def full_gradient(self, out_buffer: MeasuredArray1D, buffer_size: Any) -> None:
        ret = self._c.full_gradient(out_buffer._c if out_buffer is not None else None, buffer_size)
        return ret

    def gradient(self, axis: Any) -> MeasuredArray1D:
        ret = self._c.gradient(axis)
        return MeasuredArray1D._from_capi(ret)

    def get_sum_of_squares(self, ) -> None:
        ret = self._c.get_sum_of_squares()
        return ret

    def get_summed_diff_int_of_squares(self, other: Any) -> None:
        ret = self._c.get_summed_diff_int_of_squares(other)
        return ret

    def get_summed_diff_double_of_squares(self, other: Any) -> None:
        ret = self._c.get_summed_diff_double_of_squares(other)
        return ret

    def get_summed_diff_array_of_squares(self, other: MeasuredArray1D) -> None:
        ret = self._c.get_summed_diff_array_of_squares(other._c if other is not None else None)
        return ret

    def __len__(self):
        return self.size()

    def __add__(self, other):
        """Operator overload for +"""
        if isinstance(other, MeasuredArray1D):
            return self.plus_measured_array(other)
        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:
            return self.plus_farray(other)
        if isinstance(other, float):
            return self.plus_double(other)
        if isinstance(other, int):
            return self.plus_int(other)
        return NotImplemented

    def __sub__(self, other):
        """Operator overload for -"""
        if isinstance(other, MeasuredArray1D):
            return self.minus_measured_array(other)
        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:
            return self.minus_farray(other)
        if isinstance(other, float):
            return self.minus_double(other)
        if isinstance(other, int):
            return self.minus_int(other)
        return NotImplemented

    def __mul__(self, other):
        """Operator overload for *"""
        if isinstance(other, MeasuredArray1D):
            return self.times_measured_array(other)
        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:
            return self.times_farray(other)
        if isinstance(other, float):
            return self.times_double(other)
        if isinstance(other, int):
            return self.times_int(other)
        return NotImplemented

    def __truediv__(self, other):
        """Operator overload for /"""
        if isinstance(other, MeasuredArray1D):
            return self.divides_measured_array(other)
        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:
            return self.divides_farray(other)
        if isinstance(other, float):
            return self.divides_double(other)
        if isinstance(other, int):
            return self.divides_int(other)
        return NotImplemented

    def __neg__(self):
        """Operator overload for unary -"""
        return self.negation()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, MeasuredArray1D):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, MeasuredArray1D):
            return NotImplemented
        return self.not_equal(other)
