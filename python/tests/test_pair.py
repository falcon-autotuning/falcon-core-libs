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
