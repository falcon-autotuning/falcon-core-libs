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
	if h == nil {
		return nil
	}
	return h.chandle
}

func Construct(ptr unsafe.Pointer) FalconCoreHandle {
	return FalconCoreHandle{chandle: ptr, errorHandler: errorhandling.ErrorHandler}
}

func (h *FalconCoreHandle) ResetHandle() {
	h.chandle = nil
}

func (h *FalconCoreHandle) IsNil() bool {
	return h == nil
}
