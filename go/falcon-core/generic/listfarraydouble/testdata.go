package listfarraydouble

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
)

func mustFArrayDouble(data []float64, shape []uint64) *farraydouble.Handle {
	h, err := farraydouble.FromData(data, shape)
	if err != nil {
		panic(fmt.Errorf("failed to create FArray: %v", err))
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*farraydouble.Handle{
		mustFArrayDouble([]float64{1.0, 2.0, 3.0, 4.0}, []uint64{2, 2}),
		mustFArrayDouble([]float64{5.0, 2.0, 3.1, 4.0}, []uint64{2, 2}),
	}
	otherListData = []*farraydouble.Handle{
		mustFArrayDouble([]float64{5.0, 2.0, 3.1, 4.0, 2.0, 5.0, 6.09, 4.3, 2.3}, []uint64{3, 3}),
	}
)
