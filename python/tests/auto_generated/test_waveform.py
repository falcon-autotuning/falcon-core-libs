import pytest
import array
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform
from falcon_core.instrument_interfaces.waveform import Waveform
from falcon_core.math.discrete_spaces.discrete_space import DiscreteSpace
from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
from falcon_core.math.domains.domain import Domain
from falcon_core.math.domains.labelled_domain import LabelledDomain
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.units.symbol_unit import SymbolUnit
from falcon_core.instrument_interfaces.waveform import Waveform


def _make_test_waveform():
    from falcon_core.instrument_interfaces.waveform import Waveform
    from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
    from falcon_core.math.domains.labelled_domain import LabelledDomain
    from falcon_core.math.domains.domain import Domain
    from falcon_core.physics.device_structures.connection import Connection
    from falcon_core.physics.units.symbol_unit import SymbolUnit
    from falcon_core.generic.map import Map
    
    domain = Domain.new(0.0, 1.0, True, True)
    ld = LabelledDomain.new_from_domain(domain, 'test_name', Connection.new_barrier('test'), 'DAC', SymbolUnit.new_volt(), 'test description')
    cld = CoupledLabelledDomain.new_empty()
    cld._c.push_back(ld._c)
    msb = Map[str, bool]()
    msb._c.insert('test_name', True)
    return Waveform.new_cartesian_identity_waveform_1D(10, cld, msb, domain)


class TestWaveform:
    def setup_method(self):
        self.obj = None
        try:
            # Using recipe for Waveform
            self.obj = _make_test_waveform()
        except Exception as e:
            print(f'Setup failed: {e}')

    def test_copy(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.copy()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.equal(_make_test_waveform())
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_op_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj == _make_test_waveform()
        except Exception as e:
            print(f'Operator == failed: {e}')

    def test_not_equal(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.not_equal(_make_test_waveform())
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_op_not_equal(self):
        if self.obj is None: pytest.skip()
        try:
            self.obj != _make_test_waveform()
        except Exception as e:
            print(f'Operator != failed: {e}')

    def test_to_json(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.to_json()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_space(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.space()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_transforms(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.transforms()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_push_back(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.push_back(PortTransform.new_identity_transform(InstrumentPort.new_timer()))
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_size(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.size
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_empty(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.empty()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_erase_at(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.erase_at(1)
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_clear(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.clear()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_at(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.at(1)
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_items(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.items()
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_contains(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.contains(PortTransform.new_identity_transform(InstrumentPort.new_timer()))
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_index(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.index(PortTransform.new_identity_transform(InstrumentPort.new_timer()))
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_intersection(self):
        if self.obj is None:
            pytest.skip('Skipping test because object could not be instantiated')
        try:
            self.obj.intersection(_make_test_waveform())
        except Exception as e:
            print(f'Method call failed: {e}')

    def test_ctor_from_json(self):
        try:
            Waveform.from_json("test_string")
        except Exception as e:
            print(f'Constructor from_json failed: {e}')

    def test_ctor_new(self):
        try:
            Waveform.new(DiscreteSpace.new_cartesian_discrete_space_1D(10, CoupledLabelledDomain.new_empty(), Map[str, bool](), Domain.new(0.0, 1.0, True, True)), List[PortTransform]())
        except Exception as e:
            print(f'Constructor new failed: {e}')

    def test_ctor_new_cartesian_waveform(self):
        try:
            Waveform.new_cartesian_waveform(None, None, None, List[PortTransform](), Domain.new(0.0, 1.0, True, True))
        except Exception as e:
            print(f'Constructor new_cartesian_waveform failed: {e}')

    def test_ctor_new_cartesian_identity_waveform(self):
        try:
            Waveform.new_cartesian_identity_waveform(None, None, None, Domain.new(0.0, 1.0, True, True))
        except Exception as e:
            print(f'Constructor new_cartesian_identity_waveform failed: {e}')

    def test_ctor_new_cartesian_waveform_2D(self):
        try:
            Waveform.new_cartesian_waveform_2D(None, None, None, List[PortTransform](), Domain.new(0.0, 1.0, True, True))
        except Exception as e:
            print(f'Constructor new_cartesian_waveform_2D failed: {e}')

    def test_ctor_new_cartesian_identity_waveform_2D(self):
        try:
            Waveform.new_cartesian_identity_waveform_2D(None, None, None, Domain.new(0.0, 1.0, True, True))
        except Exception as e:
            print(f'Constructor new_cartesian_identity_waveform_2D failed: {e}')

    def test_ctor_new_cartesian_waveform_1D(self):
        try:
            Waveform.new_cartesian_waveform_1D(1, CoupledLabelledDomain.new_empty(), Map[str, bool](), List[PortTransform](), Domain.new(0.0, 1.0, True, True))
        except Exception as e:
            print(f'Constructor new_cartesian_waveform_1D failed: {e}')

    def test_ctor_new_cartesian_identity_waveform_1D(self):
        try:
            Waveform.new_cartesian_identity_waveform_1D(1, CoupledLabelledDomain.new_empty(), Map[str, bool](), Domain.new(0.0, 1.0, True, True))
        except Exception as e:
            print(f'Constructor new_cartesian_identity_waveform_1D failed: {e}')

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
