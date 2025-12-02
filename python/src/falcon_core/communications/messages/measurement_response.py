from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.measurement_response import MeasurementResponse as _CMeasurementResponse
from falcon_core.math.arrays.labelled_arrays import LabelledArrays

class MeasurementResponse:
    """Python wrapper for MeasurementResponse."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def MeasurementResponse_create(cls, arrays: LabelledArrays) -> MeasurementResponse:
        return cls(_CMeasurementResponse.MeasurementResponse_create(arrays._c))

    @classmethod
    def MeasurementResponse_from_json_string(cls, json: str) -> MeasurementResponse:
        return cls(_CMeasurementResponse.MeasurementResponse_from_json_string(json))

    def arrays(self, ) -> LabelledArrays:
        ret = self._c.arrays()
        if ret is None: return None
        return LabelledArrays(ret)

    def message(self, ) -> str:
        ret = self._c.message()
        return ret

    def equal(self, other: MeasurementResponse) -> None:
        ret = self._c.equal(other._c)
        return ret

    def not_equal(self, other: MeasurementResponse) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, MeasurementResponse):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, MeasurementResponse):
            return NotImplemented
        return self.notequality(other)
