package labelledmeasuredarray

import (
	"math"
	"reflect"
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/measuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

var (
	defaultShape = []int{2, 2}
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

func TestLabelledMeasuredArray_ShapeDimensionData(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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
	data, err := a.Data()
	if err != nil {
		t.Fatalf("Data failed: %v", err)
	}
	if !eqSlice(data, defaultData) {
		t.Errorf("Expected %v, got %v", defaultData, data)
	}
}

func TestLabelledMeasuredArray_PlusEqualsFArray(t *testing.T) {
	aold, err := farraydouble.FromData(defaultData, defaultShape)
	if err != nil || aold == nil {
		t.Fatalf("farraydouble.FromData failed: %v", err)
	}
	bgate, err := connection.NewBarrierGate("B1")
	if err != nil || bgate == nil {
		t.Fatalf("NewBarrierGate failed: %v", err)
	}
	volt, err := symbolunit.NewVolt()
	if err != nil || volt == nil {
		t.Fatalf("NewVolt failed: %v", err)
	}
	ac, err := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	if err != nil || ac == nil {
		t.Fatalf("acquisitioncontext.New failed: %v", err)
	}
	a, err := FromFArray(aold, ac)
	if err != nil || a == nil {
		t.Fatalf("FromFArray failed: %v", err)
	}
	defer a.Close()
	b, _ := farraydouble.FromData(defaultData, defaultShape)
	defer b.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] + defaultData[i]
	}
	if err := a.PlusEqualsFArray(b); err != nil {
		t.Errorf("PlusEqualsFArray failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("PlusEqualsFArray: got %v, want %v", got, want)
	}
}

func TestLabelledMeasuredArray_PlusEqualsDouble(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_PlusEqualsInt(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_MinusEqualsFArray(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
	defer a.Close()
	b, _ := farraydouble.FromData(defaultData, defaultShape)
	defer b.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] - defaultData[i]
	}
	if err := a.MinusEqualsFArray(b); err != nil {
		t.Errorf("MinusEqualsFArray failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("MinusEqualsFArray: got %v, want %v", got, want)
	}
}

func TestLabelledMeasuredArray_MinusEqualsDouble(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_MinusEqualsInt(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_TimesEqualsFArray(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
	defer a.Close()
	b, _ := farraydouble.FromData(defaultData, defaultShape)
	defer b.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] * defaultData[i]
	}
	if err := a.TimesEqualsFArray(b); err != nil {
		t.Errorf("TimesEqualsFArray failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("TimesEqualsFArray: got %v, want %v", got, want)
	}
}

func TestLabelledMeasuredArray_TimesEqualsDouble(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_TimesEqualsInt(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_DividesEqualsFArray(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
	defer a.Close()
	b, _ := farraydouble.FromData(defaultData, defaultShape)
	defer b.Close()
	want := make([]float64, len(defaultData))
	for i := range want {
		want[i] = defaultData[i] / defaultData[i]
	}
	if err := a.DividesEqualsFArray(b); err != nil {
		t.Errorf("DividesEqualsFArray failed: %v", err)
	}
	got, _ := a.Data()
	if !eqSlice(got, want) {
		t.Errorf("DividesEqualsFArray: got %v, want %v", got, want)
	}
}

func TestLabelledMeasuredArray_DividesEqualsDouble(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_DividesEqualsInt(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_ArithmeticOpsNonMutating(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_MinMax(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_Equal(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
	defer a.Close()
	bold, _ := farraydouble.FromData(defaultData, defaultShape)
	b, _ := FromFArray(bold, ac)
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

func TestLabelledMeasuredArray_GreaterLessThan(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_RemoveOffsetSum(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
	defer a.Close()
	if err := a.RemoveOffset(defaultVal); err != nil {
		t.Errorf("RemoveOffset failed: %v", err)
	}
	_, err := a.Sum()
	if err != nil {
		t.Errorf("Sum failed: %v", err)
	}
}

func TestLabelledMeasuredArray_ReshapeWhereFlip(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_FullGradientGradient(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_SumOfSquaresAndDiffs(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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
	bold, _ := farraydouble.FromData(defaultData, defaultShape)
	b, _ := FromFArray(bold, ac)
	defer b.Close()
	_, err = a.GetSummedDiffArrayOfSquares(b)
	if err != nil {
		t.Errorf("GetSummedDiffArrayOfSquares failed: %v", err)
	}
}

func TestLabelledMeasuredArray_ToJSONAndFromJSON(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func TestLabelledMeasuredArray_ErrorBranches(t *testing.T) {
	aold, _ := farraydouble.FromData(defaultData, defaultShape)
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	a, _ := FromFArray(aold, ac)
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

func mustMeasuredArray() *measuredarray.Handle {
	h, err := measuredarray.FromData([]float64{1, 2, 3, 4}, []int{2, 2})
	if err != nil {
		panic(err)
	}
	return h
}

func TestLabelledMeasuredArray_FromMeasuredArray(t *testing.T) {
	// nil input
	bgate, _ := connection.NewBarrierGate("B1")
	volt, _ := symbolunit.NewVolt()
	ac, _ := acquisitioncontext.New(bgate, instrumenttypes.VoltageSource(), volt)
	lma, err := FromMeasuredArray(nil, ac)
	if err == nil || lma != nil {
		t.Errorf("FromMeasuredArray(nil) should error and return nil")
	}

	// valid input
	ma := mustMeasuredArray()
	defer ma.Close()
	lma, err = FromMeasuredArray(ma, ac)
	if err != nil {
		t.Fatalf("FromMeasuredArray failed: %v", err)
	}
	defer lma.Close()

	// CAPIHandle (open)
	ptr, err := lma.CAPIHandle()
	if err != nil || ptr == nil {
		t.Errorf("CAPIHandle (open) failed: %v", err)
	}

	// Label
	label, err := lma.Label()
	if err != nil {
		t.Errorf("Label failed: %v", err)
	}
	if label != nil {
		label.Close()
	}

	// Connection
	conn, err := lma.Connection()
	if err != nil {
		t.Errorf("Connection failed: %v", err)
	}
	if conn != nil {
		conn.Close()
	}

	// InstrumentType
	_, err = lma.InstrumentType()
	if err != nil {
		t.Errorf("InstrumentType failed: %v", err)
	}

	// Units
	units, err := lma.Units()
	if err != nil {
		t.Errorf("Units failed: %v", err)
	}
	if units != nil {
		units.Close()
	}

	// Error branches for closed handle
	lma.Close()
	_, err = lma.Label()
	if err == nil {
		t.Errorf("Label on closed should error")
	}
	_, err = lma.Connection()
	if err == nil {
		t.Errorf("Connection on closed should error")
	}
	_, err = lma.InstrumentType()
	if err == nil {
		t.Errorf("InstrumentType on closed should error")
	}
	_, err = lma.Units()
	if err == nil {
		t.Errorf("Units on closed should error")
	}
}
