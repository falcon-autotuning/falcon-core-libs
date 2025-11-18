package listpairsizetsizet

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairsizetsizet"
)

func mustListPairSizeTSizeT(val1 uint64, val2 uint64) *pairsizetsizet.Handle {
	h, err := pairsizetsizet.New(val1, val2)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairsizetsizet.Handle{
		mustListPairSizeTSizeT(3, 1),
		mustListPairSizeTSizeT(0, 4),
	}
	otherListData = []*pairsizetsizet.Handle{
		mustListPairSizeTSizeT(1, 4),
	}
)
