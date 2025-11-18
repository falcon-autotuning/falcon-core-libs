package listpairstringstring

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringstring"
)

func mustListPairStringString(str1 string, str2 string) *pairstringstring.Handle {
	h, err := pairstringstring.New(str1, str2)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairstringstring.Handle{
		mustListPairStringString("hello", "this"),
		mustListPairStringString("world", "is"),
	}
	otherListData = []*pairstringstring.Handle{
		mustListPairStringString("wow", "falcon"),
	}
)
