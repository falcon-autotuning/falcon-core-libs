package unitspace

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
)

func makeTestDomain(t *testing.T) *domain.Handle {
	d, err := domain.New(0, 1, true, true)
	if err != nil {
		t.Fatalf("domain.New error: %v", err)
	}
	return d
}

func makeTestAxesDiscretizer(t *testing.T) *axesdiscretizer.Handle {
	a, err := axesdiscretizer.New([]*discretizer.Handle{makeTestDiscretizer(t)})
	if err != nil {
		t.Fatalf("axesdiscretizer.NewEmpty error: %v", err)
	}
	return a
}

func makeTestAxesDouble(t *testing.T) *axesdouble.Handle {
	a, err := axesdouble.New([]float64{50.0})
	if err != nil {
		t.Fatalf("axesdouble.New error: %v", err)
	}
	return a
}

func makeTestAxesInt(t *testing.T) *axesint.Handle {
	a, err := axesint.New([]int32{0})
	if err != nil {
		t.Fatalf("axesint.New error: %v", err)
	}
	return a
}

func makeTestDiscretizer(t *testing.T) *discretizer.Handle {
	a, err := discretizer.NewCartesian(0.2)
	if err != nil {
		t.Fatalf("discretizer.NewEmpty error: %v", err)
	}
	return a
}

func withUnitSpace(t *testing.T, fn func(t *testing.T, us *Handle)) {
	axes := makeTestAxesDiscretizer(t)
	defer axes.Close()
	dom := makeTestDomain(t)
	defer dom.Close()
	us, err := New(axes, dom)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	defer us.Close()
	fn(t, us)
}

func TestUnitSpace_NewAndFields(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		axes, err := us.Axes()
		if err != nil {
			t.Fatalf("Axes error: %v", err)
		}
		defer axes.Close()
		dom, err := us.Domain()
		if err != nil {
			t.Fatalf("Domain error: %v", err)
		}
		defer dom.Close()
		us.Compile()
		space, err := us.Space()
		if err != nil {
			t.Fatalf("Space error: %v", err)
		}
		defer space.Close()
		shape, err := us.Shape()
		if err != nil {
			t.Fatalf("Shape error: %v", err)
		}
		defer shape.Close()
		dim, err := us.Dimension()
		if err != nil {
			t.Fatalf("Dimension error: %v", err)
		}
		if dim < 0 {
			t.Errorf("Dimension = %v, want >=0", dim)
		}
	})
}

func TestUnitSpace_NewRaySpace(t *testing.T) {
	dom := makeTestDomain(t)
	defer dom.Close()
	us, err := NewRaySpace(1.0, 2.0, dom)
	if err != nil {
		t.Fatalf("NewRaySpace error: %v", err)
	}
	defer us.Close()
}

func TestUnitSpace_NewCartesianSpace(t *testing.T) {
	deltas := makeTestAxesDouble(t)
	defer deltas.Close()
	dom := makeTestDomain(t)
	defer dom.Close()
	us, err := NewCartesianSpace(deltas, dom)
	if err != nil {
		t.Fatalf("NewCartesianSpace error: %v", err)
	}
	defer us.Close()
}

func TestUnitSpace_NewCartesian1DSpace(t *testing.T) {
	dom := makeTestDomain(t)
	defer dom.Close()
	us, err := NewCartesian1DSpace(1.0, dom)
	if err != nil {
		t.Fatalf("NewCartesian1DSpace error: %v", err)
	}
	defer us.Close()
}

func TestUnitSpace_NewCartesian2DSpace(t *testing.T) {
	deltas := makeTestAxesDouble(t)
	defer deltas.Close()
	dom := makeTestDomain(t)
	defer dom.Close()
	us, err := NewCartesian2DSpace(deltas, dom)
	if err != nil {
		t.Fatalf("NewCartesian2DSpace error: %v", err)
	}
	defer us.Close()
}

func TestUnitSpace_Compile(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		if err := us.Compile(); err != nil {
			t.Errorf("Compile error: %v", err)
		}
	})
}

func TestUnitSpace_CreateArray(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		axes := makeTestAxesInt(t)
		defer axes.Close()
		arr, err := us.CreateArray(axes)
		if err != nil {
			t.Errorf("CreateArray error: %v", err)
		}
		if arr != nil {
			defer arr.Close()
		}
	})
}

func TestUnitSpace_PushBackAndItems(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		disc := makeTestDiscretizer(t)
		defer disc.Close()
		if err := us.PushBack(disc); err != nil {
			t.Errorf("PushBack error: %v", err)
		}
		items, err := us.Items()
		if err != nil {
			t.Errorf("Items error: %v", err)
		}
		// Items may be empty if not supported, but should not panic
		_ = items
	})
}

func TestUnitSpace_SizeEmptyEraseAtClear(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		sz, err := us.Size()
		if err != nil {
			t.Errorf("Size error: %v", err)
		}
		_ = sz
		empty, err := us.Empty()
		if err != nil {
			t.Errorf("Empty error: %v", err)
		}
		_ = empty
		if err := us.EraseAt(0); err != nil {
			// May error if nothing to erase, but should not panic
		}
		if err := us.Clear(); err != nil {
			t.Errorf("Clear error: %v", err)
		}
	})
}

func TestUnitSpace_AtContainsIndex(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		disc := makeTestDiscretizer(t)
		defer disc.Close()
		_ = us.PushBack(disc)
		_, _ = us.At(0)
		_, _ = us.Contains(disc)
		_, _ = us.Index(disc)
	})
}

func TestUnitSpace_IntersectionEqualNotEqual(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		axes := makeTestAxesDiscretizer(t)
		defer axes.Close()
		dom := makeTestDomain(t)
		defer dom.Close()
		us2, err := New(axes, dom)
		if err != nil {
			t.Fatalf("New error: %v", err)
		}
		defer us2.Close()
		_, _ = us.Intersection(us2)
		_, _ = us.Equal(us2)
		_, _ = us.NotEqual(us2)
		_, err = us.Equal(nil)
		if err == nil {
			t.Error("Equal(nil) should error")
		}
		_, err = us.NotEqual(nil)
		if err == nil {
			t.Error("NotEqual(nil) should error")
		}
	})
}

func TestUnitSpace_ToJSONAndFromJSON(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		jsonStr, err := us.ToJSON()
		if err != nil {
			t.Fatalf("ToJSON error: %v", err)
		}
		us2, err := FromJSON(jsonStr)
		if err != nil {
			t.Fatalf("FromJSON error: %v", err)
		}
		defer us2.Close()
		eq, err := us.Equal(us2)
		if err != nil || !eq {
			t.Errorf("ToJSON/FromJSON roundtrip not equal: %v, err: %v", eq, err)
		}
	})
}

func TestUnitSpace_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestUnitSpace_CAPIHandle(t *testing.T) {
	withUnitSpace(t, func(t *testing.T, us *Handle) {
		ptr, err := us.CAPIHandle()
		if err != nil {
			t.Errorf("CAPIHandle failed: %v", err)
		}
		if ptr == nil {
			t.Errorf("CAPIHandle returned nil")
		}
	})
}

func TestUnitSpace_ClosedErrors(t *testing.T) {
	axes := makeTestAxesDiscretizer(t)
	defer axes.Close()
	dom := makeTestDomain(t)
	defer dom.Close()
	us, err := New(axes, dom)
	if err != nil {
		t.Fatalf("New error: %v", err)
	}
	us.Close()
	if _, err := us.CAPIHandle(); err == nil {
		t.Error("CAPIHandle on closed: expected error")
	}
	if err := us.Close(); err == nil {
		t.Error("Second close should error")
	}
	if _, err := us.Axes(); err == nil {
		t.Error("Axes on closed: expected error")
	}
	if _, err := us.Domain(); err == nil {
		t.Error("Domain on closed: expected error")
	}
	if _, err := us.Space(); err == nil {
		t.Error("Space on closed: expected error")
	}
	if _, err := us.Shape(); err == nil {
		t.Error("Shape on closed: expected error")
	}
	if _, err := us.Dimension(); err == nil {
		t.Error("Dimension on closed: expected error")
	}
	if err := us.Compile(); err == nil {
		t.Error("Compile on closed: expected error")
	}
	if _, err := us.CreateArray(nil); err == nil {
		t.Error("CreateArray on closed: expected error")
	}
	if err := us.PushBack(nil); err == nil {
		t.Error("PushBack on closed: expected error")
	}
	if _, err := us.Size(); err == nil {
		t.Error("Size on closed: expected error")
	}
	if _, err := us.Empty(); err == nil {
		t.Error("Empty on closed: expected error")
	}
	if err := us.EraseAt(0); err == nil {
		t.Error("EraseAt on closed: expected error")
	}
	if err := us.Clear(); err == nil {
		t.Error("Clear on closed: expected error")
	}
	if _, err := us.At(0); err == nil {
		t.Error("At on closed: expected error")
	}
	if _, err := us.Items(); err == nil {
		t.Error("Items on closed: expected error")
	}
	if _, err := us.Contains(nil); err == nil {
		t.Error("Contains on closed: expected error")
	}
	if _, err := us.Index(nil); err == nil {
		t.Error("Index on closed: expected error")
	}
	if _, err := us.Intersection(us); err == nil {
		t.Error("Intersection on closed: expected error")
	}
	if _, err := us.Equal(us); err == nil {
		t.Error("Equal on closed: expected error")
	}
	if _, err := us.NotEqual(us); err == nil {
		t.Error("NotEqual on closed: expected error")
	}
	if _, err := us.ToJSON(); err == nil {
		t.Error("ToJSON on closed: expected error")
	}
}
