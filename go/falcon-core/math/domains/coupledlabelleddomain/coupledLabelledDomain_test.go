package coupledlabelleddomain

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func makeTestInstrumentPort(t *testing.T) *instrumentport.Handle {
	v, err := symbolunit.NewVolt()
	if err != nil {
		t.Fatalf("Invalid volt: %v", err)
	}
	conn, err := connection.NewBarrierGate("knob")
	if err != nil {
		t.Fatalf("Invalid conn: %v", err)
	}

	ip, err := instrumentport.NewKnob("knob", conn, instrumenttypes.VoltageSource(), v, "desc")
	if err != nil {
		t.Fatalf("instrumentport.NewKnob failed: %v", err)
	}
	return ip
}

func makeTestLabelledDomain(t *testing.T, ip *instrumentport.Handle) *labelleddomain.Handle {
	ld, err := labelleddomain.NewFromPort(0.0, 1.0, instrumenttypes.VoltageSource(), ip, true, false)
	if err != nil {
		t.Fatalf("labelleddomain.NewFromPort failed: %v", err)
	}
	return ld
}

func TestCoupledLabelledDomain_ContentsAndAccessors(t *testing.T) {
	ip := makeTestInstrumentPort(t)
	defer ip.Close()
	ld := makeTestLabelledDomain(t, ip)
	defer ld.Close()

	cld, err := New([]*labelleddomain.Handle{ld})
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer cld.Close()

	// Domains
	domains, err := cld.Domains()
	if err != nil {
		t.Fatalf("Domains failed: %v", err)
	}
	defer domains.Close()
	items, err := domains.Items()
	if err != nil {
		t.Fatalf("domains.Items failed: %v", err)
	}
	if len(items) != 1 {
		t.Fatalf("Expected 1 domain, got %d", len(items))
	}
	port, err := items[0].Port()
	if err != nil {
		t.Fatalf("LabelledDomain.Port failed: %v", err)
	}
	defer port.Close()
	name, err := port.DefaultName()
	if err != nil {
		t.Fatalf("InstrumentPort.DefaultName failed: %v", err)
	}
	if name != "knob" {
		t.Errorf("Expected InstrumentPort name 'knob', got %q", name)
	}
	itype, err := port.InstrumentType()
	if err != nil {
		t.Fatalf("InstrumentPort.InstrumentType failed: %v", err)
	}
	if itype != instrumenttypes.VoltageSource() {
		t.Errorf("Expected InstrumentPort type 'type', got %q", itype)
	}
	desc, err := port.Description()
	if err != nil {
		t.Fatalf("InstrumentPort.Description failed: %v", err)
	}
	if desc != "desc" {
		t.Errorf("Expected InstrumentPort description 'desc', got %q", desc)
	}

	// Labels
	lbls, err := cld.Labels()
	if err != nil {
		t.Fatalf("Labels failed: %v", err)
	}
	defer lbls.Close()
	lblSize, err := lbls.Size()
	if err != nil {
		t.Errorf("ports.Size failed: %v", err)
	}
	if lblSize != 1 {
		t.Errorf("Expected 1 label, got %d", lblSize)
	}

	// GetDomain
	gotDom, err := cld.GetDomain(ip)
	if err != nil {
		t.Errorf("GetDomain failed: %v", err)
	}
	if gotDom != nil {
		defer gotDom.Close()
		p2, err := gotDom.Port()
		if err != nil {
			t.Errorf("LabelledDomain.Port failed: %v", err)
		} else {
			defer p2.Close()
			n2, _ := p2.DefaultName()
			if n2 != "knob" {
				t.Errorf("Expected port name 'knob', got %q", n2)
			}
		}
	}
}

func TestCoupledLabelledDomain_CollectionAndMutation(t *testing.T) {
	ip := makeTestInstrumentPort(t)
	defer ip.Close()
	ld := makeTestLabelledDomain(t, ip)
	defer ld.Close()
	cld, _ := NewEmpty()
	defer cld.Close()

	// PushBack
	err := cld.PushBack(ld)
	if err != nil {
		t.Errorf("PushBack failed: %v", err)
	}
	size, _ := cld.Size()
	if size != 1 {
		t.Errorf("Expected size 1 after PushBack, got %d", size)
	}
	empty, _ := cld.Empty()
	if empty {
		t.Errorf("Expected not empty after PushBack")
	}

	// At/ConstAt
	at, err := cld.At(0)
	if err != nil {
		t.Errorf("At failed: %v", err)
	}
	if at != nil {
		defer at.Close()
		p, _ := at.Port()
		if p != nil {
			defer p.Close()
			n, _ := p.DefaultName()
			if n != "knob" {
				t.Errorf("Expected At(0) port name 'knob', got %q", n)
			}
		}
	}
	cat, err := cld.ConstAt(0)
	if err != nil {
		t.Errorf("ConstAt failed: %v", err)
	}
	if cat != nil {
		defer cat.Close()
		p, _ := cat.Port()
		if p != nil {
			defer p.Close()
			n, _ := p.DefaultName()
			if n != "knob" {
				t.Errorf("Expected ConstAt(0) port name 'knob', got %q", n)
			}
		}
	}

	// Contains/Index
	contains, err := cld.Contains(ld)
	if err != nil {
		t.Errorf("Contains failed: %v", err)
	}
	if !contains {
		t.Errorf("Expected Contains true")
	}
	idx, err := cld.Index(ld)
	if err != nil {
		t.Errorf("Index failed: %v", err)
	}
	if idx != 0 {
		t.Errorf("Expected Index 0, got %d", idx)
	}

	// EraseAt
	err = cld.EraseAt(0)
	if err != nil {
		t.Errorf("EraseAt failed: %v", err)
	}
	size, _ = cld.Size()
	if size != 0 {
		t.Errorf("Expected size 0 after EraseAt, got %d", size)
	}
	empty, _ = cld.Empty()
	if !empty {
		t.Errorf("Expected empty after EraseAt")
	}

	// PushBack/Clear
	err = cld.PushBack(ld)
	if err != nil {
		t.Errorf("PushBack failed: %v", err)
	}
	err = cld.Clear()
	if err != nil {
		t.Errorf("Clear failed: %v", err)
	}
	empty, _ = cld.Empty()
	if !empty {
		t.Errorf("Expected empty after Clear")
	}
}

func TestCoupledLabelledDomain_EqualityIntersectionJSON(t *testing.T) {
	ip := makeTestInstrumentPort(t)
	defer ip.Close()
	ld := makeTestLabelledDomain(t, ip)
	defer ld.Close()
	cld, _ := New([]*labelleddomain.Handle{ld})
	defer cld.Close()
	other, _ := New([]*labelleddomain.Handle{ld})
	defer other.Close()

	// Equal/NotEqual
	eq, err := cld.Equal(other)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	if !eq {
		t.Errorf("Expected Equal true")
	}
	neq, err := cld.NotEqual(other)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	if neq {
		t.Errorf("Expected NotEqual false")
	}

	// Intersection
	inter, err := cld.Intersection(other)
	if err != nil {
		t.Errorf("Intersection failed: %v", err)
	}
	if inter != nil {
		defer inter.Close()
		sz, _ := inter.Size()
		if sz != 1 {
			t.Errorf("Expected intersection size 1, got %d", sz)
		}
	}

	// ToJSON/FromJSON
	jsonstr, err := cld.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	cld2, err := FromJSON(jsonstr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	if cld2 != nil {
		defer cld2.Close()
		eq2, _ := cld.Equal(cld2)
		if !eq2 {
			t.Errorf("Expected Equal true for original and FromJSON")
		}
	}
}

func TestCoupledLabelledDomain_ErrorBranches(t *testing.T) {
	ip := makeTestInstrumentPort(t)
	defer ip.Close()
	ld := makeTestLabelledDomain(t, ip)
	defer ld.Close()
	cld, _ := New([]*labelleddomain.Handle{ld})
	defer cld.Close()
	other, _ := New([]*labelleddomain.Handle{ld})
	defer other.Close()

	_, err := FromCAPI(nil)
	if err == nil {
		t.Errorf("FromCAPI(nil) should error")
	}

	_, err = cld.Intersection(nil)
	if err == nil {
		t.Errorf("Intersection with nil should error")
	}
	err = cld.PushBack(nil)
	if err == nil {
		t.Errorf("PushBack with nil should error")
	}
	_, err = cld.Contains(nil)
	if err == nil {
		t.Errorf("Contains with nil should error")
	}
	_, err = cld.Index(nil)
	if err == nil {
		t.Errorf("Index with nil should error")
	}
	_, err = cld.Equal(nil)
	if err == nil {
		t.Errorf("Equal with nil should error")
	}
	_, err = cld.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual with nil should error")
	}

	cld.Close()
	_, err = cld.CAPIHandle()
	if err == nil {
		t.Errorf("CAPIHandle on closed should error")
	}
	err = cld.Close()
	if err == nil {
		t.Errorf("second Close should error")
	}
	_, err = cld.Domains()
	if err == nil {
		t.Errorf("Domains on closed should error")
	}
	_, err = cld.Labels()
	if err == nil {
		t.Errorf("Labels on closed should error")
	}
	_, err = cld.GetDomain(ip)
	if err == nil {
		t.Errorf("GetDomain on closed should error")
	}
	_, err = cld.Intersection(other)
	if err == nil {
		t.Errorf("Intersection on closed should error")
	}
	err = cld.PushBack(ld)
	if err == nil {
		t.Errorf("PushBack on closed should error")
	}
	_, err = cld.Size()
	if err == nil {
		t.Errorf("Size on closed should error")
	}
	_, err = cld.Empty()
	if err == nil {
		t.Errorf("Empty on closed should error")
	}
	err = cld.EraseAt(0)
	if err == nil {
		t.Errorf("EraseAt on closed should error")
	}
	err = cld.Clear()
	if err == nil {
		t.Errorf("Clear on closed should error")
	}
	_, err = cld.ConstAt(0)
	if err == nil {
		t.Errorf("ConstAt on closed should error")
	}
	_, err = cld.At(0)
	if err == nil {
		t.Errorf("At on closed should error")
	}
	_, err = cld.Items()
	if err == nil {
		t.Errorf("Items on closed should error")
	}
	_, err = cld.Contains(ld)
	if err == nil {
		t.Errorf("Contains on closed should error")
	}
	_, err = cld.Index(ld)
	if err == nil {
		t.Errorf("Index on closed should error")
	}
	_, err = cld.Equal(other)
	if err == nil {
		t.Errorf("Equal on closed should error")
	}
	_, err = cld.NotEqual(other)
	if err == nil {
		t.Errorf("NotEqual on closed should error")
	}
	_, err = cld.ToJSON()
	if err == nil {
		t.Errorf("ToJSON on closed should error")
	}
}
