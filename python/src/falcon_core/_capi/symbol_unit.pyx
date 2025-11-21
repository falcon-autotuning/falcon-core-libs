# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class SymbolUnit:
    cdef c_api.SymbolUnitHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.SymbolUnitHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.SymbolUnitHandle>0 and self.owned:
            c_api.SymbolUnit_destroy(self.handle)
        self.handle = <c_api.SymbolUnitHandle>0

    cdef SymbolUnit from_capi(cls, c_api.SymbolUnitHandle h):
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_meter(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_meter()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilogram(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_kilogram()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_second(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_second()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_ampere(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_ampere()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kelvin(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_kelvin()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_mole(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_mole()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_candela(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_candela()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_hertz(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_hertz()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_newton(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_newton()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_pascal(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_pascal()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_joule(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_joule()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_watt(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_watt()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_coulomb(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_coulomb()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volt(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_volt()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_farad(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_farad()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_ohm(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_ohm()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_siemens(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_siemens()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_weber(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_weber()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_tesla(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_tesla()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_henry(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_henry()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_minute(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_minute()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_hour(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_hour()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_electronvolt(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_electronvolt()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_celsius(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_celsius()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_fahrenheit(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_fahrenheit()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_dimensionless(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_dimensionless()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_percent(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_percent()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_radian(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_radian()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilometer(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_kilometer()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millimeter(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_millimeter()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millivolt(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_millivolt()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilovolt(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_kilovolt()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_milliampere(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_milliampere()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_microampere(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_microampere()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_nanoampere(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_nanoampere()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_picoampere(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_picoampere()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millisecond(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_millisecond()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_microsecond(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_microsecond()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_nanosecond(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_nanosecond()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_picosecond(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_picosecond()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_milliohm(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_milliohm()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kiloohm(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_kiloohm()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_megaohm(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_megaohm()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millihertz(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_millihertz()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilohertz(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_kilohertz()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_megahertz(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_megahertz()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_gigahertz(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_gigahertz()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_meters_per_second(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_meters_per_second()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_meters_per_second_squared(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_meters_per_second_squared()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_newton_meter(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_newton_meter()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_newtons_per_meter(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_newtons_per_meter()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volts_per_meter(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_volts_per_meter()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volts_per_second(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_volts_per_second()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_amperes_per_meter(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_amperes_per_meter()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volts_per_ampere(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_volts_per_ampere()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_watts_per_meter_kelvin(cls, ):
        cdef c_api.SymbolUnitHandle h
        h = c_api.SymbolUnit_create_watts_per_meter_kelvin()
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.SymbolUnitHandle h
        try:
            h = c_api.SymbolUnit_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def symbol(self):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.SymbolUnit_symbol(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def name(self):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.SymbolUnit_name(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def multiplication(self, other):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.SymbolUnit_multiplication(self.handle, <c_api.SymbolUnitHandle>other.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def __mul__(self, other):
        return self.multiplication(other)

    def division(self, other):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.SymbolUnit_division(self.handle, <c_api.SymbolUnitHandle>other.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def __truediv__(self, other):
        return self.division(other)

    def power(self, power):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.SymbolUnit_power(self.handle, power)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def with_prefix(self, prefix):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        prefix_bytes = prefix.encode("utf-8")
        cdef const char* raw_prefix = prefix_bytes
        cdef size_t len_prefix = len(prefix_bytes)
        cdef c_api.StringHandle s_prefix = c_api.String_create(raw_prefix, len_prefix)
        cdef c_api.SymbolUnitHandle h_ret
        try:
            h_ret = c_api.SymbolUnit_with_prefix(self.handle, s_prefix)
        finally:
            c_api.String_destroy(s_prefix)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def convert_value_to(self, value, target):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.SymbolUnit_convert_value_to(self.handle, value, <c_api.SymbolUnitHandle>target.handle)

    def is_compatible_with(self, other):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.SymbolUnit_is_compatible_with(self.handle, <c_api.SymbolUnitHandle>other.handle)

    def equal(self, other):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.SymbolUnit_equal(self.handle, <c_api.SymbolUnitHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.SymbolUnit_not_equal(self.handle, <c_api.SymbolUnitHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.SymbolUnitHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.SymbolUnit_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef SymbolUnit _symbolunit_from_capi(c_api.SymbolUnitHandle h):
    cdef SymbolUnit obj = <SymbolUnit>SymbolUnit.__new__(SymbolUnit)
    obj.handle = h