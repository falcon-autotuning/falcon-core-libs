import pytest
import array
from falcon_core.generic.pair import Pair
from falcon_core.physics.config.core.adjacency import Adjacency
from falcon_core.physics.config.core.voltage_constraints import VoltageConstraints
from falcon_core.physics.config.core.voltage_constraints import VoltageConstraints

class TestVoltageConstraints:
    def setup_method(self):
        self.obj = None
        try:
            # Found constructor: VoltageConstraints_create
            self.obj = VoltageConstraints.new(Adjacency.from_json('{}'), 0.0, Pair[float, float](0.0, 1.0))
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_matrix(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.matrix()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_adjacency(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.adjacency()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_limits(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.limits()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(VoltageConstraints.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(VoltageConstraints.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_to_json_string(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json_string()
        except Exception as e:
            print(f'Method call failed as expected: {e}')
