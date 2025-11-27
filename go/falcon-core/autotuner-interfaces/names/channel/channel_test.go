package channel

import (
	"testing"
)

func TestChannel_LifecycleAndAccessors(t *testing.T) {
	ch, err := New("test_channel")
	if err != nil {
		t.Fatalf("Channel New error: %v", err)
	}
	defer ch.Close()

	t.Run("Name", func(t *testing.T) {
		name, err := ch.Name()
		if err != nil {
			t.Fatalf("Name() error: %v", err)
		}
		if name != "test_channel" {
			t.Errorf("Name() = %v, want test_channel", name)
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		jsonStr, err := ch.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		ch2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("ChannelFromJSON error: %v", err)
		}
		defer ch2.Close()
		name2, err := ch2.Name()
		if err != nil {
			t.Fatalf("ChannelFromJSON Name error: %v", err)
		}
		if name2 != "test_channel" {
			t.Errorf("ChannelFromJSON/ToJSON roundtrip failed: got %v, want test_channel", name2)
		}

		t.Run("Equal", func(t *testing.T) {
			eq, err := ch.Equal(ch2)
			if err != nil {
				t.Fatalf("Equal() error: %v", err)
			}
			if !eq {
				t.Errorf("Equal() = false, want true")
			}
		})

		t.Run("NotEqual", func(t *testing.T) {
			neq, err := ch.NotEqual(ch2)
			if err != nil {
				t.Fatalf("NotEqual() error: %v", err)
			}
			if neq {
				t.Errorf("NotEqual() = true, want false")
			}
		})
	})
}

func TestChannel_ClosedErrors(t *testing.T) {
	ch, err := New("closed_channel")
	if err != nil {
		t.Fatalf("Channel New error: %v", err)
	}
	ch.Close()
	if _, err := ch.Name(); err == nil {
		t.Error("Name() on closed channel: expected error")
	}
	if _, err := ch.ToJSON(); err == nil {
		t.Error("ToJSON() on closed channel: expected error")
	}
	if err := ch.Close(); err == nil {
		t.Error("Close() on closed channel: expected error")
	}
	other, err := New("other_channel")
	if err != nil {
		t.Fatalf("Channel New error: %v", err)
	}
	defer other.Close()
	if _, err := ch.Equal(other); err == nil {
		t.Error("Equal() on closed channel: expected error")
	}
	if _, err := ch.NotEqual(other); err == nil {
		t.Error("NotEqual() on closed channel: expected error")
	}
}

func TestChannel_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestChannel_FromCAPI_Valid(t *testing.T) {
	ch, err := New("foo")
	if err != nil {
		t.Fatalf("Channel New error: %v", err)
	}
	defer ch.Close()
	capi := ch.CAPIHandle()
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
