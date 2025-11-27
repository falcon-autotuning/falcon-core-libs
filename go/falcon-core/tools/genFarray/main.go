package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type FarrayType struct {
	Package      string
	File         string
	Header       string
	Type         string
	CType        string
	GoType       string
	DefaultShape string
	DefaultData  string
	DefaultVal   string
	OtherData    string
}

func toFileName(typeName string) string {
	if typeName == "" {
		return ""
	}
	runes := []rune(typeName)
	i := 1
	for ; i < len(runes); i++ {
		if runes[i] >= 'A' && runes[i] <= 'Z' {
			break
		}
	}
	return strings.ToLower(string(runes[:i])) + string(runes[i:])
}

func toPkgName(typeName string) string {
	if typeName == "" {
		return ""
	}
	return strings.ToLower(typeName)
}

func main() {
	// Only FArrayDouble for this generator
	arrays := []FarrayType{
		{
			Type:         "FArrayDouble",
			GoType:       "float64",
			CType:        "double",
			DefaultShape: "[]int{2,2}",
			DefaultData:  "[]float64{1.,.2,3.,.4}",
			DefaultVal:   "float64(5.2)",
			OtherData:    "[]float64{9.,.8,7.,.6}",
		},
		{
			Type:         "FArrayInt",
			GoType:       "int32",
			CType:        "int",
			DefaultShape: "[]int{2,2}",
			DefaultData:  "[]int32{1,2,3,4}",
			DefaultVal:   "int32(5)",
			OtherData:    "[]int32{9,8,7,6}",
		},
	}
	for i := range arrays {
		arrays[i].Package = toPkgName(arrays[i].Type)
		arrays[i].File = toFileName(arrays[i].Type)
		// Set Header automatically for each type
		arrays[i].Header = arrays[i].Type + "_c_api.h"
	}

	testTmpl := template.Must(template.ParseFiles("generic/farray/farray_test_wrapper.tmpl"))
	manifest, err := os.Create("farray_handles_manifest.txt")
	if err != nil {
		panic(err)
	}
	defer manifest.Close()
	for _, p := range arrays {
		dir := filepath.Join("generic", p.Package)
		if err := os.MkdirAll(dir, 0o755); err != nil {
			panic(err)
		}
		testFile := filepath.Join(dir, p.File+"_test.go")
		tf, err := os.Create(testFile)
		if err != nil {
			panic(err)
		}
		if err := testTmpl.Execute(tf, p); err != nil {
			panic(err)
		}
		tf.Close()
		fmt.Fprintln(manifest, testFile)
	}
}
