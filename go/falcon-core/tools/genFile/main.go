package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

const watermark = "---------INSERT-IMPORTS---------"

// Finds the Go import path for a given extraImport by scanning the header file
func findGoImport(headerPath string, extraImport string) (string, error) {
	f, err := os.Open(headerPath)
	if err != nil {
		return "", err
	}
	defer f.Close()
	search := "/" + extraImport + "_c_api.h"
	scanner := bufio.NewScanner(f)
	var includes []string
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(line, "#include") {
			start := strings.Index(line, "\"")
			end := strings.LastIndex(line, "\"")
			if start == -1 || end == -1 || end <= start {
				continue
			}
			includePath := line[start+1 : end]
			if strings.Contains(line, search) {
				parts := strings.Split(includePath, "falcon_core/")
				if len(parts) < 2 {
					continue
				}
				relPath := parts[1]
				relPath = strings.Replace(relPath, "_c_api.h", "", 1)
				segments := strings.Split(relPath, "/")
				segments[len(segments)-1] = strings.ToLower(segments[len(segments)-1])
				for i, seg := range segments {
					segments[i] = strings.ReplaceAll(seg, "_", "-")
				}
				goImport := "github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/" + strings.Join(segments, "/")
				return goImport, nil
			}
			// Collect all falcon_core includes for recursive search
			if strings.Contains(includePath, "falcon_core/") {
				includes = append(includes, includePath)
			}
		}
	}
	// Recursive search in included headers
	for _, inc := range includes {
		// Build the path to the included header
		parts := strings.Split(headerPath, "falcon_core/")
		if len(parts) < 2 {
			continue
		}
		recursivePath := parts[0] + inc
		goImport, err := findGoImport(recursivePath, extraImport)
		if err == nil {
			return goImport, nil
		}
	}
	return "", fmt.Errorf("could not find matching header for %s", extraImport)
}

// Inserts Go imports at the watermark in the generated Go file
func insertImports(goFilePath string, imports []string) error {
	content, err := os.ReadFile(goFilePath)
	if err != nil {
		return err
	}
	lines := strings.Split(string(content), "\n")
	var out []string
	for _, line := range lines {
		if strings.Contains(line, watermark) {
			if len(imports) == 0 {
				out = append(out, "	// no extra imports")
			} else {
				for _, imp := range imports {
					out = append(out, fmt.Sprintf(`	"%s"`, imp))
				}
			}
			// Do NOT append the watermark line itself
			continue
		}
		out = append(out, line)
	}
	return os.WriteFile(goFilePath, []byte(strings.Join(out, "\n")), 0644)
}

func IsNonPrimitive(gotype string) bool {
	return !IsPrimitive(gotype) && gotype != ""
}

func IsExtraImport(gotype string) bool {
	return IsNonPrimitive(gotype) && !IsString(gotype) && gotype != "*Handle" && gotype != "*string.Handle" // don't include string since it is already imported
}

func uniqueStrings(input []string) []string {
	seen := make(map[string]struct{})
	var result []string
	for _, str := range input {
		if _, ok := seen[str]; !ok {
			seen[str] = struct{}{}
			result = append(result, str)
		}
	}
	return result
}

func CtoGType(ctype, packagetype string) string {
	if ctype == "void" {
		return ""
	}
	if ctype == "StringHandle" {
		return "string"
	}
	if ctype == "StringHandle*" {
		return "*string"
	}
	if ctype == "bool" {
		return "bool"
	}
	if ctype == "long long" {
		return "int64"
	}
	if ctype == "int8_t" {
		return "int8"
	}
	if ctype == "bool*" {
		return "*bool"
	}
	if ctype == "double" {
		return "float64"
	}
	if ctype == "double*" {
		return "*float64"
	}
	if ctype == "float" {
		return "float32"
	}
	if ctype == "float*" {
		return "*float32"
	}
	if ctype == "int" {
		return "int32"
	}
	if ctype == "int*" {
		return "*int32"
	}
	if ctype == "size_t" {
		return "uint64"
	}
	if ctype == "size_t*" {
		return "*uint64"
	}
	packageType := strings.ToLower(extractCPrefix(ctype))
	if packagetype == packageType {
		return "*Handle"
	} else {
		return "*" + packageType + ".Handle"
	}
}

// extracts the header associated with a non primitve handle
func extractCPrefix(ctype string) string {
	ctype = strings.ReplaceAll(ctype, "*", "")
	ctype = strings.ReplaceAll(ctype, "Handle", "")
	return strings.TrimSpace(ctype)
}

// extracts the package associated with a non primitve handle
func extractGoPrefix(s string) string {
	parts := strings.SplitN(s, ".", 2)
	prefix := parts[0]
	prefix = strings.TrimSpace(prefix)
	prefix = strings.TrimPrefix(prefix, "*")
	prefix = strings.TrimSuffix(prefix, "*")
	if prefix != "" {
		return prefix
	}
	return ""
}

func IsPrimitive(gotype string) bool {
	if gotype == "bool" || gotype == "float64" || gotype == "float32" || gotype == "int32" || gotype == "uint64" || gotype == "*bool" || gotype == "*float64" || gotype == "*float32" || gotype == "*int32" || gotype == "*uint64" || gotype == "int64" || gotype == "int8" {
		return true
	}
	return false
}

// Handle converting a go string into a C style string in the outFile
func writeStringConversion(Goparams []*GoParameterPair, outFile *os.File) {
	for _, arg := range Goparams {
		if arg.Gotype == "string" {
			fmt.Fprintf(outFile, "real%s := str.New(%s)\n", arg.Name, arg.Name)
			arg.updateName(fmt.Sprintf("real%s", arg.Name))
		}
	}
}

func IsString(gotype string) bool {
	return gotype == "string" || gotype == "*string"
}

type CParameterPair struct {
	Ctype string
	Name  string
}

func NewCParameterPair(paramStr string) *CParameterPair {
	var splits []string
	if strings.Contains(paramStr, "const ") {
		constSplits := strings.SplitN(paramStr, " ", 3)
		splits = []string{constSplits[1], constSplits[2]}
	} else if strings.Contains(paramStr, "long long") {
		fields := strings.Fields(paramStr)
		other := strings.Join(fields[2:], " ")
		splits = []string{"long long", other}
	} else {
		splits = strings.SplitN(paramStr, " ", 2)
	}
	// need to remove any [##] on the right name
	start := strings.Index(splits[1], "[")
	end := strings.Index(splits[1], "]")
	if start != -1 && end != -1 && end > start {
		splits[1] = splits[1][:start] + splits[1][end+1:]
	}
	return &CParameterPair{Ctype: strings.TrimSpace(splits[0]), Name: strings.TrimSpace(splits[1])}
}

type GoParameterPair struct {
	Gotype string
	Name   string
}

// updates the name of a GoParamterPair in place
func (g *GoParameterPair) updateName(name string) {
	g.Name = name
}

func NewGoParameterPair(pair *CParameterPair, packagetype string) *GoParameterPair {
	return &GoParameterPair{Gotype: CtoGType(pair.Ctype, packagetype), Name: pair.Name}
}

// flattens an array of go paramters into a single string
func flattenGoParameters(p []*GoParameterPair) string {
	var out string
	for i, pair := range p {
		out = out + pair.Name + " " + pair.Gotype
		if i < len(p)-1 {
			out += ", "
		}
	}
	return out
}

// A method to count parameters in a function signature
func countParams(funcLine string) (int, []*CParameterPair) {
	var params []*CParameterPair
	start := strings.Index(funcLine, "(")
	end := strings.Index(funcLine, ")")
	if start != -1 && end != -1 && end > start+1 {
		paramStr := funcLine[start+1 : end]
		paramStr = strings.TrimSpace(paramStr)
		if paramStr != "" {
			rawParams := strings.Split(paramStr, ",")
			for _, p := range rawParams {
				params = append(params, NewCParameterPair(strings.TrimSpace(p)))
			}
		}
	}
	return len(params), params
}

// A method to extract method name from C function signature
func extractMethodName(funcLine, objectName string) string {
	// Find the first occurrence of objectName followed by an underscore
	prefix := objectName + "_"
	start := strings.Index(funcLine, prefix)
	if start == -1 {
		return ""
	}
	// Find the next space before the prefix to skip the type
	endOfType := strings.LastIndex(funcLine[:start], " ")
	if endOfType == -1 {
		endOfType = 0
	} else {
		endOfType += 1 // move past the space
	}
	// Find the opening parenthesis after the prefix
	end := strings.Index(funcLine[endOfType:], "(")
	if end == -1 {
		return ""
	}
	return strings.TrimSpace(funcLine[endOfType : endOfType+end])
}

// A method to extract result type from C function signature
func extractResultType(funcLine string) string {
	parenIdx := strings.Index(funcLine, "(")
	if parenIdx == -1 {
		return ""
	}
	// Get the substring before '('
	beforeParen := strings.TrimSpace(funcLine[:parenIdx])
	// Split by spaces
	parts := strings.Fields(beforeParen)
	if len(parts) < 2 {
		return ""
	}
	// The result type is everything except the last part (function name)
	return strings.Join(parts[:len(parts)-1], " ")
}

// Assigns a go name to a constructor method based on its C method name
func constructorGoMethodName(methodName, objectName string) string {
	if strings.Contains(methodName, "_create") {
		stem := strings.TrimPrefix(methodName, objectName+"_create")
		parts := strings.Split(stem, "_")
		caser := cases.Title(language.English)
		for i := range parts {
			parts[i] = caser.String(parts[i])
		}
		newmethod := "New" + strings.Join(parts, "")
		newmethod = strings.ReplaceAll(newmethod, "Farray", "FArray")
		return newmethod
	}
	if strings.Contains(methodName, "_from_json_string") {
		return "FromJSON"
	} else {
		return nonConstructorGoMethodName(methodName, objectName)
	}
}

// Assigns a go name to any method based on its C method name and category
func goMethodName(methodName, objectName, currentCategory string) string {
	if currentCategory == "allocation" {
		return constructorGoMethodName(methodName, objectName)
	}
	if currentCategory == "deallocation" {
		return "Close"
	}
	return nonConstructorGoMethodName(methodName, objectName)
}

// Assigns a go name to a non-constructor method based on its C method name
func nonConstructorGoMethodName(methodName, objectName string) string {
	stem := strings.TrimPrefix(methodName, objectName)
	parts := strings.Split(stem, "_")
	caser := cases.Title(language.English)
	for i := range parts {
		parts[i] = caser.String(parts[i])
	}
	out := strings.Join(parts, "")
	out = strings.ReplaceAll(out, "Farray", "FArray")
	if out == "ToJsonString" {
		return "ToJSON"
	} else {
		return out
	}
}

// Selects a default value for a C memory size allocation for malloc
func memorySize(goType, cType string) string {
	if IsNonPrimitive(goType) || IsString(goType) {
		return fmt.Sprintf("unsafe.Sizeof(C.%s(nil))", cType)
	} else if goType == "bool" {
		return fmt.Sprintf("unsafe.Sizeof(C.%s(false))", cType)
	} else {
		return fmt.Sprintf("unsafe.Sizeof(C.%s(0))", cType)
	}
}

func MakeGoArgNames(goparams []*GoParameterPair) string {
	names := []string{}
	for _, pair := range goparams {
		if IsNonPrimitive(pair.Gotype) {
			names = append(names, pair.Name)
		}
	}
	return strings.Join(names, ",")
}

func MakeCArgs(goparams []*GoParameterPair, cparams []*CParameterPair) string {
	cargs := make([]string, len(goparams))
	for i, pair := range goparams {
		var goParamHandle string
		ctype := cparams[i].Ctype
		if IsPrimitive(pair.Gotype) {
			goParamHandle = pair.Name
		} else {
			goParamHandle = pair.Name + ".CAPIHandle()"
		}
		ctype = strings.ReplaceAll(ctype, " ", "") // Removing spaces for long long case
		ctype = strings.ReplaceAll(ctype, "*", "") // Removing asterisk for pointer case
		cargs[i] = fmt.Sprintf("C.%s(%s)", ctype, goParamHandle)
	}
	return strings.Join(cargs, ",")
}

// Converts a sequence of Cparams to Gparams
func toGoParams(params []*CParameterPair, packagetype string) []*GoParameterPair {
	var out []*GoParameterPair
	for _, pair := range params {
		out = append(out, NewGoParameterPair(pair, packagetype))
	}
	return out
}

func CountNonPrimitiveParams(params []*GoParameterPair) int {
	count := 0
	for _, pair := range params {
		if IsNonPrimitive(pair.Gotype) {
			count++
		}
	}
	return count
}

// Strips a block comment from a line, returning the cleaned line and whether we are still in a block comment
func stripBlockComment(line string, inBlockComment bool) (string, bool) {
	trimmed := strings.TrimSpace(line)
	for {
		if inBlockComment {
			end := strings.Index(trimmed, "*/")
			if end == -1 {
				return "", true
			}
			trimmed = trimmed[end+2:]
			trimmed = strings.TrimSpace(trimmed)
			inBlockComment = false
			continue
		}
		start := strings.Index(trimmed, "/*")
		if start == -1 {
			break
		}
		end := strings.Index(trimmed[start+2:], "*/")
		if end == -1 {
			trimmed = trimmed[:start]
			inBlockComment = true
			break
		}
		trimmed = trimmed[:start] + trimmed[start+2+end+2:]
		trimmed = strings.TrimSpace(trimmed)
	}
	return trimmed, inBlockComment
}

func main() {
	currentCategory := ""     // The current selected category for a function
	var funcLines []string    // All of the lines relevant for a single function
	var extraImports []string // Any additional go imports needed for the package
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run genFile.go <header-file>")
		return
	}
	headerPath := os.Args[1]
	fmt.Println("processing", headerPath)
	f, err := os.Open(headerPath)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	// for storing long output for debug
	manifest, err := os.OpenFile("manifest.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		panic(err)
	}
	defer manifest.Close()

	fmt.Fprintln(manifest, "Generating", headerPath)

	// Extract the include path (after "falcon_core/")
	parts := strings.Split(headerPath, "falcon_core/")
	includePath := "falcon_core/" + parts[1]

	// Extract the object name ("Connection") from the filename
	base := filepath.Base(headerPath)         // "Connection_c_api.h"
	objectName := strings.Split(base, "_")[0] // "Connection"
	packageName := strings.ToLower(objectName)

	// Prepare the output file
	dir := filepath.Dir(parts[1])
	dir = strings.ReplaceAll(dir, "_", "-")
	goFileName := strings.ReplaceAll(
		strings.ToLower(objectName[:1])+objectName[1:], "_", "-") + ".go"
	goFilePath := filepath.Join(dir, packageName, goFileName)
	outFile, err := os.Create(goFilePath)
	if err != nil {
		panic(err)
	}

	// Imports for the file and preamble
	fmt.Fprintf(outFile, `package %s
/*
#cgo pkg-config: falcon_core_c_api
#include <%s>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"unsafe"
	"errors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	%s
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)
type Handle struct { falconcorehandle.FalconCoreHandle }
var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.%s_destroy(C.%sHandle(ptr))
	}
)
func (h *Handle) IsNil() bool { return h == nil }
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
`, packageName, includePath, watermark, objectName, objectName)
	reset := false          // whether to reser the currentCategory next loop
	inBlockComment := false // if we are in a block comment
	var line string

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		if reset {
			currentCategory = ""
			reset = false
		}
		line, inBlockComment = stripBlockComment(scanner.Text(), inBlockComment)
		if line == "" {
			continue
		}
		line = strings.TrimSpace(line)
		if cut, exists := strings.CutPrefix(line, "// @category:"); exists {
			currentCategory = strings.TrimSpace(cut)
			continue
		}
		if currentCategory == "" {
			continue
		}
		funcLines = append(funcLines, line)
		if !strings.HasSuffix(line, ");") {
			continue
		}
		reset = true
		fullSig := strings.Join(funcLines, " ")
		fullSig = strings.ReplaceAll(fullSig, "\n", " ")
		fullSig = strings.ReplaceAll(fullSig, "\t", " ")
		fmt.Fprintln(manifest, "FUll signal:", fullSig)
		funcLines = nil
		resultCType := extractResultType(fullSig)
		fmt.Fprintln(manifest, "result c type:", resultCType)
		resultGoType := CtoGType(resultCType, packageName)
		fmt.Fprintln(manifest, "result go type:", resultGoType)
		methodName := extractMethodName(fullSig, objectName)
		fmt.Fprintln(manifest, "method name:", methodName)
		goName := goMethodName(methodName, objectName, currentCategory)
		fmt.Fprintln(manifest, "go method name:", goName)
		NumParams, Cparams := countParams(fullSig)
		for _, param := range Cparams {
			fmt.Fprintln(manifest, "C param:", param.Ctype, param.Name)
		}
		Goparams := toGoParams(Cparams, packageName)
		NumNonPrimitiveParams := CountNonPrimitiveParams(Goparams)
		for i, param := range Goparams {
			if IsExtraImport(param.Gotype) {
				fmt.Fprintln(manifest, "Adding extra import for param:", param.Gotype)
				fmt.Fprintln(manifest, "Adding extra extraimport for param:", extractCPrefix(Cparams[i].Ctype), ".")
				extraImports = append(extraImports, extractCPrefix(Cparams[i].Ctype))
			}
		}
		fmt.Fprintln(manifest, "Generating method:", goName)
		fmt.Fprintln(manifest, "  with", resultGoType, "result")
		if IsExtraImport(resultGoType) {
			fmt.Fprintln(manifest, "Adding extra import for param:", resultCType)
			fmt.Fprintln(manifest, "Adding extra extraimport for param:", extractCPrefix(resultCType), ".")
			extraImports = append(extraImports, extractCPrefix(resultCType))
		}
		if currentCategory == "deallocation" {
			fmt.Fprintln(outFile, `
func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}`)
			continue
		}
		if currentCategory == "allocation" {
			methodArguments := flattenGoParameters(Goparams)
			// format used by HDF5_from_communications
			if NumParams == 7 && NumNonPrimitiveParams == 4 && strings.Contains(methodArguments, "measurement_title") {
				fmt.Fprintf(outFile, `func NewFromCommunications(request *measurementrequest.Handle, response *measurementresponse.Handle, device_voltage_states *devicevoltagestates.Handle, session_id [16]int8, measurement_title string, unique_id int32, timestamp int32) (*Handle, error) {
	var cSessionID [16]C.int8_t
	for i := 0; i < 16; i++ {
		cSessionID[i] = C.int8_t(session_id[i])
	}
	realmeasurement_title := str.New(measurement_title)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{request, response, device_voltage_states, realmeasurement_title}, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.HDF5Data_create_from_communications(C.MeasurementRequestHandle(request.CAPIHandle()), C.MeasurementResponseHandle(response.CAPIHandle()), C.DeviceVoltageStatesHandle(device_voltage_states.CAPIHandle()), &cSessionID[0], C.StringHandle(realmeasurement_title.CAPIHandle()), C.int(unique_id), C.int(timestamp))), nil
			},
			construct,
			destroy,
		)
	})
}

					`)
				continue
			}
			// format used by Adjacency_create
			if (NumParams-NumNonPrimitiveParams) == 3 && NumNonPrimitiveParams == 1 && strings.Contains(methodArguments, "*uint64") {
				ctype0 := strings.TrimSpace(strings.TrimSuffix(Cparams[0].Ctype, "*"))
				gtype0 := Goparams[0].Gotype[1:]
				sizeData := memorySize(gtype0, ctype0)
				sizeShape := memorySize("uint64", "size_t")
				fmt.Fprintf(outFile, `func %s(%s []%s, %s []uint64, %s %s) (*Handle, error) {
	nShape := len(%s)
	nData := len(%s)
	if nShape == 0  || nData == 0 {
			return cmemoryallocation.NewAllocation(
					func() (unsafe.Pointer, error) {
							return unsafe.Pointer(nil), nil
					},
					construct,
					destroy,
			)
	}
  sizeShape := C.size_t(nShape) * C.size_t(%s)
	cShape := C.malloc(sizeShape)
	if cShape == nil {
			return nil, errors.New("C.malloc failed for Shape")
	}
	// Copy Go data to C memory
	sliceS := (*[1 << 30]C.size_t)(cShape)[:nShape:nShape]
	for i, v := range %s {
			sliceS[i] = C.size_t(v) 
	}
  sizeData := C.size_t(nData) * C.size_t(%s)
	cData:= C.malloc(sizeData)
	if cData == nil {
			return nil, errors.New("C.malloc failed for Data")
	}
	// Copy Go data to C memory
	sliceD := (*[1 << 30]C.%s)(cData)[:nData:nData]
	for i, v := range %s {
			sliceD[i] = C.%s(v) 
	}
	return cmemoryallocation.Read(%s, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
					res := unsafe.Pointer(C.%s((*C.%s)(cData), (*C.size_t)(cShape), C.size_t(nShape), C.%s(%s)))
					C.free(cData)
					C.free(cShape)
					return res, nil
			},
			construct,
			destroy,
		)
	})
}
					`, goName, Goparams[0].Name, gtype0, Goparams[1].Name, Goparams[3].Name, Goparams[3].Gotype, Goparams[1].Name, Goparams[0].Name, sizeShape, Goparams[1].Name, sizeData, ctype0, Goparams[0].Name, ctype0, Goparams[3].Name, methodName, ctype0, Cparams[3].Ctype, Goparams[3].Name)
				continue
			}
			// format used by ControlArray_from_data
			if NumParams == 3 && NumNonPrimitiveParams == 0 && strings.Contains(methodArguments, "*uint64") {
				ctype0 := strings.TrimSpace(strings.TrimSuffix(Cparams[0].Ctype, "*"))
				ctype1 := strings.TrimSpace(strings.TrimSuffix(Cparams[1].Ctype, "*"))
				fmt.Fprintf(outFile, `func %s(%s []%s, %s []uint64) (*Handle, error) {
	cshape := make([]C.%s, len(%s))
	for i, v := range %s {
		cshape[i] = C.size_t(v)
	}
	cdata := make([]C.%s, len(%s))
	for i, v := range %s{
		cdata[i] = C.%s(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.%s(&cdata[0], &cshape[0], C.size_t(len(%s)))), nil
		},
		construct,
		destroy,
	)
}
					`, goName, Goparams[0].Name, Goparams[0].Gotype[1:], Goparams[1].Name, ctype1, Goparams[1].Name, Goparams[1].Name, ctype0, Cparams[0].Name, Cparams[0].Name, ctype0, methodName, Goparams[1].Name)
				continue
			}
			// format used by FArrayDouble_create_empty
			if NumParams == 2 && NumNonPrimitiveParams == 0 && strings.Contains(methodArguments, "*uint64") && strings.Contains(methodArguments, "shape") {
				fmt.Fprintf(outFile, `func %s(%s []uint64) (*Handle, error) {
	cshape := make([]C.size_t, len(%s))
	for i, v := range %s {
		cshape[i] = C.size_t(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.%s(&cshape[0], C.size_t(len(%s)))), nil
		},
		construct,
		destroy,
	)
}
					`, goName, Goparams[0].Name, Goparams[0].Name, Cparams[0].Name, methodName, Goparams[0].Name)
				continue
			}
			// format used by List_create
			if NumParams == 2 && strings.Contains(methodArguments, "uint64") && goName == "New" && (strings.Contains(packageName, "list") || strings.Contains(packageName, "map")) {
				var Go0type string
				var argument string
				var sizeExpr string
				if IsString(Goparams[0].Gotype) {
					Go0type = "string"
				} else if IsNonPrimitive(Goparams[0].Gotype) {
					Go0type = Goparams[0].Gotype
				} else {
					Go0type = Goparams[0].Gotype[1:]
				}
				C0type := Cparams[0].Ctype[:strings.Index(Cparams[0].Ctype, "*")]
				sizeExpr = memorySize(Go0type, C0type)
				if Go0type == "string" {
					argument = "str.New(v).CAPIHandle()"
				} else if IsNonPrimitive(Go0type) {
					argument = "v.CAPIHandle()"
				} else {
					argument = "v"
				}
				fmt.Fprintf(outFile, `func New(%s []%s) (*Handle, error) {
	n := len(%s)
	if n == 0 {
			return cmemoryallocation.NewAllocation(
					func() (unsafe.Pointer, error) {
							return unsafe.Pointer(nil), nil
					},
					construct,
					destroy,
			)
	}
  size := C.size_t(n) * C.size_t(%s)
	cList := C.malloc(size)
	if cList == nil {
			return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.%s)(cList)[:n:n]
	for i, v := range %s {
			slice[i] = C.%s(%s) 
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
				res := unsafe.Pointer(C.%s((*C.%s)(cList), C.size_t(n)))
				C.free(cList)
				return res, nil
		},
		construct,
		destroy,
	)
}
					`, Goparams[0].Name, Go0type, Goparams[0].Name, sizeExpr, C0type, Goparams[0].Name, C0type, argument, methodName, C0type)
				continue
			}
			// Listlike_create special case
			if NumNonPrimitiveParams == 1 && goName == "New" && strings.Contains(methodArguments, "list") {
				var goItemType string
				starIdx := strings.Index(methodArguments, "*")
				dotIdx := strings.Index(methodArguments, ".")
				typeName := methodArguments[starIdx+1 : dotIdx]
				itemPackageName := strings.TrimPrefix(typeName, "list") // if primitive a C type
				goItemType = CtoGType(itemPackageName, itemPackageName)
				if goItemType == "*Handle" {
					goItemType = "*" + itemPackageName + ".Handle"
				}
				fmt.Fprintf(outFile, `func New(items []%s) (*Handle, error) {
	list, err := list%s.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of %s failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	},)
}
`, goItemType, itemPackageName, itemPackageName)
				fmt.Fprintf(outFile, "func NewFromList(%s) (*Handle, error) {\n", methodArguments)
			} else {
				fmt.Fprintf(outFile, "func %s(%s) (*Handle, error) {\n", goName, methodArguments)
			}
			writeStringConversion(Goparams, outFile)
			carguments := MakeCArgs(Goparams, Cparams)
			gonames := MakeGoArgNames(Goparams)
			// Choose Read or MultiRead
			if NumNonPrimitiveParams == 1 {
				fmt.Fprintf(outFile, "  return cmemoryallocation.Read(%s, func() (*Handle, error) {\n", gonames)
			} else if NumNonPrimitiveParams > 1 {
				fmt.Fprintf(outFile, "  return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{%s}, func() (*Handle, error) {\n", gonames)
			}
			fmt.Fprintf(outFile, `
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.%s(%s)), nil
			},
			construct,
			destroy,
		)
	}`, methodName, carguments)

			if NumNonPrimitiveParams > 0 {
				fmt.Fprint(outFile, ",")
				fmt.Fprintln(outFile, "  )\n}")
			} else {
				fmt.Fprint(outFile, "\n")
			}
			continue
		}
		methodArguments := flattenGoParameters(Goparams[1:])
		Goparams[0] = &GoParameterPair{Gotype: "*Handle", Name: "h"}

		if currentCategory == "read" {
			// special case for reshape of farray
			if strings.Contains(methodArguments, "shape") && strings.Contains(methodArguments, "*uint64") {
				fmt.Fprintf(outFile, `func (h *Handle) %s(%s []int32) (*Handle, error) {
	cshape := make([]C.size_t, len(%s))
	for i, v := range %s {
		cshape[i] = C.size_t(v)
	}
	return cmemoryallocation.Read(h, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.%s(C.%s(h.CAPIHandle()), &cshape[0], C.size_t(len(%s)))), nil
			},
			construct,
			destroy,
		)
	})
}
`, goName, Goparams[1].Name, Goparams[1].Name, Goparams[1].Name, methodName, Cparams[0].Ctype, Goparams[1].Name)
				continue
			}
			if !strings.Contains(methodArguments, "out_buffer") {
				fmt.Fprintf(outFile, "func (h *Handle) %s(%s) (%s, error) { \n", goName, methodArguments, resultGoType)
				writeStringConversion(Goparams, outFile)
				carguments := MakeCArgs(Goparams, Cparams)
				gonames := MakeGoArgNames(Goparams)

				// Choose Read or MultiRead
				if NumNonPrimitiveParams == 1 {
					fmt.Fprintf(outFile, "  return cmemoryallocation.Read(%s, func() (%s, error) { \n", gonames, resultGoType)
				} else if NumNonPrimitiveParams > 1 {
					fmt.Fprintf(outFile, "  return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{%s}, func() (%s, error) { \n", gonames, resultGoType)
				}
				cfunction := fmt.Sprintf(`C.%s(%s)`, methodName, carguments)
				if IsPrimitive(resultGoType) {
					fmt.Fprintf(outFile, `return %s(%s), nil`, resultGoType, cfunction)
				} else if IsString(resultGoType) {
					fmt.Fprintf(outFile, `
		strObj, err := str.FromCAPI(unsafe.Pointer(%s))
		if err != nil {
			return "", errors.New("%s:" + err.Error())
		}
		return strObj.ToGoString()
`, cfunction, goName)
				} else if resultGoType == "*Handle" {
					fmt.Fprintf(outFile, `
		return FromCAPI(unsafe.Pointer(%s))
`, cfunction)
				} else {
					resultPackage := extractGoPrefix(resultGoType)
					fmt.Fprintf(outFile, `
		return %s.FromCAPI(unsafe.Pointer(%s))
`, resultPackage, cfunction)
				}
				fmt.Fprintln(outFile, "  })\n}")
				continue
			} else {
				var bufferParam *CParameterPair
				var reconstruction string
				for _, param := range Cparams {
					if param.Name != "out_buffer" {
						continue
					}
					bufferParam = param
					break
				}
				bufferCType := bufferParam.Ctype[:len(bufferParam.Ctype)-1] // remove the *
				bufferGoType := CtoGType(bufferCType, packageName)
				if IsNonPrimitive(bufferGoType) && !IsString(bufferGoType) {
					bufferpackage := extractGoPrefix(bufferGoType)
					if bufferpackage != "Handle" {
						bufferpackage = bufferpackage + "."
					} else {
						bufferpackage = ""
					}
					reconstruction = fmt.Sprintf(`realout[i], err = %sFromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("%s: conversion from CAPI failed"), err)
		}
`, bufferpackage, goName)
				} else if IsString(bufferGoType) {
					reconstruction = `realstr, err := str.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("string: conversion from capi failed"), err)
		}
		realout[i], err = realstr.ToGoString()
		if err != nil {
			return nil, errors.Join(errors.New("string: conversion to string failed"), err)
		}
`
				} else {
					reconstruction = fmt.Sprintf(`realout[i] = %s(out[i])
`, bufferGoType)
				}
				size := fmt.Sprintf("%s_size", objectName)
				if strings.Contains(goName, "Gradient") || strings.Contains(goName, "Shape") {
					size = fmt.Sprintf("%s_dimension", objectName)
				}
				fmt.Fprintf(outFile, `func (h *Handle) %s() ([]%s, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.%s(C.%sHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("%s: size errored"), err)
	}
	out := make([]C.%s, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.%s(C.%sHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout:= make([]%s, dim)
	for i := range out {
		%s
	}
	return realout, nil
}
	`, goName, bufferGoType, size, objectName, goName, bufferCType, methodName, objectName, bufferGoType, reconstruction)
				continue
			}
		}
		fmt.Fprintf(outFile, "func (h *Handle) %s(%s) error { \n", goName, methodArguments)
		writeStringConversion(Goparams, outFile)
		carguments := MakeCArgs(Goparams, Cparams)
		gonames := MakeGoArgNames(Goparams[1:])
		// Choose Write or ReadWrite
		if NumNonPrimitiveParams == 1 {
			fmt.Fprintf(outFile, "  return cmemoryallocation.Write(%s, func() error {\n", Goparams[0].Name)
		} else if NumNonPrimitiveParams > 1 {
			fmt.Fprintf(outFile, "  return cmemoryallocation.ReadWrite(%s, []cmemoryallocation.HasCAPIHandle{%s}, func() error {\n", Goparams[0].Name, gonames)
		}
		fmt.Fprintf(outFile, `C.%s(%s)
 return nil 
}) 
}
`, methodName, carguments)
	}
	outFile.Close()
	fmt.Fprintln(manifest, "Extra imports before uniqueStrings", extraImports)
	extraImports = uniqueStrings(extraImports)
	fmt.Fprintln(manifest, "Extra imports ", extraImports)
	// Finally reinject imports at the watermark
	var goImportPaths []string
	for _, extraImport := range extraImports {
		importPath, err := findGoImport(headerPath, extraImport)
		if err != nil {
			panic(err)
		}
		goImportPaths = append(goImportPaths, importPath)
	}

	if err := insertImports(goFilePath, goImportPaths); err != nil {
		panic(err)
	}
	fmt.Fprintln(manifest, "Imports inserted successfully.")
}
