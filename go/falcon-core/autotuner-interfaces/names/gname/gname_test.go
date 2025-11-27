package gname

import (
	"testing"
)

func TestGname_LifecycleAndAccessors(t *testing.T) {
	gn, err := New("test_gname")
	if err != nil {
		t.Fatalf("Gname New error: %v", err)
	}
	defer gn.Close()

	t.Run("Gname", func(t *testing.T) {
		name, err := gn.Gname()
		if err != nil {
			t.Fatalf("Gname() error: %v", err)
		}
		if name != "test_gname" {
			t.Errorf("Gname() = %v, want test_gname", name)
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := gn.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		gn2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("GnameFromJSON error: %v", err)
		}
		defer gn2.Close()
		name2, err := gn2.Gname()
		if err != nil {
			t.Fatalf("GnameFromJSON Gname error: %v", err)
		}
		if name2 != "test_gname" {
			t.Errorf("GnameFromJSON/ToJSON roundtrip failed: got %v, want test_gname", name2)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := gn.Equal(gn2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := gn.NotEqual(gn2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestGname_NewFromNum(t *testing.T) {
	gn, err := NewFromNum(42)
	if err != nil {
		t.Fatalf("Gname NewFromNum error: %v", err)
	}
	defer gn.Close()
	name, err := gn.Gname()
	if err != nil {
		t.Fatalf("Gname() error: %v", err)
	}
	if name == "" {
		t.Errorf("Gname() from num should not be empty")
	}
}

func TestGname_ClosedErrors(t *testing.T) {
	gn, err := New("closed_gname")
	if err != nil {
		t.Fatalf("Gname New error: %v", err)
	}
	gn.Close()
	if _, err := gn.Gname(); err == nil {
		t.Error("Gname() on closed gname: expected error")
	}
	if _, err := gn.ToJSON(); err == nil {
		t.Error("ToJSON() on closed gname: expected error")
	}
	if err := gn.Close(); err == nil {
		t.Error("Close() on closed gname: expected error")
	}
	other, err := New("other_gname")
	if err != nil {
		t.Fatalf("Gname New error: %v", err)
	}
	defer other.Close()
	if _, err := gn.Equal(other); err == nil {
		t.Error("Equal() on closed gname: expected error")
	}
	if _, err := gn.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed gname: expected error")
	}
}

func TestGname_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestGname_FromCAPI_Valid(t *testing.T) {
	gn, err := New("foo")
	if err != nil {
		t.Fatalf("Gname New error: %v", err)
	}
	defer gn.Close()
	capi := gn.CAPIHandle()
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
