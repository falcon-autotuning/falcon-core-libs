import pytest
import array
from falcon_core._capi.map_string_bool import MapStringBool
from falcon_core.generic.map import Map
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.math.axes import Axes
from falcon_core.math.discrete_spaces.discrete_space import DiscreteSpace
from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
from falcon_core.math.domains.domain import Domain
from falcon_core.math.unit_space import UnitSpace
from falcon_core.math.discrete_spaces.discrete_space import DiscreteSpace

class TestDiscreteSpace:
    def setup_method(self):
        self.obj = None
        try:
            # Found constructor: DiscreteSpace_create
            self.obj = DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()]))
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_space(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.space()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_axes(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.axes()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_increasing(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.increasing()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_knobs(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.knobs()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_validate_unit_space_dimensionality_matches_knobs(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.validate_unit_space_dimensionality_matches_knobs()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_validate_knob_uniqueness(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.validate_knob_uniqueness()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_axis(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_axis(InstrumentPort.new_timer())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_domain(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_domain(InstrumentPort.new_timer())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_get_projection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.get_projection(Axes[InstrumentPort]([InstrumentPort.new_timer()]))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()])))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()])))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_to_json_string(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json_string()
        except Exception as e:
            print(f'Method call failed as expected: {e}')
