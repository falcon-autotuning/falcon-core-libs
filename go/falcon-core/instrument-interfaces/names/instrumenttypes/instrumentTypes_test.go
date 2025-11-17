package instrumenttypes

import (
	"testing"
)

func TestInstrumentTypes_All(t *testing.T) {
	tests := []struct {
		name string
		fn   func() string
	}{
		{"DCVoltageSource", DCVoltageSource},
		{"Amnmeter", Amnmeter},
		{"Magnet", Magnet},
		{"Lockin", Lockin},
		{"VoltageSource", VoltageSource},
		{"CurrentSource", CurrentSource},
		{"HFVoltageSource", HFVoltageSource},
		{"DCCurrentSource", DCCurrentSource},
		{"HFCurrentSource", HFCurrentSource},
		{"Thermometer", Thermometer},
		{"Voltmeter", Voltmeter},
		{"FPGA", FPGA},
		{"Clock", Clock},
		{"Discrete", Discrete},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			val := tt.fn()
			if val == "" {
				t.Errorf("%s() returned empty string", tt.name)
			}
		})
	}
}
