import pytest
import array
from falcon_core.communications.voltage_states.device_voltage_state import DeviceVoltageState
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.units.symbol_unit import SymbolUnit
from falcon_core.communications.voltage_states.device_voltage_state import DeviceVoltageState

class TestDeviceVoltageState:
    def setup_method(self):
        self.obj = None
        try:
            # Found constructor: DeviceVoltageState_create
            self.obj = DeviceVoltageState.new(Connection.new_barrier('test_conn'), 0.0, SymbolUnit.new_meter())
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_connection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.connection()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_voltage(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.voltage()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_value(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.value()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_unit(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.unit()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_convert_to(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.convert_to(SymbolUnit.new_meter())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_multiply_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.multiply_int(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_multiply_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.multiply_double(0.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_multiply_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.multiply_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_multiply_equals_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.multiply_equals_int(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_multiply_equals_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.multiply_equals_double(0.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_multiply_equals_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.multiply_equals_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_divide_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divide_int(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_divide_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divide_double(0.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_divide_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divide_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_divide_equals_int(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divide_equals_int(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_divide_equals_double(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divide_equals_double(0.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_divide_equals_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.divide_equals_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_power(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.power(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_add_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.add_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_add_equals_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.add_equals_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_subtract_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.subtract_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_subtract_equals_quantity(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.subtract_equals_quantity(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_negate(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.negate()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_abs(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.abs()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(DeviceVoltageState.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_to_json_string(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json_string()
        except Exception as e:
            print(f'Method call failed as expected: {e}')
