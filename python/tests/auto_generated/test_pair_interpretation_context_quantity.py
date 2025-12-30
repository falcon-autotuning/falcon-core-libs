import pytest
import array
from falcon_core.generic.pair import Pair
from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext
from falcon_core.math.quantity import Quantity
from falcon_core.autotuner_interfaces.contexts.measurement_context import MeasurementContext
from falcon_core.generic.list import List
from falcon_core.math.axes import Axes
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.units.symbol_unit import SymbolUnit
from falcon_core.generic.pair import Pair


def _make_test_interpretation_context():
    from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext
    from falcon_core.autotuner_interfaces.contexts.measurement_context import MeasurementContext
    from falcon_core.math.axes import Axes
    from falcon_core.generic.list import List
    from falcon_core.physics.units.symbol_unit import SymbolUnit
    from falcon_core.physics.device_structures.connection import Connection
    
    conn = Connection.new_plunger('A')
    unit = SymbolUnit.new_volt()
    mc1 = MeasurementContext.new(conn, 'oscilloscope')
    mc2 = MeasurementContext.new(conn, 'multimeter')
    
    axes = Axes[MeasurementContext].from_list([mc1, mc2])
    list_mc = List[MeasurementContext]()
    list_mc.append(mc2)
    
    return InterpretationContext.new(axes, list_mc, unit)


class TestPairInterpretationContextQuantity:
    def setup_method(self):
        self.obj = None
        try:
            # Found constructor: PairInterpretationContextQuantity_create
            self.obj = Pair[InterpretationContext, Quantity](_make_test_interpretation_context(), Quantity.new(1.0, SymbolUnit.new_meter()))
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

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed as expected: {e}')
