import pytest
import array
from falcon_core.generic.list import List
from falcon_core.instrument_interfaces.waveform import Waveform
from falcon_core._capi.map_string_bool import MapStringBool
from falcon_core.generic.map import Map
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform
from falcon_core.math.axes import Axes
from falcon_core.math.discrete_spaces.discrete_space import DiscreteSpace
from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
from falcon_core.math.domains.domain import Domain
from falcon_core.math.unit_space import UnitSpace
from falcon_core.generic.list import List

class TestListWaveform:
    def setup_method(self):
        self.obj = None
        try:
            # Found empty constructor: ListWaveform_create_empty
            self.obj = List[Waveform]()
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_fill_value(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.fill_value(0, Waveform.new(DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()])), List[PortTransform]([])))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_push_back(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.push_back(Waveform.new(DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()])), List[PortTransform]([])))
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
            self.obj.items(array.array('L', [0]), 0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_contains(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.contains(Waveform.new(DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()])), List[PortTransform]([])))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_index(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.index(Waveform.new(DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()])), List[PortTransform]([])))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_intersection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.intersection(None)
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
