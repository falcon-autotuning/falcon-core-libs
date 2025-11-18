package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

const (
	headerRoot = "/usr/local/include/falcon-core-c-api"
	goRoot     = "./"
	green      = "\033[32m"
	red        = "\033[31m"
	reset      = "\033[0m"
)

func findGoFile(goRoot, goFile string) (string, bool) {
	var found string
	_ = filepath.Walk(goRoot, func(path string, info os.FileInfo, err error) error {
		if err == nil && !info.IsDir() && info.Name() == goFile {
			found = path
			return filepath.SkipDir
		}
		return nil
	})
	return found, found != ""
}

func main() {
	var total, missing int
	err := filepath.Walk(headerRoot, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() || !strings.HasSuffix(info.Name(), ".h") {
			return nil
		}
		total++
		base := strings.TrimSuffix(info.Name(), "_c_api.h")
		if base == info.Name() { // skip non _c_api.h headers
			return nil
		}
		goFileName := lowerFirst(base) + ".go"
		foundPath, ok := findGoFile(goRoot, goFileName)
		if ok {
			fmt.Printf("%s%-40s%s %s\n", green, info.Name(), reset, foundPath)
		} else {
			fmt.Printf("%s%-40s%s %s\n", red, info.Name(), reset, "(missing)")
			missing++
		}
		return nil
	})
	if err != nil {
		fmt.Println("Error walking header directory:", err)
	}
	percent := float64(total-missing) * 100 / float64(total)
	fmt.Printf("\nTotal headers: %d     %sMissing wrappers: %d     %sCompletion: %.2f%%%s\n", total, red, missing, green, percent, reset)
}

func lowerFirst(s string) string {
	if s == "" {
		return ""
	}
	return strings.ToLower(s[:1]) + s[1:]
}
