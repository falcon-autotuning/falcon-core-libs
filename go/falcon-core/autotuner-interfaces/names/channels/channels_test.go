package channels

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
)

func mustChannel(name string) *channel.Handle {
	h, err := channel.New(name)
	if err != nil {
		panic(err)
	}
	return h
}

func TestChannels_LifecycleAndAccessors(t *testing.T) {
	ch1 := mustChannel("A")
	ch2 := mustChannel("B")
	defer ch1.Close()
	defer ch2.Close()

	t.Run("NewEmpty", func(t *testing.T) {
		c, err := NewEmpty()
		if err != nil {
			t.Fatalf("NewEmpty() error: %v", err)
		}
		defer c.Close()
		empty, err := c.Empty()
		if err != nil {
			t.Fatalf("Empty() error: %v", err)
		}
		if !empty {
			t.Errorf("Empty() = false, want true")
		}
		size, err := c.Size()
		if err != nil {
			t.Fatalf("Size() error: %v", err)
		}
		if size != 0 {
			t.Errorf("Size() = %v, want 0", size)
		}
	})

	t.Run("New", func(t *testing.T) {
		c, err := New([]*channel.Handle{ch1, ch2})
		if err != nil {
			t.Fatalf("New() error: %v", err)
		}
		defer c.Close()
		empty, err := c.Empty()
		if err != nil {
			t.Fatalf("Empty() error: %v", err)
		}
		if empty {
			t.Errorf("Empty() = true, want false")
		}
		size, err := c.Size()
		if err != nil {
			t.Fatalf("Size() error: %v", err)
		}
		if size != 2 {
			t.Errorf("Size() = %v, want 2", size)
		}
	})

	t.Run("PushBack_At_EraseAt_Clear", func(t *testing.T) {
		c, _ := NewEmpty()
		defer c.Close()
		if err := c.PushBack(ch1); err != nil {
			t.Fatalf("PushBack() error: %v", err)
		}
		if err := c.PushBack(ch2); err != nil {
			t.Fatalf("PushBack() error: %v", err)
		}
		val, err := c.At(0)
		if err != nil {
			t.Fatalf("At(0) error: %v", err)
		}
		name, _ := val.Name()
		if name != "A" {
			t.Errorf("At(0) = %v, want A", name)
		}
		if err := c.EraseAt(0); err != nil {
			t.Fatalf("EraseAt(0) error: %v", err)
		}
		size, _ := c.Size()
		if size != 1 {
			t.Errorf("Size() after EraseAt = %v, want 1", size)
		}
		if err := c.Clear(); err != nil {
			t.Fatalf("Clear() error: %v", err)
		}
		size, _ = c.Size()
		if size != 0 {
			t.Errorf("Size() after Clear = %v, want 0", size)
		}
	})

	t.Run("Items", func(t *testing.T) {
		c, _ := New([]*channel.Handle{ch1, ch2})
		defer c.Close()
		items, err := c.Items()
		if err != nil {
			t.Fatalf("Items() error: %v", err)
		}
		if size, _ := items.Size(); size != 2 {
			t.Errorf("Items() len = %v, want 2", size)
		}
	})

	t.Run("Contains_Index", func(t *testing.T) {
		c, _ := New([]*channel.Handle{ch1, ch2})
		defer c.Close()
		ok, err := c.Contains(ch2)
		if err != nil {
			t.Fatalf("Contains() error: %v", err)
		}
		if !ok {
			t.Errorf("Contains() = false, want true")
		}
		idx, err := c.Index(ch2)
		if err != nil {
			t.Fatalf("Index() error: %v", err)
		}
		if idx != 1 {
			t.Errorf("Index() = %v, want 1", idx)
		}
	})

	t.Run("Intersection_Equal_NotEqual", func(t *testing.T) {
		c1, _ := New([]*channel.Handle{ch1, ch2})
		defer c1.Close()
		c2, _ := New([]*channel.Handle{ch2})
		defer c2.Close()
		inter, err := c1.Intersection(c2)
		if err != nil {
			t.Fatalf("Intersection() error: %v", err)
		}
		defer inter.Close()
		size, _ := inter.Size()
		if size != 1 {
			t.Errorf("Intersection size = %v, want 1", size)
		}
		eq, err := c1.Equal(c1)
		if err != nil {
			t.Fatalf("Equal() error: %v", err)
		}
		if !eq {
			t.Errorf("Equal() = false, want true")
		}
		neq, err := c1.NotEqual(c2)
		if err != nil {
			t.Fatalf("NotEqual() error: %v", err)
		}
		if !neq {
			t.Errorf("NotEqual() = false, want true")
		}
	})

	t.Run("ToJSON_And_FromJSON", func(t *testing.T) {
		c, _ := New([]*channel.Handle{ch1, ch2})
		defer c.Close()
		jsonStr, err := c.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON() error: %v", err)
		}
		c2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON() error: %v", err)
		}
		defer c2.Close()
		eq, err := c.Equal(c2)
		if err != nil {
			t.Fatalf("Equal() error: %v", err)
		}
		if !eq {
			t.Errorf("Equal() after ToJSON/FromJSON = false, want true")
		}
	})
}

func TestChannels_ClosedErrors(t *testing.T) {
	ch := mustChannel("A")
	c, _ := New([]*channel.Handle{ch})
	c.Close()
	if _, err := c.Size(); err == nil {
		t.Error("Size() on closed Channels: expected error")
	}
	if _, err := c.Empty(); err == nil {
		t.Error("Empty() on closed Channels: expected error")
	}
	if err := c.PushBack(ch); err == nil {
		t.Error("PushBack() on closed Channels: expected error")
	}
	if err := c.EraseAt(0); err == nil {
		t.Error("EraseAt() on closed Channels: expected error")
	}
	if err := c.Clear(); err == nil {
		t.Error("Clear() on closed Channels: expected error")
	}
	if _, err := c.At(0); err == nil {
		t.Error("At() on closed Channels: expected error")
	}
	if _, err := c.Items(); err == nil {
		t.Error("Items() on closed Channels: expected error")
	}
	if _, err := c.Contains(ch); err == nil {
		t.Error("Contains() on closed Channels: expected error")
	}
	if _, err := c.Index(ch); err == nil {
		t.Error("Index() on closed Channels: expected error")
	}
	if _, err := c.Equal(c); err == nil {
		t.Error("Equal() on closed Channels: expected error")
	}
	if _, err := c.NotEqual(c); err == nil {
		t.Error("NotEqual() on closed Channels: expected error")
	}
	if _, err := c.ToJSON(); err == nil {
		t.Error("ToJSON() on closed Channels: expected error")
	}
	if err := c.Close(); err == nil {
		t.Error("Close() on closed Channels: expected error")
	}
}

func TestChannels_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestChannels_FromCAPI_Valid(t *testing.T) {
	ch := mustChannel("A")
	c, _ := New([]*channel.Handle{ch})
	defer c.Close()
	capi := c.CAPIHandle()
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}
