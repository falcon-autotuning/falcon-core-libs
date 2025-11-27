package voltagestatesresponse

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestDeviceVoltageStates(t *testing.T) *devicevoltagestates.Handle {
	names := []string{"A", "B", "C"}
	var out []*devicevoltagestate.Handle
	for i, n := range names {
		conn, err := connection.NewBarrierGate(n)
		if err != nil {
			t.Fatalf("NewBarrierGate(%q) error: %v", n, err)
		}
		v, err := symbolunit.NewVolt()
		if err != nil {
			t.Fatalf("Could not create a volt: %v", err)
		}
		state, err := devicevoltagestate.New(conn, float64(i), v)
		if err != nil {
			t.Fatalf("devicevoltagestate.New(%q) error: %v", n, err)
		}
		out = append(out, state)
	}
	outs, err := devicevoltagestates.New(out)
	if err != nil {
		t.Fatalf("devicevoltagestates could not be constructed: %v", err)
	}
	return outs
}

func TestVoltageStatesResponse_FullCoverage(t *testing.T) {
	// Create a DeviceVoltageStates handle for testing
	states := makeTestDeviceVoltageStates(t)
	defer states.Close()

	// New
	vsr, err := New("test message", states)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer vsr.Close()

	// CAPIHandle (open)
	ptr := vsr.CAPIHandle()
	if ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}

	// Message
	msg, err := vsr.Message()
	if err != nil {
		t.Errorf("Message failed: %v", err)
	}
	if msg != "test message" {
		t.Errorf("Message got %q, want %q", msg, "test message")
	}

	// States
	states2, err := vsr.States()
	if err != nil {
		t.Errorf("States failed: %v", err)
	}
	if states2 == nil {
		t.Errorf("States returned nil")
	} else {
		states2.Close()
	}

	// ToJSON/FromJSON
	jsonstr, err := vsr.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	vsr2, err := FromJSON(jsonstr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	if vsr2 != nil {
		defer vsr2.Close()
	}

	// Equal
	eq, err := vsr.Equal(vsr2)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	if !eq {
		t.Errorf("Expected Equal true")
	}

	// NotEqual
	neq, err := vsr.NotEqual(vsr2)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	if neq {
		t.Errorf("Expected NotEqual false")
	}

	// Equal/NotEqual with nil/closed
	_, err = vsr.Equal(nil)
	if err == nil {
		t.Errorf("Equal with nil should error")
	}
	vsr2.Close()
	_, err = vsr.Equal(vsr2)
	if err == nil {
		t.Errorf("Equal with closed should error")
	}
	_, err = vsr.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual with nil should error")
	}
	_, err = vsr.NotEqual(vsr2)
	if err == nil {
		t.Errorf("NotEqual with closed should error")
	}

	// CAPIHandle (closed)
	vsr.Close()
	// Close twice
	err = vsr.Close()
	if err == nil {
		t.Errorf("Second Close should error")
	}

	_, err = vsr.Message()
	if err == nil {
		t.Errorf("Message on closed should error")
	}
	_, err = vsr.ToJSON()
	if err == nil {
		t.Errorf("ToJSON on closed should error")
	}
}

func TestVoltageStatesResponse_FromCAPI_Nil(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Errorf("FromCAPI(nil) should error")
	}
	if h != nil {
		t.Errorf("FromCAPI(nil) should return nil handle")
	}
}
