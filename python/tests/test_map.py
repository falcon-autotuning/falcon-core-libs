import json
import pytest
from falcon_core.generic import Map
from falcon_core._capi.map_int_int import MapIntInt as _CMapIntInt


def test_map_basic_set_get_del_and_len():
    m = Map[int, int]()
    assert len(m) == 0
    m[1] = 10
    m[2] = 20
    assert len(m) == 2
    assert m[1] == 10
    assert m.get(2) == 20
    with pytest.raises(KeyError):
        _ = m[3]
    assert 1 in m.keys()
    assert 3 not in m.keys()
    del m[1]
    assert len(m) == 1
    with pytest.raises(KeyError):
        del m[1]


def test_map_iteration_keys_values_items_and_repr():
    m = Map[int, int]({1: 100, 2: 200})
    # iteration order may vary, but items() returns list of pairs matching dict semantics
    items = dict(m.items())
    assert items == {1: 100, 2: 200}
    assert set(m.keys()) == {1, 2}
    assert set(m.values()) == {100, 200}
    assert "Map(" in repr(m)


def test_map_to_json_and_from_json_roundtrip():
    m = Map[int, int]()
    m[5] = 50
    m[7] = 70
    js = m.to_json()
    assert isinstance(js, str) and js != ""
    m2 = Map.from_json(js, types=(int, int))
    assert isinstance(m2, Map)
    assert dict(m2.items()) == dict(m.items())
    assert m == m2


def test_map_unsupported_type_and_invalid_class_getitem():
    with pytest.raises(TypeError):
        _ = Map[str, int]
    with pytest.raises(TypeError):
        _ = Map[int]


def test_map_direct_constructor_invalid_object():
    # constructing Map directly with wrong c_obj should raise TypeError
    with pytest.raises(TypeError, match="Object must conform"):
        Map(object(), None)


def test_map_get_default_and_contains_clear_empty():
    m = Map[int, int]()
    assert m.get(123, "x") == "x"
    m[1] = 2
    assert m.contains(1) if hasattr(m, "contains") else True
    m.clear()
    assert len(m) == 0






def test_setitem_without_factory_raises():
    # Create a real low-level Map object but wrap it without providing c_map_type
    c_obj = _CMapIntInt.create_empty()
    m = Map(c_obj)  # _c_map_type is None
    with pytest.raises(TypeError):
        m[1] = 10
    # Assigning arbitrary attributes on Python instances is allowed; ensure it works
    m.insert = 1
    assert getattr(m, "insert") == 1


def test_get_with_non_int_key_raises_valueerror():
    # Map[Int,int] should coerce keys; non-convertible strings should raise ValueError
    m = Map[int, int]()
    m[1] = 10
    with pytest.raises(ValueError):
        _ = m["not-an-int"]  # coercion int("not-an-int") raises ValueError

    # get() should also propagate ValueError for invalid key coercion
    with pytest.raises(ValueError):
        _ = m.get("nope", default=None)


def test_from_json_unsupported_types_and_invalid_types_param():
    # invalid types shape
    with pytest.raises(TypeError, match="types must be a tuple of"):
        Map.from_json("{}", types="not-a-tuple")

    # unsupported types tuple
    with pytest.raises(TypeError):
        Map.from_json("{}", types=(str, int))


def test_factory_with_iterable_initial():
    # Iterable of pairs should be accepted by the Map factory
    m = Map[int, int]([(1, 10), (2, 20)])
    assert len(m) == 2
    assert dict(m.items()) == {1: 10, 2: 20}






def test_map_equality_and_non_map_comparisons():
    m1 = Map[int, int]({1: 10, 2: 20})
    m2 = Map[int, int]({1: 10, 2: 20})
    m3 = Map[int, int]({1: 11})

    # equality between maps
    assert m1 == m2
    assert not (m1 != m2)
    assert m1 != m3

    # comparison with unrelated objects should return False (not raise)
    assert (m1 == 123) is False
    assert (m1 != 123) is True




def test_from_json_default_types_path():
    m = Map[int, int]()
    m[10] = 100
    js = m.to_json()
    # default from_json should accept no types argument (uses MapIntInt)
    m_round = Map.from_json(js)
    assert isinstance(m_round, Map)
    assert dict(m_round.items()) == dict(m.items())




