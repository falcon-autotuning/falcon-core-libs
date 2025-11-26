package symbolunit

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"

	// no extra imports
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.SymbolUnit_destroy(C.SymbolUnitHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func NewMeter() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_meter()), nil
		},
		construct,
		destroy,
	)
}
func NewKilogram() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_kilogram()), nil
		},
		construct,
		destroy,
	)
}
func NewSecond() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_second()), nil
		},
		construct,
		destroy,
	)
}
func NewAmpere() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_ampere()), nil
		},
		construct,
		destroy,
	)
}
func NewKelvin() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_kelvin()), nil
		},
		construct,
		destroy,
	)
}
func NewMole() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_mole()), nil
		},
		construct,
		destroy,
	)
}
func NewCandela() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_candela()), nil
		},
		construct,
		destroy,
	)
}
func NewHertz() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_hertz()), nil
		},
		construct,
		destroy,
	)
}
func NewNewton() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_newton()), nil
		},
		construct,
		destroy,
	)
}
func NewPascal() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_pascal()), nil
		},
		construct,
		destroy,
	)
}
func NewJoule() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_joule()), nil
		},
		construct,
		destroy,
	)
}
func NewWatt() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_watt()), nil
		},
		construct,
		destroy,
	)
}
func NewCoulomb() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_coulomb()), nil
		},
		construct,
		destroy,
	)
}
func NewVolt() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_volt()), nil
		},
		construct,
		destroy,
	)
}
func NewFarad() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_farad()), nil
		},
		construct,
		destroy,
	)
}
func NewOhm() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_ohm()), nil
		},
		construct,
		destroy,
	)
}
func NewSiemens() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_siemens()), nil
		},
		construct,
		destroy,
	)
}
func NewWeber() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_weber()), nil
		},
		construct,
		destroy,
	)
}
func NewTesla() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_tesla()), nil
		},
		construct,
		destroy,
	)
}
func NewHenry() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_henry()), nil
		},
		construct,
		destroy,
	)
}
func NewMinute() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_minute()), nil
		},
		construct,
		destroy,
	)
}
func NewHour() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_hour()), nil
		},
		construct,
		destroy,
	)
}
func NewElectronvolt() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_electronvolt()), nil
		},
		construct,
		destroy,
	)
}
func NewCelsius() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_celsius()), nil
		},
		construct,
		destroy,
	)
}
func NewFahrenheit() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_fahrenheit()), nil
		},
		construct,
		destroy,
	)
}
func NewDimensionless() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_dimensionless()), nil
		},
		construct,
		destroy,
	)
}
func NewPercent() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_percent()), nil
		},
		construct,
		destroy,
	)
}
func NewRadian() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_radian()), nil
		},
		construct,
		destroy,
	)
}
func NewKilometer() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_kilometer()), nil
		},
		construct,
		destroy,
	)
}
func NewMillimeter() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_millimeter()), nil
		},
		construct,
		destroy,
	)
}
func NewMillivolt() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_millivolt()), nil
		},
		construct,
		destroy,
	)
}
func NewKilovolt() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_kilovolt()), nil
		},
		construct,
		destroy,
	)
}
func NewMilliampere() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_milliampere()), nil
		},
		construct,
		destroy,
	)
}
func NewMicroampere() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_microampere()), nil
		},
		construct,
		destroy,
	)
}
func NewNanoampere() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_nanoampere()), nil
		},
		construct,
		destroy,
	)
}
func NewPicoampere() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_picoampere()), nil
		},
		construct,
		destroy,
	)
}
func NewMillisecond() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_millisecond()), nil
		},
		construct,
		destroy,
	)
}
func NewMicrosecond() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_microsecond()), nil
		},
		construct,
		destroy,
	)
}
func NewNanosecond() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_nanosecond()), nil
		},
		construct,
		destroy,
	)
}
func NewPicosecond() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_picosecond()), nil
		},
		construct,
		destroy,
	)
}
func NewMilliohm() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_milliohm()), nil
		},
		construct,
		destroy,
	)
}
func NewKiloohm() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_kiloohm()), nil
		},
		construct,
		destroy,
	)
}
func NewMegaohm() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_megaohm()), nil
		},
		construct,
		destroy,
	)
}
func NewMillihertz() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_millihertz()), nil
		},
		construct,
		destroy,
	)
}
func NewKilohertz() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_kilohertz()), nil
		},
		construct,
		destroy,
	)
}
func NewMegahertz() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_megahertz()), nil
		},
		construct,
		destroy,
	)
}
func NewGigahertz() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_gigahertz()), nil
		},
		construct,
		destroy,
	)
}
func NewMetersPerSecond() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_meters_per_second()), nil
		},
		construct,
		destroy,
	)
}
func NewMetersPerSecondSquared() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_meters_per_second_squared()), nil
		},
		construct,
		destroy,
	)
}
func NewNewtonMeter() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_newton_meter()), nil
		},
		construct,
		destroy,
	)
}
func NewNewtonsPerMeter() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_newtons_per_meter()), nil
		},
		construct,
		destroy,
	)
}
func NewVoltsPerMeter() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_volts_per_meter()), nil
		},
		construct,
		destroy,
	)
}
func NewVoltsPerSecond() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_volts_per_second()), nil
		},
		construct,
		destroy,
	)
}
func NewAmperesPerMeter() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_amperes_per_meter()), nil
		},
		construct,
		destroy,
	)
}
func NewVoltsPerAmpere() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_volts_per_ampere()), nil
		},
		construct,
		destroy,
	)
}
func NewWattsPerMeterKelvin() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.SymbolUnit_create_watts_per_meter_kelvin()), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Symbol() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.SymbolUnit_symbol(C.SymbolUnitHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Symbol:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Name() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.SymbolUnit_name(C.SymbolUnitHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Name:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Multiplication(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.SymbolUnit_multiplication(C.SymbolUnitHandle(h.CAPIHandle()), C.SymbolUnitHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Division(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.SymbolUnit_division(C.SymbolUnitHandle(h.CAPIHandle()), C.SymbolUnitHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Power(power int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.SymbolUnit_power(C.SymbolUnitHandle(h.CAPIHandle()), C.int(power))))
	})
}
func (h *Handle) WithPrefix(prefix string) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, prefix}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.SymbolUnit_with_prefix(C.SymbolUnitHandle(h.CAPIHandle()), C.StringHandle(prefix.CAPIHandle()))))
	})
}
func (h *Handle) ConvertValueTo(value float64, target *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, target}, func() (float64, error) {
		return float64(C.SymbolUnit_convert_value_to(C.SymbolUnitHandle(h.CAPIHandle()), C.double(value), C.SymbolUnitHandle(target.CAPIHandle()))), nil
	})
}
func (h *Handle) IsCompatibleWith(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.SymbolUnit_is_compatible_with(C.SymbolUnitHandle(h.CAPIHandle()), C.SymbolUnitHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.SymbolUnit_equal(C.SymbolUnitHandle(h.CAPIHandle()), C.SymbolUnitHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.SymbolUnit_not_equal(C.SymbolUnitHandle(h.CAPIHandle()), C.SymbolUnitHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.SymbolUnit_to_json_string(C.SymbolUnitHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("ToJSON:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func FromJSON(json string) (*Handle, error) {
	realjson := str.New(json)
	return cmemoryallocation.Read(realjson, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.SymbolUnit_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
