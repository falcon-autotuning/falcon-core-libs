package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type ListType struct {
	Package                string
	Header                 string
	OptionalImport         string
	Type                   string
	ElemType               string
	CType                  string
	PrimitiveType          bool
	OptDefaultElemType     string
	OptTestDefaultListData string // e.g. "{1, 2, 3}". S
	OptTestVal1            string // e.g. "42"
	OptTestOtherListData   string // e.g. "{99}"
}

// If PrimitiveType is selected then the OptTestDefaultListData, OptTestVal1, OptDefaultElemType and the OptTestDefaultListData do absolutely nothing and the user should implement these in a testdata.go file in teh folder of the tests that are not primitive

func toPkgName(typeName string) string {
	// Example: ListInt -> listInt, ListFloat -> listFloat
	if typeName == "" {
		return ""
	}
	runes := []rune(typeName)
	// Lowercase the first word
	i := 1
	for ; i < len(runes); i++ {
		if runes[i] >= 'A' && runes[i] <= 'Z' {
			break
		}
	}
	return strings.ToLower(string(runes[:i])) + string(runes[i:])
}

func main() {
	types := []ListType{
		{Type: "ListInt", ElemType: "int32", CType: "int", Header: "ListInt_c_api.h", OptDefaultElemType: "0", OptTestDefaultListData: "{0,1}", OptTestVal1: "4", OptTestOtherListData: "{3}", PrimitiveType: true},
		{Type: "ListFloat", ElemType: "float32", CType: "float", Header: "ListFloat_c_api.h", OptDefaultElemType: "0.0", OptTestDefaultListData: "{1.1,2.2}", OptTestVal1: "3.3", OptTestOtherListData: "{1.0}", PrimitiveType: true},
		{Type: "ListDouble", ElemType: "float64", CType: "double", Header: "ListDouble_c_api.h", OptDefaultElemType: "0.0", OptTestDefaultListData: "{1.1,2.2}", OptTestVal1: "3.3", OptTestOtherListData: "{1.0}", PrimitiveType: true},
		{Type: "ListBool", ElemType: "bool", CType: "bool", Header: "ListBool_c_api.h", OptDefaultElemType: "false", OptTestDefaultListData: "{true,false}", OptTestVal1: "true", OptTestOtherListData: "{true}", PrimitiveType: true},
		{Type: "ListSizeT", ElemType: "uint64", CType: "size_t", Header: "ListSizeT_c_api.h", OptDefaultElemType: "0", OptTestDefaultListData: "{0,1}", OptTestVal1: "4", OptTestOtherListData: "{3}", PrimitiveType: true},
		{Type: "ListConnection", ElemType: "*connection.Handle", CType: "ConnectionHandle", Header: "ListConnection_c_api.h", OptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`, PrimitiveType: false},
		// Add more types here...
	}

	tmpl := template.Must(template.ParseFiles(
		"generic/list/list_wrapper.tmpl",
		"generic/list/list_test_wrapper.tmpl",
	))
	manifest, err := os.Create("list_handles_manifest.txt")
	if err != nil {
		panic(err)
	}
	defer manifest.Close()

	for _, t := range types {
		pkg := toPkgName(t.Type)
		t.Package = pkg
		dir := filepath.Join("generic", pkg)
		if err := os.MkdirAll(dir, 0o755); err != nil {
			panic(err)
		}
		// Implementation file
		implFile := filepath.Join(dir, pkg+".go")
		f, err := os.Create(implFile)
		if err != nil {
			panic(err)
		}
		if err := tmpl.ExecuteTemplate(f, "list_wrapper.tmpl", t); err != nil {
			panic(err)
		}
		f.Close()
		fmt.Fprintln(manifest, implFile)

		// Test file
		testFile := filepath.Join(dir, pkg+"_test.go")
		tf, err := os.Create(testFile)
		if err != nil {
			panic(err)
		}
		if err := tmpl.ExecuteTemplate(tf, "list_wrapper_test.tmpl", t); err != nil {
			panic(err)
		}
		tf.Close()
		fmt.Fprintln(manifest, testFile)
	}
}
