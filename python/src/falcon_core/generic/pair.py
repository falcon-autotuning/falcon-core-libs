from __future__ import annotations
from typing import Any, TypeVar, Generic, Union
import collections.abc

K = TypeVar('K')
V = TypeVar('V')

class _PairFactory:
    """Factory for Pair[T] instances."""

    def __init__(self, element_type, c_pair_class):
        self.element_type = element_type
        self._c_class = c_pair_class

    def __call__(self, *args, **kwargs):
        """Construct a new Pair instance."""
        # This is for direct construction, not typically used
        # Users should use class methods like Pair[T].new_empty(...)
        raise TypeError(f'Use Pair[{self.element_type}].new_*() class methods to construct instances')

    def __getattr__(self, name):
        """Delegate class method calls to the underlying Cython class."""
        attr = getattr(self._c_class, name, None)
        if attr is None:
            raise AttributeError(f"Pair[{self.element_type}] has no attribute {name!r}")
        
        # If it's a class method or static method, wrap the result
        if callable(attr):
            def wrapper(*args, **kwargs):
                result = attr(*args, **kwargs)
                # Wrap the result if it's a Cython instance
                if result is not None and hasattr(result, 'handle'):
                    return Pair(result, self.element_type)
                return result
            return wrapper
        return attr

class Pair:
    """Generic Pair wrapper with full method support."""

    def __init__(self, c_obj, element_type=None):
        """Initialize from a Cython object."""
        self._c = c_obj
        self._element_type = element_type

    @classmethod
    def __class_getitem__(cls, types):
        """Enable Pair[K, V] syntax."""
        if not isinstance(types, tuple) or len(types) != 2:
            raise TypeError(f"Pair requires 2 type parameters")
        from ._pair_registry import PAIR_REGISTRY
        c_class = PAIR_REGISTRY.get(types)
        if c_class is None:
            raise TypeError(f"Pair does not support types: {types}")
        return _PairFactory(types, c_class)

    def __getattr__(self, name):
        """Delegate attribute access to the underlying Cython object."""
        if name.startswith('_'):
            raise AttributeError(f'{name}')
        
        attr = getattr(self._c, name, None)
        if attr is None:
            raise AttributeError(f"Pair has no attribute {name!r}")
        
        # If it's a method, wrap it to handle return values
        if callable(attr):
            def wrapper(*args, **kwargs):
                # Unwrap Pair arguments to their Cython objects
                unwrapped_args = []
                for arg in args:
                    if isinstance(arg, Pair):
                        unwrapped_args.append(arg._c)
                    else:
                        unwrapped_args.append(arg)
                
                result = attr(*unwrapped_args, **kwargs)
                
                # Wrap the result if it's a Cython instance of the same type
                if result is not None and hasattr(result, 'handle'):
                    # Check if it's the same type as self._c
                    if type(result).__name__ == type(self._c).__name__:
                        return Pair(result, self._element_type)
                return result
            return wrapper
        return attr

    def __add__(self, other):
        # Try different method overloads based on argument type
        if isinstance(other, Pair) and hasattr(self._c, 'plus_farray'):
            result = self._c.plus_farray(other._c)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, float) and hasattr(self._c, 'plus_double'):
            result = self._c.plus_double(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, int) and hasattr(self._c, 'plus_int'):
            result = self._c.plus_int(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        raise TypeError(f'unsupported operand type(s) for __add__: {type(self).__name__} and {type(other).__name__}')

    def __sub__(self, other):
        # Try different method overloads based on argument type
        if isinstance(other, Pair) and hasattr(self._c, 'minus_farray'):
            result = self._c.minus_farray(other._c)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, float) and hasattr(self._c, 'minus_double'):
            result = self._c.minus_double(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, int) and hasattr(self._c, 'minus_int'):
            result = self._c.minus_int(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        raise TypeError(f'unsupported operand type(s) for __sub__: {type(self).__name__} and {type(other).__name__}')

    def __mul__(self, other):
        # Try different method overloads based on argument type
        if isinstance(other, Pair) and hasattr(self._c, 'times_farray'):
            result = self._c.times_farray(other._c)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, float) and hasattr(self._c, 'times_double'):
            result = self._c.times_double(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, int) and hasattr(self._c, 'times_int'):
            result = self._c.times_int(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        raise TypeError(f'unsupported operand type(s) for __mul__: {type(self).__name__} and {type(other).__name__}')

    def __truediv__(self, other):
        # Try different method overloads based on argument type
        if isinstance(other, Pair) and hasattr(self._c, 'divides_farray'):
            result = self._c.divides_farray(other._c)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, float) and hasattr(self._c, 'divides_double'):
            result = self._c.divides_double(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        if isinstance(other, int) and hasattr(self._c, 'divides_int'):
            result = self._c.divides_int(other)
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        raise TypeError(f'unsupported operand type(s) for __truediv__: {type(self).__name__} and {type(other).__name__}')

    def __neg__(self):
        if hasattr(self._c, 'negation'):
            result = self._c.negation()
            if result is not None and hasattr(result, 'handle'):
                return Pair(result, self._element_type)
            return result
        raise AttributeError(f'__neg__ not supported')

    def __eq__(self, other):
        # Try different method overloads based on argument type
        return NotImplemented

    def __ne__(self, other):
        # Try different method overloads based on argument type
        return NotImplemented

    def __repr__(self):
        return f"Pair[{self._element_type}]({self._c})"
