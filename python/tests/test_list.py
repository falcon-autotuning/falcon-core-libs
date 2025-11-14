import pytest
from falcon_core.generic import List
from falcon_core.physics.device_structures.connection import Connection


def test_list_factory_creation():
    """Test creating lists using the List[type] factory syntax."""
    # Create from a Python list
    int_list = List[int]([1, 2, 3])
    assert isinstance(int_list, List)
    assert len(int_list) == 3

    # Create an empty list
    empty_list = List[int]()
    assert isinstance(empty_list, List)
    assert len(empty_list) == 0


def test_list_unsupported_type():
    """Test that List[type] raises an error for unsupported types."""
    with pytest.raises(TypeError, match="List does not support type"):
        _ = List[str]


def test_list_direct_instantiation_fails():
    """Test that direct instantiation of List is prevented."""

    # A dummy object that looks like a C-wrapper
    class DummyCWrapper:
        def at(self, index):
            return index

        def size(self):
            return 1

    _ = DummyCWrapper().at(0)

    with pytest.raises(
        TypeError, match="Object must conform to the low-level list interface."
    ):
        # This should fail because the constructor is not meant for public use
        List(object())

    # This should succeed because the dummy object has the right methods
    l = List(DummyCWrapper())
    assert len(l) == 1


def test_list_len():
    """Test the __len__ method."""
    assert len(List[int]()) == 0
    assert len(List[int]([1, 5, 10])) == 3


def test_list_getitem():
    """Test getting items by index and slice."""
    int_list = List[int]([10, 20, 30, 40])

    # Test positive and negative indexing
    assert int_list[0] == 10
    assert int_list[2] == 30
    assert int_list[-1] == 40
    assert int_list[-3] == 20

    # Test slicing
    assert int_list[1:3] == [20, 30]
    assert int_list[:2] == [10, 20]
    assert int_list[2:] == [30, 40]
    assert int_list[:] == [10, 20, 30, 40]


def test_list_getitem_out_of_bounds():
    """Test that accessing an index out of bounds raises IndexError."""
    int_list = List[int]([10, 20])
    with pytest.raises(IndexError):
        _ = int_list[2]
    with pytest.raises(IndexError):
        _ = int_list[-3]


def test_list_append():
    """Test appending items to the list."""
    int_list = List[int]()
    int_list.append(100)
    assert len(int_list) == 1
    assert int_list[0] == 100

    int_list.append(200)
    assert len(int_list) == 2
    assert int_list[1] == 200


def test_list_iteration():
    """Test iterating over the list."""
    data = [11, 22, 33]
    int_list = List[int](data)
    iterated_data = [item for item in int_list]
    assert iterated_data == data
    assert list(int_list) == data


def test_list_equality():
    """Test the __eq__ method."""
    list1 = List[int]([1, 2, 3])
    list2 = List[int]([1, 2, 3])
    list3 = List[int]([1, 2, 4])
    list4 = List[int]()

    assert list1 == list2
    assert list1 != list3
    assert list1 != list3
    assert list1 != list4

    # Comparing with other types should return False, not raise an error.
    assert (list1 == [1, 2, 3]) is False
    assert (list1 == 123) is False


def test_list_repr():
    """Test the __repr__ method for a clean representation."""
    int_list = List[int]([1, 2])
    assert repr(int_list) == "List([1, 2])"
    empty_list = List[int]()
    assert repr(empty_list) == "List([])"


def test_list_setitem():
    """Test the __setitem__ method."""
    # Test with an integer index
    int_list = List[int]([1, 2, 3])
    int_list[1] = 99
    assert list(int_list) == [1, 99, 3]

    # Test with a slice
    int_list[1:2] = [88, 77]
    assert list(int_list) == [1, 88, 77, 3]


def test_list_delitem():
    """Test the __delitem__ method."""
    int_list = List[int]([1, 2, 3, 4])
    del int_list[2]  # Delete '3'
    assert list(int_list) == [1, 2, 4]

    # Test deleting with a negative index
    del int_list[-1]  # Delete '4'
    assert list(int_list) == [1, 2]


def test_list_delitem_out_of_bounds():
    """Test that __delitem__ raises IndexError for out-of-bounds indices."""
    int_list = List[int]([1, 2])
    with pytest.raises(IndexError):
        del int_list[2]
    with pytest.raises(IndexError):
        del int_list[-3]


def test_list_insert():
    """Test the insert method."""
    int_list = List[int]([1, 4])
    int_list.insert(1, 2)
    int_list.insert(2, 3)
    assert list(int_list) == [1, 2, 3, 4]


def test_list_clear():
    """Test the clear method."""
    int_list = List[int]([1, 2, 3])
    # The check for `clear` should be part of the test logic
    if hasattr(int_list._c, "clear"):
        int_list.clear()
        assert len(int_list) == 0
        assert list(int_list) == []


def test_list_modification_without_factory_fails():
    """Test that modifying a list not made with a factory raises TypeError."""
    from falcon_core._capi.list_int import ListInt as _CListInt

    # Create a list by directly instantiating the wrapper, bypassing the factory.
    # This simulates a scenario where _c_list_type would be None.
    c_obj = _CListInt.from_list([1, 2, 3])
    raw_list = List(c_obj)

    with pytest.raises(
        TypeError, match="Cannot modify a List that was not created with a factory."
    ):
        raw_list[0] = 100

    with pytest.raises(
        TypeError, match="Cannot modify a List that was not created with a factory."
    ):
        raw_list.insert(0, 100)


def test_list_of_connections():
    """Basic test to ensure List[Connection] works."""
    p1 = Connection.new_plunger("P1")
    b1 = Connection.new_barrier("B1")

    # Test creation
    conn_list = List[Connection]([p1, b1])
    assert len(conn_list) == 2
    assert conn_list[0] == p1
    assert conn_list[1].name() == "B1"

    # Test append
    r1 = Connection.new_reservoir("R1")
    conn_list.append(r1)
    assert len(conn_list) == 3
    assert conn_list[2] == r1

    # Test equality
    conn_list2 = List[Connection]([p1, b1, r1])
    assert conn_list == conn_list2


def test_list_intersection():
    """Test the custom intersection method."""
    list1 = List[int]([1, 2, 3, 4])
    list2 = List[int]([3, 4, 5, 6])
    intersect = list1.intersection(list2)
    assert isinstance(intersect, List)
    assert sorted(list(intersect)) == [3, 4]

    # Test with connections
    p1 = Connection.new_plunger("P1")
    b1 = Connection.new_barrier("B1")
    r1 = Connection.new_reservoir("R1")
    conn_list1 = List[Connection]([p1, b1])
    conn_list2 = List[Connection]([b1, r1])
    conn_intersect = conn_list1.intersection(conn_list2)
    assert len(conn_intersect) == 1
    assert conn_intersect[0] == b1

    # Test error conditions
    with pytest.raises(TypeError, match="Intersection is only defined between List objects"):
        list1.intersection([3, 4])
    with pytest.raises(TypeError, match="Cannot find intersection of Lists of different types"):
        list1.intersection(conn_list1)
