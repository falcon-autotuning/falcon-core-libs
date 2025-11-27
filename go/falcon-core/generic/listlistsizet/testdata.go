package listlistsizet

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listsizet"
)

func mustListSizeT(val ...uint32) *listsizet.Handle {
	h, err := listsizet.New(val)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*listsizet.Handle{
		mustListSizeT(1, 2, 3),
		mustListSizeT(4, 5, 6),
	}
	otherListData = []*listsizet.Handle{
		mustListSizeT(1),
	}
)
