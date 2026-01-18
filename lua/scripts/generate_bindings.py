import os
import re

def generate_ffi(include_path):
    typedefs = set()
    declarations = []
    
    # Common FFI needs
    typedefs.add("typedef unsigned long size_t;")
    typedefs.add("typedef signed char int8_t;")
    typedefs.add("typedef short int16_t;")
    typedefs.add("typedef int int32_t;")
    typedefs.add("typedef long int64_t;")
    
    structs = set()
    
    for root, dirs, files in os.walk(include_path):
        for file in sorted(files):
            if "Macro" in file or file.endswith(".txt"):
                continue
                
            if file.endswith(".h") and "_c_api" in file:
                full_path = os.path.join(root, file)
                with open(full_path, "r") as f:
                    content = f.read()
                    content = re.sub(r'//.*', '', content)
                    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
                    content = re.sub(r'#.*', '', content)
                    content = re.sub(r'extern "C" \{', '', content)
                    content = re.sub(r'\}', '', content)
                    
                    # Capture all typedefs
                    for m in re.finditer(r'typedef\s+([^;]+);', content):
                        td_content = m.group(1).strip()
                        
                        # Special handling for void* handles
                        match = re.search(r'void\s*\*\s*([a-zA-Z0-9_]+Handle)', td_content)
                        if match:
                            handle_name = match.group(1).strip()
                            struct_name = handle_name.replace("Handle", "_s")
                            # Standard C opaque pointer declaration
                            typedefs.add(f"typedef struct {struct_name} * {handle_name};")
                            # Also add the underlying struct type for metatype usage
                            typedefs.add(f"typedef struct {struct_name} {{}} {struct_name};")
                            continue

                        if "bool" not in td_content:
                            typedefs.add(f"typedef {td_content};")
                    
                    if "struct string {" in content:
                        structs.add("struct string { char* raw; size_t length; };")

                    for m in re.finditer(r'[a-zA-Z_][a-zA-Z0-9_* ]+\s+[a-zA-Z0-9_]+\s*\([^;]*\);', content, flags=re.DOTALL):
                        functions_text = m.group(0).strip()
                        functions_text = re.sub(r'\s+', ' ', functions_text)
                        
                        if any(kw in functions_text for kw in ["try", "catch", "throw", "static_cast", "std::", "template", "FALCON_C_API"]):
                            continue
                            
                        declarations.append(functions_text)

    result = []
    result.append("// --- Typedefs ---")
    result.extend(sorted(list(typedefs)))
    result.append("")
    result.append("// --- Structs ---")
    result.extend(sorted(list(structs)))
    result.append("")
    result.append("// --- Functions ---")
    result.extend(declarations)
    
    return "\n".join(result)

if __name__ == "__main__":
    include_dir = "/home/daniel/work/wisc/playground/python-port-playground/falcon-core/c-api/include/falcon_core"
    defs = generate_ffi(include_dir)
    
    with open("falcon_core/ffi/cdef.lua", "w") as f:
        f.write("-- Auto-generated FFI definitions for falcon-core\n")
        f.write("local ffi = require('ffi')\n\n")
        f.write("ffi.cdef[[\n")
        f.write(defs)
        f.write("\n]]\n")
        f.write("\n")
        f.write("-- Export library and utilities\n")
        f.write("return {\n")
        f.write("    lib = ffi.load('/usr/local/lib/libfalcon_core_c_api.so'),\n")
        f.write("    ffi = ffi\n")
        f.write("}\n")
