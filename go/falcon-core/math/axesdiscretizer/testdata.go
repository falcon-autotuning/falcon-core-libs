package axesdiscretizer

import (
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
)

func mustDiscretizer(val float64) *discretizer.Handle {
	h, err := discretizer.NewCartesian(val)
	if err != nil {
		panic(err)
	}
	return h
}

// ... more helpers as needed

var (
	defaultAxesData = []*discretizer.Handle{
		mustDiscretizer(0.05),
		mustDiscretizer(0.02),
	}
	otherAxesData = []*discretizer.Handle{
		mustDiscretizer(0.03),
	}
)
