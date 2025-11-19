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


def test_iter_and_items_fallback_using_to_json():
    """
    If the low-level object does not expose keys()/values(), Map should
    fall back to using to_json() for iteration and items().
    """
    class FakeFallback:
        # This fake simulates a low-level C wrapper that provides at/size/contains
        # and a to_json() method, but DOES NOT have keys()/values().
        def __init__(self):
            # JSON uses string keys; Map should convert them back to ints in fallback
            self._dict = {"1": 100, "2": 200}

        def to_json(self):
            return json.dumps(self._dict)

        def size(self):
            # used by __len__
            return len(self._dict)

        def at(self, key_or_index):
            # Map.__getitem__ only calls self._c.at(key) when key is int after coercion,
            # but for iteration/fallback we rely on JSON parsing, so 'at' isn't used here.
            # Implement a best-effort mapping: if given int, map to value by str(key).
            return self._dict[str(key_or_index)]

        def contains(self, key):
            return str(key) in self._dict

        def insert_or_assign(self, key, value):
            self._dict[str(key)] = int(value)

        def erase(self, key):
            self._dict.pop(str(key), None)

    fake = FakeFallback()
    m = Map(fake, _CMapIntInt)

    # iteration should yield integer keys
    it_keys = list(iter(m))
    assert set(it_keys) == {1, 2}

    # keys/values/items should be derived from JSON fallback
    k = m.keys()
    v = m.values()
    it = dict(m.items())
    assert set(k) == {1, 2}
    assert set(v) == {100, 200}
    assert it == {1: 100, 2: 200}

    # repr should contain Map( and the mapping
    assert "Map(" in repr(m)


def test_lowlevel_keys_values_preferred():
    """
    If the low-level object provides keys() and values(), Map should prefer them.
    """
    class FakeKV:
        def __init__(self):
            self._keys = [1, 2]
            self._values = [10, 20]

        def keys(self):
            return list(self._keys)

        def values(self):
            return list(self._values)

        def size(self):
            return len(self._keys)

        def at(self, index_or_key):
            # in this fake, at(index) returns the value at that index for tests that call it
            if isinstance(index_or_key, int) and 0 <= index_or_key < len(self._values):
                return self._values[index_or_key]
            # if at is passed a key, return corresponding value
            for k, v in zip(self._keys, self._values):
                if k == index_or_key:
                    return v
            raise KeyError(index_or_key)

        def contains(self, key):
            return key in self._keys

        def insert_or_assign(self, key, value):
            # append if absent, otherwise replace
            if key in self._keys:
                i = self._keys.index(key)
                self._values[i] = int(value)
            else:
                self._keys.append(key)
                self._values.append(int(value))

        def erase(self, key):
            if key in self._keys:
                i = self._keys.index(key)
                self._keys.pop(i)
                self._values.pop(i)

    fake = FakeKV()
    m = Map(fake, _CMapIntInt)

    # keys/values come from low-level methods
    assert m.keys() == [1, 2]
    assert m.values() == [10, 20]
    assert m.items() == [(1, 10), (2, 20)]

    # iteration uses low-level keys()
    assert list(m) == [1, 2]

    # setting via __setitem__ should update (coerced to int)
    m[2] = 99
    assert m[2] == 99
    m[3] = 300
    assert 3 in m.keys()
    assert m[3] == 300

    # deleting existing and non-existing raises KeyError
    del m[3]
    with pytest.raises(KeyError):
        del m[3]


def test_setitem_without_factory_raises():
    # Create a real low-level Map object but wrap it without providing c_map_type
    c_obj = _CMapIntInt.create_empty()
    m = Map(c_obj)  # _c_map_type is None
    with pytest.raises(TypeError):
        m[1] = 10
    with pytest.raises(TypeError):
        m.insert = 1  # also ensure mutation is not allowed via other means


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
