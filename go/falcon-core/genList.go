package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type ListType struct {
	Package             string
	Header              string
	Type                string
	ElemType            string
	CType               string
	DefaultElemType     string
	TestDefaultListData string // e.g. "1, 2, 3"
	TestVal1            string // e.g. "42"
	TestOtherListData   string // e.g. "99"
}

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
		{Type: "ListInt", ElemType: "int32", CType: "int", Header: "ListInt_c_api.h", DefaultElemType: "0", TestDefaultListData: "{0,1}", TestVal1: "4", TestOtherListData: "{3}"},
		{Type: "ListFloat", ElemType: "float32", CType: "float", Header: "ListFloat_c_api.h", DefaultElemType: "0.0", TestDefaultListData: "{1.1,2.2}", TestVal1: "3.3", TestOtherListData: "{1.0}"},
		{Type: "ListDouble", ElemType: "float64", CType: "double", Header: "ListDouble_c_api.h", DefaultElemType: "0.0", TestDefaultListData: "{1.1,2.2}", TestVal1: "3.3", TestOtherListData: "{1.0}"},
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
