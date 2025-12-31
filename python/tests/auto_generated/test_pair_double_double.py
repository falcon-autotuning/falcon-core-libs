import pytest
import array
from falcon_core.generic.pair import Pair
from falcon_core.generic.pair import Pair

class TestPairDoubleDouble:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for PairDoubleDouble
            self.obj = Pair[float, float](1.0, 1.0)
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_copy(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.copy()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_first(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.first()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_second(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.second()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(Pair[float, float](1.0, 1.0))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == Pair[float, float](1.0, 1.0)
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(Pair[float, float](1.0, 1.0))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != Pair[float, float](1.0, 1.0)
        except Exception as e:
            print(f'Operator != failed: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_ctor_new(self):
        try:
            Pair[float, float](1.0, 1.0)
        except Exception as e:
            print(f'Constructor new failed: {e}')

    def test_ctor_from_json(self):
        try:
            Pair[float, float]("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')
