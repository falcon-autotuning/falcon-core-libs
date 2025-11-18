package str

import (
	"testing"
)

func TestNewString_ToGoString(t *testing.T) {
	orig := "hello world"
	s := New(orig)
	defer s.Close()

	got, err := s.ToGoString()
	if err != nil {
		t.Fatalf("ToGoString error: %v", err)
	}
	if got != orig {
		t.Errorf("ToGoString = %q, want %q", got, orig)
	}
}

func TestString_Close_Idempotent(t *testing.T) {
	s := New("close test")
	if err := s.Close(); err != nil {
		t.Errorf("First Close() error: %v", err)
	}
	if err := s.Close(); err == nil {
		t.Error("Second Close() on already closed string: expected error, got nil")
	}
}

func TestString_ToGoString_ErrorOnClosed(t *testing.T) {
	s := New("test")
	s.Close()
	_, err := s.ToGoString()
	if err == nil {
		t.Error("ToGoString on closed string: expected error, got nil")
	}
}

func TestFromCAPI_NilPointer(t *testing.T) {
	str, err := FromCAPI(nil)
	if err == nil {
		t.Error("FromCAPI(nil): expected error, got nil")
	}
	if str != nil {
		t.Error("FromCAPI(nil): expected nil, got non-nil")
	}
}

func TestFromCAPI_ValidPointer(t *testing.T) {
	orig := "abc"
	s := New(orig)
	defer s.Close()
	ptr, err := s.CAPIHandle()
	if err != nil {
		t.Errorf("CAPIHandle failed to expose capi: %v", err)
	}
	str, err := FromCAPI(ptr)
	if err != nil {
		t.Errorf("FromCAPI valid pointer: unexpected error: %v", err)
	}
	if str == nil {
		t.Fatal("FromCAPI valid pointer: got nil")
	}
	got, err := str.ToGoString()
	if err != nil {
		t.Errorf("ToGoString error: %v", err)
	}
	if got != orig {
		t.Errorf("ToGoString = %q, want %q", got, orig)
	}
}
