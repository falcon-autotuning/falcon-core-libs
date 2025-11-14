import collections.abc


class List(collections.abc.MutableSequence):
    """
    A generic, Pythonic list wrapper for Falcon Core list types.

    This class provides a standard Python list interface (slicing, iteration,
    appending, etc.) by wrapping a low-level Cython object that manages
    a C-API handle.
    """

    def __init__(self, c_obj):
        """
        Initializes the list with a low-level Cython wrapper object.
        Users should not call this directly. Use factory methods instead.
        """
        if not hasattr(c_obj, "at") or not hasattr(c_obj, "size"):
            raise TypeError("Object must conform to the low-level list interface.")
        self._c = c_obj

    def __getitem__(self, index):
        if isinstance(index, slice):
            # Basic slice support for demonstration
            return [self._c.at(i) for i in range(*index.indices(len(self)))]
        return self._c.at(index)

    def __len__(self):
        return self._c.size()

    def __setitem__(self, index, value):
        # Note: C-API does not have a 'set' method, so this is complex.
        # For now, we raise an error.
        raise NotImplementedError("Setting items by index is not supported.")

    def __delitem__(self, index):
        # Note: C-API does not have a 'del' method, so this is complex.
        raise NotImplementedError("Deleting items by index is not supported.")

    def insert(self, index, value):
        # Note: C-API does not have an 'insert' method.
        raise NotImplementedError("Inserting items by index is not supported.")

    def append(self, value):
        """Appends an item to the end of the list."""
        if not hasattr(self._c, "push_back"):
            raise AttributeError("append is not supported by the underlying object")
        self._c.push_back(value)

    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return self._c == other._c

    def __repr__(self):
        return f"{self.__class__.__name__}({list(self)})"
