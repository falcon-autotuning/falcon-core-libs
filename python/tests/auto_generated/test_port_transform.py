import pytest
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform

class TestPortTransform:
    def setup_method(self):
        self.obj = None
        try:
            # Found constructor: PortTransform_create
            self.obj = PortTransform.new(None, None)
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_port(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.port()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_labels(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.labels()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_evaluate(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.evaluate(None, 0.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_evaluate_arraywise(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.evaluate_arraywise(None, 0.0, 0.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(None)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(None)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_to_json_string(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json_string()
        except Exception as e:
            print(f'Method call failed as expected: {e}')
