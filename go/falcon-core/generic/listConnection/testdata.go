package listConnection

import (
	"testing"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

func mustBarrierGate(t testing.TB, name string) *connection.Handle {
	h, err := connection.NewBarrierGate(name)
	if err != nil {
		t.Fatalf("failed to create BarrierGate: %v", err)
	}
	return h
}

func mustPlungerGate(t testing.TB, name string) *connection.Handle {
	h, err := connection.NewPlungerGate(name)
	if err != nil {
		t.Fatalf("failed to create PlungerGate: %v", err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultListData = []*connection.Handle{
		mustPlungerGate(nil, "P1"),
		mustBarrierGate(nil, "B1"),
	}
	val1          = mustBarrierGate(nil, "B2")
	otherListData = []*connection.Handle{
		mustPlungerGate(nil, "P2"),
	}
	defaultElemType = mustBarrierGate(nil, "B1")
)
