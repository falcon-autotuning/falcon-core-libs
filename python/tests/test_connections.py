import pytest
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.generic import List


def build_sample_connections():
    p1 = Connection.new_plunger("P1")
    b1 = Connection.new_barrier("B1")
    r1 = Connection.new_reservoir("R1")
    return p1, b1, r1


def test_list_like_behavior_and_items():
    p1, b1, r1 = build_sample_connections()

    c = Connections.from_list([p1, b1])
    assert len(c) == 2
    assert c[0] == p1
    assert c[1].name() == "B1"

    # append and iteration
    c.append(r1)
    assert len(c) == 3
    names = [x.name() for x in c]
    assert names == ["P1", "B1", "R1"]

    # items() returns a GenericList of Connection wrappers
    items = c.items()
    assert list(items)[0].name() == "P1"
    assert isinstance(items, List)


def test_mutation_and_clear():
    p1, b1, r1 = build_sample_connections()
    c = Connections.from_list([p1, b1, r1])

    # erase_at
    c.erase_at(1)
    assert len(c) == 2
    assert c[0].name() == "P1"
    assert c[1].name() == "R1"

    c.clear()
    assert len(c) == 0


def test_contains_index_and_intersection_and_equality():
    p1, b1, r1 = build_sample_connections()
    c1 = Connections.from_list([p1, b1])
    c2 = Connections.from_list([b1, r1])

    assert b1 in c1
    assert not (r1 in c1)
    assert c1.index(b1) == 1

    inter = c1.intersection(c2)
    assert len(inter) == 1
    assert inter[0] == b1

    # equality
    cop = Connections.from_list([p1, b1])
    assert c1 == cop
    assert not (c1 != cop)


def test_serialization_roundtrip_and_invalid_json():
    p1, b1, r1 = build_sample_connections()
    c = Connections.from_list([p1, b1, r1])
    js = c.to_json()
    assert isinstance(js, str) and js != ""

    rec = Connections.from_json(js)
    assert rec == c

    with pytest.raises(MemoryError):
        Connections.from_json("this is not valid connections json")


def test_misc_methods_and_type_errors():
    p1, b1, r1 = build_sample_connections()
    c = Connections.from_list([p1, b1, r1])

    # new_empty and length via GenericList wrapper
    empty = Connections.new_empty()
    assert len(empty) == 0

    # is_* convenience accessors — we don't assert exact semantics here,
    # just ensure they return booleans and are callable.
    assert isinstance(c.is_gates(), bool)
    assert isinstance(c.is_ohmics(), bool)
    assert isinstance(c.is_dot_gates(), bool)
    assert isinstance(c.is_plunger_gates(), bool)
    assert isinstance(c.is_barrier_gates(), bool)
    assert isinstance(c.is_reservoir_gates(), bool)
    assert isinstance(c.is_screening_gates(), bool)

    # Equality with unrelated types should raise per wrapper design
    # Equality with unrelated types should return False (NotImplemented -> False)
    assert not (c == 123)
    assert c != "foo"
