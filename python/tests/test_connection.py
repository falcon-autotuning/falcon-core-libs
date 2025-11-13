import pytest

try:
    from falcon_core.physics.device_structures import Connection
except Exception as exc:
    pytest.skip(
        f"falcon_core extension not available or failed to load: {exc}",
        allow_module_level=True,
    )


def test_constructors_and_accessors():
    c = Connection.new_barrier("foo")
    assert c.name() == "foo"
    # type string is provided by the C API; this test assumes "BarrierGate"
    # If the upstream C API differs, adjust the expected value.
    assert c.type() == "BarrierGate"


def test_serialization_roundtrip():
    c = Connection.new_screening("foo")
    j = c.to_json()
    c2 = Connection.from_json(j)
    assert c2.name() == "foo"
    assert c2.is_screening_gate() or c2.type() == "ScreeningGate"
