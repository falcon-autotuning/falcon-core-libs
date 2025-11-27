package listpairchannelconnections

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairchannelconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

func mustPairChannelConnections(channel *channel.Handle, conns *connections.Handle) *pairchannelconnections.Handle {
	h, err := pairchannelconnections.New(channel, conns)
	if err != nil {
		panic(err)
	}
	return h
}

func mustBarrierGate(name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(err)
	}
	return h
}

func mustChannel(name string) *channel.Handle {
	h, err := channel.New(name)
	if err != nil {
		panic(err)
	}
	return h
}

func mustGates(names ...string) []*connection.Handle {
	var handles []*connection.Handle
	for _, n := range names {
		handles = append(handles, mustBarrierGate(n))
	}
	return handles
}

func mustConnections(names ...string) *connections.Handle {
	handles := mustGates(names...)
	h, err := connections.New(handles)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*pairchannelconnections.Handle{
		mustPairChannelConnections(mustChannel("Chan1"), mustConnections("P1", "P2")),
		mustPairChannelConnections(mustChannel("Chan2"), mustConnections("P3", "P4")),
	}
	otherListData = []*pairchannelconnections.Handle{
		mustPairChannelConnections(mustChannel("Chan3"), mustConnections("P6", "P5")),
	}
)
