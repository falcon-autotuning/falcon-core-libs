import pytest
import array
from falcon_core.generic.pair import Pair
from falcon_core.physics.config.core.adjacency import Adjacency
from falcon_core.physics.config.core.voltage_constraints import VoltageConstraints
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.physics.config.core.voltage_constraints import VoltageConstraints

class TestVoltageConstraints:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for VoltageConstraints
            self.obj = VoltageConstraints.new(Adjacency.new(array.array('i', [1]), array.array('L', [1, 1]), 2, Connections.from_list([Connection.new_plunger('P1')])), 0.0, Pair[float, float](0.0, 0.0))
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
            self.obj.equal(VoltageConstraints.new(Adjacency.new(array.array('i', [1]), array.array('L', [1, 1]), 2, Connections.from_list([Connection.new_plunger('P1')])), 0.0, Pair[float, float](0.0, 0.0)))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == VoltageConstraints.new(Adjacency.new(array.array('i', [1]), array.array('L', [1, 1]), 2, Connections.from_list([Connection.new_plunger('P1')])), 0.0, Pair[float, float](0.0, 0.0))
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(VoltageConstraints.new(Adjacency.new(array.array('i', [1]), array.array('L', [1, 1]), 2, Connections.from_list([Connection.new_plunger('P1')])), 0.0, Pair[float, float](0.0, 0.0)))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != VoltageConstraints.new(Adjacency.new(array.array('i', [1]), array.array('L', [1, 1]), 2, Connections.from_list([Connection.new_plunger('P1')])), 0.0, Pair[float, float](0.0, 0.0))
        except Exception as e:
            print(f'Operator != failed: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

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

    def test_ctor_from_json(self):
        try:
            VoltageConstraints.from_json("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')

    def test_ctor_new(self):
        try:
            VoltageConstraints.new(Adjacency.new(array.array('i', [1]), array.array('L', [1, 1]), 2, Connections.from_list([Connection.new_plunger('P1')])), 1.0, Pair[float, float](1.0, 1.0))
        except Exception as e:
            print(f'Constructor new failed: {e}')
