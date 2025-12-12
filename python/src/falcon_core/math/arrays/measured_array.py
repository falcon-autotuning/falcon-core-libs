from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.measured_array import MeasuredArray as _CMeasuredArray
from falcon_core.generic.f_array import FArray
from falcon_core.generic.list import List

class MeasuredArray:
    """Python wrapper for MeasuredArray."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> MeasuredArray:
        return cls(_CMeasuredArray.from_json(json))

    @classmethod
    def from_data(cls, data: Any, shape: Any, ndim: Any) -> MeasuredArray:
        ret = _CMeasuredArray.from_data(data, shape, ndim)
        return cls._from_capi(ret)

    @classmethod
    def from_farray(cls, farray: FArray) -> MeasuredArray:
        ret = _CMeasuredArray.from_farray(farray._c)
        return cls._from_capi(ret)

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

    def plusequals_farray(self, other: FArray) -> None:
        ret = self._c.plusequals_farray(other._c)
        return ret

    def plusequals_double(self, other: Any) -> None:
        ret = self._c.plusequals_double(other)
        return ret

    def plusequals_int(self, other: Any) -> None:
        ret = self._c.plusequals_int(other)
        return ret

    def plus_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.plus_measured_array(other._c)
        return cls._from_capi(ret)

    def plus_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.plus_farray(other._c)
        return cls._from_capi(ret)

    def plus_double(self, other: Any) -> MeasuredArray:
        ret = self._c.plus_double(other)
        return cls._from_capi(ret)

    def plus_int(self, other: Any) -> MeasuredArray:
        ret = self._c.plus_int(other)
        return cls._from_capi(ret)

    def minusequals_farray(self, other: FArray) -> None:
        ret = self._c.minusequals_farray(other._c)
        return ret

    def minusequals_double(self, other: Any) -> None:
        ret = self._c.minusequals_double(other)
        return ret

    def minusequals_int(self, other: Any) -> None:
        ret = self._c.minusequals_int(other)
        return ret

    def minus_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.minus_measured_array(other._c)
        return cls._from_capi(ret)

    def minus_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.minus_farray(other._c)
        return cls._from_capi(ret)

    def minus_double(self, other: Any) -> MeasuredArray:
        ret = self._c.minus_double(other)
        return cls._from_capi(ret)

    def minus_int(self, other: Any) -> MeasuredArray:
        ret = self._c.minus_int(other)
        return cls._from_capi(ret)

    def negation(self, ) -> MeasuredArray:
        ret = self._c.negation()
        return cls._from_capi(ret)

    def timesequals_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.timesequals_measured_array(other._c)
        return cls._from_capi(ret)

    def timesequals_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.timesequals_farray(other._c)
        return cls._from_capi(ret)

    def timesequals_double(self, other: Any) -> None:
        ret = self._c.timesequals_double(other)
        return ret

    def timesequals_int(self, other: Any) -> None:
        ret = self._c.timesequals_int(other)
        return ret

    def times_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.times_measured_array(other._c)
        return cls._from_capi(ret)

    def times_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.times_farray(other._c)
        return cls._from_capi(ret)

    def times_double(self, other: Any) -> MeasuredArray:
        ret = self._c.times_double(other)
        return cls._from_capi(ret)

    def times_int(self, other: Any) -> MeasuredArray:
        ret = self._c.times_int(other)
        return cls._from_capi(ret)

    def dividesequals_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.dividesequals_measured_array(other._c)
        return cls._from_capi(ret)

    def dividesequals_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.dividesequals_farray(other._c)
        return cls._from_capi(ret)

    def dividesequals_double(self, other: Any) -> None:
        ret = self._c.dividesequals_double(other)
        return ret

    def dividesequals_int(self, other: Any) -> None:
        ret = self._c.dividesequals_int(other)
        return ret

    def divides_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.divides_measured_array(other._c)
        return cls._from_capi(ret)

    def divides_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.divides_farray(other._c)
        return cls._from_capi(ret)

    def divides_double(self, other: Any) -> MeasuredArray:
        ret = self._c.divides_double(other)
        return cls._from_capi(ret)

    def divides_int(self, other: Any) -> MeasuredArray:
        ret = self._c.divides_int(other)
        return cls._from_capi(ret)

    def pow(self, other: Any) -> MeasuredArray:
        ret = self._c.pow(other)
        return cls._from_capi(ret)

    def abs(self, ) -> MeasuredArray:
        ret = self._c.abs()
        return cls._from_capi(ret)

    def min_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.min_farray(other._c)
        return cls._from_capi(ret)

    def min_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.min_measured_array(other._c)
        return cls._from_capi(ret)

    def max_farray(self, other: FArray) -> MeasuredArray:
        ret = self._c.max_farray(other._c)
        return cls._from_capi(ret)

    def max_measured_array(self, other: MeasuredArray) -> MeasuredArray:
        ret = self._c.max_measured_array(other._c)
        return cls._from_capi(ret)

    def equality(self, other: MeasuredArray) -> None:
        ret = self._c.equality(other._c)
        return ret

    def notequality(self, other: MeasuredArray) -> None:
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

    def reshape(self, shape: Any, ndims: Any) -> MeasuredArray:
        ret = self._c.reshape(shape, ndims)
        return cls._from_capi(ret)

    def where(self, value: Any) -> List:
        ret = self._c.where(value)
        if ret is None: return None
        return List(ret)

    def flip(self, axis: Any) -> MeasuredArray:
        ret = self._c.flip(axis)
        return cls._from_capi(ret)

    def full_gradient(self, out_buffer: MeasuredArray, buffer_size: Any) -> None:
        ret = self._c.full_gradient(out_buffer._c, buffer_size)
        return ret

    def gradient(self, axis: Any) -> MeasuredArray:
        ret = self._c.gradient(axis)
        return cls._from_capi(ret)

    def get_sum_of_squares(self, ) -> None:
        ret = self._c.get_sum_of_squares()
        return ret

    def get_summed_diff_int_of_squares(self, other: Any) -> None:
        ret = self._c.get_summed_diff_int_of_squares(other)
        return ret

    def get_summed_diff_double_of_squares(self, other: Any) -> None:
        ret = self._c.get_summed_diff_double_of_squares(other)
        return ret

    def get_summed_diff_array_of_squares(self, other: MeasuredArray) -> None:
        ret = self._c.get_summed_diff_array_of_squares(other._c)
        return ret

    def __add__(self, other):
        """Operator overload for +"""
        if isinstance(other, MeasuredArray):
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
        if isinstance(other, MeasuredArray):
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
        if isinstance(other, MeasuredArray):
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
        if isinstance(other, MeasuredArray):
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

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, MeasuredArray):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, MeasuredArray):
            return NotImplemented
        return self.notequality(other)
