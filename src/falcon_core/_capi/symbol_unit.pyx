cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class SymbolUnit:
    def __cinit__(self):
        self.handle = <_c_api.SymbolUnitHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.SymbolUnitHandle>0 and self.owned:
            _c_api.SymbolUnit_destroy(self.handle)
        self.handle = <_c_api.SymbolUnitHandle>0


cdef SymbolUnit _symbol_unit_from_capi(_c_api.SymbolUnitHandle h):
    if h == <_c_api.SymbolUnitHandle>0:
        return None
    cdef SymbolUnit obj = SymbolUnit.__new__(SymbolUnit)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_meter(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_meter()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilogram(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_kilogram()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_second(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_second()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_ampere(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_ampere()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kelvin(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_kelvin()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_mole(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_mole()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_candela(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_candela()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_hertz(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_hertz()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_newton(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_newton()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_pascal(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_pascal()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_joule(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_joule()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_watt(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_watt()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_coulomb(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_coulomb()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volt(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_volt()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_farad(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_farad()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_ohm(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_ohm()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_siemens(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_siemens()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_weber(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_weber()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_tesla(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_tesla()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_henry(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_henry()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_minute(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_minute()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_hour(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_hour()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_electronvolt(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_electronvolt()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_celsius(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_celsius()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_fahrenheit(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_fahrenheit()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_dimensionless(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_dimensionless()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_percent(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_percent()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_radian(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_radian()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilometer(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_kilometer()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millimeter(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_millimeter()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millivolt(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_millivolt()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilovolt(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_kilovolt()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_milliampere(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_milliampere()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_microampere(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_microampere()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_nanoampere(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_nanoampere()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_picoampere(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_picoampere()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millisecond(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_millisecond()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_microsecond(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_microsecond()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_nanosecond(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_nanosecond()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_picosecond(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_picosecond()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_milliohm(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_milliohm()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kiloohm(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_kiloohm()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_megaohm(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_megaohm()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_millihertz(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_millihertz()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_kilohertz(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_kilohertz()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_megahertz(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_megahertz()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_gigahertz(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_gigahertz()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_meters_per_second(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_meters_per_second()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_meters_per_second_squared(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_meters_per_second_squared()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_newton_meter(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_newton_meter()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_newtons_per_meter(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_newtons_per_meter()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volts_per_meter(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_volts_per_meter()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volts_per_second(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_volts_per_second()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_amperes_per_meter(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_amperes_per_meter()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_volts_per_ampere(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_volts_per_ampere()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_watts_per_meter_kelvin(cls, ):
        cdef _c_api.SymbolUnitHandle h
        h = _c_api.SymbolUnit_create_watts_per_meter_kelvin()
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.SymbolUnitHandle h
        try:
            h = _c_api.SymbolUnit_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.SymbolUnitHandle>0:
            raise MemoryError("Failed to create SymbolUnit")
        cdef SymbolUnit obj = <SymbolUnit>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def symbol(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.SymbolUnit_symbol(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def name(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.SymbolUnit_name(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def multiplication(self, SymbolUnit other):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.SymbolUnit_multiplication(self.handle, other.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def __mul__(self, SymbolUnit other):
        return self.multiplication(other)

    def division(self, SymbolUnit other):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.SymbolUnit_division(self.handle, other.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def __truediv__(self, SymbolUnit other):
        return self.division(other)

    def power(self, int power):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.SymbolUnit_power(self.handle, power)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def with_prefix(self, str prefix):
        cdef bytes b_prefix = prefix.encode("utf-8")
        cdef StringHandle s_prefix = _c_api.String_create(b_prefix, len(b_prefix))
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.SymbolUnit_with_prefix(self.handle, s_prefix)
        _c_api.String_destroy(s_prefix)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def convert_value_to(self, double value, SymbolUnit target):
        return _c_api.SymbolUnit_convert_value_to(self.handle, value, target.handle)

    def is_compatible_with(self, SymbolUnit other):
        return _c_api.SymbolUnit_is_compatible_with(self.handle, other.handle)

    def equal(self, SymbolUnit other):
        return _c_api.SymbolUnit_equal(self.handle, other.handle)

    def __eq__(self, SymbolUnit other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, SymbolUnit other):
        return _c_api.SymbolUnit_not_equal(self.handle, other.handle)

    def __ne__(self, SymbolUnit other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
