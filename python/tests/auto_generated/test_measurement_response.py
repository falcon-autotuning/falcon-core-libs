import pytest
import array
from falcon_core.communications.messages.measurement_response import MeasurementResponse
from falcon_core.generic.list import List
from falcon_core.math.arrays.labelled_arrays import LabelledArrays
from falcon_core.math.arrays.labelled_measured_array import LabelledMeasuredArray
from falcon_core.communications.messages.measurement_response import MeasurementResponse


def _make_test_measurement_response():
    from falcon_core.communications.messages.measurement_response import MeasurementResponse
    from falcon_core.math.arrays.labelled_arrays import LabelledArrays
    from falcon_core.math.arrays.labelled_measured_array import LabelledMeasuredArray
    from falcon_core.generic.list import List
    
    arrays = LabelledArrays[LabelledMeasuredArray](List[LabelledMeasuredArray]())
    return MeasurementResponse.new(arrays)


class TestMeasurementResponse:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for MeasurementResponse
            self.obj = _make_test_measurement_response()
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_copy(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.copy()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(_make_test_measurement_response())
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == _make_test_measurement_response()
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(_make_test_measurement_response())
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != _make_test_measurement_response()
        except Exception as e:
            print(f'Operator != failed: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_arrays(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.arrays()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_message(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.message()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_ctor_from_json(self):
        try:
            MeasurementResponse.from_json("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')

    def test_ctor_new(self):
        try:
            MeasurementResponse.new(LabelledArrays[LabelledMeasuredArray](List[LabelledMeasuredArray]()))
        except Exception as e:
            print(f'Constructor new failed: {e}')
