package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type WrapperType struct {
	Type                   string
	Package                string
	File                   string
	Header                 string
	OptionalImport         string
	ValueType              string
	GoValueType            string
	CValueType             string
	ElemIsPrimitive        bool
	ElemIsString           bool
	MapGoType              string
	MapCType               string
	ListValueGoType        string
	ListPairGoType         string
	GoValueConstructor     string
	OptTestDefaultListData string
	OptTestVal1            string
	OptTestOtherListData   string
}

func isPrimitive(goType string) bool {
	switch goType {
	case "int", "int32", "int64", "uint", "uint32", "uint64", "float32", "float64", "bool":
		return true
	default:
		return false
	}
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
	types := []WrapperType{
		{
			Type:                   "InterpretationContainerDouble",
			ValueType:              "Double",
			GoValueType:            "float64",
			CValueType:             "double",
			MapGoType:              "mapinterpretationcontextdouble",
			ListValueGoType:        "listdouble",
			ListPairGoType:         "listpairinterpretationcontextdouble",
			GoValueConstructor:     "",
			OptTestDefaultListData: "{1.1,2.2}",
			OptTestVal1:            "3.3",
			OptTestOtherListData:   "{1.0}",
		},
		{
			Type:                   "InterpretationContainerQuantity",
			ValueType:              "Quantity",
			GoValueType:            "*quantity.Handle",
			CValueType:             "Quantity",
			MapGoType:              "mapinterpretationcontextquantity",
			ListValueGoType:        "listquantity",
			ListPairGoType:         "listpairinterpretationcontextquantity",
			GoValueConstructor:     "quantity.FromCAPI",
			OptTestDefaultListData: "{quantity1,quantity2}",
			OptTestVal1:            "quantity3",
			OptTestOtherListData:   "{quantity4}",
			OptionalImport:         `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"`,
		},
		{
			Type:                   "InterpretationContainerString",
			ValueType:              "String",
			GoValueType:            "string",
			MapGoType:              "mapinterpretationcontextstring",
			ListValueGoType:        "liststring",
			ListPairGoType:         "listpairinterpretationcontextstring",
			GoValueConstructor:     "",
			OptTestDefaultListData: `{"foo","bar"}`,
			OptTestVal1:            `"baz"`,
			OptTestOtherListData:   `{"qux"}`,
		},
	}

	for i := range types {
		types[i].Header = types[i].Type + "_c_api.h"
		types[i].Package = toPkgName(types[i].Type)
		types[i].File = toFileName(types[i].Type)
		types[i].ElemIsString = isString(types[i].GoValueType)
		types[i].ElemIsPrimitive = isPrimitive(types[i].GoValueType)
	}
	wrapperTmpl := template.Must(template.ParseFiles(
		"autotuner-interfaces/interpretations/interpretationcontainer/interpretationContainer_wrapper.tmpl",
	))
	testTmpl := template.Must(template.ParseFiles(
		"autotuner-interfaces/interpretations/interpretationcontainer/interpretationContainer_test_wrapper.tmpl",
	))

	manifest, err := os.Create("interpretationcontainer_handles_manifest.txt")
	if err != nil {
		panic(err)
	}
	defer manifest.Close()

	for _, t := range types {
		dir := filepath.Join("autotuner-interfaces", "interpretations", t.Package)
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
