package listchannel

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
)

func mustChannel(name string) *channel.Handle {
	h, err := channel.New(name)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*channel.Handle{
		mustChannel("C1"),
		mustChannel("C2"),
	}
	otherListData = []*channel.Handle{
		mustChannel("P2"),
	}
)
