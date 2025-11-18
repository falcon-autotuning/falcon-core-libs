package listpairstringbool

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
)

func mustListPairStringBool(str string, b bool) *pairstringbool.Handle {
	h, err := pairstringbool.New(str, b)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairstringbool.Handle{
		mustListPairStringBool("hello", true),
		mustListPairStringBool("world", false),
	}
	otherListData = []*pairstringbool.Handle{
		mustListPairStringBool("wow", false),
	}
)
