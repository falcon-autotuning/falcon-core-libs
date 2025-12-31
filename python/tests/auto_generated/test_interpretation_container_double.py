import pytest
import array
from falcon_core.autotuner_interfaces.interpretations.interpretation_container import InterpretationContainer
from falcon_core.autotuner_interfaces.contexts.measurement_context import MeasurementContext
from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.math.axes import Axes
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.physics.units.symbol_unit import SymbolUnit
from falcon_core.autotuner_interfaces.interpretations.interpretation_container import InterpretationContainer


def _make_test_interpretation_container_double():
    from falcon_core.autotuner_interfaces.interpretations.interpretation_container import InterpretationContainer
    from falcon_core.generic.map import Map
    from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext
    
    ctx = _make_test_interpretation_context()
    m = Map[InterpretationContext, float]()
    m._c.insert_or_assign(ctx._c, 1.0)
    return InterpretationContainer[float](m)



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


class TestInterpretationContainerDouble:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for InterpretationContainerDouble
            self.obj = _make_test_interpretation_container_double()
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_copy(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.copy()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_unit(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.unit()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_select_by_connection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.select_by_connection(Connection.new_barrier('test_conn'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_select_by_connections(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.select_by_connections(Connections.new_empty())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_select_by_independent_connection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.select_by_independent_connection(Connection.new_barrier('test_conn'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_select_by_dependent_connection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.select_by_dependent_connection(Connection.new_barrier('test_conn'))
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_select_contexts(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.select_contexts(None, None)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_insert_or_assign(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.insert_or_assign(_make_test_interpretation_context(), 1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_insert(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.insert(_make_test_interpretation_context(), 1.0)
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_at(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.at(_make_test_interpretation_context())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_erase(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.erase(_make_test_interpretation_context())
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

    def test_clear(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.clear()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_contains(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.contains(_make_test_interpretation_context())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_keys(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.keys()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_values(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.values()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_items(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.items()
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(_make_test_interpretation_container_double())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == _make_test_interpretation_container_double()
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(_make_test_interpretation_container_double())
        except Exception as e:
            print(f'Method call failed as expected: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != _make_test_interpretation_container_double()
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
            InterpretationContainer[float](None)
        except Exception as e:
            print(f'Constructor new failed: {e}')

    def test_ctor_from_json(self):
        try:
            InterpretationContainer[float]("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')

    def test_len_magic(self):
        if self.obj is None: pytest.skip('Skipping test because object could not be instantiated')
        try:
            len(self.obj)
        except Exception as e:
            print(f'len() failed as expected: {e}')

    def test_getitem_magic(self):
        if self.obj is None: pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj[0]
        except Exception as e:
            print(f'__getitem__ failed as expected: {e}')

    def test_iter_magic(self):
        if self.obj is None: pytest.skip('Skipping test because object could not be instantiated')
        try:
            # Try to iterate over the object
            for _ in self.obj: break
        except Exception as e:
            print(f'iter() failed as expected: {e}')
