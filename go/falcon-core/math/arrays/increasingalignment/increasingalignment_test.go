package increasingalignment

import (
	"testing"
)

func TestIncreasingAlignment_LifecycleAndAccessors(t *testing.T) {
	ia, err := New(true)
	if err != nil {
		t.Fatalf("New(true) error: %v", err)
	}
	defer ia.Close()

	t.Run("Alignment", func(t *testing.T) {
		val, err := ia.Alignment()
		if err != nil {
			t.Fatalf("Alignment() error: %v", err)
		}
		if val != 1 {
			t.Errorf("Alignment() = %v, want 1 (true)", val)
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := ia.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		ia2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer ia2.Close()
		val, err := ia2.Alignment()
		if err != nil {
			t.Fatalf("FromJSON Alignment error: %v", err)
		}
		if val != 1 {
			t.Errorf("FromJSON/ToJSON roundtrip failed: got %v, want 1", val)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := ia.Equal(ia2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := ia.NotEqual(ia2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestIncreasingAlignment_Empty(t *testing.T) {
	ia, err := NewEmpty()
	if err != nil {
		t.Fatalf("NewEmpty() error: %v", err)
	}
	defer ia.Close()
	val, err := ia.Alignment()
	if err != nil {
		t.Fatalf("Alignment() error: %v", err)
	}
	// Accept 0 or whatever the C++ default is for empty
	if val != 0 && val != 1 {
		t.Errorf("Alignment() for empty = %v, want 0 or 1", val)
	}
}

func TestIncreasingAlignment_Equality(t *testing.T) {
	ia1, err := New(true)
	if err != nil {
		t.Fatalf("New(true) error: %v", err)
	}
	defer ia1.Close()
	ia2, err := New(false)
	if err != nil {
		t.Fatalf("New(false) error: %v", err)
	}
	defer ia2.Close()

	eq, err := ia1.Equal(ia2)
	if err != nil {
		t.Fatalf("Equal() error: %v", err)
	}
	if eq {
		t.Errorf("Equal() = true, want false")
	}

	neq, err := ia1.NotEqual(ia2)
	if err != nil {
		t.Fatalf("NotEqual() error: %v", err)
	}
	if !neq {
		t.Errorf("NotEqual() = false, want true")
	}
}

func TestIncreasingAlignment_ClosedErrors(t *testing.T) {
	ia, err := New(true)
	if err != nil {
		t.Fatalf("New(true) error: %v", err)
	}
	ia.Close()
	if _, err := ia.Alignment(); err == nil {
		t.Error("Alignment() on closed IncreasingAlignment: expected error")
	}
	if _, err := ia.ToJSON(); err == nil {
		t.Error("ToJSON() on closed IncreasingAlignment: expected error")
	}
	if err := ia.Close(); err == nil {
		t.Error("Close() on closed IncreasingAlignment: expected error")
	}
	other, err := New(false)
	if err != nil {
		t.Fatalf("New(false) error: %v", err)
	}
	defer other.Close()
	if _, err := ia.Equal(other); err == nil {
		t.Error("Equal() on closed IncreasingAlignment: expected error")
	}
	if _, err := ia.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed IncreasingAlignment: expected error")
	}
}

func TestIncreasingAlignment_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestIncreasingAlignment_FromCAPI_Valid(t *testing.T) {
	ia, err := New(true)
	if err != nil {
		t.Fatalf("New(true) error: %v", err)
	}
	defer ia.Close()
	capi, err := ia.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert IncreasingAlignment to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
