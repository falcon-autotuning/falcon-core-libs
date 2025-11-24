package analyticfunction

import (
	"sync"
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringdouble"
)

func makeTestLabels(t *testing.T) *liststring.Handle {
	labels, err := liststring.New([]string{"x"})
	if err != nil {
		t.Fatalf("liststring.New error: %v", err)
	}
	return labels
}

func makeTestArgs(t *testing.T) *mapstringdouble.Handle {
	m, err := mapstringdouble.NewEmpty()
	if err != nil {
		t.Fatalf("mapstringdouble.NewEmpty error: %v", err)
	}
	if err := m.InsertOrAssign("x", 1.0); err != nil {
		t.Fatalf("InsertOrAssign error: %v", err)
	}
	return m
}

func makeTestAnalyticFunction(t *testing.T) (*Handle, *liststring.Handle) {
	labels := makeTestLabels(t)
	af, err := New(labels, "2*x[0]+1")
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	return af, labels
}

func TestAnalyticFunction_NewAndClose(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	defer labels.Close()
	if af == nil {
		t.Fatal("New returned nil")
	}
	if err := af.Close(); err != nil {
		t.Fatalf("Close error: %v", err)
	}
	if err := af.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestAnalyticFunction_NewIdentity(t *testing.T) {
	af, err := NewIdentity()
	if err != nil {
		t.Fatalf("NewIdentity error: %v", err)
	}
	defer af.Close()
}

func TestAnalyticFunction_NewConstant(t *testing.T) {
	af, err := NewConstant(3.14)
	if err != nil {
		t.Fatalf("NewConstant error: %v", err)
	}
	defer af.Close()
}

func TestAnalyticFunction_Labels(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	defer af.Close()
	defer labels.Close()
	l, err := af.Labels()
	if err != nil {
		t.Fatalf("Labels error: %v", err)
	}
	if l == nil {
		t.Error("Labels returned nil")
	}
	l.Close()
}

func TestAnalyticFunction_Evaluate(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	defer af.Close()
	defer labels.Close()
	args := makeTestArgs(t)
	defer args.Close()
	val, err := af.Evaluate(args, 0.0)
	if err != nil {
		t.Fatalf("Evaluate error: %v", err)
	}
	if val != 3.0 {
		t.Errorf("Evaluate = %v, want 3.0", val)
	}
}

func TestAnalyticFunction_EvaluateArraywise(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	defer af.Close()
	defer labels.Close()
	args := makeTestArgs(t)
	defer args.Close()
	arr, err := af.EvaluateArraywise(args, 1.0, 3.0)
	if err != nil {
		t.Fatalf("EvaluateArraywise error: %v", err)
	}
	if arr == nil {
		t.Error("EvaluateArraywise returned nil")
	}
	arr.Close()
}

func TestAnalyticFunction_EqualAndNotEqual(t *testing.T) {
	af1, labels := makeTestAnalyticFunction(t)
	defer af1.Close()
	defer labels.Close()
	af2, _ := makeTestAnalyticFunction(t)
	defer af2.Close()
	eq, err := af1.Equal(af2)
	if err != nil || !eq {
		t.Errorf("Equal = %v, want true, err: %v", eq, err)
	}
	neq, err := af1.NotEqual(af2)
	if err != nil || neq {
		t.Errorf("NotEqual = %v, want false, err: %v", neq, err)
	}
}

func TestAnalyticFunction_ToJSONAndFromJSON(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	defer af.Close()
	defer labels.Close()
	jsonStr, err := af.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON error: %v", err)
	}
	af2, err := FromJSON(jsonStr)
	if err != nil {
		t.Fatalf("FromJSON error: %v", err)
	}
	defer af2.Close()
	eq, err := af.Equal(af2)
	if err != nil || !eq {
		t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
	}
}

func TestAnalyticFunction_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestAnalyticFunction_FromCAPI_Valid(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	defer af.Close()
	defer labels.Close()
	capi, err := af.CAPIHandle()
	if err != nil {
		t.Fatalf("Could not convert to CAPI: %v", err)
	}
	h, err := FromCAPI(capi)
	if err != nil {
		t.Errorf("FromCAPI valid: unexpected error: %v", err)
	}
	if h == nil {
		t.Fatal("FromCAPI valid: got nil")
	}
}

func TestAnalyticFunction_ClosedErrors(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	af.Close()
	labels.Close()
	args := makeTestArgs(t)
	defer args.Close()
	if _, err := af.Labels(); err == nil {
		t.Error("Labels() on closed: expected error")
	}
	if _, err := af.Evaluate(args, 0.0); err == nil {
		t.Error("Evaluate() on closed: expected error")
	}
	if _, err := af.EvaluateArraywise(args, 1.0, 3.0); err == nil {
		t.Error("EvaluateArraywise() on closed: expected error")
	}
	if _, err := af.Equal(af); err == nil {
		t.Error("Equal() on closed: expected error")
	}
	if _, err := af.NotEqual(af); err == nil {
		t.Error("NotEqual() on closed: expected error")
	}
	if _, err := af.ToJSON(); err == nil {
		t.Error("ToJSON() on closed: expected error")
	}
	if err := af.Close(); err == nil {
		t.Error("Close() on closed: expected error")
	}
}

func TestSimultaneousEvaluationAndClosing(t *testing.T) {
	af, labels := makeTestAnalyticFunction(t)
	defer af.Close()
	defer labels.Close()
	pair, err := pairstringdouble.New("x", 2)
	if err != nil {
		t.Fatalf("Failed to create pair: %v", err)
	}
	args, err := mapstringdouble.New([]*pairstringdouble.Handle{pair})
	if err != nil {
		t.Fatalf("Failed to create args: %v", err)
	}
	defer args.Close()

	var wg sync.WaitGroup
	wg.Add(2)

	// Run Evaluate in a goroutine
	go func() {
		defer wg.Done()
		val, evalErr := af.Evaluate(args, 0)
		// Either we get a value, or an error if closed
		if evalErr != nil && evalErr.Error() != "Evaluate: object is closed" {
			t.Errorf("Unexpected error from Evaluate: %v", evalErr)
		}
		_ = val // ignore value
	}()

	// Run Close in a goroutine
	go func() {
		defer wg.Done()
		closeErr := args.Close()
		// Either close succeeds, or returns error if already closed
		if closeErr != nil && closeErr.Error() != "unable to close the arguments map" {
			t.Errorf("Unexpected error from Close: %v", closeErr)
		}
	}()

	wg.Wait()
}
