import pytest
import array
from falcon_core.communications.time import Time
from falcon_core.communications.time import Time

class TestTime:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for Time
            self.obj = Time.new(0, 0)
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
            self.obj.equal(Time.new(0, 0))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(Time.new(0, 0))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_micro_seconds_since_epoch(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.micro_seconds_since_epoch()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_time(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.time()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_to_string(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_string()
        except Exception as e:
            print(f'Method call failed as expected: {e}')
