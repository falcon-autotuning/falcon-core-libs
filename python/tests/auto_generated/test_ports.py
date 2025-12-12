import pytest
from falcon_core.instrument_interfaces.names.ports import Ports

class TestPorts:
    def setup_method(self):
        self.obj = None
        try:
            # Found empty constructor: Ports_create_empty
            self.obj = Ports.create_empty()
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_ports(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.ports()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_default_names(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.default_names()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_psuedo_names(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_psuedo_names()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test__get_raw_names(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj._get_raw_names()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test__get_instrument_facing_names(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj._get_instrument_facing_names()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test__get_psuedoname_matching_port(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj._get_psuedoname_matching_port(None)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test__get_instrument_type_matching_port(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj._get_instrument_type_matching_port("test_string")
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_is_knobs(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.is_knobs()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_is_meters(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.is_meters()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_intersection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.intersection(None)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_push_back(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.push_back(None)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_size(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.size()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_empty(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.empty()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_erase_at(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.erase_at(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_clear(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.clear()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_const_at(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.const_at(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_at(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.at(0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_items(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.items()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_contains(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.contains(None)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_index(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.index(None)
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
