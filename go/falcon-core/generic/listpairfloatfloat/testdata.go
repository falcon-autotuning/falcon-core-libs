package listpairfloatfloat

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairfloatfloat"
)

func mustListPairFloatFloat(val1 float32, val2 float32) *pairfloatfloat.Handle {
	h, err := pairfloatfloat.New(val1, val2)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairfloatfloat.Handle{
		mustListPairFloatFloat(0.3, 1.0),
		mustListPairFloatFloat(0.3, 1.4),
	}
	otherListData = []*pairfloatfloat.Handle{
		mustListPairFloatFloat(0.1, 1.4),
	}
)
