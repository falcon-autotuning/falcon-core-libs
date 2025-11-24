package cmemoryallocation

import "sync"

var (
	DefaultCMAS *CMAS
	once        sync.Once
)

func GetCMAS() *CMAS {
	once.Do(func() {
		DefaultCMAS = NewCMAS()
	})
	return DefaultCMAS
}
