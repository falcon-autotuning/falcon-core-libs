package listpairstringdouble

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringdouble"
)

func mustListPairStringDouble(str string, val float64) *pairstringdouble.Handle {
	h, err := pairstringdouble.New(str, val)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairstringdouble.Handle{
		mustListPairStringDouble("hello", 1.0),
		mustListPairStringDouble("world", 1.),
	}
	otherListData = []*pairstringdouble.Handle{
		mustListPairStringDouble("wow", 0.5),
	}
)
