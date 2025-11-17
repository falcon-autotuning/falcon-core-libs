package discretizer

import (
	"testing"
)

func TestDiscretizer_LifecycleAndAccessors(t *testing.T) {
	d, err := NewCartesian(0.5)
	if err != nil {
		t.Fatalf("Discretizer NewCartesian error: %v", err)
	}
	defer d.Close()

	t.Run("Delta", func(t *testing.T) {
		val, err := d.Delta()
		if err != nil {
			t.Fatalf("Delta() error: %v", err)
		}
		if val != 0.5 {
			t.Errorf("Delta() = %v, want 0.5", val)
		}
	})

	t.Run("SetDelta", func(t *testing.T) {
		err := d.SetDelta(1.0)
		if err != nil {
			t.Fatalf("SetDelta() error: %v", err)
		}
		val, err := d.Delta()
		if err != nil {
			t.Fatalf("Delta() after SetDelta error: %v", err)
		}
		if val != 1.0 {
			t.Errorf("Delta() after SetDelta = %v, want 1.0", val)
		}
	})

	t.Run("Domain", func(t *testing.T) {
		dom, err := d.Domain()
		if err != nil {
			t.Fatalf("Domain() error: %v", err)
		}
		if dom == nil {
			t.Fatalf("Domain() returned nil")
		}
		defer dom.Close()
	})

	t.Run("IsCartesian", func(t *testing.T) {
		val, err := d.IsCartesian()
		if err != nil {
			t.Fatalf("IsCartesian() error: %v", err)
		}
		if !val {
			t.Errorf("IsCartesian() = false, want true")
		}
	})

	t.Run("IsPolar", func(t *testing.T) {
		val, err := d.IsPolar()
		if err != nil {
			t.Fatalf("IsPolar() error: %v", err)
		}
		if val {
			t.Errorf("IsPolar() = true, want false")
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := d.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		d2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("DiscretizerFromJSON error: %v", err)
		}
		defer d2.Close()
		val, err := d2.Delta()
		if err != nil {
			t.Fatalf("DiscretizerFromJSON Delta error: %v", err)
		}
		if val != 1.0 {
			t.Errorf("DiscretizerFromJSON/ToJSON roundtrip failed: got %v, want 1.0", val)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := d.Equal(d2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := d.NotEqual(d2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestDiscretizer_Polar(t *testing.T) {
	d, err := NewPolar(2.0)
	if err != nil {
		t.Fatalf("Discretizer NewPolar error: %v", err)
	}
	defer d.Close()
	val, err := d.IsPolar()
	if err != nil {
		t.Fatalf("IsPolar() error: %v", err)
	}
	if !val {
		t.Errorf("IsPolar() = false, want true")
	}
	val, err = d.IsCartesian()
	if err != nil {
		t.Fatalf("IsCartesian() error: %v", err)
	}
	if val {
		t.Errorf("IsCartesian() = true, want false")
	}
}

func TestDiscretizer_ClosedErrors(t *testing.T) {
	d, err := NewCartesian(1.0)
	if err != nil {
		t.Fatalf("Discretizer NewCartesian error: %v", err)
	}
	d.Close()
	if _, err := d.Delta(); err == nil {
		t.Error("Delta() on closed discretizer: expected error")
	}
	if err := d.SetDelta(2.0); err == nil {
		t.Error("SetDelta() on closed discretizer: expected error")
	}
	if _, err := d.Domain(); err == nil {
		t.Error("Domain() on closed discretizer: expected error")
	}
	if _, err := d.IsCartesian(); err == nil {
		t.Error("IsCartesian() on closed discretizer: expected error")
	}
	if _, err := d.IsPolar(); err == nil {
		t.Error("IsPolar() on closed discretizer: expected error")
	}
	other, err := NewCartesian(2.0)
	if err != nil {
		t.Fatalf("Discretizer NewCartesian error: %v", err)
	}
	defer other.Close()
	if _, err := d.Equal(other); err == nil {
		t.Error("Equal() on closed discretizer: expected error")
	}
	if _, err := d.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed discretizer: expected error")
	}
	if _, err := d.ToJSON(); err == nil {
		t.Error("ToJSON() on closed discretizer: expected error")
	}
	if err := d.Close(); err == nil {
		t.Error("Close() on closed discretizer: expected error")
	}
}

func TestDiscretizer_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestDiscretizer_FromCAPI_Valid(t *testing.T) {
	d, err := NewCartesian(1.0)
	if err != nil {
		t.Fatalf("Discretizer NewCartesian error: %v", err)
	}
	defer d.Close()
	capi, err := d.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert discretizer to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
