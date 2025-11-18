import pytest
from falcon_core.generic import Pair


def test_pair_factory_creation_and_accessors():
    p = Pair[int, int](1, 2)
    assert isinstance(p, Pair)
    assert p.first() == 1
    assert p.second() == 2
    assert repr(p) == "Pair(1, 2)"


def test_pair_default_and_json_roundtrip():
    p = Pair[int, int](0, 0)
    js = p.to_json()
    assert isinstance(js, str) and js != ""
    p2 = Pair.from_json(js, types=(int, int))
    assert isinstance(p2, Pair)
    assert p2.first() == p.first() and p2.second() == p.second()


def test_pair_unsupported_type():
    with pytest.raises(TypeError, match="Pair does not support types"):
        _ = Pair[str, int]


def test_pair_factory_default_and_from_json_default():
    # default factory (no args) should create (0,0)
    p = Pair[int, int]()
    assert p.first() == 0
    assert p.second() == 0

    # JSON roundtrip using the default from_json (no types arg)
    js = p.to_json()
    p2 = Pair.from_json(js)     # uses default Pair[int,int]
    assert isinstance(p2, Pair)
    assert p2.first() == 0 and p2.second() == 0


def test_pair_constructor_invalid_object_raises():
    # Passing an object that doesn't expose 'first'/'second' should raise
    with pytest.raises(TypeError, match="Object must conform"):
        Pair(object(), None)


def test_pair_class_getitem_invalid_and_unsupported():
    # Invalid class-getitem shapes
    with pytest.raises(TypeError, match="requires two type parameters"):
        _ = Pair[int]            # not a 2-tuple

    with pytest.raises(TypeError, match="requires two type parameters"):
        _ = Pair["x"]           # wrong kind

    # Unsupported types tuple
    with pytest.raises(TypeError, match="Pair does not support types"):
        Pair.from_json("{}", types=(str, int))


def test_pair_eq_behavior():
    a = Pair[int, int](5, 6)
    b = Pair[int, int](5, 6)
    c = Pair[int, int](7, 8)

    # equality of same contents
    assert a == b
    assert not (a != b)

    # inequality of different contents
    assert a != c

    # comparison to an unrelated type should not raise, but evaluate to False/True
    assert (a == 123) is False
    assert (a != 123) is True
