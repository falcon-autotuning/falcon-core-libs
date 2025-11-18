package listmapstringbool

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairstringbool"
)

func mustArrayPair(s []string, b []bool) []*pairstringbool.Handle {
	out := make([]*pairstringbool.Handle, 0, len(b))
	for i := 0; i < len(s) && i < len(b); i++ {
		out = append(out, mustPairStringBool(s[i], b[i]))
	}
	return out
}

func mustMapStringBool(p []*pairstringbool.Handle) *mapstringbool.Handle {
	h, err := mapstringbool.New(p)
	if err != nil {
		panic(err)
	}
	return h
}

func mustPairStringBool(s string, b bool) *pairstringbool.Handle {
	h, err := pairstringbool.New(s, b)
	if err != nil {
		panic(err)
	}
	return h
}

var (
	defaultListData = []*mapstringbool.Handle{
		mustMapStringBool(mustArrayPair([]string{"a", "b"}, []bool{true, false})),
		mustMapStringBool(mustArrayPair([]string{"c", "d"}, []bool{true, false})),
	}
	otherListData = []*mapstringbool.Handle{
		mustMapStringBool(mustArrayPair([]string{"c"}, []bool{false})),
	}
)
