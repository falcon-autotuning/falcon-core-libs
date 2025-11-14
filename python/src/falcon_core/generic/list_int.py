from .list import List
from .._capi.list_int import ListInt as _CListInt


class ListInt(List):
    """A specialized List for holding integers."""

    @classmethod
    def from_list(cls, py_list: list):
        """Creates a ListInt from a Python list of integers."""
        c_obj = _CListInt.from_list(py_list)
        return cls(c_obj)

    @classmethod
    def create_empty(cls):
        """Creates an empty ListInt."""
        c_obj = _CListInt.create_empty()
        return cls(c_obj)
