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


def test_iter_and_items_with_non_int_maptype():
    # Fake low-level object that only supplies to_json() and friends,
    # but uses string keys; wrap with a non-int c_map_type so coercion is skipped.
    class FakeStringKeys:
        def __init__(self):
            self._d = {"a": 1, "b": 2}

        def to_json(self):
            return json.dumps(self._d)

        def size(self):
            return len(self._d)

        def at(self, k):
            # support at if someone calls with a key
            return self._d[str(k)]

        def contains(self, k):
            return str(k) in self._d

        def insert_or_assign(self, k, v):
            self._d[str(k)] = v

        def erase(self, k):
            self._d.pop(str(k), None)

    fake = FakeStringKeys()
    # Pass a non-_CMapIntInt c_map_type so Map._coerce_key returns keys unchanged.
    m = Map(fake, c_map_type=object)

    # iteration should yield string keys (fallback path, no int coercion)
    keys = list(iter(m))
    assert set(keys) == {"a", "b"}

    # items should return string keys
    assert dict(m.items()) == {"a": 1, "b": 2}


def test_items_fallback_returns_string_keys():
    class FakeStringKeys2:
        def __init__(self):
            self._d = {"x": 100}

        def to_json(self):
            return json.dumps(self._d)

        def size(self):
            return len(self._d)

        def at(self, k):
            return self._d[str(k)]

        def contains(self, k):
            return str(k) in self._d

        def insert_or_assign(self, k, v):
            self._d[str(k)] = v

        def erase(self, k):
            self._d.pop(str(k), None)

    fake = FakeStringKeys2()
    m = Map(fake, c_map_type=object)
    items = m.items()
    assert items == [("x", 100)]


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


def test_items_with_keys_only_and_values_only_behavior():
    # keys-only fake: has keys() but no values(); items() should fallback to to_json()
    class KeysOnly:
        def __init__(self):
            # maintain a dict for to_json fallback
            self._d = {"1": 100, "2": 200}
        def keys(self):
            return ["1", "2"]
        def to_json(self):
            return json.dumps(self._d)
        def size(self):
            return len(self._d)
        def at(self, k):
            return self._d[str(k)]
        def contains(self, k):
            return str(k) in self._d
        def insert_or_assign(self, k, v):
            self._d[str(k)] = int(v)
        def erase(self, k):
            self._d.pop(str(k), None)

    konly = KeysOnly()
    m = Map(konly, _CMapIntInt)
    # __iter__ should prefer low-level keys() method
    assert list(m) == ["1", "2"]
    # items() should fall back to to_json() and produce int keys for _CMapIntInt
    it = dict(m.items())
    assert it == {1: 100, 2: 200}

    # values-only fake: has values() but no keys(); values() should use low-level values()
    class ValuesOnly:
        def __init__(self):
            self._vals = [7, 8]
            self._d = {"1": 7, "2": 8}
        def values(self):
            return list(self._vals)
        def to_json(self):
            return json.dumps(self._d)
        def size(self):
            return len(self._vals)
        def at(self, k):
            return self._d[str(k)]
        def contains(self, k):
            return str(k) in self._d
        def insert_or_assign(self, k, v):
            self._d[str(k)] = int(v)
        def erase(self, k):
            self._d.pop(str(k), None)

    vonly = ValuesOnly()
    m2 = Map(vonly, _CMapIntInt)
    assert m2.values() == [7, 8]


def test_from_json_default_types_path():
    m = Map[int, int]()
    m[10] = 100
    js = m.to_json()
    # default from_json should accept no types argument (uses MapIntInt)
    m_round = Map.from_json(js)
    assert isinstance(m_round, Map)
    assert dict(m_round.items()) == dict(m.items())
