import collections.abc
from .._capi.list_int import ListInt as _CListInt

# A registry mapping Python types to their low-level Cython wrappers.
# This is the key to the generic factory.
_C_LIST_REGISTRY = {
    int: _CListInt,
    # When you create ListConnection, you'll add its entry here:
    # Connection: _CListConnection,
}


class _ListFactory:
    """A helper class to act as a specialized constructor, e.g., List[int]."""

    def __init__(self, c_list_type):
        self._c_list_type = c_list_type

    def __call__(self, initial_data=None):
        """Creates a new List instance, e.g., List[int]([1, 2, 3])."""
        if initial_data is None:
            c_obj = self._c_list_type.create_empty()
        else:
            c_obj = self._c_list_type.from_list(initial_data)
        # Pass the factory's c_list_type to the List instance so it knows its type.
        return List(c_obj, self._c_list_type)


class List(collections.abc.MutableSequence):
    """
    A generic, Pythonic list wrapper for Falcon Core list types.

    This class acts as a generic factory. Use square brackets to specify the
    contained type, for example:
        int_list = List[int]([1, 2, 3])
    """

    def __init__(self, c_obj, c_list_type=None):
        """
        Initializes the list with a low-level Cython wrapper object.
        Users should not call this directly. Use the List[type] factory syntax.
        """
        if not hasattr(c_obj, "at") or not hasattr(c_obj, "size"):
            raise TypeError("Object must conform to the low-level list interface.")
        self._c = c_obj
        self._c_list_type = c_list_type

    @classmethod
    def __class_getitem__(cls, item_type):
        """Enables the `List[type]` syntax."""
        c_list_type = _C_LIST_REGISTRY.get(item_type)
        if c_list_type is None:
            raise TypeError(f"List does not support type: {item_type}")
        return _ListFactory(c_list_type)

    def __getitem__(self, index):
        if isinstance(index, slice):
            # By calling self[i], we reuse the integer index logic below.
            return [self[i] for i in range(*index.indices(len(self)))]

        list_len = len(self)
        if index < 0:
            index += list_len

        # After converting negative indices, check if it's within bounds.
        if not 0 <= index < list_len:
            raise IndexError("list index out of range")

        return self._c.at(index)

    def __len__(self):
        return self._c.size()

    def __setitem__(self, index, value):
        # This is an "out-of-place" operation.
        # It's less efficient but provides the expected interface.
        if self._c_list_type is None:
            raise TypeError("Cannot modify a List that was not created with a factory.")
        temp_list = list(self)  # Convert to Python list
        temp_list[index] = value  # Modify in Python
        new_c_obj = self._c_list_type.from_list(temp_list)  # Create new C++ list
        self._c = new_c_obj  # Replace internal object

    def __delitem__(self, index):
        # This is an "in-place" operation, using the efficient C-API call.
        if not hasattr(self._c, "erase_at"):
            raise NotImplementedError("delete is not supported by the underlying object")
        self._c.erase_at(index)

    def insert(self, index, value):
        # This is an "out-of-place" operation.
        if self._c_list_type is None:
            raise TypeError("Cannot modify a List that was not created with a factory.")
        temp_list = list(self)
        temp_list.insert(index, value)
        new_c_obj = self._c_list_type.from_list(temp_list)
        self._c = new_c_obj

    def append(self, value):
        self._c.push_back(value)

    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return self._c == other._c

    def __repr__(self):
        return f"List({list(self)})"
