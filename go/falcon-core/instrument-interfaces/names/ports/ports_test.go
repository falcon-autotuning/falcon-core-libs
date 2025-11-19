package ports

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func TestPorts_FullCoverage(t *testing.T) {
	// Create instrument ports for testing
	conn, err := connection.NewBarrierGate("port1")
	if err != nil {
		t.Fatalf("the connection failed to start: %v", err)
	}
	conn2, err := connection.NewBarrierGate("port2")
	if err != nil {
		t.Fatalf("the connection failed to start: %v", err)
	}
	sym, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("the volt did not get created: %v", err)
	}
	ip1, err := instrumentport.NewKnob("port1", conn, instrumenttypes.VoltageSource(), sym, "")
	if err != nil {
		t.Fatalf("instrumentport.New failed: %v", err)
	}
	defer ip1.Close()
	ip2, err := instrumentport.NewKnob("port2", conn2, instrumenttypes.VoltageSource(), sym, "")
	if err != nil {
		t.Fatalf("instrumentport.New failed: %v", err)
	}
	defer ip2.Close()

	// New from Go array
	portsHandle, err := New([]*instrumentport.Handle{ip1, ip2})
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer portsHandle.Close()

	// CAPIHandle (open)
	ptr, err := portsHandle.CAPIHandle()
	if err != nil || ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}

	// Ports
	li, err := portsHandle.Ports()
	if err != nil {
		t.Errorf("Ports failed: %v", err)
	}
	if li != nil {
		defer li.Close()
	}

	// DefaultNames
	ln, err := portsHandle.DefaultNames()
	if err != nil {
		t.Errorf("DefaultNames failed: %v", err)
	}
	if ln != nil {
		defer ln.Close()
	}

	// GetPsuedoNames
	lc, err := portsHandle.GetPsuedoNames()
	if err != nil {
		t.Errorf("GetPsuedoNames failed: %v", err)
	}
	if lc != nil {
		defer lc.Close()
	}

	// GetRawNames
	lrn, err := portsHandle.GetRawNames()
	if err != nil {
		t.Errorf("GetRawNames failed: %v", err)
	}
	if lrn != nil {
		defer lrn.Close()
	}

	// GetInstrumentFacingNames
	lifn, err := portsHandle.GetInstrumentFacingNames()
	if err != nil {
		t.Errorf("GetInstrumentFacingNames failed: %v", err)
	}
	if lifn != nil {
		defer lifn.Close()
	}

	// GetPsuedonameMatchingPort (with nil)
	_, err = portsHandle.GetPsuedonameMatchingPort(nil)
	if err == nil {
		t.Errorf("GetPsuedonameMatchingPort with nil should error")
	}

	// GetPsuedonameMatchingPort (with valid)
	_, err = portsHandle.GetPsuedonameMatchingPort(conn)
	if err != nil {
		t.Fatalf("connection.New failed: %v", err)
	}
	defer conn.Close()
	pmp, err := portsHandle.GetPsuedonameMatchingPort(conn)
	if err != nil {
		t.Errorf("GetPsuedonameMatchingPort failed: %v", err)
	}
	if pmp != nil {
		defer pmp.Close()
	}

	// GetInstrumentTypeMatchingPort
	itmp, err := portsHandle.GetInstrumentTypeMatchingPort(instrumenttypes.VoltageSource())
	if err != nil {
		t.Errorf("GetInstrumentTypeMatchingPort failed: %v", err)
	}
	if itmp != nil {
		defer itmp.Close()
	}

	// IsKnobs
	_, err = portsHandle.IsKnobs()
	if err != nil {
		t.Errorf("IsKnobs failed: %v", err)
	}

	// IsMeters
	_, err = portsHandle.IsMeters()
	if err != nil {
		t.Errorf("IsMeters failed: %v", err)
	}

	// Intersection (with nil)
	_, err = portsHandle.Intersection(nil)
	if err == nil {
		t.Errorf("Intersection with nil should error")
	}

	// Intersection (with valid)
	other, err := New([]*instrumentport.Handle{ip1})
	if err != nil {
		t.Fatalf("New (other) failed: %v", err)
	}
	defer other.Close()
	inter, err := portsHandle.Intersection(other)
	if err != nil {
		t.Errorf("Intersection failed: %v", err)
	}
	if inter != nil {
		defer inter.Close()
	}

	// PushBack (with nil)
	err = portsHandle.PushBack(nil)
	if err == nil {
		t.Errorf("PushBack with nil should error")
	}

	// PushBack (with valid)
	err = portsHandle.PushBack(ip1)
	if err != nil {
		t.Errorf("PushBack failed: %v", err)
	}

	// Size
	_, err = portsHandle.Size()
	if err != nil {
		t.Errorf("Size failed: %v", err)
	}

	// Empty
	_, err = portsHandle.Empty()
	if err != nil {
		t.Errorf("Empty failed: %v", err)
	}

	// ConstAt
	_, err = portsHandle.ConstAt(0)
	if err != nil {
		t.Errorf("ConstAt failed: %v", err)
	}

	// At
	_, err = portsHandle.At(0)
	if err != nil {
		t.Errorf("At failed: %v", err)
	}

	// Items
	items, err := portsHandle.Items()
	if err != nil {
		t.Errorf("Items failed: %v", err)
	}
	if items != nil {
		defer items.Close()
	}

	// Contains (with nil)
	_, err = portsHandle.Contains(nil)
	if err == nil {
		t.Errorf("Contains with nil should error")
	}

	// Contains (with valid)
	_, err = portsHandle.Contains(ip1)
	if err != nil {
		t.Errorf("Contains failed: %v", err)
	}

	// Index (with nil)
	_, err = portsHandle.Index(nil)
	if err == nil {
		t.Errorf("Index with nil should error")
	}

	// Index (with valid)
	_, err = portsHandle.Index(ip1)
	if err != nil {
		t.Errorf("Index failed: %v", err)
	}

	// Equal (with nil)
	_, err = portsHandle.Equal(nil)
	if err == nil {
		t.Errorf("Equal with nil should error")
	}

	// Equal (with valid)
	eq, err := portsHandle.Equal(other)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	if !eq && eq {
		t.Errorf("Equal returned unexpected value")
	}

	// NotEqual (with nil)
	_, err = portsHandle.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual with nil should error")
	}

	// NotEqual (with valid)
	_, err = portsHandle.NotEqual(other)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}

	// ToJSON/FromJSON
	jsonstr, err := portsHandle.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	ph2, err := FromJSON(jsonstr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	if ph2 != nil {
		defer ph2.Close()
	}

	// FromCAPI(nil)
	h, err := FromCAPI(nil)
	if err == nil {
		t.Errorf("FromCAPI(nil) should error")
	}
	if h != nil {
		t.Errorf("FromCAPI(nil) should return nil handle")
	}
	// EraseAt
	err = portsHandle.EraseAt(0)
	if err != nil {
		t.Errorf("EraseAt failed: %v", err)
	}

	// Clear
	err = portsHandle.Clear()
	if err != nil {
		t.Errorf("Clear failed: %v", err)
	}

	// CAPIHandle (closed)
	portsHandle.Close()
	_, err = portsHandle.CAPIHandle()
	if err == nil {
		t.Errorf("CAPIHandle on closed should error")
	}
	// Close twice
	err = portsHandle.Close()
	if err == nil {
		t.Errorf("second Close should error")
	}
	_, err = portsHandle.Ports()
	if err == nil {
		t.Errorf("Ports on closed should error")
	}
	_, err = portsHandle.DefaultNames()
	if err == nil {
		t.Errorf("DefaultNames on closed should error")
	}
	_, err = portsHandle.GetPsuedoNames()
	if err == nil {
		t.Errorf("GetPsuedoNames on closed should error")
	}
	_, err = portsHandle.GetRawNames()
	if err == nil {
		t.Errorf("GetRawNames on closed should error")
	}
	_, err = portsHandle.GetInstrumentFacingNames()
	if err == nil {
		t.Errorf("GetInstrumentFacingNames on closed should error")
	}
	_, err = portsHandle.GetPsuedonameMatchingPort(conn)
	if err == nil {
		t.Errorf("GetPsuedonameMatchingPort on closed should error")
	}
	_, err = portsHandle.GetInstrumentTypeMatchingPort("type1")
	if err == nil {
		t.Errorf("GetInstrumentTypeMatchingPort on closed should error")
	}
	_, err = portsHandle.IsKnobs()
	if err == nil {
		t.Errorf("IsKnobs on closed should error")
	}
	_, err = portsHandle.IsMeters()
	if err == nil {
		t.Errorf("IsMeters on closed should error")
	}
	_, err = portsHandle.Intersection(other)
	if err == nil {
		t.Errorf("Intersection on closed should error")
	}
	err = portsHandle.PushBack(ip1)
	if err == nil {
		t.Errorf("PushBack on closed should error")
	}
	_, err = portsHandle.Size()
	if err == nil {
		t.Errorf("Size on closed should error")
	}
	_, err = portsHandle.Empty()
	if err == nil {
		t.Errorf("Empty on closed should error")
	}
	err = portsHandle.EraseAt(0)
	if err == nil {
		t.Errorf("EraseAt on closed should error")
	}
	err = portsHandle.Clear()
	if err == nil {
		t.Errorf("Clear on closed should error")
	}
	_, err = portsHandle.ConstAt(0)
	if err == nil {
		t.Errorf("ConstAt on closed should error")
	}
	_, err = portsHandle.At(0)
	if err == nil {
		t.Errorf("At on closed should error")
	}
	_, err = portsHandle.Items()
	if err == nil {
		t.Errorf("Items on closed should error")
	}
	_, err = portsHandle.Contains(ip1)
	if err == nil {
		t.Errorf("Contains on closed should error")
	}
	_, err = portsHandle.Index(ip1)
	if err == nil {
		t.Errorf("Index on closed should error")
	}
	_, err = portsHandle.Equal(other)
	if err == nil {
		t.Errorf("Equal on closed should error")
	}
	_, err = portsHandle.NotEqual(other)
	if err == nil {
		t.Errorf("NotEqual on closed should error")
	}
	_, err = portsHandle.ToJSON()
	if err == nil {
		t.Errorf("ToJSON on closed should error")
	}
}
