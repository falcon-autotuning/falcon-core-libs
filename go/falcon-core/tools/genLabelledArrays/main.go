package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type ArrayType struct {
	Package     string
	File        string
	Header      string
	Type        string
	CArrayType  string
	GoArrayType string
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
	types := []ArrayType{
		{
			Type:       "LabelledArraysLabelledControlArray1D",
			CArrayType: "LabelledControlArray1D",
		},
		{
			Type:       "LabelledArraysLabelledControlArray",
			CArrayType: "LabelledControlArray",
		},
		{
			Type:       "LabelledArraysLabelledMeasuredArray1D",
			CArrayType: "LabelledMeasuredArray1D",
		},
		{
			Type:       "LabelledArraysLabelledMeasuredArray",
			CArrayType: "LabelledMeasuredArray",
		},
	}
	for i := range types {
		types[i].Header = types[i].Type + "_c_api.h"
		types[i].Package = toPkgName(types[i].Type)
		types[i].File = toFileName(types[i].Type)
		types[i].GoArrayType = toPkgName(types[i].CArrayType)
	}
	wrapperTmpl := template.Must(template.ParseFiles("math/arrays/labelledarrays/labelledArrays_wrapper.tmpl"))
	testTmpl := template.Must(template.ParseFiles("math/arrays/labelledarrays/labelledArrays_test_wrapper.tmpl"))
	manifest, err := os.Create("labelledarrays_handles_manifest.txt")
	if err != nil {
		panic(err)
	}
	defer manifest.Close()
	for _, t := range types {
		dir := filepath.Join("math", "arrays", t.Package)
		if err := os.MkdirAll(dir, 0o755); err != nil {
			panic(err)
		}
		implFile := filepath.Join(dir, t.File+".go")
		f, err := os.Create(implFile)
		if err != nil {
			panic(err)
		}
		if err := wrapperTmpl.Execute(f, t); err != nil {
			panic(err)
		}
		f.Close()
		fmt.Fprintln(manifest, implFile)
		testFile := filepath.Join(dir, t.File+"_test.go")
		tf, err := os.Create(testFile)
		if err != nil {
			panic(err)
		}
		if err := testTmpl.Execute(tf, t); err != nil {
			panic(err)
		}
		tf.Close()
		fmt.Fprintln(manifest, testFile)
	}
}
