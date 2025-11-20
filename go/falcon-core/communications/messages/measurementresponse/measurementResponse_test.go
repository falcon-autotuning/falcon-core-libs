package measurementresponse

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledarrayslabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustLabelledMeasuredArray() *labelledmeasuredarray.Handle {
	// Create a simple farraydouble
	fa, err := farraydouble.FromData([]float64{1.0, 2.0, 3.0}, []int{3})
	if err != nil {
		panic("failed to create farraydouble: " + err.Error())
	}
	defer fa.Close()
	conn, _ := connection.NewPlungerGate("P1")
	v, _ := symbolunit.NewVolt()
	is, _ := instrumentport.NewKnob("P1", conn, instrumenttypes.DCVoltageSource(), v, "")
	ac, err := acquisitioncontext.NewFromPort(is)
	if err != nil {
		panic("failed to create acquisitioncontext: " + err.Error())
	}
	defer ac.Close()
	// Create the labelled measured array from farray and acquisition context
	h, err := labelledmeasuredarray.FromFArray(fa, ac)
	if err != nil {
		panic("failed to create labelledmeasuredarray: " + err.Error())
	}
	return h
}

func mustLabelledArraysLabelledMeasuredArray() *labelledarrayslabelledmeasuredarray.Handle {
	lm := mustLabelledMeasuredArray()
	defer lm.Close()
	list, err := listlabelledmeasuredarray.New([]*labelledmeasuredarray.Handle{lm})
	if err != nil {
		panic("failed to create listlabelledmeasuredarray: " + err.Error())
	}
	defer list.Close()
	h, err := labelledarrayslabelledmeasuredarray.NewFromList(list)
	if err != nil {
		panic("failed to create labelledarrayslabelledmeasuredarray: " + err.Error())
	}
	return h
}

func TestMeasurementResponse_FullCoverage(t *testing.T) {
	// --- Constructors ---
	arr := mustLabelledArraysLabelledMeasuredArray()
	defer arr.Close()
	h, err := New(arr)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()

	// --- Arrays() ---
	a2, err := h.Arrays()
	if err != nil {
		t.Errorf("Arrays error: %v", err)
	}
	a2.Close()

	// --- Message() ---
	_, err = h.Message()
	if err != nil {
		t.Errorf("Message error: %v", err)
	}

	// --- Equal/NotEqual ---
	h2, err := New(arr)
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
	// Self-equality
	eqSelf, err := h.Equal(h)
	if err != nil || !eqSelf {
		t.Errorf("Self Equal error: %v %v", err, eqSelf)
	}
	_, err = h.NotEqual(h)
	if err != nil {
		t.Errorf("Self NotEqual error: %v", err)
	}
	// Nil/closed branches
	_, err = h.Equal(nil)
	if err == nil {
		t.Errorf("Equal(nil) should error")
	}
	_, err = h.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual(nil) should error")
	}
	h2.Close()
	_, err = h.Equal(h2)
	if err == nil {
		t.Errorf("Equal(closed) should error")
	}
	_, err = h.NotEqual(h2)
	if err == nil {
		t.Errorf("NotEqual(closed) should error")
	}

	// --- ToJSON/FromJSON ---
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

	// --- Close() and closed error branches ---
	h3.Close()
	if err := h3.Close(); err == nil {
		t.Errorf("Second close should error")
	}
	if _, err := h3.Arrays(); err == nil {
		t.Errorf("Arrays on closed should error")
	}
	if _, err := h3.Message(); err == nil {
		t.Errorf("Message on closed should error")
	}
	if _, err := h3.CAPIHandle(); err == nil {
		t.Errorf("CAPIHandle on closed should error")
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
}
