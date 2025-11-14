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

    # This will fail until Connection is added to the registry
    with pytest.raises(TypeError, match="List does not support type"):
        _ = List[Connection]


def test_list_direct_instantiation_fails():
    """Test that direct instantiation of List is prevented."""
    # A dummy object that looks like a C-wrapper
    class DummyCWrapper:
        def at(self, index): return index
        def size(self): return 1

    with pytest.raises(TypeError, match="Object must conform to the low-level list interface."):
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
    assert list1 != list4
    assert (list1 == [1, 2, 3]) is False  # Comparison with other types
    with pytest.raises(TypeError):
        _ = list1 == 123  # Should return NotImplemented, which pytest raises as TypeError in this context


def test_list_repr():
    """Test the __repr__ method for a clean representation."""
    int_list = List[int]([1, 2])
    assert repr(int_list) == "List([1, 2])"
    empty_list = List[int]()
    assert repr(empty_list) == "List([])"


def test_list_mutable_methods_not_implemented():
    """Ensure methods that would mutate in place are not implemented."""
    int_list = List[int]([1, 2, 3])
    with pytest.raises(NotImplementedError):
        int_list[0] = 10
    with pytest.raises(NotImplementedError):
        del int_list[0]
    with pytest.raises(NotImplementedError):
        int_list.insert(0, 10)
