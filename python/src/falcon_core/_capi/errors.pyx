# cython: language_level=3
"""
Centralized C-API error helpers.

This module exposes:
- CAPIError: a Python exception type to raise for C API errors.
- Inline cdef helpers (check_null_handle, check_int_result, check_size_t_result)
  that are cheap to call from Cython and will raise a CAPIError with the message
  from the C shim (get_last_error_msg) when the shim indicates an error.
- maybe_raise: a Python-visible helper for use at higher levels.
"""

from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.string cimport strlen
from libc.stddef cimport size_t
from . cimport c_api

class CAPIError(RuntimeError):
    """Raised when the underlying C API reports an error via the shim."""
    pass

cdef void _raise_from_shim(const char* default_msg):
    """
    Read the last error from the C shim and raise CAPIError with a helpful
    message. Clears the shim's last-error afterwards.
    """
    cdef int code = c_api.get_last_error_code()
    cdef const char* msg = c_api.get_last_error_msg()
    if msg != NULL and strlen(msg) > 0:
        # Create Python string from C char*
        cdef PyObject* pybytes = PyBytes_FromStringAndSize(msg, strlen(msg))
        py_msg = (<bytes>pybytes).decode("utf-8")
    else:
        py_msg = None

    # Clear the shim error so subsequent checks are clean.
    c_api.set_last_error(0, <const char*>NULL)

    if py_msg:
        raise CAPIError(f"{default_msg}: {py_msg}")
    else:
        raise CAPIError(default_msg)


# Inline helpers for Cython call sites (zero-cost when inlined).
cdef inline void check_null_handle(void* h, const char* default_msg):
    """
    Check a returned handle for NULL (or 0). If NULL and the shim has an error,
    raise an exception with the shim message; otherwise raise with default_msg.
    """
    if h == NULL or h == <void*>0:
        _raise_from_shim(default_msg)

cdef inline bint check_int_result(int v, const char* default_msg):
    """
    Check an int-returning C API call for error state. Many C APIs use the error
    shim rather than sentinel values; prefer to test the shim.
    Returns True on success (caller may still inspect v).
    """
    if c_api.get_last_error_code() != 0:
        _raise_from_shim(default_msg)
    return True

cdef inline void check_size_t_result(size_t v, const char* default_msg):
    """
    Check size_t-returning calls. If v == 0 and shim reports an error,
    raise; otherwise return normally.
    """
    if v == 0 and c_api.get_last_error_code() != 0:
        _raise_from_shim(default_msg)
    return

# Python-visible convenience helper
def maybe_raise(default_msg: str = "C API error"):
    """
    Python-level helper: if the shim reports an error, raise CAPIError.
    Useful for code paths that call into the C API from pure Python.
    """
    if c_api.get_last_error_code() != 0:
        _raise_from_shim(default_msg)
