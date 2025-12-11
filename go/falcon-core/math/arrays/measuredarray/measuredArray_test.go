package measuredarray

import (
	"math"
	"reflect"
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
)

var (
	defaultShape = []uint64{2, 2}
	defaultData  = []float64{1., .2, 3., .4}
	defaultVal   = float64(5.2)
	otherData    = []float64{9., .8, 7., .6}
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

func TestMeasuredArray_FromDataAndClose(t *testing.T) {
	a, err := FromData(defaultData, defaultShape)
	if err != nil {
		t.Fatalf("FromData failed: %v", err)
	}
	defer a.Close()
	if sz, err := a.Size(); err != nil || sz != 4 {
		t.Errorf("Expected size 4, got %d, err: %v", sz, err)
	}
}

func TestMeasuredArray_ShapeDimensionData(t *testing.T) {
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
	data, err := a.Data()
	if err != nil {
		t.Fatalf("Data failed: %v", err)
	}
	if !eqSlice(data, defaultData) {
		t.Errorf("Expected %v, got %v", defaultData, data)
	}
}

func TestMeasuredArray_ArithmeticOpsEquals(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	b, _ := farraydouble.FromData(defaultData, defaultShape)
	defer b.Close()
	want := make([]float64, len(defaultData))

	// PlusEqualsFArray
	if err := a.PlusEqualsFArray(b); err != nil {
		t.Errorf("PlusEqualsFArray failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] + defaultData[i]
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsFArray: got %v, want %v", got, want)
	}

	// PlusEqualsDouble
	a2, _ := FromData(defaultData, defaultShape)
	defer a2.Close()
	if err := a2.PlusEqualsDouble(defaultVal); err != nil {
		t.Errorf("PlusEqualsDouble failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] + defaultVal
	}
	got, _ = a2.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsDouble: got %v, want %v", got, want)
	}

	// PlusEqualsInt
	a3, _ := FromData(defaultData, defaultShape)
	defer a3.Close()
	if err := a3.PlusEqualsInt(2); err != nil {
		t.Errorf("PlusEqualsInt failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] + 2
	}
	got, _ = a3.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsInt: got %v, want %v", got, want)
	}

	// MinusEqualsFArray
	a4, _ := FromData(defaultData, defaultShape)
	defer a4.Close()
	if err := a4.MinusEqualsFArray(b); err != nil {
		t.Errorf("MinusEqualsFArray failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] - defaultData[i]
	}
	got, _ = a4.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsFArray: got %v, want %v", got, want)
	}

	// MinusEqualsDouble
	a5, _ := FromData(defaultData, defaultShape)
	defer a5.Close()
	if err := a5.MinusEqualsDouble(defaultVal); err != nil {
		t.Errorf("MinusEqualsDouble failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] - defaultVal
	}
	got, _ = a5.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsDouble: got %v, want %v", got, want)
	}

	// MinusEqualsInt
	a6, _ := FromData(defaultData, defaultShape)
	defer a6.Close()
	if err := a6.MinusEqualsInt(2); err != nil {
		t.Errorf("MinusEqualsInt failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] - 2
	}
	got, _ = a6.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsInt: got %v, want %v", got, want)
	}

	// TimesEqualsFArray
	a7, _ := FromData(defaultData, defaultShape)
	defer a7.Close()
	if err := a7.TimesEqualsFArray(b); err != nil {
		t.Errorf("TimesEqualsFArray failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] * defaultData[i]
	}
	got, _ = a7.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsFArray: got %v, want %v", got, want)
	}

	// TimesEqualsDouble
	a8, _ := FromData(defaultData, defaultShape)
	defer a8.Close()
	if err := a8.TimesEqualsDouble(defaultVal); err != nil {
		t.Errorf("TimesEqualsDouble failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] * defaultVal
	}
	got, _ = a8.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsDouble: got %v, want %v", got, want)
	}

	// TimesEqualsInt
	a9, _ := FromData(defaultData, defaultShape)
	defer a9.Close()
	if err := a9.TimesEqualsInt(2); err != nil {
		t.Errorf("TimesEqualsInt failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] * 2
	}
	got, _ = a9.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsInt: got %v, want %v", got, want)
	}

	// DividesEqualsFArray
	a10, _ := FromData(defaultData, defaultShape)
	defer a10.Close()
	if err := a10.DividesEqualsFArray(b); err != nil {
		t.Errorf("DividesEqualsFArray failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] / defaultData[i]
	}
	got, _ = a10.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsFArray: got %v, want %v", got, want)
	}

	// DividesEqualsDouble
	a11, _ := FromData(defaultData, defaultShape)
	defer a11.Close()
	if err := a11.DividesEqualsDouble(defaultVal); err != nil {
		t.Errorf("DividesEqualsDouble failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] / defaultVal
	}
	got, _ = a11.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsDouble: got %v, want %v", got, want)
	}

	// DividesEqualsInt
	a12, _ := FromData(defaultData, defaultShape)
	defer a12.Close()
	if err := a12.DividesEqualsInt(2); err != nil {
		t.Errorf("DividesEqualsInt failed: %v", err)
	}
	for i := range want {
		want[i] = defaultData[i] / 2
	}
	got, _ = a12.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsInt: got %v, want %v", got, want)
	}
}

func TestMeasuredArray_ArithmeticOpsNonMutating(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	b, _ := farraydouble.FromData(defaultData, defaultShape)
	defer b.Close()
	want := make([]float64, len(defaultData))

	// PlusFArray
	res, err := a.PlusFArray(b)
	if err != nil {
		t.Errorf("PlusFArray failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] + defaultData[i]
	}
	got, _ := res.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusFArray: got %v, want %v", got, want)
	}

	// PlusDouble
	res, err = a.PlusDouble(defaultVal)
	if err != nil {
		t.Errorf("PlusDouble failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] + defaultVal
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusDouble: got %v, want %v", got, want)
	}

	// PlusInt
	res, err = a.PlusInt(2)
	if err != nil {
		t.Errorf("PlusInt failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] + 2
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusInt: got %v, want %v", got, want)
	}

	// MinusFArray
	res, err = a.MinusFArray(b)
	if err != nil {
		t.Errorf("MinusFArray failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] - defaultData[i]
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusFArray: got %v, want %v", got, want)
	}

	// MinusDouble
	res, err = a.MinusDouble(defaultVal)
	if err != nil {
		t.Errorf("MinusDouble failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] - defaultVal
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusDouble: got %v, want %v", got, want)
	}

	// MinusInt
	res, err = a.MinusInt(2)
	if err != nil {
		t.Errorf("MinusInt failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] - 2
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusInt: got %v, want %v", got, want)
	}

	// Negation
	res, err = a.Negation()
	if err != nil {
		t.Errorf("Negation failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = -defaultData[i]
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("Negation: got %v, want %v", got, want)
	}

	// TimesFArray
	res, err = a.TimesFArray(b)
	if err != nil {
		t.Errorf("TimesFArray failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] * defaultData[i]
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesFArray: got %v, want %v", got, want)
	}

	// TimesDouble
	res, err = a.TimesDouble(defaultVal)
	if err != nil {
		t.Errorf("TimesDouble failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] * defaultVal
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesDouble: got %v, want %v", got, want)
	}

	// TimesInt
	res, err = a.TimesInt(2)
	if err != nil {
		t.Errorf("TimesInt failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] * 2
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesInt: got %v, want %v", got, want)
	}

	// DividesFArray
	res, err = a.DividesFArray(b)
	if err != nil {
		t.Errorf("DividesFArray failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] / defaultData[i]
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesFArray: got %v, want %v", got, want)
	}

	// DividesDouble
	res, err = a.DividesDouble(defaultVal)
	if err != nil {
		t.Errorf("DividesDouble failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] / defaultVal
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesDouble: got %v, want %v", got, want)
	}

	// DividesInt
	res, err = a.DividesInt(2)
	if err != nil {
		t.Errorf("DividesInt failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = defaultData[i] / 2
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesInt: got %v, want %v", got, want)
	}

	// Pow
	res, err = a.Pow(defaultVal)
	if err != nil {
		t.Errorf("Pow failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		want[i] = math.Pow(defaultData[i], defaultVal)
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("Pow: got %v, want %v", got, want)
	}

	// Abs
	res, err = a.Abs()
	if err != nil {
		t.Errorf("Abs failed: %v", err)
	}
	defer res.Close()
	for i := range want {
		v := defaultData[i]
		if v < 0 {
			want[i] = -v
		} else {
			want[i] = v
		}
	}
	got, _ = res.Data()
	if !eqSlice(got, want) {
		t.Errorf("Abs: got %v, want %v", got, want)
	}
}

func TestMeasuredArray_MinMax(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	b, _ := farraydouble.FromData(defaultData, defaultShape)
	defer b.Close()
	_, err := a.MinFArray(b)
	if err != nil {
		t.Errorf("MinFArray failed: %v", err)
	}
	_, err = a.MaxFArray(b)
	if err != nil {
		t.Errorf("MaxFArray failed: %v", err)
	}
}

func TestMeasuredArray_Equal(t *testing.T) {
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

func TestMeasuredArray_GreaterLessThan(t *testing.T) {
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

func TestMeasuredArray_RemoveOffsetSum(t *testing.T) {
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

func TestMeasuredArray_ReshapeWhereFlip(t *testing.T) {
	a, _ := FromData(defaultData, defaultShape)
	defer a.Close()
	_, err := a.Reshape([]int32{4, 1})
	if err != nil {
		t.Errorf("Reshape failed: %v", err)
	}
	_, err = a.Where(defaultVal)
	if err != nil {
		t.Errorf("Where failed: %v", err)
	}
	_, err = a.Flip(0)
	if err != nil {
		t.Errorf("Flip failed: %v", err)
	}
}

func TestMeasuredArray_FullGradientGradient(t *testing.T) {
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

func TestMeasuredArray_SumOfSquaresAndDiffs(t *testing.T) {
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

func TestMeasuredArray_ToJSONAndFromJSON(t *testing.T) {
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

func TestMeasuredArray_ErrorBranches(t *testing.T) {
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
	_, err = a.PlusFArray(nil)
	if err == nil {
		t.Error("Expected error on PlusFArray with nil")
	}
	_, err = a.MinFArray(nil)
	if err == nil {
		t.Error("Expected error on MinFArray with nil")
	}
	_, err = a.MaxFArray(nil)
	if err == nil {
		t.Error("Expected error on MaxFArray with nil")
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
