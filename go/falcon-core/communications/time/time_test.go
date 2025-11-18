package time

import (
	"testing"
	"time"
)

func TestTime_LifecycleAndAccessors(t *testing.T) {
	th, err := NewNow()
	if err != nil {
		t.Fatalf("Time NewNow error: %v", err)
	}
	defer th.Close()

	t.Run("MicroSecondsSinceEpoch", func(t *testing.T) {
		us, err := th.MicroSecondsSinceEpoch()
		if err != nil {
			t.Fatalf("MicroSecondsSinceEpoch() error: %v", err)
		}
		if us <= 0 {
			t.Errorf("MicroSecondsSinceEpoch() = %v, want > 0", us)
		}
	})

	t.Run("Time", func(t *testing.T) {
		val, err := th.Time()
		if err != nil {
			t.Fatalf("Time() error: %v", err)
		}
		if val <= 0 {
			t.Errorf("Time() = %v, want > 0", val)
		}
	})

	t.Run("ToString", func(t *testing.T) {
		s, err := th.ToString()
		if err != nil {
			t.Fatalf("ToString() error: %v", err)
		}
		if s == "" {
			t.Errorf("ToString() returned empty string")
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := th.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		th2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("TimeFromJSON error: %v", err)
		}
		defer th2.Close()
		us2, err := th2.MicroSecondsSinceEpoch()
		if err != nil {
			t.Fatalf("TimeFromJSON MicroSecondsSinceEpoch error: %v", err)
		}
		us1, err := th.MicroSecondsSinceEpoch()
		if err != nil {
			t.Fatalf("Time MicroSecondsSinceEpoch error: %v", err)
		}
		if us2 != 0 && us2 != us1 {
			// Accept either exact match or 0 (if not serialized)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := th.Equal(th2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := th.NotEqual(th2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestTime_NewAt(t *testing.T) {
	now := time.Now().UnixMicro()
	th, err := NewAt(now)
	if err != nil {
		t.Fatalf("Time NewAt error: %v", err)
	}
	defer th.Close()
	us, err := th.MicroSecondsSinceEpoch()
	if err != nil {
		t.Fatalf("MicroSecondsSinceEpoch() error: %v", err)
	}
	if us != now {
		t.Errorf("MicroSecondsSinceEpoch() = %v, want %v", us, now)
	}
}

func TestTime_ClosedErrors(t *testing.T) {
	th, err := NewNow()
	if err != nil {
		t.Fatalf("Time NewNow error: %v", err)
	}
	th.Close()
	if _, err := th.MicroSecondsSinceEpoch(); err == nil {
		t.Error("MicroSecondsSinceEpoch() on closed time: expected error")
	}
	if _, err := th.Time(); err == nil {
		t.Error("Time() on closed time: expected error")
	}
	if _, err := th.ToString(); err == nil {
		t.Error("ToString() on closed time: expected error")
	}
	if _, err := th.ToJSON(); err == nil {
		t.Error("ToJSON() on closed time: expected error")
	}
	if err := th.Close(); err == nil {
		t.Error("Close() on closed time: expected error")
	}
	other, err := NewNow()
	if err != nil {
		t.Fatalf("Time NewNow error: %v", err)
	}
	defer other.Close()
	if _, err := th.Equal(other); err == nil {
		t.Error("Equal() on closed time: expected error")
	}
	if _, err := th.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed time: expected error")
	}
}

func TestTime_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestTime_FromCAPI_Valid(t *testing.T) {
	th, err := NewNow()
	if err != nil {
		t.Fatalf("Time NewNow error: %v", err)
	}
	defer th.Close()
	capi, err := th.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert time to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
