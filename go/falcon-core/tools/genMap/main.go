package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type MapType struct {
	Package              string
	File                 string
	Header               string
	Type                 string
	PairGoType           string
	PairCType            string
	FirstGoType          string
	FirstCType           string
	FirstIsPrimitive     bool
	FirstIsString        bool
	FirstZeroValue       string
	FirstConstructor     string
	FirstOptionalImport  string
	SecondGoType         string
	SecondCType          string
	SecondIsPrimitive    bool
	SecondIsString       bool
	SecondZeroValue      string
	SecondConstructor    string
	SecondOptionalImport string
	ListKeyGoType        string
	ListValueGoType      string
	// Test variables for template
	FirstTestDefault  string
	SecondTestDefault string
	FirstTestOther    string
	SecondTestOther   string
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

func isString(goType string) bool {
	return goType == "string"
}

func main() {
	maps := []MapType{
		{
			Type:                 "MapIntInt",
			PairGoType:           "pairintint",
			PairCType:            "PairIntIntHandle",
			FirstGoType:          "int32",
			FirstCType:           "int",
			FirstIsPrimitive:     true,
			FirstZeroValue:       "0",
			FirstConstructor:     "",
			FirstOptionalImport:  "",
			SecondGoType:         "int32",
			SecondCType:          "int",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "0",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			ListKeyGoType:        "listint",
			ListValueGoType:      "listint",
			FirstTestDefault:     "int32(42)",
			SecondTestDefault:    "int32(24)",
			FirstTestOther:       "int32(99)",
			SecondTestOther:      "int32(11)",
		},
		{
			Type:                 "MapFloatFloat",
			PairGoType:           "pairfloatfloat",
			PairCType:            "PairFloatFloatHandle",
			FirstGoType:          "float32",
			FirstCType:           "float",
			FirstIsPrimitive:     true,
			FirstZeroValue:       "0",
			FirstConstructor:     "",
			FirstOptionalImport:  "",
			SecondGoType:         "float32",
			SecondCType:          "float",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "0",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			ListKeyGoType:        "listfloat",
			ListValueGoType:      "listfloat",
			FirstTestDefault:     "float32(42)",
			SecondTestDefault:    "float32(24)",
			FirstTestOther:       "float32(99)",
			SecondTestOther:      "float32(11)",
		},
	}

	for i := range maps {
		maps[i].Package = toPkgName(maps[i].Type)
		maps[i].File = toFileName(maps[i].Type)
		maps[i].Header = maps[i].Type + "_c_api.h"
		maps[i].FirstIsString = isString(maps[i].FirstGoType)
		maps[i].SecondIsString = isString(maps[i].SecondGoType)
	}

	wrapperTmpl := template.Must(template.ParseFiles("generic/map/map_wrapper.tmpl"))
	testTmpl := template.Must(template.ParseFiles("generic/map/map_test_wrapper.tmpl"))
	manifest, err := os.Create("map_handles_manifest.txt")
	if err != nil {
		panic(err)
	}
	defer manifest.Close()
	for _, m := range maps {
		dir := filepath.Join("generic", m.Package)
		if err := os.MkdirAll(dir, 0o755); err != nil {
			panic(err)
		}
		implFile := filepath.Join(dir, m.File+".go")
		f, err := os.Create(implFile)
		if err != nil {
			panic(err)
		}
		if err := wrapperTmpl.Execute(f, m); err != nil {
			panic(err)
		}
		f.Close()
		fmt.Fprintln(manifest, implFile)
		testFile := filepath.Join(dir, m.File+"_test.go")
		tf, err := os.Create(testFile)
		if err != nil {
			panic(err)
		}
		if err := testTmpl.Execute(tf, m); err != nil {
			panic(err)
		}
		tf.Close()
		fmt.Fprintln(manifest, testFile)
	}
}
