package standardrequest

import (
	"testing"
)

func TestStandardRequest_LifecycleAndAccessors(t *testing.T) {
	sr, err := New("test_message")
	if err != nil {
		t.Fatalf("StandardRequest New error: %v", err)
	}
	defer sr.Close()

	t.Run("Message", func(t *testing.T) {
		msg, err := sr.Message()
		if err != nil {
			t.Fatalf("Message() error: %v", err)
		}
		if msg != "test_message" {
			t.Errorf("Message() = %v, want test_message", msg)
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := sr.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		sr2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("StandardRequestFromJSON error: %v", err)
		}
		defer sr2.Close()
		msg2, err := sr2.Message()
		if err != nil {
			t.Fatalf("StandardRequestFromJSON Message error: %v", err)
		}
		if msg2 != "test_message" {
			t.Errorf("StandardRequestFromJSON/ToJSON roundtrip failed: got %v, want test_message", msg2)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := sr.Equal(sr2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := sr.NotEqual(sr2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestStandardRequest_ClosedErrors(t *testing.T) {
	sr, err := New("closed_message")
	if err != nil {
		t.Fatalf("StandardRequest New error: %v", err)
	}
	sr.Close()
	if _, err := sr.Message(); err == nil {
		t.Error("Message() on closed StandardRequest: expected error")
	}
	if _, err := sr.ToJSON(); err == nil {
		t.Error("ToJSON() on closed StandardRequest: expected error")
	}
	if err := sr.Close(); err == nil {
		t.Error("Close() on closed StandardRequest: expected error")
	}
	other, err := New("other_message")
	if err != nil {
		t.Fatalf("StandardRequest New error: %v", err)
	}
	defer other.Close()
	if _, err := sr.Equal(other); err == nil {
		t.Error("Equal() on closed StandardRequest: expected error")
	}
	if _, err := sr.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed StandardRequest: expected error")
	}
}

func TestStandardRequest_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestStandardRequest_FromCAPI_Valid(t *testing.T) {
	sr, err := New("foo")
	if err != nil {
		t.Fatalf("StandardRequest New error: %v", err)
	}
	defer sr.Close()
	capi, err := sr.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert StandardRequest to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
