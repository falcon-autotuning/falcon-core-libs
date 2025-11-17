package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

type PairType struct {
	Package              string
	Header               string
	Type                 string
	FirstGoType          string
	FirstCType           string
	FirstIsPrimitive     bool
	FirstZeroValue       string
	FirstConstructor     string
	FirstOptionalImport  string
	SecondGoType         string
	SecondCType          string
	SecondIsPrimitive    bool
	SecondZeroValue      string
	SecondConstructor    string
	SecondOptionalImport string

	// Test variables for template
	FirstTestDefault  string
	SecondTestDefault string
	FirstTestOther    string
	SecondTestOther   string
}

func toPkgName(typeName string) string {
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

func main() {
	pairs := []PairType{
		{
			Type:                 "PairFloatFloat",
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
			FirstTestDefault:     "float32(1.1)",
			SecondTestDefault:    "float32(2.2)",
			FirstTestOther:       "float32(3.3)",
			SecondTestOther:      "float32(4.4)",
		},
		{
			Type:                 "PairDoubleDouble",
			FirstGoType:          "float64",
			FirstCType:           "double",
			FirstIsPrimitive:     true,
			FirstZeroValue:       "0.0",
			FirstConstructor:     "",
			FirstOptionalImport:  "",
			SecondGoType:         "float64",
			SecondCType:          "double",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "0.0",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			FirstTestDefault:     "float64(1.1)",
			SecondTestDefault:    "float64(2.2)",
			FirstTestOther:       "float64(3.3)",
			SecondTestOther:      "float64(4.4)",
		},
		{
			Type:                 "PairIntFloat",
			FirstGoType:          "int32",
			FirstCType:           "int",
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
			FirstTestDefault:     "int32(42)",
			SecondTestDefault:    "float32(2.2)",
			FirstTestOther:       "int32(99)",
			SecondTestOther:      "float32(4.4)",
		},
		{
			Type:                 "PairIntInt",
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
			FirstTestDefault:     "int32(42)",
			SecondTestDefault:    "int32(24)",
			FirstTestOther:       "int32(99)",
			SecondTestOther:      "int32(11)",
		},
		{
			Type:                 "PairSizeTSizeT",
			FirstGoType:          "uint64",
			FirstCType:           "size_t",
			FirstIsPrimitive:     true,
			FirstZeroValue:       "0",
			FirstConstructor:     "",
			FirstOptionalImport:  "",
			SecondGoType:         "uint64",
			SecondCType:          "size_t",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "0",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			FirstTestDefault:     "uint64(123)",
			SecondTestDefault:    "uint64(456)",
			FirstTestOther:       "uint64(789)",
			SecondTestOther:      "uint64(101112)",
		},
		{
			Type:                 "PairConnectionFloat",
			FirstGoType:          "*connection.Handle",
			FirstCType:           "ConnectionHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "connection.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`,
			SecondGoType:         "float32",
			SecondCType:          "float",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "0",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			FirstTestDefault:     "defaultConnection",
			SecondTestDefault:    "float32(2.2)",
			FirstTestOther:       "otherConnection",
			SecondTestOther:      "float32(4.4)",
		},
		{
			Type:                 "PairConnectionConnection",
			FirstGoType:          "*connection.Handle",
			FirstCType:           "ConnectionHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "connection.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`,
			SecondGoType:         "*connection.Handle",
			SecondCType:          "ConnectionHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "connection.FromCAPI",
			SecondOptionalImport: "",
			FirstTestDefault:     "defaultConnection",
			SecondTestDefault:    "defaultConnection2",
			FirstTestOther:       "otherConnection",
			SecondTestOther:      "otherConnection2",
		},
		{
			Type:                 "PairConnectionDouble",
			FirstGoType:          "*connection.Handle",
			FirstCType:           "ConnectionHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "connection.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`,
			SecondGoType:         "float64",
			SecondCType:          "double",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "0.0",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			FirstTestDefault:     "defaultConnection",
			SecondTestDefault:    "float64(2.2)",
			FirstTestOther:       "otherConnection",
			SecondTestOther:      "float64(4.4)",
		},
	}
	for i := range pairs {
		pairs[i].Package = toPkgName(pairs[i].Type)
	}
	// Set Header automatically for each type
	for i := range pairs {
		pairs[i].Header = pairs[i].Type + "_c_api.h"
	}
	wrapperTmpl := template.Must(template.ParseFiles("generic/pair/pair_wrapper.tmpl"))
	testTmpl := template.Must(template.ParseFiles("generic/pair/pair_test_wrapper.tmpl"))
	manifest, err := os.Create("pair_handles_manifest.txt")
	if err != nil {
		panic(err)
	}
	defer manifest.Close()
	for _, p := range pairs {
		dir := filepath.Join("generic", p.Package)
		if err := os.MkdirAll(dir, 0o755); err != nil {
			panic(err)
		}
		implFile := filepath.Join(dir, p.Package+".go")
		f, err := os.Create(implFile)
		if err != nil {
			panic(err)
		}
		if err := wrapperTmpl.Execute(f, p); err != nil {
			panic(err)
		}
		f.Close()
		fmt.Fprintln(manifest, implFile)
		testFile := filepath.Join(dir, p.Package+"_test.go")
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
