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
	return IsNonPrimitive(gotype) && !IsString(gotype) && gotype != "*Handle"
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
		return "uint32"
	}
	if ctype == "size_t*" {
		return "*uint32"
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
	return strings.TrimSpace(ctype[:len(ctype)-len("Handle")])
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
	if gotype == "bool" || gotype == "float64" || gotype == "float32" || gotype == "int32" || gotype == "uint32" || gotype == "*bool" || gotype == "*float64" || gotype == "*float32" || gotype == "*int32" || gotype == "*uint32" || gotype == "int64" || gotype == "int8" {
		return true
	}
	return false
}

func IsString(gotype string) bool {
	return gotype == "string"
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
		return "New" + strings.Join(parts, "")
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
	if out == "ToJsonString" {
		return "ToJSON"
	} else {
		return out
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

func main() {
	var currentCategory string = "" // The current selected category for a function
	var funcLines []string          // All of the lines relevant for a single function
	var extraImports []string       // Any additional go imports needed for the package
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run genFile.go <header-file>")
		return
	}
	headerPath := os.Args[1]
	fmt.Println("proceessing", headerPath)
	f, err := os.Open(headerPath)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	fmt.Println("Generating", headerPath)

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
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
`, packageName, includePath, watermark, objectName, objectName)
	var reset bool = false // whether to reser the currentCategory next loop

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		if reset {
			currentCategory = ""
			reset = false
		}
		line := strings.TrimSpace(scanner.Text())
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
		fmt.Println("FUll signal:", fullSig)
		funcLines = nil
		resultCType := extractResultType(fullSig)
		fmt.Println("result c type:", resultCType)
		resultGoType := CtoGType(resultCType, packageName)
		fmt.Println("result go type:", resultGoType)
		methodName := extractMethodName(fullSig, objectName)
		fmt.Println("method name:", methodName)
		goName := goMethodName(methodName, objectName, currentCategory)
		fmt.Println("go method name:", goName)
		NumParams, Cparams := countParams(fullSig)
		for _, param := range Cparams {
			fmt.Println("C param:", param.Ctype, param.Name)
		}
		Goparams := toGoParams(Cparams, packageName)
		NumNonPrimitiveParams := CountNonPrimitiveParams(Goparams)
		for i, param := range Goparams {
			if IsExtraImport(param.Gotype) {
				fmt.Println("Adding extra import for param:", param.Gotype)
				fmt.Println("Adding extra extraimport for param:", extractCPrefix(Cparams[i].Ctype), ".")
				extraImports = append(extraImports, extractCPrefix(Cparams[i].Ctype))
			}
		}
		fmt.Println("Generating method:", goName)
		fmt.Println("  with", resultGoType, "result")
		if IsExtraImport(resultGoType) {
			fmt.Println("Adding extra import for param:", resultCType)
			fmt.Println("Adding extra extraimport for param:", extractCPrefix(resultCType), ".")
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
			if (NumParams-NumNonPrimitiveParams) == 3 && strings.Contains(methodArguments, "*uint32") {
				ctype0 := strings.TrimSpace(strings.TrimSuffix(Cparams[0].Ctype, "*"))
				ctype1 := strings.TrimSpace(strings.TrimSuffix(Cparams[1].Ctype, "*"))
				fmt.Fprintf(outFile, `func %s(%s []%s, %s []int, %s %s) (*Handle, error) {
	cshape := make([]C.%s, len(%s))
	for i, v := range %s {
		cshape[i] = C.size_t(v)
	}
	cdata := make([]C.%s, len(%s))
	for i, v := range %s{
		cdata[i] = C.%s(v)
	}
	return cmemoryallocation.Read(%s, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Adjacency_create(&cdata[0], &cshape[0], C.size_t(len(%s)), C.%s(%s))), nil
			},
			construct,
			destroy,
		)
	})
}
					`, goName, Goparams[0].Name, Goparams[0].Gotype[1:], Goparams[1].Name, Goparams[3].Name, Goparams[3].Gotype, ctype1, Goparams[1].Name, Goparams[1].Name, ctype0, Cparams[0].Name, Cparams[0].Name, ctype0, Goparams[3].Name, Goparams[1].Name, Cparams[3].Ctype, Goparams[3].Name)
				continue
			}
			if NumNonPrimitiveParams == 1 && goName == "New" && strings.Contains(methodArguments, "list") {
				starIdx := strings.Index(methodArguments, "*")
				dotIdx := strings.Index(methodArguments, ".")
				typeName := methodArguments[starIdx+1 : dotIdx]
				itemPackageName := strings.TrimPrefix(typeName, "list")
				fmt.Fprintf(outFile, `func New(items []*%s.Handle) (*Handle, error) {
	list, err := list%s.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of %s failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	},)
}
`, itemPackageName, itemPackageName, itemPackageName)
				fmt.Fprintf(outFile, "func NewFromList(%s) (*Handle, error) {\n", methodArguments)
			} else {
				fmt.Fprintf(outFile, "func %s(%s) (*Handle, error) {\n", goName, methodArguments)
			}

			// Handle string arguments
			for _, arg := range Goparams {
				if arg.Gotype == "string" {
					fmt.Fprintf(outFile, "real%s := str.New(%s)\n", arg.Name, arg.Name)
					arg.updateName(fmt.Sprintf("real%s", arg.Name))
				}
			}

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

		carguments := MakeCArgs(Goparams, Cparams)
		if currentCategory == "read" {
			if !strings.Contains(methodArguments, "out_buffer") {
				fmt.Fprintf(outFile, "func (h *Handle) %s(%s) (%s, error) { \n", goName, methodArguments, resultGoType)

				// Choose Read or MultiRead
				gonames := MakeGoArgNames(Goparams)
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
				for _, param := range Cparams {
					if param.Name != "out_buffer" {
						continue
					}
					bufferParam = param
					break
				}
				bufferCType := bufferParam.Ctype[:len(bufferParam.Ctype)-1] // remove the *
				bufferGoType := CtoGType(bufferCType, packageName)
				fmt.Fprintf(outFile, `func (h *Handle) %s() ([]%s, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.%s_dimension(C.%sHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("%s: dimension errored"), err)
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
		realout[i] = %s(realout[i])
	}
	return realout, nil
}
	`, goName, bufferGoType, objectName, objectName, goName, bufferCType, methodName, objectName, bufferGoType, bufferGoType)
				continue
			}
		}
		fmt.Fprintf(outFile, "func (h *Handle) %s(%s) error { \n", goName, methodArguments)
		// Choose Write or ReadWrite
		if NumNonPrimitiveParams == 1 {
			fmt.Fprintf(outFile, "  return cmemoryallocation.Write(%s, func() error {\n", Goparams[0].Name)
		} else if NumNonPrimitiveParams > 1 {
			// Build Go argument names
			names := make([]string, len(Goparams[1:]))
			for i, pair := range Goparams[1:] {
				names[i] = pair.Name
			}
			gonames := strings.Join(names, ",")
			fmt.Fprintf(outFile, "  return cmemoryallocation.ReadWrite(%s, []cmemoryallocation.HasCAPIHandle{%s}, func() error {\n", Goparams[0].Name, gonames)
		}
		fmt.Fprintf(outFile, `C.%s(%s)
 return nil 
}) 
}
`, methodName, carguments)
	}
	outFile.Close()
	fmt.Println("Extra imports before uniqueStrings", extraImports)
	extraImports = uniqueStrings(extraImports)
	fmt.Println("Extra imports ", extraImports)
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
	fmt.Println("Imports inserted successfully.")
}
