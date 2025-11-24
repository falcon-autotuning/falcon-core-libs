package falconcorehandle

import (
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
)

type FalconCoreHandle struct {
	chandle      unsafe.Pointer
	errorHandler *errorhandling.Handle
}

func (h *FalconCoreHandle) CAPIHandle() unsafe.Pointer {
	return h.chandle
}

func Construct(ptr unsafe.Pointer) FalconCoreHandle {
	return FalconCoreHandle{chandle: ptr, errorHandler: errorhandling.ErrorHandler}
}

func (h *FalconCoreHandle) ResetHandle() {
	h.chandle = nil
}
