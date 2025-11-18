package listcontrolarray1d

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray1d"
)

func mustControlArray(data []float64, shape []int) *controlarray1d.Handle {
	h, err := controlarray1d.FromData(data, shape)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultListData = []*controlarray1d.Handle{
		mustControlArray([]float64{0.0, 1.0}, []int{2}),
		mustControlArray([]float64{0.0, 1.0, 2.0, 3.0}, []int{4}),
	}
	otherListData = []*controlarray1d.Handle{
		mustControlArray([]float64{0.5, 1.0, 2.0, 3.0}, []int{4}),
	}
)
