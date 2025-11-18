package listgname

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/gname"
)

func mustGname(name string) *gname.Handle {
	h, err := gname.New(name)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*gname.Handle{
		mustGname("Group1"),
		mustGname("Group2"),
	}
	otherListData = []*gname.Handle{
		mustGname("Group3"),
	}
)
