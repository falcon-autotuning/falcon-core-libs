package axescoupledlabelleddomain

import (
	"fmt"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumenttypes"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

func mustTestInstrumentPort(name string) *instrumentport.Handle {
	v, err := symbolunit.NewVolt()
	if err != nil {
		panic(fmt.Errorf("Invalid volt: %v", err))
	}
	conn, err := connection.NewBarrierGate(name)
	if err != nil {
		panic(fmt.Errorf("Invalid conn: %v", err))
	}

	ip, err := instrumentport.NewKnob(name, conn, instrumenttypes.VoltageSource(), v, "desc")
	if err != nil {
		panic(fmt.Errorf("instrumentport.NewKnob failed: %v", err))
	}
	return ip
}

func mustTestLabelledDomain(ip *instrumentport.Handle) *labelleddomain.Handle {
	ld, err := labelleddomain.NewFromPort(0.0, 1.0, instrumenttypes.VoltageSource(), ip, true, false)
	if err != nil {
		panic(fmt.Errorf("labelleddomain.NewFromPort failed: %v", err))
	}
	return ld
}

func mustCoupledLabelledDomain(name string) *coupledlabelleddomain.Handle {
	ip := mustTestInstrumentPort(name)
	defer ip.Close()
	ld := mustTestLabelledDomain(ip)
	defer ld.Close()

	cld, err := coupledlabelleddomain.New([]*labelleddomain.Handle{ld})
	if err != nil {
		panic(fmt.Errorf("invalid construction of labelleddomain: %v", err))
	}
	return cld
}

var (
	defaultAxesData = []*coupledlabelleddomain.Handle{
		mustCoupledLabelledDomain("port1"),
		mustCoupledLabelledDomain("port2"),
	}
	otherAxesData = []*coupledlabelleddomain.Handle{
		mustCoupledLabelledDomain("port3"),
	}
)
