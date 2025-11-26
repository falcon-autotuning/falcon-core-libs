package gategeometryarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/GateGeometryArray1D_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/dotgateswithneighbors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/dotgatewithneighbors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/leftreservoirwithimplantedohmic"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/rightreservoirwithimplantedohmic"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.GateGeometryArray1D_destroy(C.GateGeometryArray1DHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(lineararray *connections.Handle, screening_gates *connections.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{lineararray, screening_gates}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.GateGeometryArray1D_create(C.ConnectionsHandle(lineararray.CAPIHandle()), C.ConnectionsHandle(screening_gates.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) AppendCentralGate(left_neighbor *connection.Handle, selected_gate *connection.Handle, right_neighbor *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{left_neighbor, selected_gate, right_neighbor}, func() error {
		C.GateGeometryArray1D_append_central_gate(C.GateGeometryArray1DHandle(h.CAPIHandle()), C.ConnectionHandle(left_neighbor.CAPIHandle()), C.ConnectionHandle(selected_gate.CAPIHandle()), C.ConnectionHandle(right_neighbor.CAPIHandle()))
		return nil
	})
}
func (h *Handle) AllDotGates() (*dotgateswithneighbors.Handle, error) {
	return cmemoryallocation.Read(h, func() (*dotgateswithneighbors.Handle, error) {

		return dotgateswithneighbors.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_all_dot_gates(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) QueryNeighbors(gate *connection.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gate}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_query_neighbors(C.GateGeometryArray1DHandle(h.CAPIHandle()), C.ConnectionHandle(gate.CAPIHandle()))))
	})
}
func (h *Handle) LeftReservoir() (*leftreservoirwithimplantedohmic.Handle, error) {
	return cmemoryallocation.Read(h, func() (*leftreservoirwithimplantedohmic.Handle, error) {

		return leftreservoirwithimplantedohmic.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_left_reservoir(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) RightReservoir() (*rightreservoirwithimplantedohmic.Handle, error) {
	return cmemoryallocation.Read(h, func() (*rightreservoirwithimplantedohmic.Handle, error) {

		return rightreservoirwithimplantedohmic.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_right_reservoir(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) LeftBarrier() (*dotgatewithneighbors.Handle, error) {
	return cmemoryallocation.Read(h, func() (*dotgatewithneighbors.Handle, error) {

		return dotgatewithneighbors.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_left_barrier(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) RightBarrier() (*dotgatewithneighbors.Handle, error) {
	return cmemoryallocation.Read(h, func() (*dotgatewithneighbors.Handle, error) {

		return dotgatewithneighbors.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_right_barrier(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Lineararray() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_lineararray(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ScreeningGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_screening_gates(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) RawCentralGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_raw_central_gates(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) CentralDotGates() (*dotgateswithneighbors.Handle, error) {
	return cmemoryallocation.Read(h, func() (*dotgateswithneighbors.Handle, error) {

		return dotgateswithneighbors.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_central_dot_gates(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Ohmics() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_ohmics(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.GateGeometryArray1D_equal(C.GateGeometryArray1DHandle(h.CAPIHandle()), C.GateGeometryArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.GateGeometryArray1D_not_equal(C.GateGeometryArray1DHandle(h.CAPIHandle()), C.GateGeometryArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_to_json_string(C.GateGeometryArray1DHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("ToJSON:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func FromJSON(json string) (*Handle, error) {
	realjson := str.New(json)
	return cmemoryallocation.Read(realjson, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.GateGeometryArray1D_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
