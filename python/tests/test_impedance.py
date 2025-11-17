import pytest
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.impedance import Impedance


def test_constructors_and_accessors():
    conn = Connection.new_plunger("P1")
    imp = Impedance.new(conn, 1.5, 2.75)

    # Accessors
    assert pytest.approx(imp.resistance(), rel=1e-12) == 1.5
    assert pytest.approx(imp.capacitance(), rel=1e-12) == 2.75

    # connection() should return a Connection wrapper with same semantics
    returned_conn = imp.connection()
    assert returned_conn is not None
    assert isinstance(returned_conn, Connection)
    assert returned_conn.name() == "P1"
    # Should be equal according to Connection equality semantics,
    # but definitely not the same Python object
    assert returned_conn == conn
    assert returned_conn is not conn

    # to_json should give a string
    js = imp.to_json()
    assert isinstance(js, str)
    assert js != ""


def test_equality_and_type_errors():
    c1 = Connection.new_plunger("P1")
    c2 = Connection.new_barrier("B1")

    imp1 = Impedance.new(c1, 1.0, 2.0)
    imp2 = Impedance.new(c1, 1.0, 2.0)
    imp3 = Impedance.new(c2, 1.0, 2.0)
    imp4 = Impedance.new(c1, 3.0, 4.0)

    # Same parameters on same logical connection -> should compare equal
    assert imp1 == imp2
    assert not (imp1 != imp2)

    # Different underlying connection -> not equal
    assert imp1 != imp3

    # Different numeric params -> not equal
    assert imp1 != imp4

    # Comparisons with unrelated types raise TypeError (per Python wrapper)
    with pytest.raises(TypeError):
        _ = (imp1 == 123)
    with pytest.raises(TypeError):
        _ = (imp1 != "foo")


def test_serialization_roundtrip_and_invalid_json():
    conn = Connection.new_reservoir("R1")
    imp = Impedance.new(conn, 0.125, 0.25)

    json_str = imp.to_json()
    assert isinstance(json_str, str)
    assert json_str != ""

    # Roundtrip
    rec = Impedance.from_json(json_str)
    assert isinstance(rec, Impedance)
    # Values should match (use approx for floats)
    assert pytest.approx(rec.resistance(), rel=1e-12) == 0.125
    assert pytest.approx(rec.capacitance(), rel=1e-12) == 0.25
    # Connection roundtrip semantics: should compare equal
    assert rec.connection() == conn
    assert rec == imp

    # Invalid JSON should raise ValueError
    with pytest.raises(ValueError):
        Impedance.from_json("this is not valid impedance json")


def test_new_with_invalid_connection_object():
    # Passing an object without the expected ._c attribute should raise AttributeError
    class Dummy:
        pass

    with pytest.raises(AttributeError):
        Impedance.new(Dummy(), 1.0, 1.0)

    # None also should raise (no ._c)
    with pytest.raises(AttributeError):
        Impedance.new(None, 1.0, 1.0)
