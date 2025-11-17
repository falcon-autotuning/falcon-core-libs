package domain

import (
	"testing"
)

func TestDomain_LifecycleAndAccessors(t *testing.T) {
	d, err := New(1.0, 5.0, true, false)
	if err != nil {
		t.Fatalf("Domain New error: %v", err)
	}
	defer d.Close()

	t.Run("LesserBound", func(t *testing.T) {
		val, err := d.LesserBound()
		if err != nil {
			t.Fatalf("LesserBound() error: %v", err)
		}
		if val != 1.0 {
			t.Errorf("LesserBound() = %v, want 1.0", val)
		}
	})

	t.Run("GreaterBound", func(t *testing.T) {
		val, err := d.GreaterBound()
		if err != nil {
			t.Fatalf("GreaterBound() error: %v", err)
		}
		if val != 5.0 {
			t.Errorf("GreaterBound() = %v, want 5.0", val)
		}
	})

	t.Run("LesserBoundContained", func(t *testing.T) {
		val, err := d.LesserBoundContained()
		if err != nil {
			t.Fatalf("LesserBoundContained() error: %v", err)
		}
		if !val {
			t.Errorf("LesserBoundContained() = %v, want true", val)
		}
	})

	t.Run("GreaterBoundContained", func(t *testing.T) {
		val, err := d.GreaterBoundContained()
		if err != nil {
			t.Fatalf("GreaterBoundContained() error: %v", err)
		}
		if val {
			t.Errorf("GreaterBoundContained() = %v, want false", val)
		}
	})

	t.Run("In", func(t *testing.T) {
		in, err := d.In(1.0)
		if err != nil {
			t.Fatalf("In() error: %v", err)
		}
		if !in {
			t.Errorf("In(1.0) = false, want true")
		}
		in, err = d.In(5.0)
		if err != nil {
			t.Fatalf("In() error: %v", err)
		}
		if in {
			t.Errorf("In(5.0) = true, want false")
		}
	})

	t.Run("Range", func(t *testing.T) {
		val, err := d.Range()
		if err != nil {
			t.Fatalf("Range() error: %v", err)
		}
		if val != 4.0 {
			t.Errorf("Range() = %v, want 4.0", val)
		}
	})

	t.Run("Center", func(t *testing.T) {
		val, err := d.Center()
		if err != nil {
			t.Fatalf("Center() error: %v", err)
		}
		if val != 3.0 {
			t.Errorf("Center() = %v, want 3.0", val)
		}
	})

	t.Run("Shift", func(t *testing.T) {
		shifted, err := d.Shift(2.0)
		if err != nil {
			t.Fatalf("Shift() error: %v", err)
		}
		defer shifted.Close()
		val, err := shifted.LesserBound()
		if err != nil {
			t.Fatalf("Shifted LesserBound() error: %v", err)
		}
		if val != 3.0 {
			t.Errorf("Shifted LesserBound() = %v, want 3.0", val)
		}
	})

	t.Run("Scale", func(t *testing.T) {
		scaled, err := d.Scale(2.0)
		if err != nil {
			t.Fatalf("Scale() error: %v", err)
		}
		defer scaled.Close()
		val, err := scaled.Range()
		if err != nil {
			t.Fatalf("Scaled Range() error: %v", err)
		}
		if val != 8.0 {
			t.Errorf("Scaled Range() = %v, want 8.0", val)
		}
	})

	t.Run("IsEmpty", func(t *testing.T) {
		empty, err := d.IsEmpty()
		if err != nil {
			t.Fatalf("IsEmpty() error: %v", err)
		}
		if empty {
			t.Errorf("IsEmpty() = true, want false")
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := d.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		d2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("DomainFromJSON error: %v", err)
		}
		defer d2.Close()
		val, err := d2.LesserBound()
		if err != nil {
			t.Fatalf("DomainFromJSON LesserBound error: %v", err)
		}
		if val != 1.0 {
			t.Errorf("DomainFromJSON/ToJSON roundtrip failed: got %v, want 1.0", val)
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

	t.Run("Intersection_Union_ContainsDomain_Transform", func(t *testing.T) {
		d2, err := New(2.0, 6.0, true, true)
		if err != nil {
			t.Fatalf("Domain New error: %v", err)
		}
		defer d2.Close()
		inter, err := d.Intersection(d2)
		if err != nil {
			t.Fatalf("Intersection() error: %v", err)
		}
		defer inter.Close()
		union, err := d.Union(d2)
		if err != nil {
			t.Fatalf("Union() error: %v", err)
		}
		defer union.Close()
		contains, err := union.ContainsDomain(d)
		if err != nil {
			t.Fatalf("ContainsDomain() error: %v", err)
		}
		if !contains {
			t.Errorf("Union.ContainsDomain(d) = false, want true")
		}
		val, err := d.Transform(d2, 3.0)
		if err != nil {
			t.Fatalf("Transform() error: %v", err)
		}
		_ = val // Just check for error, value is implementation-defined
	})
}

func TestDomain_ClosedErrors(t *testing.T) {
	d, err := New(1.0, 2.0, true, true)
	if err != nil {
		t.Fatalf("Domain New error: %v", err)
	}
	d.Close()
	if _, err := d.LesserBound(); err == nil {
		t.Error("LesserBound() on closed domain: expected error")
	}
	if _, err := d.GreaterBound(); err == nil {
		t.Error("GreaterBound() on closed domain: expected error")
	}
	if _, err := d.LesserBoundContained(); err == nil {
		t.Error("LesserBoundContained() on closed domain: expected error")
	}
	if _, err := d.GreaterBoundContained(); err == nil {
		t.Error("GreaterBoundContained() on closed domain: expected error")
	}
	if _, err := d.In(1.5); err == nil {
		t.Error("In() on closed domain: expected error")
	}
	if _, err := d.Range(); err == nil {
		t.Error("Range() on closed domain: expected error")
	}
	if _, err := d.Center(); err == nil {
		t.Error("Center() on closed domain: expected error")
	}
	if _, err := d.Shift(1.0); err == nil {
		t.Error("Shift() on closed domain: expected error")
	}
	if _, err := d.Scale(2.0); err == nil {
		t.Error("Scale() on closed domain: expected error")
	}
	if _, err := d.IsEmpty(); err == nil {
		t.Error("IsEmpty() on closed domain: expected error")
	}
	if _, err := d.ToJSON(); err == nil {
		t.Error("ToJSON() on closed domain: expected error")
	}
	other, err := New(2.0, 3.0, true, true)
	if err != nil {
		t.Fatalf("Domain New error: %v", err)
	}
	defer other.Close()
	if _, err := d.Intersection(other); err == nil {
		t.Error("Intersection() on closed domain: expected error")
	}
	if _, err := d.Union(other); err == nil {
		t.Error("Union() on closed domain: expected error")
	}
	if _, err := d.ContainsDomain(other); err == nil {
		t.Error("ContainsDomain() on closed domain: expected error")
	}
	if _, err := d.Transform(other, 1.0); err == nil {
		t.Error("Transform() on closed domain: expected error")
	}
	if _, err := d.Equal(other); err == nil {
		t.Error("Equal() on closed domain: expected error")
	}
	if _, err := d.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed domain: expected error")
	}
	if err := d.Close(); err == nil {
		t.Error("Close() on closed domain: expected error")
	}
}

func TestDomain_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestDomain_FromCAPI_Valid(t *testing.T) {
	d, err := New(1.0, 2.0, true, true)
	if err != nil {
		t.Fatalf("Domain New error: %v", err)
	}
	defer d.Close()
	capi, err := d.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert domain to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
