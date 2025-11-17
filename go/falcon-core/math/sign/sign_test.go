package sign

import "testing"

func TestSign_Positive(t *testing.T) {
	val := Positive()
	if val == 0 {
		t.Errorf("Positive() returned 0, want non-zero (should be positive sign)")
	}
}

func TestSign_Negative(t *testing.T) {
	val := Negative()
	if val == 0 {
		t.Errorf("Negative() returned 0, want non-zero (should be negative sign)")
	}
}

func TestSign_PositiveAndNegativeAreDifferent(t *testing.T) {
	pos := Positive()
	neg := Negative()
	if pos == neg {
		t.Errorf("Positive() and Negative() returned the same value: %v", pos)
	}
}
