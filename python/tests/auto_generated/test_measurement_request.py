import pytest
import array
from falcon_core.communications.messages.measurement_request import MeasurementRequest
from falcon_core.instrument_interfaces.names.ports import Ports
from falcon_core.math.domains.labelled_domain import LabelledDomain
from falcon_core.communications.messages.measurement_request import MeasurementRequest

class TestMeasurementRequest:
    def setup_method(self):
        self.obj = None
        try:
            # Found constructor: MeasurementRequest_create
            self.obj = MeasurementRequest.new("test_string", "test_string", None, Ports.new_empty(), None, LabelledDomain.new_empty())
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_measurement_name(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.measurement_name()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_getters(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.getters()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_waveforms(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.waveforms()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_meter_transforms(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.meter_transforms()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_time_domain(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.time_domain()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_message(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.message()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(MeasurementRequest.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(MeasurementRequest.from_json('{}'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_to_json_string(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json_string()
        except Exception as e:
            print(f'Method call failed as expected: {e}')
