package listcontrolarray

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray"
)

func mustControlArray(data []float64, shape []uint64) *controlarray.Handle {
	h, err := controlarray.FromData(data, shape)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultListData = []*controlarray.Handle{
		mustControlArray([]float64{0.0, 1.0}, []uint64{2}),
		mustControlArray([]float64{0.0, 1.0, 0.0, 1.0}, []uint64{2, 2}),
	}
	otherListData = []*controlarray.Handle{
		mustControlArray([]float64{2.0, 5.0, 2.0, 5.0}, []uint64{2, 2}),
	}
)
