package devicevoltagestate

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustConnection() *connection.Handle {
	h, err := connection.NewBarrierGate("conn_id")
	if err != nil {
		panic(err)
	}
	return h
}

func mustSymbolUnit() *symbolunit.Handle {
	h, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	return h
}

func TestDeviceVoltageState_Basic(t *testing.T) {
	conn := mustConnection()
	defer conn.Close()
	unit := mustSymbolUnit()
	defer unit.Close()
	dvs, err := New(conn, 5.0, unit)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer dvs.Close()

	ptr, err := dvs.CAPIHandle()
	if err != nil || ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}
	gotConn, err := dvs.Connection()
	if err != nil {
		t.Errorf("Connection failed: %v", err)
	}
	if gotConn != nil {
		gotConn.Close()
	}
	_, err = dvs.Voltage()
	if err != nil {
		t.Errorf("Voltage failed: %v", err)
	}
	_, err = dvs.Value()
	if err != nil {
		t.Errorf("Value failed: %v", err)
	}
	gotUnit, err := dvs.Unit()
	if err != nil {
		t.Errorf("Unit failed: %v", err)
	}
	if gotUnit != nil {
		gotUnit.Close()
	}
}

func TestDeviceVoltageState_Arithmetic(t *testing.T) {
	conn := mustConnection()
	defer conn.Close()
	unit := mustSymbolUnit()
	defer unit.Close()
	dvs, err := New(conn, 5.0, unit)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer dvs.Close()
	err = dvs.ConvertTo(unit)
	if err != nil {
		t.Errorf("ConvertTo failed: %v", err)
	}
	checkClose := func(h *Handle, err error, name string, shouldClose bool) {
		if err != nil {
			t.Errorf("%s failed: %v", name, err)
			return
		}
		if h == nil {
			t.Errorf("%s returned nil handle without error", name)
			return
		}
		if shouldClose {
			h.Close()
		}
	}

	h, err := dvs.MultiplyInt(2)
	checkClose(h, err, "MultiplyInt", true)

	h, err = dvs.MultiplyDouble(2.5)
	checkClose(h, err, "MultiplyDouble", true)

	h, err = dvs.MultiplyQuantity(dvs)
	checkClose(h, err, "MultiplyQuantity", true)

	h, err = dvs.MultiplyEqualsInt(2)
	checkClose(h, err, "MultiplyEqualsInt", false)

	h, err = dvs.MultiplyEqualsDouble(2.5)
	checkClose(h, err, "MultiplyEqualsDouble", false)

	h, err = dvs.MultiplyEqualsQuantity(dvs)
	checkClose(h, err, "MultiplyEqualsQuantity", false)

	h, err = dvs.DivideInt(2)
	checkClose(h, err, "DivideInt", true)

	h, err = dvs.DivideDouble(2.5)
	checkClose(h, err, "DivideDouble", true)

	h, err = dvs.DivideQuantity(dvs)
	checkClose(h, err, "DivideQuantity", true)

	h, err = dvs.DivideEqualsInt(2)
	checkClose(h, err, "DivideEqualsInt", false)

	h, err = dvs.DivideEqualsDouble(2.5)
	checkClose(h, err, "DivideEqualsDouble", false)

	h, err = dvs.DivideEqualsQuantity(dvs)
	checkClose(h, err, "DivideEqualsQuantity", false)

	h, err = dvs.Power(2)
	checkClose(h, err, "Power", true)

	h, err = dvs.AddQuantity(dvs)
	checkClose(h, err, "AddQuantity", true)

	h, err = dvs.AddEqualsQuantity(dvs)
	checkClose(h, err, "AddEqualsQuantity", false)

	h, err = dvs.SubtractQuantity(dvs)
	checkClose(h, err, "SubtractQuantity", true)

	h, err = dvs.SubtractEqualsQuantity(dvs)
	checkClose(h, err, "SubtractEqualsQuantity", false)

	h, err = dvs.Negate()
	checkClose(h, err, "Negate", true)

	h, err = dvs.Abs()
	checkClose(h, err, "Abs", true)
}

func TestDeviceVoltageState_EqualityAndSerialization(t *testing.T) {
	conn := mustConnection()
	defer conn.Close()
	unit := mustSymbolUnit()
	defer unit.Close()
	dvs, err := New(conn, 5.0, unit)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	defer dvs.Close()

	eq, err := dvs.Equal(dvs)
	if err != nil {
		t.Errorf("Equal failed: %v", err)
	}
	if !eq {
		t.Errorf("Expected Equal true")
	}
	neq, err := dvs.NotEqual(dvs)
	if err != nil {
		t.Errorf("NotEqual failed: %v", err)
	}
	if neq {
		t.Errorf("Expected NotEqual false")
	}
	jsonStr, err := dvs.ToJSON()
	if err != nil {
		t.Errorf("ToJSON failed: %v", err)
	}
	dvs2, err := FromJSON(jsonStr)
	if err != nil {
		t.Errorf("FromJSON failed: %v", err)
	}
	if dvs2 != nil {
		dvs2.Close()
	}
}

func TestDeviceVoltageState_ErrorBranches(t *testing.T) {
	conn := mustConnection()
	defer conn.Close()
	unit := mustSymbolUnit()
	defer unit.Close()
	dvs, err := New(conn, 5.0, unit)
	if err != nil {
		t.Fatalf("New failed: %v", err)
	}
	dvs.Close()
	_, err = dvs.CAPIHandle()
	if err == nil {
		t.Errorf("CAPIHandle on closed should error")
	}
	err = dvs.Close()
	if err == nil {
		t.Errorf("Second Close should error")
	}
	_, err = dvs.Connection()
	if err == nil {
		t.Errorf("Connection on closed should error")
	}
	_, err = dvs.Voltage()
	if err == nil {
		t.Errorf("Voltage on closed should error")
	}
	_, err = dvs.Value()
	if err == nil {
		t.Errorf("Value on closed should error")
	}
	_, err = dvs.Unit()
	if err == nil {
		t.Errorf("Unit on closed should error")
	}
	err = dvs.ConvertTo(unit)
	if err == nil {
		t.Errorf("ConvertTo on closed should error")
	}
	_, err = dvs.MultiplyInt(2)
	if err == nil {
		t.Errorf("MultiplyInt on closed should error")
	}
	_, err = dvs.MultiplyDouble(2.5)
	if err == nil {
		t.Errorf("MultiplyDouble on closed should error")
	}
	_, err = dvs.MultiplyQuantity(dvs)
	if err == nil {
		t.Errorf("MultiplyQuantity on closed should error")
	}
	_, err = dvs.MultiplyEqualsInt(2)
	if err == nil {
		t.Errorf("MultiplyEqualsInt on closed should error")
	}
	_, err = dvs.MultiplyEqualsDouble(2.5)
	if err == nil {
		t.Errorf("MultiplyEqualsDouble on closed should error")
	}
	_, err = dvs.MultiplyEqualsQuantity(dvs)
	if err == nil {
		t.Errorf("MultiplyEqualsQuantity on closed should error")
	}
	_, err = dvs.DivideInt(2)
	if err == nil {
		t.Errorf("DivideInt on closed should error")
	}
	_, err = dvs.DivideDouble(2.5)
	if err == nil {
		t.Errorf("DivideDouble on closed should error")
	}
	_, err = dvs.DivideQuantity(dvs)
	if err == nil {
		t.Errorf("DivideQuantity on closed should error")
	}
	_, err = dvs.DivideEqualsInt(2)
	if err == nil {
		t.Errorf("DivideEqualsInt on closed should error")
	}
	_, err = dvs.DivideEqualsDouble(2.5)
	if err == nil {
		t.Errorf("DivideEqualsDouble on closed should error")
	}
	_, err = dvs.DivideEqualsQuantity(dvs)
	if err == nil {
		t.Errorf("DivideEqualsQuantity on closed should error")
	}
	_, err = dvs.Power(2)
	if err == nil {
		t.Errorf("Power on closed should error")
	}
	_, err = dvs.AddQuantity(dvs)
	if err == nil {
		t.Errorf("AddQuantity on closed should error")
	}
	_, err = dvs.AddEqualsQuantity(dvs)
	if err == nil {
		t.Errorf("AddEqualsQuantity on closed should error")
	}
	_, err = dvs.SubtractQuantity(dvs)
	if err == nil {
		t.Errorf("SubtractQuantity on closed should error")
	}
	_, err = dvs.SubtractEqualsQuantity(dvs)
	if err == nil {
		t.Errorf("SubtractEqualsQuantity on closed should error")
	}
	_, err = dvs.Negate()
	if err == nil {
		t.Errorf("Negate on closed should error")
	}
	_, err = dvs.Abs()
	if err == nil {
		t.Errorf("Abs on closed should error")
	}
	_, err = dvs.Equal(dvs)
	if err == nil {
		t.Errorf("Equal on closed should error")
	}
	_, err = dvs.NotEqual(dvs)
	if err == nil {
		t.Errorf("NotEqual on closed should error")
	}
	_, err = dvs.ToJSON()
	if err == nil {
		t.Errorf("ToJSON on closed should error")
	}
}
