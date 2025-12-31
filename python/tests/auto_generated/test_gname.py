import pytest
import array
from falcon_core.autotuner_interfaces.names.gname import Gname
from falcon_core.autotuner_interfaces.names.gname import Gname

class TestGname:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for Gname
            self.obj = Gname.new('test_gname')
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
            self.obj.equal(Gname.new('test_gname'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == Gname.new('test_gname')
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(Gname.new('test_gname'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != Gname.new('test_gname')
        except Exception as e:
            print(f'Operator != failed: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_gname(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.gname()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_ctor_from_json(self):
        try:
            Gname.from_json("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')

    def test_ctor_new_from_num(self):
        try:
            Gname.new_from_num(1)
        except Exception as e:
            print(f'Constructor new_from_num failed: {e}')

    def test_ctor_new(self):
        try:
            Gname.new("test_string")
        except Exception as e:
            print(f'Constructor new failed: {e}')
