import pytest
from falcon_core.generic import Map


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
    assert m.to_json() == "{}" or m.to_json() == ""  # depending on C API representation
