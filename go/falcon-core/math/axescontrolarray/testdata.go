package axescontrolarray

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray"
)

func mustControlArray(data []float64, shape []int) *controlarray.Handle {
	h, err := controlarray.FromData(data, shape)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultAxesData = []*controlarray.Handle{
		mustControlArray([]float64{0.0, 1.0}, []int{2}),
		mustControlArray([]float64{0.0, 1.0, 0.0, 1.0}, []int{2, 2}),
	}
	otherAxesData = []*controlarray.Handle{
		mustControlArray([]float64{2.0, 5.0, 2.0, 5.0}, []int{2, 2}),
	}
)
