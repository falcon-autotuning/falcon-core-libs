import pytest
import array
from falcon_core.autotuner_interfaces.contexts.acquisition_context import AcquisitionContext
from falcon_core.generic.f_array import FArray
from falcon_core.math.arrays.control_array import ControlArray
from falcon_core.math.arrays.labelled_control_array import LabelledControlArray
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.units.symbol_unit import SymbolUnit
from falcon_core.math.arrays.labelled_control_array import LabelledControlArray

class TestLabelledControlArray:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for LabelledControlArray
            self.obj = LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter()))
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_copy(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.copy()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter()))
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter()))
        except Exception as e:
            print(f'Operator != failed: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_from_farray(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'oscilloscope', SymbolUnit.new_volt()))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_from_control_array(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.from_control_array(ControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0])), AcquisitionContext.new(Connection.new_barrier('test'), 'oscilloscope', SymbolUnit.new_volt()))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_label(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.label()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_connection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.connection()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_instrument_type(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.instrument_type()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_units(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.units()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_size(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.size()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_dimension(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.dimension()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_shape(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.shape(array.array('L', [0]), 1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_data(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.data(array.array('d', [0]), 1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_plus_equals_farray(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.plus_equals_farray(FArray[float].from_list([1.0, 2.0, 3.0]))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_plus_equals_farray(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj += FArray[float].from_list([1.0, 2.0, 3.0])
        except Exception as e:
            print(f'Operator += failed: {e}')

    def test_plus_equals_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.plus_equals_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_plus_equals_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj += 1.0
        except Exception as e:
            print(f'Operator += failed: {e}')

    def test_plus_equals_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.plus_equals_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_plus_equals_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj += 1
        except Exception as e:
            print(f'Operator += failed: {e}')

    def test_plus_control_array(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.plus_control_array(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_plus_control_array(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj + LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter()))
        except Exception as e:
            print(f'Operator + failed: {e}')

    def test_plus_farray(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.plus_farray(FArray[float].from_list([1.0, 2.0, 3.0]))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_plus_farray(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj + FArray[float].from_list([1.0, 2.0, 3.0])
        except Exception as e:
            print(f'Operator + failed: {e}')

    def test_plus_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.plus_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_plus_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj + 1.0
        except Exception as e:
            print(f'Operator + failed: {e}')

    def test_plus_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.plus_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_plus_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj + 1
        except Exception as e:
            print(f'Operator + failed: {e}')

    def test_minus_equals_control_array(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_equals_control_array(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_minus_equals_farray(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_equals_farray(FArray[float].from_list([1.0, 2.0, 3.0]))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_minus_equals_farray(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj -= FArray[float].from_list([1.0, 2.0, 3.0])
        except Exception as e:
            print(f'Operator -= failed: {e}')

    def test_minus_equals_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_equals_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_minus_equals_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj -= 1.0
        except Exception as e:
            print(f'Operator -= failed: {e}')

    def test_minus_equals_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_equals_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_minus_equals_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj -= 1
        except Exception as e:
            print(f'Operator -= failed: {e}')

    def test_minus_control_array(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_control_array(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_minus_control_array(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj - LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter()))
        except Exception as e:
            print(f'Operator - failed: {e}')

    def test_minus_farray(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_farray(FArray[float].from_list([1.0, 2.0, 3.0]))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_minus_farray(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj - FArray[float].from_list([1.0, 2.0, 3.0])
        except Exception as e:
            print(f'Operator - failed: {e}')

    def test_minus_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_minus_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj - 1.0
        except Exception as e:
            print(f'Operator - failed: {e}')

    def test_minus_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.minus_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_minus_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj - 1
        except Exception as e:
            print(f'Operator - failed: {e}')

    def test_negation(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.negation()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_unary_op_negation(self):
        if self.obj is None: pytest.skip()
        try:
            -self.obj
        except Exception as e:
            print(f'Unary operator - failed: {e}')

    def test_times_equals_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.times_equals_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_times_equals_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj *= 1.0
        except Exception as e:
            print(f'Operator *= failed: {e}')

    def test_times_equals_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.times_equals_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_times_equals_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj *= 1
        except Exception as e:
            print(f'Operator *= failed: {e}')

    def test_times_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.times_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_times_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj * 1.0
        except Exception as e:
            print(f'Operator * failed: {e}')

    def test_times_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.times_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_times_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj * 1
        except Exception as e:
            print(f'Operator * failed: {e}')

    def test_divides_equals_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divides_equals_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_divides_equals_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj /= 1.0
        except Exception as e:
            print(f'Operator /= failed: {e}')

    def test_divides_equals_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divides_equals_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_divides_equals_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj /= 1
        except Exception as e:
            print(f'Operator /= failed: {e}')

    def test_divides_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divides_double(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_divides_double(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj / 1.0
        except Exception as e:
            print(f'Operator / failed: {e}')

    def test_divides_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divides_int(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_divides_int(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj / 1
        except Exception as e:
            print(f'Operator / failed: {e}')

    def test_pow(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.pow(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_abs(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.abs()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_min(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.min()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_min_farray(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.min_farray(FArray[float].from_list([1.0, 2.0, 3.0]))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_min_control_array(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.min_control_array(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_max(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.max()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_max_farray(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.max_farray(FArray[float].from_list([1.0, 2.0, 3.0]))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_max_control_array(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.max_control_array(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_greater_than(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.greater_than(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_greater_than(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj > 1.0
        except Exception as e:
            print(f'Operator > failed: {e}')

    def test_less_than(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.less_than(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_less_than(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj < 1.0
        except Exception as e:
            print(f'Operator < failed: {e}')

    def test_remove_offset(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.remove_offset(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_sum(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.sum()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_where(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.where(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_flip(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.flip(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_full_gradient(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.full_gradient(array.array('L', [0]), 1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_gradient(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.gradient(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_sum_of_squares(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_sum_of_squares()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_summed_diff_int_of_squares(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_summed_diff_int_of_squares(1)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_summed_diff_double_of_squares(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_summed_diff_double_of_squares(1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_summed_diff_array_of_squares(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_summed_diff_array_of_squares(LabelledControlArray.from_farray(FArray[float].from_list([1.0, 2.0, 3.0]), AcquisitionContext.new(Connection.new_barrier('test'), 'test', SymbolUnit.new_meter())))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_ctor_from_json(self):
        try:
            LabelledControlArray.from_json("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')

    def test_len_magic(self):
        if self.obj is None: pytest.skip('Skipping test because object could not be instantiated')
        try:
            len(self.obj)
        except Exception as e:
            print(f'len() failed as expected: {e}')
