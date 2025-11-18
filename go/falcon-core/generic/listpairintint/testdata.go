package listpairintint

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairintint"
)

func mustListPairIntInt(val1 int32, val2 int32) *pairintint.Handle {
	h, err := pairintint.New(val1, val2)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairintint.Handle{
		mustListPairIntInt(3, 1),
		mustListPairIntInt(0, 4),
	}
	otherListData = []*pairintint.Handle{
		mustListPairIntInt(1, 4),
	}
)
