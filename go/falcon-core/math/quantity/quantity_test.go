package quantity

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func newVoltQ(val float64) *Handle {
	volt, _ := symbolunit.NewVolt()
	q, _ := New(val, volt)
	return q
}

func TestQuantity_LifecycleAndAccessors(t *testing.T) {
	volt, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("symbol could not be created: %v", err)
	}
	q, err := New(42.0, volt)
	if err != nil {
		t.Fatalf("Quantity New error: %v", err)
	}
	defer q.Close()
	t.Run("Value", func(t *testing.T) {
		val, err := q.Value()
		if err != nil {
			t.Fatalf("Value() error: %v", err)
		}
		if val != 42.0 {
			t.Errorf("Value() = %v, want 42.0", val)
		}
	})
	t.Run("Unit", func(t *testing.T) {
		unit, err := q.Unit()
		if err != nil {
			t.Fatalf("Unit() error: %v", err)
		}
		if unit == nil {
			t.Errorf("Unit() returned nil")
		}
		defer unit.Close()
	})
	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := q.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		q2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("QuantityFromJSON error: %v", err)
		}
		defer q2.Close()
		val, err := q2.Value()
		if err != nil {
			t.Fatalf("QuantityFromJSON Value error: %v", err)
		}
		if val != 42.0 {
			t.Errorf("QuantityFromJSON/ToJSON roundtrip failed: got %v, want 42.0", val)
		}
		t.Run("Equal", func(t *testing.T) {
			eq, err := q.Equal(q2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})
		t.Run("NotEqual", func(t *testing.T) {
			neq, err := q.NotEqual(q2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestQuantity_Arithmetic(t *testing.T) {
	q := newVoltQ(10.0)
	defer q.Close()
	other := newVoltQ(2.0)
	defer other.Close()

	t.Run("MultiplyInt", func(t *testing.T) {
		res, err := q.MultiplyInt(2)
		if err != nil {
			t.Fatalf("MultiplyInt() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 20.0 {
			t.Errorf("MultiplyInt() = %v, want 20.0", val)
		}
	})
	t.Run("MultiplyDouble", func(t *testing.T) {
		res, err := q.MultiplyDouble(2.5)
		if err != nil {
			t.Fatalf("MultiplyDouble() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 25.0 {
			t.Errorf("MultiplyDouble() = %v, want 25.0", val)
		}
	})
	t.Run("MultiplyQuantity", func(t *testing.T) {
		res, err := q.MultiplyQuantity(other)
		if err != nil {
			t.Fatalf("MultiplyQuantity() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 20.0 {
			t.Errorf("MultiplyQuantity() = %v, want 20.0", val)
		}
	})
	t.Run("DivideInt", func(t *testing.T) {
		res, err := q.DivideInt(2)
		if err != nil {
			t.Fatalf("DivideInt() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 5.0 {
			t.Errorf("DivideInt() = %v, want 5.0", val)
		}
	})
	t.Run("DivideDouble", func(t *testing.T) {
		res, err := q.DivideDouble(2.0)
		if err != nil {
			t.Fatalf("DivideDouble() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 5.0 {
			t.Errorf("DivideDouble() = %v, want 5.0", val)
		}
	})
	t.Run("DivideQuantity", func(t *testing.T) {
		res, err := q.DivideQuantity(other)
		if err != nil {
			t.Fatalf("DivideQuantity() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 5.0 {
			t.Errorf("DivideQuantity() = %v, want 5.0", val)
		}
	})
	t.Run("Power", func(t *testing.T) {
		res, err := q.Power(2)
		if err != nil {
			t.Fatalf("Power() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 100.0 {
			t.Errorf("Power() = %v, want 100.0", val)
		}
	})
	t.Run("AddQuantity", func(t *testing.T) {
		res, err := q.AddQuantity(other)
		if err != nil {
			t.Fatalf("AddQuantity() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 12.0 {
			t.Errorf("AddQuantity() = %v, want 12.0", val)
		}
	})
	t.Run("SubtractQuantity", func(t *testing.T) {
		res, err := q.SubtractQuantity(other)
		if err != nil {
			t.Fatalf("SubtractQuantity() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != 8.0 {
			t.Errorf("SubtractQuantity() = %v, want 8.0", val)
		}
	})
	t.Run("Negate", func(t *testing.T) {
		res, err := q.Negate()
		if err != nil {
			t.Fatalf("Negate() error: %v", err)
		}
		defer res.Close()
		val, _ := res.Value()
		if val != -10.0 {
			t.Errorf("Negate() = %v, want -10.0", val)
		}
	})
	t.Run("Abs", func(t *testing.T) {
		res, err := q.Negate()
		if err != nil {
			t.Fatalf("Negate() error: %v", err)
		}
		defer res.Close()
		abs, err := res.Abs()
		if err != nil {
			t.Fatalf("Abs() error: %v", err)
		}
		defer abs.Close()
		val, _ := abs.Value()
		if val != 10.0 {
			t.Errorf("Abs() = %v, want 10.0", val)
		}
	})
}

func TestQuantity_EqualsArithmetic(t *testing.T) {
	// Each test uses a fresh quantity to avoid state contamination
	t.Run("MultiplyEqualsInt", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		_, err := q.MultiplyEqualsInt(2)
		if err != nil {
			t.Fatalf("MultiplyEqualsInt() error: %v", err)
		}
		val, _ := q.Value()
		if val != 20.0 {
			t.Errorf("MultiplyEqualsInt() = %v, want 20.0", val)
		}
	})
	t.Run("MultiplyEqualsDouble", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		_, err := q.MultiplyEqualsDouble(2.5)
		if err != nil {
			t.Fatalf("MultiplyEqualsDouble() error: %v", err)
		}
		val, _ := q.Value()
		if val != 25.0 {
			t.Errorf("MultiplyEqualsDouble() = %v, want 25.0", val)
		}
	})
	t.Run("MultiplyEqualsQuantity", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		other := newVoltQ(2.0)
		defer other.Close()
		_, err := q.MultiplyEqualsQuantity(other)
		if err != nil {
			t.Fatalf("MultiplyEqualsQuantity() error: %v", err)
		}
		val, _ := q.Value()
		if val != 20.0 {
			t.Errorf("MultiplyEqualsQuantity() = %v, want 20.0", val)
		}
	})
	t.Run("DivideEqualsInt", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		_, err := q.DivideEqualsInt(2)
		if err != nil {
			t.Fatalf("DivideEqualsInt() error: %v", err)
		}
		val, _ := q.Value()
		if val != 5.0 {
			t.Errorf("DivideEqualsInt() = %v, want 5.0", val)
		}
	})
	t.Run("DivideEqualsDouble", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		_, err := q.DivideEqualsDouble(2.0)
		if err != nil {
			t.Fatalf("DivideEqualsDouble() error: %v", err)
		}
		val, _ := q.Value()
		if val != 5.0 {
			t.Errorf("DivideEqualsDouble() = %v, want 5.0", val)
		}
	})
	t.Run("DivideEqualsQuantity", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		other := newVoltQ(2.0)
		defer other.Close()
		_, err := q.DivideEqualsQuantity(other)
		if err != nil {
			t.Fatalf("DivideEqualsQuantity() error: %v", err)
		}
		val, _ := q.Value()
		if val != 5.0 {
			t.Errorf("DivideEqualsQuantity() = %v, want 5.0", val)
		}
	})
	t.Run("AddEqualsQuantity", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		other := newVoltQ(2.0)
		defer other.Close()
		_, err := q.AddEqualsQuantity(other)
		if err != nil {
			t.Fatalf("AddEqualsQuantity() error: %v", err)
		}
		val, _ := q.Value()
		if val != 12.0 {
			t.Errorf("AddEqualsQuantity() = %v, want 12.0", val)
		}
	})
	t.Run("SubtractEqualsQuantity", func(t *testing.T) {
		q := newVoltQ(10.0)
		defer q.Close()
		other := newVoltQ(2.0)
		defer other.Close()
		_, err := q.SubtractEqualsQuantity(other)
		if err != nil {
			t.Fatalf("SubtractEqualsQuantity() error: %v", err)
		}
		val, _ := q.Value()
		if val != 8.0 {
			t.Errorf("SubtractEqualsQuantity() = %v, want 8.0", val)
		}
	})
}

func TestQuantity_ClosedErrors(t *testing.T) {
	volt, _ := symbolunit.NewVolt()
	q, _ := New(1.0, volt)
	q.Close()
	if _, err := q.Value(); err == nil {
		t.Error("Value() on closed quantity: expected error")
	}
	if _, err := q.Unit(); err == nil {
		t.Error("Unit() on closed quantity: expected error")
	}
	if _, err := q.MultiplyInt(2); err == nil {
		t.Error("MultiplyInt() on closed quantity: expected error")
	}
	if _, err := q.DivideInt(2); err == nil {
		t.Error("DivideInt() on closed quantity: expected error")
	}
	if _, err := q.Power(2); err == nil {
		t.Error("Power() on closed quantity: expected error")
	}
	if _, err := q.Negate(); err == nil {
		t.Error("Negate() on closed quantity: expected error")
	}
	if _, err := q.Abs(); err == nil {
		t.Error("Abs() on closed quantity: expected error")
	}
	if _, err := q.ToJSON(); err == nil {
		t.Error("ToJSON() on closed quantity: expected error")
	}
	if err := q.Close(); err == nil {
		t.Error("Close() on closed quantity: expected error")
	}
}

func TestQuantity_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestQuantity_FromCAPI_Valid(t *testing.T) {
	volt, _ := symbolunit.NewVolt()
	q, _ := New(1.0, volt)
	defer q.Close()
	capi, err := q.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert quantity to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
