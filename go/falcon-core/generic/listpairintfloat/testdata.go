package listpairintfloat

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairintfloat"
)

func mustListPairIntFloat(val1 int32, val2 float32) *pairintfloat.Handle {
	h, err := pairintfloat.New(val1, val2)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairintfloat.Handle{
		mustListPairIntFloat(0, 1.0),
		mustListPairIntFloat(3, 1.4),
	}
	otherListData = []*pairintfloat.Handle{
		mustListPairIntFloat(2, 1.4),
	}
)
