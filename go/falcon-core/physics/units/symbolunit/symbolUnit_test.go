package symbolunit

import (
	"testing"
)

func TestSymbolUnit_ErrorOnClosed(t *testing.T) {
	u, err := NewMeter()
	if err != nil {
		t.Fatalf("unexpected error creating SymbolUnit: %v", err)
	}
	u.Close()
	u2, err := NewKilogram()
	if err != nil {
		t.Fatalf("unexpected error creating SymbolUnit: %v", err)
	}
	defer u2.Close()
	tests := []struct {
		name string
		test func() error
	}{
		{"Symbol", func() error { _, err := u.Symbol(); return err }},
		{"Name", func() error { _, err := u.Name(); return err }},
		{"Multiplication", func() error { _, err := u.Multiplication(u2); return err }},
		{"Division", func() error { _, err := u.Division(u2); return err }},
		{"Power", func() error { _, err := u.Power(2); return err }},
		{"WithPrefix", func() error { _, err := u.WithPrefix("kilo"); return err }},
		{"ConvertValueTo", func() error { _, err := u.ConvertValueTo(1.0, u2); return err }},
		{"IsCompatibleWith", func() error { _, err := u.IsCompatibleWith(u2); return err }},
		{"Equal", func() error { _, err := u.Equal(u2); return err }},
		{"NotEqual", func() error { _, err := u.NotEqual(u2); return err }},
		{"ToJSON", func() error { _, err := u.ToJSON(); return err }},
		{"Close", func() error { err := u.Close(); return err }},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if err := tc.test(); err == nil {
				t.Errorf("Expected error from %s() on closed SymbolUnit", tc.name)
			}
		})
	}
}

func TestSymbolUnit_AccessorsReturnValues(t *testing.T) {
	u, err := NewMeter()
	if err != nil {
		t.Fatalf("unexpected error creating SymbolUnit: %v", err)
	}
	defer u.Close()
	u2, err := NewMeter()
	if err != nil {
		t.Fatalf("unexpected error creating SymbolUnit: %v", err)
	}
	defer u2.Close()
	u3, err := NewKilogram()
	if err != nil {
		t.Fatalf("unexpected error creating SymbolUnit: %v", err)
	}
	defer u3.Close()
	tests := []struct {
		name string
		test func(t *testing.T)
	}{
		{"Symbol", func(t *testing.T) {
			sym, err := u.Symbol()
			if err != nil || sym == "" {
				t.Errorf("Expected non-empty symbol, got '%s', err: %v", sym, err)
			}
		}},
		{"Name", func(t *testing.T) {
			name, err := u.Name()
			if err != nil || name == "" {
				t.Errorf("Expected non-empty name, got '%s', err: %v", name, err)
			}
		}},
		{"Multiplication", func(t *testing.T) {
			res, err := u.Multiplication(u3)
			if err != nil || res == nil {
				t.Errorf("Multiplication failed: %v", err)
			}
			if res != nil {
				defer res.Close()
			}
		}},
		{"Division", func(t *testing.T) {
			res, err := u.Division(u3)
			if err != nil || res == nil {
				t.Errorf("Division failed: %v", err)
			}
			if res != nil {
				defer res.Close()
			}
		}},
		{"Power", func(t *testing.T) {
			res, err := u.Power(2)
			if err != nil || res == nil {
				t.Errorf("Power failed: %v", err)
			}
			if res != nil {
				defer res.Close()
			}
		}},
		{"WithPrefix", func(t *testing.T) {
			res, err := u.WithPrefix("k")
			if err != nil || res == nil {
				t.Errorf("WithPrefix failed: %v", err)
			}
			if res != nil {
				defer res.Close()
			}
		}},
		{"ConvertValueTo", func(t *testing.T) {
			val, err := u.ConvertValueTo(1.0, u)
			if err != nil {
				t.Errorf("ConvertValueTo failed: %v", err)
			}
			if val != 1.0 {
				t.Errorf("Expected 1.0, got %v", val)
			}
		}},
		{"IsCompatibleWith", func(t *testing.T) {
			ok, err := u.IsCompatibleWith(u2)
			if err != nil {
				t.Errorf("IsCompatibleWith failed: %v", err)
			}
			if !ok {
				t.Error("Expected IsCompatibleWith true")
			}
		}},
		{"Equal", func(t *testing.T) {
			eq, err := u.Equal(u2)
			if err != nil {
				t.Errorf("Equal error: %v", err)
			} else if !eq {
				t.Error("Expected Equal true")
			}
		}},
		{"NotEqual", func(t *testing.T) {
			neq, err := u.NotEqual(u3)
			if err != nil {
				t.Errorf("NotEqual error: %v", err)
			} else if !neq {
				t.Error("Expected NotEqual true")
			}
		}},
		{"ToJSON", func(t *testing.T) {
			js, err := u.ToJSON()
			if err != nil || js == "" {
				t.Errorf("Expected non-empty JSON, got '%s', err: %v", js, err)
			}
		}},
	}
	for _, tc := range tests {
		t.Run(tc.name, tc.test)
	}
}

func TestSymbolUnit_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestSymbolUnit_FromCAPI_Valid(t *testing.T) {
	u, err := NewMeter()
	if err != nil {
		t.Fatalf("unexpected error creating SymbolUnit: %v", err)
	}
	defer u.Close()
	capiunit := u.CAPIHandle()
	h, err := FromCAPI(capiunit)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}

func TestSymbolUnit_AllConstructors_Coverage(t *testing.T) {
	constructors := []struct {
		name        string
		constructor func() (*Handle, error)
	}{
		{"Meter", NewMeter},
		{"Kilogram", NewKilogram},
		{"Second", NewSecond},
		{"Ampere", NewAmpere},
		{"Kelvin", NewKelvin},
		{"Mole", NewMole},
		{"Candela", NewCandela},
		{"Hertz", NewHertz},
		{"Newton", NewNewton},
		{"Pascal", NewPascal},
		{"Joule", NewJoule},
		{"Watt", NewWatt},
		{"Coulomb", NewCoulomb},
		{"Volt", NewVolt},
		{"Farad", NewFarad},
		{"Ohm", NewOhm},
		{"Siemens", NewSiemens},
		{"Weber", NewWeber},
		{"Tesla", NewTesla},
		{"Henry", NewHenry},
		{"Minute", NewMinute},
		{"Hour", NewHour},
		{"Electronvolt", NewElectronvolt},
		{"Celsius", NewCelsius},
		{"Fahrenheit", NewFahrenheit},
		{"Dimensionless", NewDimensionless},
		{"Percent", NewPercent},
		{"Radian", NewRadian},
		{"Kilometer", NewKilometer},
		{"Millimeter", NewMillimeter},
		{"Millivolt", NewMillivolt},
		{"Kilovolt", NewKilovolt},
		{"Milliampere", NewMilliampere},
		{"Microampere", NewMicroampere},
		{"Nanoampere", NewNanoampere},
		{"Picoampere", NewPicoampere},
		{"Millisecond", NewMillisecond},
		{"Microsecond", NewMicrosecond},
		{"Nanosecond", NewNanosecond},
		{"Picosecond", NewPicosecond},
		{"Milliohm", NewMilliohm},
		{"Kiloohm", NewKiloohm},
		{"Megaohm", NewMegaohm},
		{"Millihertz", NewMillihertz},
		{"Kilohertz", NewKilohertz},
		{"Megahertz", NewMegahertz},
		{"Gigahertz", NewGigahertz},
		{"MetersPerSecond", NewMetersPerSecond},
		{"MetersPerSecondSquared", NewMetersPerSecondSquared},
		{"NewtonMeter", NewNewtonMeter},
		{"NewtonsPerMeter", NewNewtonsPerMeter},
		{"VoltsPerMeter", NewVoltsPerMeter},
		{"VoltsPerSecond", NewVoltsPerSecond},
		{"AmperesPerMeter", NewAmperesPerMeter},
		{"VoltsPerAmpere", NewVoltsPerAmpere},
		{"WattsPerMeterKelvin", NewWattsPerMeterKelvin},
	}
	for _, tc := range constructors {
		t.Run(tc.name, func(t *testing.T) {
			u, err := tc.constructor()
			if err != nil {
				t.Fatalf("%s returned error: %v", tc.name, err)
			}
			if u == nil {
				t.Fatalf("%s returned nil", tc.name)
			}
			defer u.Close()
			_, err = u.Name()
			if err != nil {
				t.Errorf("%s.Name() error: %v", tc.name, err)
			}
		})
	}
	t.Run("FromJSON", func(t *testing.T) {
		orig, err := NewMeter()
		if err != nil {
			t.Fatalf("NewMeter error: %v", err)
		}
		defer orig.Close()
		js, err := orig.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		u, err := FromJSON(js)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		if u == nil {
			t.Fatal("FromJSON returned nil")
		}
		defer u.Close()
	})
}
