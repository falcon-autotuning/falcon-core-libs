package hdf5data

import (
	"fmt"
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementrequest"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/messages/measurementresponse"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listwaveform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinstrumentportporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringstring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringstring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/waveform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledarrayslabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretespace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/unitspace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustLabelledMeasuredArray(name string) *labelledmeasuredarray.Handle {
	// Create a simple farraydouble
	fa, err := farraydouble.FromData([]float64{1.0, 2.0, 3.0}, []int{3})
	if err != nil {
		panic("failed to create farraydouble: " + err.Error())
	}
	defer fa.Close()
	conn, _ := connection.NewPlungerGate(name)
	v, _ := symbolunit.NewVolt()
	is, _ := instrumentport.NewKnob(name, conn, instrumenttypes.DCVoltageSource(), v, "")
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

func mustLabelledArraysLabelledMeasuredArray(name string) *labelledarrayslabelledmeasuredarray.Handle {
	lm := mustLabelledMeasuredArray(name)
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

func mustMeasurementResponse(name string) *measurementresponse.Handle {
	h, err := measurementresponse.New(mustLabelledArraysLabelledMeasuredArray(name))
	if err != nil {
		panic("failed to create measurement response")
	}
	return h
}

func mustMeasurementRequest(msg, name string) *measurementrequest.Handle {
	// --- Setup a minimal but real MeasurementRequest ---
	// Waveform
	wf := mustWaveform("A")
	defer wf.Close()
	wflist, err := listwaveform.New([]*waveform.Handle{wf})
	if err != nil {
		panic("failed to create listwaveform: " + err.Error())
	}
	defer wflist.Close()
	// Getter
	getter, err := ports.NewEmpty()
	if err != nil {
		panic("failed to create ports: " + err.Error())
	}
	defer getter.Close()
	// Meter transform
	pt := mustPortTransform(mustInstrumentPort("A"), 0.2)
	defer pt.Close()
	port := mustInstrumentPort("A")
	defer port.Close()
	meterTransforms, err := mapinstrumentportporttransform.New(nil)
	if err != nil {
		panic("failed to create mapinstrumentportporttransform: " + err.Error())
	}
	defer meterTransforms.Close()
	_ = meterTransforms.Insert(port, pt)
	// Time domain
	clock, _ := instrumentport.NewExecutionClock()
	timeDomain := mustLabelledDomain(0, 1.0, instrumenttypes.Clock(), clock, true, true)
	defer timeDomain.Close()
	// Construct
	h, err := measurementrequest.New(msg, name, wflist, getter, meterTransforms, timeDomain)
	if err != nil {
		panic("failed to create MeasurementRequest: " + err.Error())
	}
	return h
}

func mustWaveform(name string) *waveform.Handle {
	dom := mustDomain()
	p := mustInstrumentPort(name)
	axes := mustAxesCoupledLabelledDomain(p, dom)
	// MapStringBool
	pair, _ := pairstringbool.New(name, true)
	msb, err := mapstringbool.New([]*pairstringbool.Handle{pair})
	if err != nil {
		panic(fmt.Errorf("mapstringbool.New error: %v", err))
	}
	// AxesMapStringBool
	amap, err := axesmapstringbool.NewEmpty()
	if err != nil {
		panic(fmt.Errorf("axesmapstringbool.NewEmpty error: %v", err))
	}
	amap.PushBack(msb)
	// Discretizer
	discr, err := discretizer.NewCartesianDiscretizer(0.1)
	if err != nil {
		panic(fmt.Errorf("discretizer.NewCartesian error: %v", err))
	}
	ad, err := axesdiscretizer.New([]*discretizer.Handle{discr})
	if err != nil {
		panic(fmt.Errorf("axesdiscretizer.New error: %v", err))
	}
	// UnitSpace
	unit, err := unitspace.New(ad, dom)
	if err != nil {
		panic(fmt.Errorf("unitspace.New error: %v", err))
	}
	// DiscreteSpace
	ds, err := discretespace.New(unit, axes, amap)
	if err != nil {
		panic(fmt.Errorf("discretespace.New error: %v", err))
	}
	// AnalyticFunction
	labels, err := liststring.New([]string{"x"})
	if err != nil {
		panic(fmt.Errorf("liststring.New error: %v", err))
	}
	af, err := analyticfunction.New(labels, "2x[0]+1")
	if err != nil {
		panic(fmt.Errorf("analyticfunction.New error: %v", err))
	}
	// PortTransform
	pt, err := porttransform.New(p, af)
	if err != nil {
		panic(fmt.Errorf("porttransform.New error: %v", err))
	}
	// ListPortTransform
	lpt, err := listporttransform.New([]*porttransform.Handle{pt})
	if err != nil {
		panic(fmt.Errorf("listporttransform.New error: %v", err))
	}
	// Waveform
	w, err := waveform.New(ds, lpt)
	if err != nil {
		panic(fmt.Errorf("waveform.New error: %v", err))
	}
	return w
}

func mustPortTransform(port *instrumentport.Handle, val float64) *porttransform.Handle {
	h, err := porttransform.NewConstantTransform(port, val)
	if err != nil {
		panic(err)
	}
	return h
}

func mustLabelledDomain(minVal, maxVal float64, instrumentType string, port *instrumentport.Handle, lesserBoundContained, greaterBoundContained bool) *labelleddomain.Handle {
	h, err := labelleddomain.NewFromPort(minVal, maxVal, instrumentType, port, lesserBoundContained, greaterBoundContained)
	if err != nil {
		panic(fmt.Errorf("failed to craete a lablled domain: %v", err))
	}
	return h
}

func mustAxesInt() *axesint.Handle {
	h, err := axesint.New([]int32{1})
	if err != nil {
		panic("failed to create axesint: " + err.Error())
	}
	return h
}

func mustControlArray() *controlarray.Handle {
	h, err := controlarray.FromData([]float64{0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}, []int{11})
	if err != nil {
		panic("failed to create controlarray: " + err.Error())
	}
	return h
}

func mustAxesControlArray() *axescontrolarray.Handle {
	h, err := axescontrolarray.NewEmpty()
	if err != nil {
		panic("failed to create axescontrolarray: " + err.Error())
	}
	h.PushBack(mustControlArray())
	return h
}

func mustDomain() *domain.Handle {
	h, err := domain.New(0.0, 1.0, true, true)
	if err != nil {
		panic("failed to create domain: " + err.Error())
	}
	return h
}

func mustInstrumentPort(name string) *instrumentport.Handle {
	h, err := instrumentport.NewKnob(name, mustBarrierGate(name), instrumenttypes.VoltageSource(), mustVolt(), "A test")
	if err != nil {
		panic("failed to create instrumentport: " + err.Error())
	}
	return h
}

func mustAxesCoupledLabelledDomain(p *instrumentport.Handle, dom *domain.Handle) *axescoupledlabelleddomain.Handle {
	ld, err := labelleddomain.NewFromPortAndDomain(p, dom)
	if err != nil {
		panic(fmt.Errorf("labelleddomain.NewFromPortAndDomain error: %v", err))
	}
	// CoupledLabelledDomain
	cld, err := coupledlabelleddomain.New([]*labelleddomain.Handle{ld})
	if err != nil {
		panic(fmt.Errorf("coupledlabelleddomain.New error: %v", err))
	}
	// AxesCoupledLabelledDomain
	axes, err := axescoupledlabelleddomain.NewEmpty()
	if err != nil {
		panic(fmt.Errorf("axescoupledlabelleddomain.NewEmpty error: %v", err))
	}
	err = axes.PushBack(cld)
	if err != nil {
		panic("failed to create axescoupledlabelleddomain: " + err.Error())
	}
	return axes
}

func mustMapStringString(name string) *mapstringstring.Handle {
	mrepjson, err := mustMeasurementResponse(name).ToJSON()
	if err != nil {
		panic("failed to create measurement response JSON: " + err.Error())
	}
	pssrep, _ := pairstringstring.New("song_response", mrepjson)
	mreqjson, err := mustMeasurementRequest("this is really happening", "P1").ToJSON()
	if err != nil {
		panic("failed to create measurement response JSON: " + err.Error())
	}
	pssreq, _ := pairstringstring.New("song_request", mreqjson)
	h, err := mapstringstring.New([]*pairstringstring.Handle{pssrep, pssreq})
	if err != nil {
		panic("failed to create mapstringstring: " + err.Error())
	}
	return h
}

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("failed to create BarrierGate: %v", err))
	}
	return h
}

func mustDeviceVoltageState(conn *connection.Handle, val float64) *devicevoltagestate.Handle {
	h, err := devicevoltagestate.New(conn, val, mustVolt())
	if err != nil {
		panic(err)
	}
	return h
}

func mustVolt() *symbolunit.Handle {
	h, err := symbolunit.NewVolt()
	if err != nil {
		panic(err)
	}
	return h
}

func TestHDF5Data_NewAndToFile(t *testing.T) {
	name := "P1"
	shape := mustAxesInt()
	defer shape.Close()
	unitDomain := mustAxesControlArray()
	defer unitDomain.Close()
	domainLabels := mustAxesCoupledLabelledDomain(mustInstrumentPort(name), mustDomain())
	defer domainLabels.Close()
	ranges := mustLabelledArraysLabelledMeasuredArray(name)
	defer ranges.Close()
	metadata := mustMapStringString(name)
	defer metadata.Close()
	h, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title", 42, 123456)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	_ = h.ToFile("/tmp/testfile.h5")
}

func TestHDF5Data_ToCommunications(t *testing.T) {
	name := "P1"
	shape := mustAxesInt()
	defer shape.Close()
	unitDomain := mustAxesControlArray()
	defer unitDomain.Close()
	domainLabels := mustAxesCoupledLabelledDomain(mustInstrumentPort(name), mustDomain())
	defer domainLabels.Close()
	ranges := mustLabelledArraysLabelledMeasuredArray("P1")
	defer ranges.Close()
	metadata := mustMapStringString(name)
	defer metadata.Close()
	h, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title", 42, 123456)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	comm, err := h.ToCommunications()
	if err != nil {
		t.Errorf("ToCommunications error: %v", err)
	}
	if comm == nil {
		t.Errorf("ToCommunications returned nil")
	}
}

func TestHDF5Data_Equality(t *testing.T) {
	name := "P1"
	shape := mustAxesInt()
	defer shape.Close()
	unitDomain := mustAxesControlArray()
	defer unitDomain.Close()
	domainLabels := mustAxesCoupledLabelledDomain(mustInstrumentPort(name), mustDomain())
	defer domainLabels.Close()
	ranges := mustLabelledArraysLabelledMeasuredArray(name)
	defer ranges.Close()
	metadata := mustMapStringString(name)
	defer metadata.Close()
	h, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title", 42, 123456)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	h2, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title2", 43, 123457)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h2.Close()
	_, _ = h.Equal(h2)
	_, _ = h.NotEqual(h2)
	_, _ = h.Equal(h)
	_, _ = h.NotEqual(h)
}

func TestHDF5Data_NilAndClosedBranches(t *testing.T) {
	name := "P1"
	shape := mustAxesInt()
	defer shape.Close()
	unitDomain := mustAxesControlArray()
	defer unitDomain.Close()
	domainLabels := mustAxesCoupledLabelledDomain(mustInstrumentPort(name), mustDomain())
	defer domainLabels.Close()
	ranges := mustLabelledArraysLabelledMeasuredArray(name)
	defer ranges.Close()
	metadata := mustMapStringString(name)
	defer metadata.Close()
	h, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title", 42, 123456)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	h2, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title2", 43, 123457)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h2.Close()
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
}

func TestHDF5Data_ToJSON(t *testing.T) {
	name := "P1"
	shape := mustAxesInt()
	defer shape.Close()
	unitDomain := mustAxesControlArray()
	defer unitDomain.Close()
	domainLabels := mustAxesCoupledLabelledDomain(mustInstrumentPort(name), mustDomain())
	defer domainLabels.Close()
	ranges := mustLabelledArraysLabelledMeasuredArray(name)
	defer ranges.Close()
	metadata := mustMapStringString(name)
	defer metadata.Close()
	h, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title", 42, 123456)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	_, err = h.ToJSON()
	if err != nil {
		t.Errorf("ToJSON error: %v", err)
	}
}

func TestHDF5Data_NewFromFile(t *testing.T) {
	name := "P1"
	shape := mustAxesInt()
	defer shape.Close()
	unitDomain := mustAxesControlArray()
	defer unitDomain.Close()
	domainLabels := mustAxesCoupledLabelledDomain(mustInstrumentPort(name), mustDomain())
	defer domainLabels.Close()
	ranges := mustLabelledArraysLabelledMeasuredArray(name)
	defer ranges.Close()
	metadata := mustMapStringString(name)
	defer metadata.Close()
	h, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title", 42, 123456)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	_ = h.ToFile("/tmp/testfile.h5")
	h3, err := NewFromFile("/tmp/testfile.h5")
	if err != nil {
		t.Errorf("NewFromFile error: %v", err)
	}
	defer h3.Close()
	_, _ = h.Equal(h3)
}

func TestHDF5Data_NewFromCommunications(t *testing.T) {
	req := mustMeasurementRequest("hello world", "P1")
	defer req.Close()
	resp := mustMeasurementResponse("P1")
	defer resp.Close()
	dvs := mustDeviceVoltageState(mustBarrierGate("B1"), 1.0)
	dvss, _ := devicevoltagestates.New([]*devicevoltagestate.Handle{dvs})
	defer dvs.Close()
	var sessionID [16]int8
	h4, err := NewFromCommunications(req, resp, dvss, sessionID, "title", 44, 123458)
	if err != nil {
		t.Errorf("NewFromCommunications error: %v", err)
	}
	defer h4.Close()
	_, err = h4.ToCommunications()
	if err != nil {
		t.Errorf("ToCommunications on h4 error: %v", err)
	}
}

func TestHDF5Data_ClosedErrorBranches(t *testing.T) {
	name := "P1"
	shape := mustAxesInt()
	defer shape.Close()
	unitDomain := mustAxesControlArray()
	defer unitDomain.Close()
	domainLabels := mustAxesCoupledLabelledDomain(mustInstrumentPort(name), mustDomain())
	defer domainLabels.Close()
	ranges := mustLabelledArraysLabelledMeasuredArray(name)
	defer ranges.Close()
	metadata := mustMapStringString(name)
	defer metadata.Close()
	h, err := New(shape, unitDomain, domainLabels, ranges, metadata, "title", 42, 123456)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer h.Close()
	_ = h.ToFile("/tmp/testfile.h5")
	h3, err := NewFromFile("/tmp/testfile.h5")
	if err != nil {
		t.Errorf("NewFromFile error: %v", err)
	}
	h3.Close()
	if err := h3.Close(); err == nil {
		t.Errorf("Second close should error")
	}
	if _, err := h3.ToCommunications(); err == nil {
		t.Errorf("ToCommunications on closed should error")
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
