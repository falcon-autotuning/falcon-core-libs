package loader

import (
	"os"
	"path/filepath"
	"testing"
)

const fullYAMLConfig = `ScreeningGates: "S1;S2;S3"
PlungerGates: "P1;P2;P3"
Ohmics: "O1;O2;O3;O4"
BarrierGates: "B1;B2;B3;B4;B5"
ReservoirGates: "R1;R2;R3;R4"
num-unique-channels: 2
groups:
  group1:
    Name: "I_O1"
    NumDots: 2
    ScreeningGates: "S1;S2"
    ReservoirGates: "R1;R2"
    PlungerGates: "P1;P2"
    BarrierGates: "B1;B2;B3"
    Order: "O1;R1;B1;P1;B2;P2;B3;R2;O2"
  group2:
    Name: "I_O3"
    NumDots: 1
    ScreeningGates: "S2;S3"
    ReservoirGates: "R3;R4"
    PlungerGates: "P3"
    BarrierGates: "B4;B5"
    Order: "O3;R3;B4;P3;B5;R4;O4"
adjacency:
  S2: "P1;P2;P3;P4;R1;R2;R3;R4;B1;B2;B3;B4;B5"
  S1: "P1;P2;R1;R2;B1;B2;B3"
  S3: "P3;B4;B5;R3;R4"
  B1: "R1;P1"
  B2: "P1;P2"
  B3: "P2;R2"
  B4: "P3;R3"
  B5: "R4;P3"
  O3: "R3"
  O4: "R4"
  O1: "R1"
  O2: "R2"
max_safe_diff: 1.0
safe_voltage_bounds: [-1.0, 1.0]
wiringDC:
  S1: {resistance: 1000.0, capacitance: 1e-12}
  S2: {resistance: 1000.0, capacitance: 1e-12}
  S3: {resistance: 1000.0, capacitance: 1e-12}
  P1: {resistance: 1000.0, capacitance: 1e-12}
  P2: {resistance: 1000.0, capacitance: 1e-12}
  P3: {resistance: 1000.0, capacitance: 1e-12}
  O1: {resistance: 1000.0, capacitance: 1e-12}
  O2: {resistance: 1000.0, capacitance: 1e-12}
  O3: {resistance: 1000.0, capacitance: 1e-12}
  O4: {resistance: 1000.0, capacitance: 1e-12}
  R1: {resistance: 1000.0, capacitance: 1e-12}
  R2: {resistance: 1000.0, capacitance: 1e-12}
  R3: {resistance: 1000.0, capacitance: 1e-12}
  R4: {resistance: 1000.0, capacitance: 1e-12}
  B1: {resistance: 1000.0, capacitance: 1e-12}
  B2: {resistance: 1000.0, capacitance: 1e-12}
  B3: {resistance: 1000.0, capacitance: 1e-12}
  B4: {resistance: 1000.0, capacitance: 1e-12}
  B5: {resistance: 1000.0, capacitance: 1e-12}
`

func createYAMLConfigFile(t *testing.T) string {
	tmpDir := t.TempDir()
	path := filepath.Join(tmpDir, "test_config.yaml")
	if err := os.WriteFile(path, []byte(fullYAMLConfig), 0644); err != nil {
		t.Fatalf("Failed to write config file: %v", err)
	}
	return path
}

func TestLoader_New_Config_RealFile(t *testing.T) {
	configPath := createYAMLConfigFile(t)
	h, err := New(configPath)
	if err != nil {
		t.Fatalf("New() failed: %v", err)
	}
	defer h.Close()
	cfg, err := h.Config()
	if err != nil {
		t.Fatalf("Config() failed: %v", err)
	}
	if cfg == nil {
		t.Fatalf("Config() returned nil")
	}
	// Optionally, check some property of cfg if available
}

func TestLoader_FromCAPI_Error(t *testing.T) {
	h, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if h != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestLoader_IsNil(t *testing.T) {
	var h *Handle
	if !h.IsNil() {
		t.Error("IsNil() on nil Handle should return true")
	}
	h = &Handle{}
	if h.IsNil() {
		t.Error("IsNil() on non-nil Handle should return false")
	}
}

func TestLoader_Config_ErrorOnClosed(t *testing.T) {
	configPath := createYAMLConfigFile(t)
	h, err := New(configPath)
	if err != nil {
		t.Fatalf("New() failed: %v", err)
	}
	if err := h.Close(); err != nil {
		t.Fatalf("Close() failed: %v", err)
	}
	_, err = h.Config()
	if err == nil {
		t.Error("Config() on closed handle: expected error, got nil")
	}
}
