package controlarray1d

import (
	"math"
	"reflect"
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
)

var (
	defaultShape = []uint64{4}
	defaultData  = []float64{1., 2., 3., 4.}
	defaultVal   = float64(2.0)
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

func TestControlArray1D_FromDataAndData(t *testing.T) {
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

func TestControlArray1D_ShapeDimensionSize(t *testing.T) {
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
	if dim != uint64(len(defaultShape)) {
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

func TestControlArray1D_MutatingOps(t *testing.T) {
	// PlusEqualsFArray
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	fb, _ := farraydouble.FromData(defaultData, defaultShape)
	defer fb.Close()
	want := []float64{2, 4, 6, 8}
	if err := a.PlusEqualsFArray(fb); err != nil {
		t.Errorf("PlusEqualsFArray failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsFArray: got %v, want %v", got, want)
	}

	// PlusEqualsDouble
	a2, _ := FromData(defaultData, defaultShape)
	defer a2.Close()
	want = []float64{3, 4, 5, 6}
	if err := a2.PlusEqualsDouble(defaultVal); err != nil {
		t.Errorf("PlusEqualsDouble failed: %v", err)
	}
	got, _ = a2.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsDouble: got %v, want %v", got, want)
	}

	// PlusEqualsInt
	a3, _ := FromData(defaultData, defaultShape)
	defer a3.Close()
	want = []float64{3, 4, 5, 6}
	if err := a3.PlusEqualsInt(2); err != nil {
		t.Errorf("PlusEqualsInt failed: %v", err)
	}
	got, _ = a3.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsInt: got %v, want %v", got, want)
	}

	// MinusEqualsFArray
	a4, _ := FromData(defaultData, defaultShape)
	defer a4.Close()
	want = []float64{0, 0, 0, 0}
	if err := a4.MinusEqualsFArray(fb); err != nil {
		t.Errorf("MinusEqualsFArray failed: %v", err)
	}
	got, _ = a4.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsFArray: got %v, want %v", got, want)
	}

	// MinusEqualsDouble
	a5, _ := FromData(defaultData, defaultShape)
	defer a5.Close()
	want = []float64{-1, 0, 1, 2}
	if err := a5.MinusEqualsDouble(defaultVal); err != nil {
		t.Errorf("MinusEqualsDouble failed: %v", err)
	}
	got, _ = a5.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsDouble: got %v, want %v", got, want)
	}

	// MinusEqualsInt
	a6, _ := FromData(defaultData, defaultShape)
	defer a6.Close()
	want = []float64{-1, 0, 1, 2}
	if err := a6.MinusEqualsInt(2); err != nil {
		t.Errorf("MinusEqualsInt failed: %v", err)
	}
	got, _ = a6.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsInt: got %v, want %v", got, want)
	}

	// TimesEqualsDouble
	a7, _ := FromData(defaultData, defaultShape)
	defer a7.Close()
	want = []float64{2, 4, 6, 8}
	if err := a7.TimesEqualsDouble(defaultVal); err != nil {
		t.Errorf("TimesEqualsDouble failed: %v", err)
	}
	got, _ = a7.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsDouble: got %v, want %v", got, want)
	}

	// TimesEqualsInt
	a8, _ := FromData(defaultData, defaultShape)
	defer a8.Close()
	want = []float64{2, 4, 6, 8}
	if err := a8.TimesEqualsInt(2); err != nil {
		t.Errorf("TimesEqualsInt failed: %v", err)
	}
	got, _ = a8.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsInt: got %v, want %v", got, want)
	}

	// DividesEqualsDouble
	a9, _ := FromData(defaultData, defaultShape)
	defer a9.Close()
	want = []float64{0.5, 1, 1.5, 2}
	if err := a9.DividesEqualsDouble(defaultVal); err != nil {
		t.Errorf("DividesEqualsDouble failed: %v", err)
	}
	got, _ = a9.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsDouble: got %v, want %v", got, want)
	}

	// DividesEqualsInt
	a10, _ := FromData(defaultData, defaultShape)
	defer a10.Close()
	want = []float64{0.5, 1, 1.5, 2}
	if err := a10.DividesEqualsInt(2); err != nil {
		t.Errorf("DividesEqualsInt failed: %v", err)
	}
	got, _ = a10.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsInt: got %v, want %v", got, want)
	}
}

func TestControlArray1D_NonMutatingOps(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	b, _ := FromData(defaultData, defaultShape)
	defer b.Close()
	fb, _ := farraydouble.FromData(defaultData, defaultShape)
	defer fb.Close()
	want := make([]float64, len(defaultData))

	// PlusControlArray1D
	res, err := a.PlusControlArray(b)
	if err != nil {
		t.Errorf("PlusControlArray1D failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] + defaultData[i]
	}
	got, _ := res.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusControlArray1D: got %v, want %v", got, want)
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

	// MinusControlArray1D
	c, _ := a.TimesDouble(2.0)
	res5, err := c.MinusControlArray(b)
	if err != nil {
		t.Errorf("MinusControlArray1D failed: %v", err)
	}
	defer res5.Close()
	for i := range want {
		want[i] = defaultData[i]
	}
	got, _ = res5.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusControlArray1D: got %v, want %v", got, want)
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

func TestControlArray1D_BooleanAndGetterMethods(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	if ok, err := a.Is1D(); err != nil || !ok {
		t.Errorf("Is1D failed: %v", err)
	}
	if _, err := a.As1D(); err != nil {
		t.Errorf("As1D failed: %v", err)
	}
	if _, err := a.GetStart(); err != nil {
		t.Errorf("GetStart failed: %v", err)
	}
	if _, err := a.GetEnd(); err != nil {
		t.Errorf("GetEnd failed: %v", err)
	}
	if _, err := a.IsDecreasing(); err != nil {
		t.Errorf("IsDecreasing failed: %v", err)
	}
	if _, err := a.IsIncreasing(); err != nil {
		t.Errorf("IsIncreasing failed: %v", err)
	}
	if _, err := a.GetDistance(); err != nil {
		t.Errorf("GetDistance failed: %v", err)
	}
	if _, err := a.GetMean(); err != nil {
		t.Errorf("GetMean failed: %v", err)
	}
	if _, err := a.GetStd(); err != nil {
		t.Errorf("GetStd failed: %v", err)
	}
	if err := a.Reverse(); err != nil {
		t.Errorf("Reverse failed: %v", err)
	}
	if _, err := a.GetClosestIndex(2.0); err != nil {
		t.Errorf("GetClosestIndex failed: %v", err)
	}
	if _, err := a.EvenDivisions(2); err != nil {
		t.Errorf("EvenDivisions failed: %v", err)
	}
}

func TestControlArray1D_MinMax(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	fb, _ := farraydouble.FromData(defaultData, defaultShape)
	c, _ := fb.TimesDouble(2.0)
	defer fb.Close()
	if _, err := a.MinFArray(c); err != nil {
		t.Errorf("MinFArray failed: %v", err)
	}
	if _, err := a.MaxFArray(c); err != nil {
		t.Errorf("MaxFArray failed: %v", err)
	}
	b, _ := FromData(defaultData, defaultShape)
	d, _ := b.TimesDouble(2.0)
	defer b.Close()
	if _, err := a.MinControlArray(d); err != nil {
		t.Errorf("MinControlArray1D failed: %v", err)
	}
	if _, err := a.MaxControlArray(d); err != nil {
		t.Errorf("MaxControlArray1D failed: %v", err)
	}
}

func TestControlArray1D_Equal(t *testing.T) {
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

func TestControlArray1D_GreaterLessThan(t *testing.T) {
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

func TestControlArray1D_RemoveOffsetSum(t *testing.T) {
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

func TestControlArray1D_WhereFlip(t *testing.T) {
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

func TestControlArray1D_FullGradientGradient(t *testing.T) {
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

func TestControlArray1D_SumOfSquaresAndDiffs(t *testing.T) {
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

func TestControlArray1D_ToJSONAndFromJSON(t *testing.T) {
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

func TestControlArray1D_ErrorBranches(t *testing.T) {
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
		t.Error("Expected error on PlusControlArray1D with nil")
	}
	_, err = a.MinControlArray(nil)
	if err == nil {
		t.Error("Expected error on MinControlArray1D with nil")
	}
	_, err = a.MaxControlArray(nil)
	if err == nil {
		t.Error("Expected error on MaxControlArray1D with nil")
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
