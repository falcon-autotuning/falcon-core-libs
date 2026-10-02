package settingresponse

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinstrumentportquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrument"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustMapInstrumentPortQuantity() *mapinstrumentportquantity.Handle {
	conn, err := connection.NewBarrierGate("P1")
	if err != nil {
		panic(err)
	}

	units, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}

	port, err := instrumentport.NewKnob(
		"P1",
		"inst1",
		conn,
		instrument.DcVoltageSource,
		units,
		"",
	)
	if err != nil {
		panic(err)
	}

	q, err := quantity.New(1.0, units)
	if err != nil {
		panic(err)
	}

	m, err := mapinstrumentportquantity.NewEmpty()
	if err != nil {
		panic(err)
	}

	if err := m.Insert(port, q); err != nil {
		panic(err)
	}

	return m
}

func TestSettingResponse_FullCoverage(t *testing.T) {
	// --- Constructors ---
	getters := mustMapInstrumentPortQuantity()
	defer getters.Close()

	h, err := New("success", getters)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()

	// Nil constructor branch
	if _, err := New("", nil); err == nil {
		t.Errorf("expected error for nil getters")
	}

	// --- Getters() ---
	g2, err := h.Getters()
	if err != nil {
		t.Errorf("Getters error: %v", err)
	}
	if g2 != nil {
		g2.Close()
	}

	// --- Message() ---
	msg, err := h.Message()
	if err != nil {
		t.Errorf("Message error: %v", err)
	}
	if msg == "" {
		t.Errorf("expected non-empty message")
	}

	// --- Equal / NotEqual ---
	h2, err := New("other", getters)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h2.Close()

	_, err = h.Equal(h2)
	if err != nil {
		t.Errorf("Equal error: %v", err)
	}

	_, err = h.NotEqual(h2)
	if err != nil {
		t.Errorf("NotEqual error: %v", err)
	}

	eqSelf, err := h.Equal(h)
	if err != nil || !eqSelf {
		t.Errorf("Self Equal error: %v %v", err, eqSelf)
	}

	_, err = h.NotEqual(h)
	if err != nil {
		t.Errorf("Self NotEqual error: %v", err)
	}

	// Nil branches
	_, err = h.Equal(nil)
	if err == nil {
		t.Errorf("Equal(nil) should error")
	}

	_, err = h.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual(nil) should error")
	}

	// Closed handle branches
	h2.Close()

	_, err = h.Equal(h2)
	if err == nil {
		t.Errorf("Equal(closed) should error")
	}

	_, err = h.NotEqual(h2)
	if err == nil {
		t.Errorf("NotEqual(closed) should error")
	}

	// --- Copy ---
	cp, err := Copy(h)
	if err != nil {
		t.Errorf("Copy error: %v", err)
	}
	defer cp.Close()

	eqCopy, err := h.Equal(cp)
	if err != nil {
		t.Errorf("Copy equality error: %v", err)
	}
	if !eqCopy {
		t.Errorf("Copy should equal original")
	}

	// --- ToJSON / FromJSON ---
	jsonStr, err := h.ToJSON()
	if err != nil {
		t.Errorf("ToJSON error: %v", err)
	}

	h3, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON error: %v", err)
	}
	defer h3.Close()

	_, err = h.Equal(h3)
	if err != nil {
		t.Errorf("Equal after FromJSON error: %v", err)
	}

	// --- FromCAPI ---
	dup, err := FromCAPI(h.CAPIHandle())
	if err != nil {
		t.Errorf("FromCAPI error: %v", err)
	}
	if dup == nil {
		t.Errorf("FromCAPI returned nil")
	}

	nilHandle, err := FromCAPI(nil)
	if err == nil {
		t.Errorf("FromCAPI(nil) should error")
	}
	if nilHandle != nil {
		t.Errorf("FromCAPI(nil) should return nil")
	}

	// --- IsNil ---
	var nilResp *Handle
	if !nilResp.IsNil() {
		t.Errorf("nil handle should report IsNil()")
	}

	if h.IsNil() {
		t.Errorf("non-nil handle should not report IsNil()")
	}

	// --- Closed error branches ---
	h3.Close()

	if err := h3.Close(); err == nil {
		t.Errorf("second close should error")
	}

	if _, err := h3.Getters(); err == nil {
		t.Errorf("Getters on closed should error")
	}

	if _, err := h3.Message(); err == nil {
		t.Errorf("Message on closed should error")
	}

	if _, err := h3.ToJSON(); err == nil {
		t.Errorf("ToJSON on closed should error")
	}

	if _, err := h3.Equal(h); err == nil {
		t.Errorf("Equal on closed should error")
	}

	if _, err := h3.NotEqual(h); err == nil {
		t.Errorf("NotEqual on closed should error")
	}

	if _, err := Copy(h3); err == nil {
		t.Errorf("Copy on closed should error")
	}
}
