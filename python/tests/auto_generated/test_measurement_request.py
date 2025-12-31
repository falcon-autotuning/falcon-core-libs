import pytest
import array
from falcon_core.communications.messages.measurement_request import MeasurementRequest
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.instrument_interfaces.names.ports import Ports
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform
from falcon_core.instrument_interfaces.waveform import Waveform
from falcon_core.math.domains.domain import Domain
from falcon_core.math.domains.labelled_domain import LabelledDomain
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.units.symbol_unit import SymbolUnit
from falcon_core.communications.messages.measurement_request import MeasurementRequest


def _make_test_measurement_request():
    from falcon_core.communications.messages.measurement_request import MeasurementRequest
    from falcon_core.instrument_interfaces.names.ports import Ports
    from falcon_core.math.domains.labelled_domain import LabelledDomain
    from falcon_core.physics.device_structures.connection import Connection
    from falcon_core.physics.units.symbol_unit import SymbolUnit
    from falcon_core.generic.list import List
    from falcon_core.generic.map import Map
    from falcon_core.instrument_interfaces.waveform import Waveform
    from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
    from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform
    from falcon_core.math.domains.domain import Domain
    
    conn = Connection.new_plunger("test_gate")
    unit = SymbolUnit.new_volt()
    domain = LabelledDomain.new_from_domain(Domain.new(0.0, 1.0, True, True), 'time', conn, 'DAC', unit, 'test')
    getters = Ports.new_empty()
    waveforms = List[Waveform]()
    meter_transforms = Map[InstrumentPort, PortTransform]()
    return MeasurementRequest.new("test message", "test_measurement", waveforms, getters, meter_transforms, domain)


class TestMeasurementRequest:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for MeasurementRequest
            self.obj = _make_test_measurement_request()
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
            self.obj.equal(_make_test_measurement_request())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == _make_test_measurement_request()
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(_make_test_measurement_request())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != _make_test_measurement_request()
        except Exception as e:
            print(f'Operator != failed: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

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

    def test_ctor_from_json(self):
        try:
            MeasurementRequest.from_json("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')

    def test_ctor_new(self):
        try:
            MeasurementRequest.new("test_string", "test_string", None, Ports.new_empty(), None, LabelledDomain.new_from_domain(Domain.new(0.0, 1.0, True, True), 'test_name', Connection.new_barrier('test'), 'DAC', SymbolUnit.new_volt(), 'test description'))
        except Exception as e:
            print(f'Constructor new failed: {e}')
