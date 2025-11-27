package standardresponse

import (
	"fmt"
	"testing"
)

func teststandardresponse_fullcoverage(t *testing.T) {
	// new
	sr, err := New("hello world")
	if err != nil {
		panic(fmt.Errorf("New failed: %v", err))
	}
	defer sr.Close()

	// capihandle (open)
	ptr := sr.CAPIHandle()
	if ptr == nil {
		t.Errorf("capihandle (open) failed: %v", err)
	}

	// message
	msg, err := sr.Message()
	if err != nil {
		t.Errorf("message failed: %v", err)
	}
	if msg != "hello world" {
		t.Errorf("message got %q, want %q", msg, "hello world")
	}

	// tojson/fromjson
	jsonstr, err := sr.ToJSON()
	if err != nil {
		t.Errorf("tojson failed: %v", err)
	}
	sr2, err := FromJSON(jsonstr)
	if err != nil {
		t.Errorf("fromjson failed: %v", err)
	}
	if sr2 != nil {
		defer sr2.Close()
	}

	// equal
	eq, err := sr.Equal(sr2)
	if err != nil {
		t.Errorf("equal failed: %v", err)
	}
	if !eq {
		t.Errorf("expected equal true")
	}

	// notequal
	neq, err := sr.NotEqual(sr2)
	if err != nil {
		t.Errorf("notequal failed: %v", err)
	}
	if neq {
		t.Errorf("expected notequal false")
	}

	// equal/notequal with nil/closed
	_, err = sr.Equal(nil)
	if err == nil {
		t.Errorf("equal with nil should error")
	}
	sr2.Close()
	_, err = sr.Equal(sr2)
	if err == nil {
		t.Errorf("equal with closed should error")
	}
	_, err = sr.NotEqual(nil)
	if err == nil {
		t.Errorf("notequal with nil should error")
	}
	_, err = sr.NotEqual(sr2)
	if err == nil {
		t.Errorf("notequal with closed should error")
	}

	// capihandle (closed)
	sr.Close()
	// close twice
	err = sr.Close()
	if err == nil {
		t.Errorf("second close should error")
	}
	_, err = sr.Message()
	if err == nil {
		t.Errorf("message on closed should error")
	}
	_, err = sr.ToJSON()
	if err == nil {
		t.Errorf("tojson on closed should error")
	}
}
