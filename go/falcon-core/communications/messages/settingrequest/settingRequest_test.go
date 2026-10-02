package settingrequest

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinstrumentportquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrument"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustSettingRequest(msg string) *Handle {
	v, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}

	conn, err := connection.NewBarrierGate("P1")
	if err != nil {
		panic(err)
	}

	port, err := instrumentport.NewKnob(
		"P1",
		"instrument1",
		conn,
		instrument.VoltageSource,
		v,
		"test port",
	)
	if err != nil {
		panic(err)
	}

	getters, err := ports.New([]*instrumentport.Handle{port})
	if err != nil {
		panic(err)
	}

	qty, err := quantity.New(1.23, v)
	if err != nil {
		panic(err)
	}

	setters, err := mapinstrumentportquantity.NewEmpty()
	if err != nil {
		panic(err)
	}

	if err := setters.Insert(port, qty); err != nil {
		panic(err)
	}

	h, err := New(msg, getters, setters)
	if err != nil {
		panic(err)
	}

	return h
}

func TestSettingRequest_CreateDestroy(t *testing.T) {
	_ = mustSettingRequest("msg")

	_, err := New("", nil, nil)
	if err == nil {
		t.Errorf("expected error for nil arguments")
	}
}

func TestSettingRequest_Accessors(t *testing.T) {
	req := mustSettingRequest("msg")
	defer req.Close()

	msg, err := req.Message()
	if err != nil || msg != "msg" {
		t.Errorf("Message error: %v %v", err, msg)
	}

	getters, err := req.Getters()
	if err != nil {
		t.Errorf("Getters error: %v", err)
	}
	if getters != nil {
		getters.Close()
	}

	setters, err := req.Setters()
	if err != nil {
		t.Errorf("Setters error: %v", err)
	}
	if setters != nil {
		setters.Close()
	}

	req.Close()

	if _, err := req.Message(); err == nil {
		t.Errorf("Message on closed should error")
	}

	if _, err := req.Getters(); err == nil {
		t.Errorf("Getters on closed should error")
	}

	if _, err := req.Setters(); err == nil {
		t.Errorf("Setters on closed should error")
	}
}

func TestSettingRequest_Equality(t *testing.T) {
	req1 := mustSettingRequest("msg")
	defer req1.Close()

	req2 := mustSettingRequest("other")
	defer req2.Close()

	_, err := req1.Equal(req2)
	if err != nil {
		t.Errorf("Equal error: %v", err)
	}

	_, err = req1.NotEqual(req2)
	if err != nil {
		t.Errorf("NotEqual error: %v", err)
	}

	eq, err := req1.Equal(req1)
	if err != nil || !eq {
		t.Errorf("Self Equal error: %v %v", err, eq)
	}

	_, err = req1.NotEqual(req1)
	if err != nil {
		t.Errorf("Self NotEqual error: %v", err)
	}

	_, err = req1.Equal(nil)
	if err == nil {
		t.Errorf("Equal(nil) should error")
	}

	_, err = req1.NotEqual(nil)
	if err == nil {
		t.Errorf("NotEqual(nil) should error")
	}

	req2.Close()

	_, err = req1.Equal(req2)
	if err == nil {
		t.Errorf("Equal(closed) should error")
	}

	_, err = req1.NotEqual(req2)
	if err == nil {
		t.Errorf("NotEqual(closed) should error")
	}
}

func TestSettingRequest_Copy(t *testing.T) {
	req := mustSettingRequest("msg")
	defer req.Close()

	cp, err := Copy(req)
	if err != nil {
		t.Fatalf("Copy error: %v", err)
	}
	defer cp.Close()

	eq, err := req.Equal(cp)
	if err != nil {
		t.Fatalf("Equal error: %v", err)
	}

	if !eq {
		t.Fatal("copy should equal original")
	}

	req.Close()

	if _, err := Copy(req); err == nil {
		t.Fatal("expected error copying closed request")
	}
}

func TestSettingRequest_ToJSONFromJSON(t *testing.T) {
	req := mustSettingRequest("msg")
	defer req.Close()

	jsonStr, err := req.ToJSON()
	if err != nil {
		t.Errorf("ToJSON error: %v", err)
	}

	req2, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON error: %v", err)
	}
	defer req2.Close()

	eq, err := req.Equal(req2)
	if err != nil || !eq {
		t.Errorf("roundtrip not equal: %v err=%v", eq, err)
	}

	req2.Close()

	if _, err := req2.ToJSON(); err == nil {
		t.Errorf("ToJSON on closed should error")
	}

	if _, err := req2.Equal(req); err == nil {
		t.Errorf("Equal on closed should error")
	}

	if _, err := req2.NotEqual(req); err == nil {
		t.Errorf("NotEqual on closed should error")
	}
}

func TestSettingRequest_FromCAPI(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Errorf("FromCAPI(nil) expected error")
	}
	if h != nil {
		t.Errorf("FromCAPI(nil) expected nil handle")
	}

	req := mustSettingRequest("msg")
	defer req.Close()

	dup, err := FromCAPI(req.CAPIHandle())
	if err != nil {
		t.Fatalf("FromCAPI valid failed: %v", err)
	}
	if dup == nil {
		t.Fatal("FromCAPI returned nil")
	}
}

func TestSettingRequest_IsNil(t *testing.T) {
	var req *Handle

	if !req.IsNil() {
		t.Fatal("nil handle should report IsNil()")
	}

	req = mustSettingRequest("msg")
	defer req.Close()

	if req.IsNil() {
		t.Fatal("non-nil handle should not report IsNil()")
	}
}
