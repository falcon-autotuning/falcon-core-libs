package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type AxesType struct {
	Package                string
	File                   string
	Header                 string
	OptionalImport         string
	Type                   string
	ElemType               string
	CType                  string
	PrimitiveType          bool
	ElemIsPrimitive        bool
	OptDefaultElemType     string
	OptTestDefaultAxesData string
	OptTestVal1            string
	OptTestOtherAxesData   string
	CElemTypeConstructor   string
	ListType               string
	ListPackage            string
}

func toFileName(typeName string) string {
	if typeName == "" {
		return ""
	}
	runes := []rune(typeName)
	i := 1
	for ; i < len(runes); i++ {
		if runes[i] >= 'a' && runes[i] <= 'z' {
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

func isPrimitive(goType string) bool {
	switch goType {
	case "int", "int32", "int64", "uint", "uint32", "uint64", "float32", "float64", "bool":
		return true
	default:
		return false
	}
}

func main() {
	types := []AxesType{
		{
			Type:                   "AxesInt",
			ElemType:               "int32",
			CType:                  "int",
			OptDefaultElemType:     "0",
			OptTestDefaultAxesData: "{0,1}",
			OptTestVal1:            "4",
			OptTestOtherAxesData:   "{3}",
			PrimitiveType:          true,
			ListType:               "ListInt",
		},
		{
			Type:                   "AxesDouble",
			ElemType:               "float64",
			CType:                  "double",
			OptDefaultElemType:     "0.0",
			OptTestDefaultAxesData: "{1.1,2.2}",
			OptTestVal1:            "3.3",
			OptTestOtherAxesData:   "{1.0}",
			PrimitiveType:          true,
			ListType:               "ListDouble",
		},
		{
			Type:                 "AxesDiscretizer",
			ElemType:             "*discretizer.Handle",
			CType:                "DiscretizerHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "discretizer.FromCAPI",
			ListType:             "ListDiscretizer",
		},
		{
			Type:                 "AxesInstrumentPort",
			ElemType:             "*instrumentport.Handle",
			CType:                "InstrumentPortHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "instrumentport.FromCAPI",
			ListType:             "ListInstrumentPort",
		},
		{
			Type:                 "AxesMapStringBool",
			ElemType:             "*mapstringbool.Handle",
			CType:                "MapStringBoolHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "mapstringbool.FromCAPI",
			ListType:             "ListMapStringBool",
		},
		{
			Type:                 "AxesLabelledControlArray1D",
			ElemType:             "*labelledcontrolarray1d.Handle",
			CType:                "LabelledControlArray1DHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledcontrolarray1d"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "labelledcontrolarray1d.FromCAPI",
			ListType:             "ListLabelledControlArray1D",
		},
		{
			Type:                 "AxesLabelledControlArray",
			ElemType:             "*labelledcontrolarray.Handle",
			CType:                "LabelledControlArrayHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledcontrolarray"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "labelledcontrolarray.FromCAPI",
			ListType:             "ListLabelledControlArray",
		},
		{
			Type:                 "AxesLabelledMeasuredArray1D",
			ElemType:             "*labelledmeasuredarray1d.Handle",
			CType:                "LabelledMeasuredArray1DHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray1d"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "labelledmeasuredarray1d.FromCAPI",
			ListType:             "ListLabelledMeasuredArray1D",
		},
		{
			Type:                 "AxesLabelledMeasuredArray",
			ElemType:             "*labelledmeasuredarray.Handle",
			CType:                "LabelledMeasuredArrayHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "labelledmeasuredarray.FromCAPI",
			ListType:             "ListLabelledMeasuredArray",
		},
		{
			Type:                 "AxesControlArray1D",
			ElemType:             "*controlarray1d.Handle",
			CType:                "ControlArray1DHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray1d"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "controlarray1d.FromCAPI",
			ListType:             "ListControlArray1D",
		},
		{
			Type:                 "AxesControlArray",
			ElemType:             "*controlarray.Handle",
			CType:                "ControlArrayHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "controlarray.FromCAPI",
			ListType:             "ListControlArray",
		},
		{
			Type:                 "AxesMeasurementContext",
			ElemType:             "*measurementcontext.Handle",
			CType:                "MeasurementContextHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "measurementcontext.FromCAPI",
			ListType:             "ListMeasurementContext",
		},
		{
			Type:                 "AxesCoupledLabelledDomain",
			ElemType:             "*coupledlabelleddomain.Handle",
			CType:                "CoupledLabelledDomainHandle",
			OptionalImport:       `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"`,
			PrimitiveType:        false,
			CElemTypeConstructor: "coupledlabelleddomain.FromCAPI",
			ListType:             "ListCoupledLabelledDomain",
		},
		// Add more axes types here as needed...
	}

	for i := range types {
		types[i].Header = types[i].Type + "_c_api.h"
		types[i].Package = toPkgName(types[i].Type)
		types[i].File = toFileName(types[i].Type)
		types[i].ElemIsPrimitive = isPrimitive(types[i].ElemType)
		types[i].ListPackage = toPkgName(types[i].ListType)
	}

	testTmpl := template.Must(template.ParseFiles("math/axes/axes_test_wrapper.tmpl"))
	manifest, err := os.Create("axes_handles_manifest.txt")
	if err != nil {
		panic(err)
	}
	defer manifest.Close()
	for _, t := range types {
		dir := filepath.Join("math", t.Package)
		if err := os.MkdirAll(dir, 0o755); err != nil {
			panic(err)
		}
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
