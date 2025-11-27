package controlarray

import (
	"math"
	"reflect"
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
)

var (
	defaultShape = []int{2, 2}
	defaultData  = []float64{1., .2, 1., .2}
	defaultVal   = float64(5.2)
)

func eqSliceFloat64(a, b []float64) bool {
	const tol = 1e-12
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if math.IsNaN(a[i]) && math.IsNaN(b[i]) {
			continue
		}
		if math.Abs(a[i]-b[i]) > tol {
			return false
		}
	}
	return true
}

func eqSlice(a, b []float64) bool {
	return eqSliceFloat64(a, b)
}

func TestControlArray_FromDataAndData(t *testing.T) {
	a, err := FromData(defaultData, defaultShape)
	if err != nil {
		t.Fatalf("FromData failed: %v", err)
	}
	defer a.Close()
	data, err := a.Data()
	if err != nil {
		t.Fatalf("Data failed: %v", err)
	}
	if !eqSlice(data, defaultData) {
		t.Errorf("Expected %v, got %v", defaultData, data)
	}
}

func TestControlArray_ShapeDimensionSize(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	shape, err := a.Shape()
	if err != nil {
		t.Fatalf("Shape failed: %v", err)
	}
	if !reflect.DeepEqual(shape, defaultShape) {
		t.Errorf("Expected shape %v, got %v", defaultShape, shape)
	}
	dim, err := a.Dimension()
	if err != nil {
		t.Fatalf("Dimension failed: %v", err)
	}
	if dim != uint32(len(defaultShape)) {
		t.Errorf("Expected dimension %d, got %d", len(defaultShape), dim)
	}
	sz, err := a.Size()
	if err != nil {
		t.Fatalf("Size failed: %v", err)
	}
	if sz != 4 {
		t.Errorf("Expected size 4, got %d", sz)
	}
}

// Mutating operations: each in its own test with a fresh array

func TestControlArray_PlusEqualsFArray(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	fb, _ := farraydouble.FromData(defaultData, defaultShape)
	defer fb.Close()
	want := []float64{2, 0.4, 2, 0.4}
	if err := a.PlusEqualsFArray(fb); err != nil {
		t.Errorf("PlusEqualsFArray failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsFArray: got %v, want %v", got, want)
	}
}

func TestControlArray_PlusEqualsDouble(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] + defaultVal
	}
	if err := a.PlusEqualsDouble(defaultVal); err != nil {
		t.Errorf("PlusEqualsDouble failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsDouble: got %v, want %v", got, want)
	}
}

func TestControlArray_PlusEqualsInt(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] + 2
	}
	if err := a.PlusEqualsInt(2); err != nil {
		t.Errorf("PlusEqualsInt failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsInt: got %v, want %v", got, want)
	}
}

func TestControlArray_MinusEqualsFArray(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	fb, _ := farraydouble.FromData(defaultData, defaultShape)
	defer fb.Close()
	want := []float64{0, 0, 0, 0}
	if err := a.MinusEqualsFArray(fb); err != nil {
		t.Errorf("MinusEqualsFArray failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsFArray: got %v, want %v", got, want)
	}
}

func TestControlArray_MinusEqualsDouble(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] - defaultVal
	}
	if err := a.MinusEqualsDouble(defaultVal); err != nil {
		t.Errorf("MinusEqualsDouble failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsDouble: got %v, want %v", got, want)
	}
}

func TestControlArray_MinusEqualsInt(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] - 2
	}
	if err := a.MinusEqualsInt(2); err != nil {
		t.Errorf("MinusEqualsInt failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsInt: got %v, want %v", got, want)
	}
}

func TestControlArray_TimesEqualsDouble(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] * defaultVal
	}
	if err := a.TimesEqualsDouble(defaultVal); err != nil {
		t.Errorf("TimesEqualsDouble failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsDouble: got %v, want %v", got, want)
	}
}

func TestControlArray_TimesEqualsInt(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] * 2
	}
	if err := a.TimesEqualsInt(2); err != nil {
		t.Errorf("TimesEqualsInt failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsInt: got %v, want %v", got, want)
	}
}

func TestControlArray_DividesEqualsDouble(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] / defaultVal
	}
	if err := a.DividesEqualsDouble(defaultVal); err != nil {
		t.Errorf("DividesEqualsDouble failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsDouble: got %v, want %v", got, want)
	}
}

func TestControlArray_DividesEqualsInt(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] / 2
	}
	if err := a.DividesEqualsInt(2); err != nil {
		t.Errorf("DividesEqualsInt failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsInt: got %v, want %v", got, want)
	}
}

// Non-mutating operations can be grouped

func TestControlArray_NonMutatingOps(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	b, _ := FromData(defaultData, defaultShape)
	defer b.Close()
	fb, _ := farraydouble.FromData(defaultData, defaultShape)
	defer fb.Close()
	want := make([]float64, len(defaultData))

	// PlusControlArray
	res, err := a.PlusControlArray(b)
	if err != nil {
		t.Errorf("PlusControlArray failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] + defaultData[i]
	}
	got, _ := res.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusControlArray: got %v, want %v", got, want)
	}

	// PlusFArray
	res2, err := a.PlusFArray(fb)
	if err != nil {
		t.Errorf("PlusFArray failed: %v", err)
	}
	defer res2.Close()
	for i := range want {
		want[i] = defaultData[i] + defaultData[i]
	}
	got, _ = res2.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusFArray: got %v, want %v", got, want)
	}

	// PlusDouble
	res3, err := a.PlusDouble(defaultVal)
	if err != nil {
		t.Errorf("PlusDouble failed: %v", err)
	}
	defer res3.Close()
	for i := range want {
		want[i] = defaultData[i] + defaultVal
	}
	got, _ = res3.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusDouble: got %v, want %v", got, want)
	}

	// PlusInt
	res4, err := a.PlusInt(2)
	if err != nil {
		t.Errorf("PlusInt failed: %v", err)
	}
	defer res4.Close()
	for i := range want {
		want[i] = defaultData[i] + 2
	}
	got, _ = res4.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusInt: got %v, want %v", got, want)
	}

	// MinusControlArray
	c, _ := a.TimesDouble(2.0)
	res5, err := c.MinusControlArray(b)
	if err != nil {
		t.Errorf("MinusControlArray failed: %v", err)
	}
	defer res5.Close()
	for i := range want {
		want[i] = defaultData[i]
	}
	got, _ = res5.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusControlArray: got %v, want %v", got, want)
	}

	// MinusFArray
	res6, err := c.MinusFArray(fb)
	if err != nil {
		t.Errorf("MinusFArray failed: %v", err)
	}
	defer res6.Close()
	for i := range want {
		want[i] = defaultData[i]
	}
	got, _ = res6.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusFArray: got %v, want %v", got, want)
	}

	// MinusDouble
	res7, err := a.MinusDouble(defaultVal)
	if err != nil {
		t.Errorf("MinusDouble failed: %v", err)
	}
	defer res7.Close()
	for i := range want {
		want[i] = defaultData[i] - defaultVal
	}
	got, _ = res7.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusDouble: got %v, want %v", got, want)
	}

	// MinusInt
	res8, err := a.MinusInt(2)
	if err != nil {
		t.Errorf("MinusInt failed: %v", err)
	}
	defer res8.Close()
	for i := range want {
		want[i] = defaultData[i] - 2
	}
	got, _ = res8.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusInt: got %v, want %v", got, want)
	}

	// Negation
	res9, err := a.Negation()
	if err != nil {
		t.Errorf("Negation failed: %v", err)
	}
	defer res9.Close()
	for i := range want {
		want[i] = -defaultData[i]
	}
	got, _ = res9.Data()
	if !eqSlice(got, want) {
		t.Errorf("Negation: got %v, want %v", got, want)
	}

	// TimesDouble
	res10, err := a.TimesDouble(defaultVal)
	if err != nil {
		t.Errorf("TimesDouble failed: %v", err)
	}
	defer res10.Close()
	for i := range want {
		want[i] = defaultData[i] * defaultVal
	}
	got, _ = res10.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesDouble: got %v, want %v", got, want)
	}

	// TimesInt
	res11, err := a.TimesInt(2)
	if err != nil {
		t.Errorf("TimesInt failed: %v", err)
	}
	defer res11.Close()
	for i := range want {
		want[i] = defaultData[i] * 2
	}
	got, _ = res11.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesInt: got %v, want %v", got, want)
	}

	// DividesDouble
	res12, err := a.DividesDouble(defaultVal)
	if err != nil {
		t.Errorf("DividesDouble failed: %v", err)
	}
	defer res12.Close()
	for i := range want {
		want[i] = defaultData[i] / defaultVal
	}
	got, _ = res12.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesDouble: got %v, want %v", got, want)
	}

	// DividesInt
	res13, err := a.DividesInt(2)
	if err != nil {
		t.Errorf("DividesInt failed: %v", err)
	}
	defer res13.Close()
	for i := range want {
		want[i] = defaultData[i] / 2
	}
	got, _ = res13.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesInt: got %v, want %v", got, want)
	}

	// Pow
	res14, err := a.Pow(defaultVal)
	if err != nil {
		t.Errorf("Pow failed: %v", err)
	}
	defer res14.Close()
	for i := range want {
		want[i] = math.Pow(defaultData[i], defaultVal)
	}
	got, _ = res14.Data()
	if !eqSlice(got, want) {
		t.Errorf("Pow: got %v, want %v", got, want)
	}

	// Abs
	res15, err := a.Abs()
	if err != nil {
		t.Errorf("Abs failed: %v", err)
	}
	defer res15.Close()
	for i := range want {
		v := defaultData[i]
		if v < 0 {
			want[i] = -v
		} else {
			want[i] = v
		}
	}
	got, _ = res15.Data()
	if !eqSlice(got, want) {
		t.Errorf("Abs: got %v, want %v", got, want)
	}
}

func TestControlArray_MinMax(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	fb, _ := farraydouble.FromData(defaultData, defaultShape)
	defer fb.Close()
	_, err := a.MinFArray(fb)
	if err != nil {
		t.Errorf("MinFArray failed: %v", err)
	}
	_, err = a.MaxFArray(fb)
	if err != nil {
		t.Errorf("MaxFArray failed: %v", err)
	}
	b, _ := FromData(defaultData, defaultShape)
	defer b.Close()
	_, err = a.MinControlArray(b)
	if err != nil {
		t.Errorf("MinControlArray failed: %v", err)
	}
	_, err = a.MaxControlArray(b)
	if err != nil {
		t.Errorf("MaxControlArray failed: %v", err)
	}
}

func TestControlArray_Equal(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	b, _ := FromData(defaultData, defaultShape)
	defer b.Close()
	ok, err := a.Equal(b)
	if err != nil || !ok {
		t.Errorf("Expected Equal true, got %v, err: %v", ok, err)
	}
	ok, err = a.NotEqual(b)
	if err != nil || ok {
		t.Errorf("Expected NotEqual false, got %v, err: %v", ok, err)
	}
}

func TestControlArray_GreaterLessThan(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	ok, err := a.GreaterThan(defaultVal)
	if err != nil {
		t.Errorf("GreaterThan failed: %v", err)
	}
	_ = ok
	ok, err = a.LessThan(defaultVal)
	if err != nil {
		t.Errorf("LessThan failed: %v", err)
	}
	_ = ok
}

func TestControlArray_RemoveOffsetSum(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	if err := a.RemoveOffset(defaultVal); err != nil {
		t.Errorf("RemoveOffset failed: %v", err)
	}
	_, err := a.Sum()
	if err != nil {
		t.Errorf("Sum failed: %v", err)
	}
}

func TestControlArray_WhereFlip(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	_, err := a.Where(defaultVal)
	if err != nil {
		t.Errorf("Where failed: %v", err)
	}
	_, err = a.Flip(0)
	if err != nil {
		t.Errorf("Flip failed: %v", err)
	}
}

func TestControlArray_FullGradientGradient(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	grads, err := a.FullGradient()
	if err != nil {
		t.Errorf("FullGradient failed: %v", err)
	}
	for _, g := range grads {
		if g != nil {
			defer g.Close()
		}
	}
	_, err = a.Gradient(0)
	if err != nil {
		t.Errorf("Gradient failed: %v", err)
	}
}

func TestControlArray_SumOfSquaresAndDiffs(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	_, err := a.GetSumOfSquares()
	if err != nil {
		t.Errorf("GetSumOfSquares failed: %v", err)
	}
	_, err = a.GetSummedDiffIntOfSquares(2)
	if err != nil {
		t.Errorf("GetSummedDiffIntOfSquares failed: %v", err)
	}
	_, err = a.GetSummedDiffDoubleOfSquares(2.0)
	if err != nil {
		t.Errorf("GetSummedDiffDoubleOfSquares failed: %v", err)
	}
	b, _ := FromData(defaultData, defaultShape)
	defer b.Close()
	_, err = a.GetSummedDiffArrayOfSquares(b)
	if err != nil {
		t.Errorf("GetSummedDiffArrayOfSquares failed: %v", err)
	}
}

func TestControlArray_ToJSONAndFromJSON(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	js, err := a.ToJSON()
	if err != nil {
		t.Fatalf("ToJSON failed: %v", err)
	}
	b, err := FromJSON(js)
	if err != nil {
		t.Fatalf("FromJSON failed: %v", err)
	}
	defer b.Close()
	data, err := b.Data()
	if err != nil {
		t.Fatalf("Data failed: %v", err)
	}
	if !eqSlice(data, defaultData) {
		t.Errorf("Expected %v, got %v", defaultData, data)
	}
}

func TestControlArray_ErrorBranches(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	a.Close()
	_, err := a.Size()
	if err == nil {
		t.Error("Expected error on Size after Close")
	}
	_, err = a.Dimension()
	if err == nil {
		t.Error("Expected error on Dimension after Close")
	}
	_, err = a.Shape()
	if err == nil {
		t.Error("Expected error on Shape after Close")
	}
	_, err = a.Data()
	if err == nil {
		t.Error("Expected error on Data after Close")
	}
	_, err = a.PlusControlArray(nil)
	if err == nil {
		t.Error("Expected error on PlusControlArray with nil")
	}
	_, err = a.MinControlArray(nil)
	if err == nil {
		t.Error("Expected error on MinControlArray with nil")
	}
	_, err = a.MaxControlArray(nil)
	if err == nil {
		t.Error("Expected error on MaxControlArray with nil")
	}
	_, err = a.Equal(nil)
	if err == nil {
		t.Error("Expected error on Equal with nil")
	}
	_, err = a.NotEqual(nil)
	if err == nil {
		t.Error("Expected error on NotEqual with nil")
	}
	_, err = a.GetSummedDiffArrayOfSquares(nil)
	if err == nil {
		t.Error("Expected error on GetSummedDiffArrayOfSquares with nil")
	}
}
