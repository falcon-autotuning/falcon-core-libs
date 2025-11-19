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

func dict(values ...interface{}) map[string]interface{} {
	d := make(map[string]interface{}, len(values)/2)
	for i := 0; i < len(values); i += 2 {
		k := values[i].(string)
		d[k] = values[i+1]
	}
	return d
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
		{
			Type:                 "MapStringBool",
			PairGoType:           "pairstringbool",
			PairCType:            "PairStringBoolHandle",
			FirstGoType:          "string",
			FirstCType:           "StringHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       `""`,
			FirstConstructor:     "str.FromGoString",
			FirstOptionalImport:  "",
			SecondGoType:         "bool",
			SecondCType:          "bool",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "false",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			ListKeyGoType:        "liststring",
			ListValueGoType:      "listbool",
			FirstTestDefault:     `"hello"`,
			SecondTestDefault:    "true",
			FirstTestOther:       `"world"`,
			SecondTestOther:      "false",
		},
		{
			Type:                 "MapStringDouble",
			PairGoType:           "pairstringdouble",
			PairCType:            "PairStringDoubleHandle",
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
			ListKeyGoType:        "liststring",
			ListValueGoType:      "listdouble",
			FirstTestDefault:     `"foo"`,
			SecondTestDefault:    "1.23",
			FirstTestOther:       `"bar"`,
			SecondTestOther:      "4.56",
		},
		{
			Type:                 "MapStringString",
			PairGoType:           "pairstringstring",
			PairCType:            "PairStringStringHandle",
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
			ListKeyGoType:        "liststring",
			ListValueGoType:      "liststring",
			FirstTestDefault:     `"foo"`,
			SecondTestDefault:    `"bar"`,
			FirstTestOther:       `"baz"`,
			SecondTestOther:      `"qux"`,
		},
		{
			Type:                 "MapConnectionDouble",
			PairGoType:           "pairconnectiondouble",
			PairCType:            "PairConnectionDoubleHandle",
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
			ListKeyGoType:        "listconnection",
			ListValueGoType:      "listdouble",
			FirstTestDefault:     "firstConnection",
			SecondTestDefault:    "1.23",
			FirstTestOther:       "secondConnection",
			SecondTestOther:      "4.56",
		},
		{
			Type:                 "MapConnectionFloat",
			PairGoType:           "pairconnectionfloat",
			PairCType:            "PairConnectionFloatHandle",
			FirstGoType:          "*connection.Handle",
			FirstCType:           "ConnectionHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "connection.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"`,
			SecondGoType:         "float32",
			SecondCType:          "float",
			SecondIsPrimitive:    true,
			SecondZeroValue:      "float32(0)",
			SecondConstructor:    "",
			SecondOptionalImport: "",
			ListKeyGoType:        "listconnection",
			ListValueGoType:      "listfloat",
			FirstTestDefault:     "firstConnection",
			SecondTestDefault:    "float32(1.23)",
			FirstTestOther:       "secondConnection",
			SecondTestOther:      "float32(4.56)",
		},
		{
			Type:                 "MapChannelConnections",
			PairGoType:           "pairchannelconnections",
			PairCType:            "PairChannelConnectionsHandle",
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
			ListKeyGoType:        "listchannel",
			ListValueGoType:      "listconnections",
			FirstTestDefault:     "firstChannel",
			SecondTestDefault:    "firstConnections",
			FirstTestOther:       "secondChannel",
			SecondTestOther:      "secondConnections",
		},
		{
			Type:                 "MapConnectionQuantity",
			PairGoType:           "pairconnectionquantity",
			PairCType:            "PairConnectionQuantityHandle",
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
			ListKeyGoType:        "listconnection",
			ListValueGoType:      "listquantity",
			FirstTestDefault:     "firstConnection",
			SecondTestDefault:    "firstQuantity",
			FirstTestOther:       "secondConnection",
			SecondTestOther:      "secondQuantity",
		},
		{
			Type:                 "MapGnameGroup",
			PairGoType:           "pairgnamegroup",
			PairCType:            "PairGnameGroupHandle",
			FirstGoType:          "*gname.Handle",
			FirstCType:           "GnameHandle",
			FirstIsPrimitive:     false,
			FirstZeroValue:       "nil",
			FirstConstructor:     "gname.FromCAPI",
			FirstOptionalImport:  `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/gname"`,
			SecondGoType:         "*group.Handle",
			SecondCType:          "GroupHandle",
			SecondIsPrimitive:    false,
			SecondZeroValue:      "nil",
			SecondConstructor:    "group.FromCAPI",
			SecondOptionalImport: `"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/group"`,
			ListKeyGoType:        "listgname",
			ListValueGoType:      "listgroup",
			FirstTestDefault:     "firstGname",
			SecondTestDefault:    "firstGroup",
			FirstTestOther:       "secondGname",
			SecondTestOther:      "secondGroup",
		},
		{
			Type:                 "MapInstrumentPortPortTransform",
			PairGoType:           "pairinstrumentportporttransform",
			PairCType:            "PairInstrumentPortPortTransformHandle",
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
			ListKeyGoType:        "listinstrumentport",
			ListValueGoType:      "listporttransform",
			FirstTestDefault:     "firstInstrumentPort",
			SecondTestDefault:    "firstPortTransform",
			FirstTestOther:       "secondInstrumentPort",
			SecondTestOther:      "secondPortTransform",
		},
	}

	for i := range maps {
		maps[i].Package = toPkgName(maps[i].Type)
		maps[i].File = toFileName(maps[i].Type)
		maps[i].Header = maps[i].Type + "_c_api.h"
		maps[i].FirstIsString = isString(maps[i].FirstGoType)
		maps[i].SecondIsString = isString(maps[i].SecondGoType)
	}

	wrapperTmpl := template.New("map_wrapper.tmpl").Funcs(template.FuncMap{"dict": dict})
	wrapperTmpl = template.Must(wrapperTmpl.ParseFiles("generic/map/map_wrapper.tmpl"))

	testTmpl := template.New("map_test_wrapper.tmpl").Funcs(template.FuncMap{"dict": dict})
	testTmpl = template.Must(testTmpl.ParseFiles("generic/map/map_test_wrapper.tmpl"))
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
