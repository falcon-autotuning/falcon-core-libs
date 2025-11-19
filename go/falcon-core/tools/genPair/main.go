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
	File                 string
	Header               string
	Type                 string
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
		{
			Type:                 "PairStringBool",
			FirstGoType:          "string",
			FirstCType:           "StringHandle",
			FirstIsPrimitive:     false, // treat as non-primitive!
			FirstZeroValue:       `""`,
			FirstConstructor:     "str.FromGoString",
			FirstOptionalImport:  "",
			SecondGoType:         "bool",
			SecondCType:          "bool",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "false",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			FirstTestDefault:     `"hello"`,
			SecondTestDefault:    "true",
			FirstTestOther:       `"world"`,
			SecondTestOther:      "false",
		},
		{
			Type:                 "PairStringDouble",
			FirstGoType:          "string",
			FirstCType:           "StringHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       `""`,
			FirstConstructor:     "str.FromGoString",
			FirstOptionalImport:  "",
			SecondGoType:         "float64",
			SecondCType:          "double",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "0.0",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			FirstTestDefault:     `"foo"`,
			SecondTestDefault:    "1.23",
			FirstTestOther:       `"bar"`,
			SecondTestOther:      "4.56",
		},
		{
			Type:                 "PairStringString",
			FirstGoType:          "string",
			FirstCType:           "StringHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       `""`,
			FirstConstructor:     "str.FromGoString",
			FirstOptionalImport:  "",
			SecondGoType:         "string",
			SecondCType:          "StringHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      `""`,
			SecondConstructor:    "str.FromGoString",
			SecondOptionalImport: "",
			FirstTestDefault:     `"foo"`,
			SecondTestDefault:    `"bar"`,
			FirstTestOther:       `"baz"`,
			SecondTestOther:      `"qux"`,
		},
		{
			Type:                 "PairQuantityQuantity",
			FirstGoType:          "*quantity.Handle",
			FirstCType:           "QuantityHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "quantity.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"`,
			SecondGoType:         "*quantity.Handle",
			SecondCType:          "QuantityHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "quantity.FromCAPI",
			SecondOptionalImport: "",
			FirstTestDefault:     "defaultQuantity",
			SecondTestDefault:    "defaultQuantity2",
			FirstTestOther:       "otherQuantity",
			SecondTestOther:      "otherQuantity2",
		},
		{
			Type:                 "PairChannelConnections",
			FirstGoType:          "*channel.Handle",
			FirstCType:           "ChannelHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "channel.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"`,
			SecondGoType:         "*connections.Handle",
			SecondCType:          "ConnectionsHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "connections.FromCAPI",
			SecondOptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"`,
			FirstTestDefault:     "defaultChannel",
			SecondTestDefault:    "defaultConnections",
			FirstTestOther:       "otherChannel",
			SecondTestOther:      "otherConnections",
		},
		{
			Type:                 "PairConnectionConnections",
			FirstGoType:          "*connection.Handle",
			FirstCType:           "ConnectionHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "connection.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`,
			SecondGoType:         "*connections.Handle",
			SecondCType:          "ConnectionsHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "connections.FromCAPI",
			SecondOptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"`,
			FirstTestDefault:     "defaultConnection",
			SecondTestDefault:    "defaultConnections",
			FirstTestOther:       "otherConnection",
			SecondTestOther:      "otherConnections",
		},
		{
			Type:                 "PairConnectionQuantity",
			FirstGoType:          "*connection.Handle",
			FirstCType:           "ConnectionHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "connection.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`,
			SecondGoType:         "*quantity.Handle",
			SecondCType:          "QuantityHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "quantity.FromCAPI",
			SecondOptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"`,
			FirstTestDefault:     "defaultConnection",
			SecondTestDefault:    "defaultQuantity",
			FirstTestOther:       "otherConnection",
			SecondTestOther:      "otherQuantity",
		},
		{
			Type:                 "PairConnectionPairQuantityQuantity",
			FirstGoType:          "*connection.Handle",
			FirstCType:           "ConnectionHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "connection.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`,
			SecondGoType:         "*pairquantityquantity.Handle",
			SecondCType:          "PairQuantityQuantityHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "pairquantityquantity.FromCAPI",
			SecondOptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairquantityquantity"`,
			FirstTestDefault:     "defaultConnection",
			SecondTestDefault:    "defaultPairQuantityQuantity",
			FirstTestOther:       "otherConnection",
			SecondTestOther:      "otherPairQuantityQuantity",
		},
		{
			Type:                 "PairGnameGroup",
			FirstGoType:          "*gname.Handle",
			FirstCType:           "GnameHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       `nil`,
			FirstConstructor:     "gname.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/gname"`,
			SecondGoType:         "*group.Handle",
			SecondCType:          "GroupHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "group.FromCAPI",
			SecondOptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/group"`,
			FirstTestDefault:     `g1`,
			SecondTestDefault:    "defaultGroup",
			FirstTestOther:       `g2`,
			SecondTestOther:      "otherGroup",
		},
		{
			Type:                 "PairInstrumentPortPortTransform",
			FirstGoType:          "*instrumentport.Handle",
			FirstCType:           "InstrumentPortHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "instrumentport.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"`,
			SecondGoType:         "*porttransform.Handle",
			SecondCType:          "PortTransformHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "porttransform.FromCAPI",
			SecondOptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"`,
			FirstTestDefault:     "defaultInstrumentPort",
			SecondTestDefault:    "defaultPortTransform",
			FirstTestOther:       "otherInstrumentPort",
			SecondTestOther:      "otherPortTransform",
		},
	}
	for i := range pairs {
		pairs[i].Package = toPkgName(pairs[i].Type)
		pairs[i].File = toFileName(pairs[i].Type)
		// Set Header automatically for each type
		pairs[i].Header = pairs[i].Type + "_c_api.h"
		// Set IsString flags
		pairs[i].FirstIsString = isString(pairs[i].FirstGoType)
		pairs[i].SecondIsString = isString(pairs[i].SecondGoType)
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
		implFile := filepath.Join(dir, p.File+".go")
		f, err := os.Create(implFile)
		if err != nil {
			panic(err)
		}
		if err := wrapperTmpl.Execute(f, p); err != nil {
			panic(err)
		}
		f.Close()
		fmt.Fprintln(manifest, implFile)
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
