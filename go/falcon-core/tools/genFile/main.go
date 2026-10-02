package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

type CTypeKind int

const (
	TypePrimitive CTypeKind = iota
	TypeHandle
	TypeEnum
)

type CTypeInfo struct {
	Name       string
	Kind       CTypeKind
	HeaderPath string
	EnumValues []string
}

type CTypeTable struct {
	Types map[string]CTypeInfo
}

func BuildTypeTable(rootHeader string) (*CTypeTable, error) {
	table := &CTypeTable{
		Types: make(map[string]CTypeInfo),
	}

	visited := map[string]bool{}

	if err := scanHeader(rootHeader, table, visited); err != nil {
		return nil, err
	}

	return table, nil
}

func scanHeader(
	headerPath string,
	table *CTypeTable,
	visited map[string]bool,
) error {
	if visited[headerPath] {
		return nil
	}

	visited[headerPath] = true

	f, err := os.Open(headerPath)
	if err != nil {
		return err
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	insideEnum := false
	var enumLines []string

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())

		parseHandle(line, table, headerPath)

		if strings.Contains(line, "typedef enum") {

			enumLines = []string{line}

			if strings.Contains(line, "}") {
				parseEnum(line, table, headerPath)
				continue
			}

			insideEnum = true
			continue

		} else if insideEnum {

			enumLines = append(enumLines, line)

			if strings.Contains(line, "}") {
				parseEnum(
					strings.Join(enumLines, "\n"),
					table,
					headerPath,
				)

				insideEnum = false
				enumLines = nil
			}

			continue
		}

		if include := extractInclude(line); include != "" {
			next := resolveInclude(headerPath, include)

			if err := scanHeader(next, table, visited); err != nil {
				continue
			}
		}
	}

	return nil
}

var handleRegex = regexp.MustCompile(
	`typedef\s+void\s*\*\s*([A-Za-z0-9_]+)\s*;`,
)

func parseHandle(
	line string,
	table *CTypeTable,
	header string,
) {
	match := handleRegex.FindStringSubmatch(line)

	if len(match) != 2 {
		return
	}

	table.Types[match[1]] = CTypeInfo{
		Name:       match[1],
		Kind:       TypeHandle,
		HeaderPath: header,
	}
}

func extractInclude(line string) string {
	match := regexp.MustCompile(`^#include\s+"([^"]+)"`).
		FindStringSubmatch(line)

	if len(match) != 2 {
		return ""
	}

	return match[1]
}

func resolveInclude(
	currentHeader string,
	include string,
) string {
	idx := strings.Index(
		currentHeader,
		"falcon-core/",
	)

	if idx == -1 {
		return include
	}

	prefix := currentHeader[:idx]

	return filepath.Join(prefix, include)
}

var enumRegex = regexp.MustCompile(
	`}\s*([A-Za-z0-9_]+)\s*;`,
)

func parseEnum(
	enumText string,
	table *CTypeTable,
	header string,
) {
	match := enumRegex.FindStringSubmatch(enumText)

	if len(match) != 2 {
		return
	}

	enumName := match[1]

	bodyStart := strings.Index(enumText, "{")
	bodyEnd := strings.LastIndex(enumText, "}")

	var values []string

	if bodyStart >= 0 && bodyEnd > bodyStart {
		body := enumText[bodyStart+1 : bodyEnd]

		for _, part := range strings.Split(body, ",") {
			value := strings.TrimSpace(part)

			if value != "" {
				values = append(values, value)
			}
		}
	}

	table.Types[enumName] = CTypeInfo{
		Name:       enumName,
		Kind:       TypeEnum,
		HeaderPath: header,
		EnumValues: values,
	}
}

func lookupType(
	ctype string,
	table *CTypeTable,
) (CTypeInfo, bool) {
	ctype = strings.TrimSpace(ctype)
	ctype = strings.TrimSuffix(ctype, "*")

	info, ok := table.Types[ctype]

	return info, ok
}

const watermark = "---------INSERT-IMPORTS---------"

func findGoImportFromTypeInfo(
	info CTypeInfo,
) string {
	parts := strings.Split(
		info.HeaderPath,
		"falcon-core/",
	)

	relPath := parts[1]

	relPath = strings.Replace(
		relPath,
		"_c_api.h",
		"",
		1,
	)

	segments := strings.Split(
		relPath,
		"/",
	)

	if info.Kind == TypeEnum {
		segments[len(segments)-1] = strings.ToLower(info.Name)
	} else {
		segments[len(segments)-1] = strings.ToLower(
			segments[len(segments)-1],
		)
	}

	for i, seg := range segments {
		segments[i] = strings.ReplaceAll(
			seg,
			"_",
			"-",
		)
	}

	return "github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/" +
		strings.Join(segments, "/")
}

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
		if !strings.HasPrefix(line, "#include") {
			continue
		}
		start := strings.Index(line, "\"")
		end := strings.LastIndex(line, "\"")
		if start == -1 || end == -1 || end <= start {
			continue
		}
		includePath := line[start+1 : end]
		if strings.Contains(line, search) {
			parts := strings.Split(includePath, "falcon-core/")
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
		// Collect all falcon-core includes for recursive search
		if strings.Contains(includePath, "falcon-core/") {
			includes = append(includes, includePath)
		}
	}
	// Recursive search in included headers
	for _, inc := range includes {
		parts := strings.Split(headerPath, "falcon-core/")
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
		if !strings.Contains(line, watermark) {
			out = append(out, line)
			continue
		}
		if len(imports) == 0 {
			out = append(out, "	// no extra imports")
		} else {
			for _, imp := range imports {
				out = append(out, fmt.Sprintf(`	"%s"`, imp))
			}
		}
		// Do NOT append the watermark line itself
	}
	return os.WriteFile(goFilePath, []byte(strings.Join(out, "\n")), 0o644)
}

func IsNonPrimitive(gotype string) bool {
	return !IsPrimitive(gotype) &&
		!IsEnumGoType(gotype) &&
		gotype != ""
}

func IsExtraImport(gotype string) bool {
	if IsEnumGoType(gotype) {
		return true
	}

	return IsNonPrimitive(gotype) &&
		!IsString(gotype) &&
		gotype != "*Handle" &&
		gotype != "*string.Handle"
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

func CtoGType(
	ctype string,
	packagetype string,
	table *CTypeTable,
) string {
	switch ctype {
	case "void":
		return ""
	case "StringHandle":
		return "string"
	case "StringHandle*":
		return "*string"
	case "bool":
		return "bool"
	case "long long":
		return "int64"
	case "int8_t":
		return "int8"
	case "bool*":
		return "*bool"
	case "double":
		return "float64"
	case "double*":
		return "*float64"
	case "float":
		return "float32"
	case "float*":
		return "*float32"
	case "int":
		return "int32"
	case "int*":
		return "*int32"
	case "size_t":
		return "uint64"
	case "size_t*":
		return "*uint64"
	}
	if info, ok := lookupType(ctype, table); ok {
		switch info.Kind {

		case TypeHandle:

			packageType := strings.ToLower(
				extractCPrefix(ctype),
			)

			if packageType == packagetype {
				return "*Handle"
			}

			return "*" + packageType + ".Handle"

		case TypeEnum:

			packageType := strings.ToLower(info.Name)

			return packageType + "." + info.Name
		}
	}
	packageType := strings.ToLower(extractCPrefix(ctype))

	if packagetype == packageType {
		return "*Handle"
	}

	return "*" + packageType + ".Handle"
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
	prefix := strings.TrimSpace(parts[0])
	prefix = strings.TrimPrefix(prefix, "*")
	prefix = strings.TrimSuffix(prefix, "*")
	if prefix != "" {
		return prefix
	}
	return ""
}

func IsPrimitive(gotype string) bool {
	switch gotype {
	case "bool", "float64", "float32", "int32", "uint64", "*bool", "*float64", "*float32", "*int32", "*uint64", "int64", "int8":
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
	switch {
	case strings.Contains(paramStr, "const "):
		constSplits := strings.SplitN(paramStr, " ", 3)
		splits = []string{constSplits[1], constSplits[2]}
	case strings.Contains(paramStr, "long long"):
		fields := strings.Fields(paramStr)
		other := strings.Join(fields[2:], " ")
		splits = []string{"long long", other}
	default:
		splits = strings.SplitN(paramStr, " ", 2)
	}
	// need to remove any [##] on the right name
	start := strings.Index(splits[1], "[")
	end := strings.Index(splits[1], "]")
	if start != -1 && end != -1 && end > start {
		splits[1] = splits[1][:start] + splits[1][end+1:]
	}
	ctype := strings.TrimSpace(splits[0])
	name := strings.TrimSpace(splits[1])

	for strings.HasPrefix(name, "*") {
		ctype += "*"
		name = strings.TrimPrefix(name, "*")
	}

	return &CParameterPair{
		Ctype: ctype,
		Name:  name,
	}
}

var goKeywords = map[string]struct{}{
	"break":       {},
	"default":     {},
	"func":        {},
	"interface":   {},
	"select":      {},
	"case":        {},
	"defer":       {},
	"go":          {},
	"map":         {},
	"struct":      {},
	"chan":        {},
	"else":        {},
	"goto":        {},
	"package":     {},
	"switch":      {},
	"const":       {},
	"fallthrough": {},
	"if":          {},
	"range":       {},
	"type":        {},
	"continue":    {},
	"for":         {},
	"import":      {},
	"return":      {},
	"var":         {},
}

func sanitizeGoIdentifier(name string) string {
	if _, ok := goKeywords[name]; ok {
		return name + "_"
	}
	return name
}

type GoParameterPair struct {
	Gotype string
	Name   string
}

// updates the name of a GoParamterPair in place
func (g *GoParameterPair) updateName(name string) {
	g.Name = name
}

func NewGoParameterPair(
	pair *CParameterPair,
	packagetype string,
	table *CTypeTable,
) *GoParameterPair {
	return &GoParameterPair{
		Gotype: CtoGType(pair.Ctype, packagetype, table),
		Name:   sanitizeGoIdentifier(pair.Name),
	}
}

// flattens an array of go paramters into a single string
func flattenGoParameters(p []*GoParameterPair) string {
	var out string
	for i, pair := range p {
		out += pair.Name + " " + pair.Gotype
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
		paramStr := strings.TrimSpace(funcLine[start+1 : end])
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
	prefix := objectName + "_"
	start := strings.Index(funcLine, prefix)
	if start == -1 {
		return ""
	}
	endOfType := strings.LastIndex(funcLine[:start], " ")
	if endOfType == -1 {
		endOfType = 0
	} else {
		endOfType++
	}
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
	beforeParen := strings.TrimSpace(funcLine[:parenIdx])
	beforeParen = strings.TrimPrefix(beforeParen, "FALCON_CORE_C_API ")
	parts := strings.Fields(beforeParen)
	if len(parts) < 2 {
		return ""
	}
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
	}
	return nonConstructorGoMethodName(methodName, objectName)
}

// Assigns a go name to any method based on its C method name and category
func goMethodName(methodName, objectName, currentCategory string) string {
	switch currentCategory {
	case "allocation":
		return constructorGoMethodName(methodName, objectName)
	case "deallocation":
		return "Close"
	default:
		return nonConstructorGoMethodName(methodName, objectName)
	}
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
	}
	return out
}

// Selects a default value for a C memory size allocation for malloc
func memorySize(goType, cType string) string {
	switch {
	case IsNonPrimitive(goType) || IsString(goType):
		return fmt.Sprintf("unsafe.Sizeof(C.%s(nil))", cType)
	case goType == "bool":
		return fmt.Sprintf("unsafe.Sizeof(C.%s(false))", cType)
	default:
		return fmt.Sprintf("unsafe.Sizeof(C.%s(0))", cType)
	}
}

// A whole malloc method for proper c types
func emitGoMallocBlock(
	outFile *os.File,
	goVar string, // e.g. "cList"
	goLenVar string, // e.g. "n"
	goSliceVar string, // e.g. "Goparams[0].Name"
	cType string, // e.g. "size_t"
	sizeExpr string, // e.g. memorySize(goType, cType)
	convertExpr string, // e.g. "C.size_t(v)"
) {
	fmt.Fprintf(outFile, `	%s := len(%s)
	if %s == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	%s := C.malloc(C.size_t(%s) * C.size_t(%s))
	if %s == nil {
		return nil, errors.New("C.malloc failed")
	}
	slice%s := (*[1 << 30]C.%s)(%s)[:%s:%s]
	for i, v := range %s {
		slice%s[i] = %s
	}
`, goLenVar, goSliceVar, goLenVar, goVar, goLenVar, sizeExpr, goVar, goVar, cType, goVar, goLenVar, goLenVar, goSliceVar, goVar, convertExpr)
}

func MakeGoArgNames(goparams []*GoParameterPair) string {
	var names []string
	for _, pair := range goparams {
		if IsNonPrimitive(pair.Gotype) {
			names = append(names, pair.Name)
		}
	}
	return strings.Join(names, ",")
}

func IsEnumGoType(gotype string) bool {
	return strings.Contains(gotype, ".") &&
		!strings.HasSuffix(gotype, ".Handle")
}

func MakeCArgs(goparams []*GoParameterPair, cparams []*CParameterPair) string {
	cargs := make([]string, len(goparams))
	for i, pair := range goparams {
		var goParamHandle string
		ctype := cparams[i].Ctype
		switch {

		case IsPrimitive(pair.Gotype):
			goParamHandle = pair.Name

		case IsEnumGoType(pair.Gotype):
			goParamHandle = pair.Name

		default:
			goParamHandle =
				pair.Name + ".CAPIHandle()"
		}
		ctype = strings.ReplaceAll(ctype, " ", "")
		ctype = strings.ReplaceAll(ctype, "*", "")
		cargs[i] = fmt.Sprintf("C.%s(%s)", ctype, goParamHandle)
	}
	return strings.Join(cargs, ",")
}

// Converts a sequence of Cparams to Gparams
func toGoParams(
	params []*CParameterPair,
	packagetype string,
	table *CTypeTable,
) []*GoParameterPair {
	out := make([]*GoParameterPair, 0, len(params))

	for _, pair := range params {
		out = append(
			out,
			NewGoParameterPair(
				pair,
				packagetype,
				table,
			),
		)
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
			trimmed = strings.TrimSpace(trimmed[end+2:])
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
		trimmed = strings.TrimSpace(trimmed[:start] + trimmed[start+2+end+2:])
	}
	return trimmed, inBlockComment
}

func enumPackageName(enumName string) string {
	return strings.ToLower(enumName)
}

func enumIncludePath(headerPath string) string {
	parts := strings.Split(headerPath, "falcon-core/")
	if len(parts) < 2 {
		return ""
	}

	return "falcon-core/" + parts[1]
}

func enumValueGoName(
	enumName string,
	value string,
) string {
	prefix := strings.ToUpper(enumName) + "_"

	value = strings.TrimPrefix(value, prefix)

	parts := strings.Split(
		strings.ToLower(value),
		"_",
	)

	caser := cases.Title(language.English)

	for i := range parts {
		parts[i] = caser.String(parts[i])
	}

	return strings.Join(parts, "")
}

func generateEnum(
	info CTypeInfo,
	rootDir string,
) error {
	if info.Kind != TypeEnum {
		return nil
	}

	packageName := strings.ToLower(info.Name)

	packageDir := filepath.Join(
		rootDir,
		packageName,
	)

	if err := os.MkdirAll(
		packageDir,
		0o755,
	); err != nil {
		return err
	}

	enumFile := filepath.Join(
		packageDir,
		packageName+".go",
	)

	out, err := os.Create(enumFile)
	if err != nil {
		return err
	}
	defer out.Close()

	includePath := enumIncludePath(info.HeaderPath)

	fmt.Fprintf(
		out,
		`package %s

/*
#cgo pkg-config: falcon-core-c-api
#include <%s>
*/
import "C"

type %s int32

const (
`,
		packageName,
		includePath,
		info.Name,
	)
	for _, value := range info.EnumValues {

		name := enumValueGoName(
			info.Name,
			value,
		)

		fmt.Fprintf(
			out,
			"\t%s %s = %s(C.%s)\n",
			name,
			info.Name,
			info.Name,
			value,
		)
	}

	fmt.Fprintln(out, ")")

	fmt.Fprintf(
		out,
		"\nfunc (v %s) String() string {\n",
		info.Name,
	)

	fmt.Fprintln(out, "switch v {")

	for _, value := range info.EnumValues {

		name := enumValueGoName(
			info.Name,
			value,
		)

		fmt.Fprintf(
			out,
			"case %s:\n",
			name,
		)

		fmt.Fprintf(
			out,
			`return "%s"`+"\n",
			name,
		)
	}

	fmt.Fprintln(out, `
default:
    return "Unknown"
}
}`)

	return nil
}

var generatedEnums = map[string]bool{}

func main() {
	currentCategory := ""
	var funcLines []string
	var extraImports []string
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
	manifest, err := os.OpenFile("manifest.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0o644)
	if err != nil {
		panic(err)
	}
	defer manifest.Close()
	fmt.Fprintln(manifest, "Generating", headerPath)

	table, err := BuildTypeTable(headerPath)
	if err != nil {
		panic(err)
	}

	fmt.Fprintln(manifest, "=== TYPE TABLE ===")
	for _, info := range table.Types {
		fmt.Fprintf(
			manifest,
			"%s kind=%v values=%v header=%s\n",
			info.Name,
			info.Kind,
			info.EnumValues,
			info.HeaderPath,
		)
	}
	fmt.Fprintln(manifest, "==================")

	parts := strings.Split(headerPath, "falcon-core/")
	includePath := "falcon-core/" + parts[1]
	base := filepath.Base(headerPath)
	objectName := strings.Split(base, "_")[0]
	packageName := strings.ToLower(objectName)
	dir := filepath.Dir(parts[1])
	dir = strings.ReplaceAll(dir, "_", "-")
	for _, info := range table.Types {

		if info.Kind != TypeEnum {
			continue
		}

		if info.HeaderPath != headerPath {
			continue
		}

		if generatedEnums[info.Name] {
			continue
		}

		generatedEnums[info.Name] = true

		parts := strings.Split(
			info.HeaderPath,
			"falcon-core/",
		)

		relDir := filepath.Dir(parts[1])

		relDir = strings.ReplaceAll(
			relDir,
			"_",
			"-",
		)

		if err := generateEnum(
			info,
			relDir,
		); err != nil {
			panic(err)
		}
	}
	goFileName := strings.ReplaceAll(
		strings.ToLower(objectName[:1])+objectName[1:], "_", "-",
	) + ".go"
	goFilePath := filepath.Join(dir, packageName, goFileName)
	outFile, err := os.Create(goFilePath)
	if err != nil {
		panic(err)
	}

	fmt.Fprintf(outFile, `package %s
/*
#cgo pkg-config: falcon-core-c-api
#include <%s>
#include <falcon-core/generic/String_c_api.h>
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

	reset := false
	inBlockComment := false
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
		resultGoType := CtoGType(resultCType, packageName, table)
		fmt.Fprintln(manifest, "result go type:", resultGoType)
		methodName := extractMethodName(fullSig, objectName)
		fmt.Fprintln(manifest, "method name:", methodName)
		goName := goMethodName(methodName, objectName, currentCategory)
		fmt.Fprintln(manifest, "go method name:", goName)
		NumParams, Cparams := countParams(fullSig)
		for _, param := range Cparams {
			fmt.Fprintln(manifest, "C param:", param.Ctype, param.Name)
		}
		Goparams := toGoParams(Cparams, packageName, table)
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
			if strings.Contains(methodArguments, "*uint64") &&
				(NumParams-NumNonPrimitiveParams == 3 &&
					(NumNonPrimitiveParams == 1 || NumNonPrimitiveParams == 0)) ||
				(NumParams == 2 &&
					(strings.Contains(methodArguments, "shape") ||
						(goName == "New" && (strings.Contains(packageName, "list") || strings.Contains(packageName, "map"))))) {

				C0type := strings.TrimSpace(strings.TrimSuffix(Cparams[0].Ctype, "*"))
				var Go0type, argument string
				if IsString(Goparams[0].Gotype) {
					Go0type = "string"
					argument = fmt.Sprintf("C.%s(str.New(v).CAPIHandle())", C0type)
				} else if IsNonPrimitive(Goparams[0].Gotype) {
					Go0type = Goparams[0].Gotype
					argument = fmt.Sprintf("C.%s(v.CAPIHandle())", C0type)
				} else {
					Go0type = Goparams[0].Gotype[1:]
					argument = fmt.Sprintf("C.%s(v)", C0type)
				}
				sizeData := memorySize(Go0type, C0type)

				if NumParams > 2 {
					hasExtraParam := NumNonPrimitiveParams == 1
					var extraParamDecl, extraParamCall, wrapperStart, wrapperEnd string
					if hasExtraParam {
						extraParamDecl = fmt.Sprintf(", %s %s", Goparams[3].Name, Goparams[3].Gotype)
						extraParamCall = fmt.Sprintf(", C.%s(%s.CAPIHandle())", Cparams[3].Ctype, Goparams[3].Name)
						wrapperStart = fmt.Sprintf("return cmemoryallocation.Read(%s, func() (*Handle, error) {", Goparams[3].Name)
						wrapperEnd = "})"
					}
					fmt.Fprintf(outFile, `func %s(%s []%s, %s []uint64%s) (*Handle, error) {
`, goName, Goparams[0].Name, Go0type, Goparams[1].Name, extraParamDecl)
					emitGoMallocBlock(outFile, "cData", "nData", Goparams[0].Name, C0type, sizeData, argument)
					sizeShape := memorySize("uint64", "size_t")
					emitGoMallocBlock(outFile, "cShape", "nShape", Goparams[1].Name, "size_t", sizeShape, "C.size_t(v)")
					fmt.Fprintf(outFile, `%s
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				res := unsafe.Pointer(C.%s((*C.%s)(cData), (*C.size_t)(cShape), C.size_t(nShape)%s))
				C.free(cData)
				C.free(cShape)
				return res, nil
			},
			construct,
			destroy,
		)
	%s
}
`, wrapperStart, methodName, C0type, extraParamCall, wrapperEnd)
				} else {
					fmt.Fprintf(outFile, `func %s(%s []%s) (*Handle, error) {
`, goName, Goparams[0].Name, Go0type)
					emitGoMallocBlock(outFile, "cData", "nData", Goparams[0].Name, C0type, sizeData, argument)
					fmt.Fprintf(outFile, `return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.%s((*C.%s)(cData), C.size_t(nData)))
			C.free(cData)
			return res, nil
		},
		construct,
		destroy,
	)
}
`, methodName, C0type)
				}
				continue
			}
			// Listlike_create special case
			if NumNonPrimitiveParams == 1 && goName == "New" && strings.Contains(methodArguments, "list") {
				var goItemType string
				starIdx := strings.Index(methodArguments, "*")
				dotIdx := strings.Index(methodArguments, ".")
				typeName := methodArguments[starIdx+1 : dotIdx]
				itemPackageName := strings.TrimPrefix(typeName, "list") // if primitive a C type
				goItemType = CtoGType(itemPackageName, itemPackageName, table)
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
			hasOutBuffer := false
			fmt.Fprintf(
				manifest,
				"DEBUG %s Cparams=%+v\n",
				methodName,
				Cparams,
			)
			for _, param := range Cparams {
				if param.Name == "out_buffer" {
					hasOutBuffer = true
					break
				}
			}

			if !hasOutBuffer {
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
				} else if IsEnumGoType(resultGoType) {
					fmt.Fprintf(
						outFile,
						`return %s(%s), nil`,
						resultGoType,
						cfunction,
					)
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
				if bufferParam == nil {
					panic(fmt.Sprintf(
						"%s: expected out_buffer parameter but none was found",
						methodName,
					))
				}
				bufferCType := bufferParam.Ctype[:len(bufferParam.Ctype)-1]
				bufferGoType := CtoGType(bufferCType, packageName, table)
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

		if info, ok := table.Types[extraImport]; ok {

			goImportPaths = append(
				goImportPaths,
				findGoImportFromTypeInfo(info),
			)

			continue
		}

		importPath, err := findGoImport(
			headerPath,
			extraImport,
		)
		if err != nil {
			panic(err)
		}

		goImportPaths = append(
			goImportPaths,
			importPath,
		)
	}

	if err := insertImports(goFilePath, goImportPaths); err != nil {
		panic(err)
	}
	fmt.Fprintln(manifest, "Imports inserted successfully.")
}
