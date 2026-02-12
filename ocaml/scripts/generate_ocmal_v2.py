#!/usr/bin/env python3
"""
Complete OCaml wrapper generator for falcon-core C-API.
Mirrors Go's genFile/main.go with all special cases and proper implementations.

"""

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

IMPORT_WATERMARK = "(* ---------INSERT-IMPORTS--------- *)"


@dataclass
class Argument:
    type_name: str
    name: str
    is_ptr: bool = False
    is_const: bool = False


@dataclass
class Function:
    name: str
    return_type: str
    args: list[Argument]
    category: str  # allocation, deallocation, read, write
    raw_sig: str


@dataclass
class ClassDef:
    name: str
    handle_type: str
    namespace_path: list[str]
    include_path: str = ""
    methods: list[Function] = field(default_factory=list)
    constructors: list[Function] = field(default_factory=list)
    destructor: Optional[Function] = None

    # Add this as a class attribute in OCamlGenerator.__init__
    # These C-API types should NOT generate wrapper files because they
    # conflict with OCaml stdlib or are handled specially by capi_bindings


class OCamlGenerator:
    def __init__(self, include_dir: Path, output_dir: Path):
        self.include_dir = include_dir
        self.output_dir = output_dir
        self.classes: list[ClassDef] = []

        # Types to skip generating wrappers for - these shadow stdlib modules
        # or are handled specially (like String being handled by capi_bindings)
        self.SKIP_TYPES = {
            "String",
            "ErrorHandling",
            "InstrumentTypes",
            "Sign",
            "Precompiled",
        }

        # ... rest of __init__ unchanged ...

        # Track type dependencies for proper imports
        self.type_dependencies: dict[str, set[str]] = {}
        # Current class being generated (for tracking)
        self.current_class_dependencies: set[str] = set()
        # Cache: type_name -> (qualified_module_path, module_name)
        # e.g. "Connection" -> ("Physics.Device_structures.Connection", "Connection")
        self._module_path_cache: dict[str, Optional[str]] = {}
        # C to OCaml type mapping
        self.primitive_map = {
            "void": "unit",
            "int": "int",
            "size_t": "int",
            "bool": "bool",
            "double": "float",
            "float": "float",
            "char": "char",
            "int8_t": "int",
            "int16_t": "int",
            "int32_t": "int32",
            "int64_t": "int64",
            "uint8_t": "int",
            "uint16_t": "int",
            "uint32_t": "int32",
            "uint64_t": "int64",
            "long long": "int64",
        }

        self.ocaml_keywords = {
            "type",
            "end",
            "method",
            "object",
            "module",
            "class",
            "val",
            "let",
            "in",
            "match",
            "with",
            "try",
            "raise",
            "exception",
            "external",
            "open",
            "include",
            "constraint",
            "done",
            "if",
            "then",
            "else",
            "for",
            "while",
            "do",
            "to",
            "downto",
            "begin",
            "rec",
            "mutable",
            "virtual",
            "private",
            "as",
            "fun",
            "function",
            "initializer",
            "lazy",
            "assert",
            "asr",
            "land",
            "lor",
            "lsl",
            "lsr",
            "lxor",
            "mod",
            "or",
            "sig",
            "struct",
        }

    def safe_name(self, name: str) -> str:
        """Escape OCaml keywords"""
        if name in self.ocaml_keywords:
            return name + "_"
        return name

    def is_primitive(self, ocaml_type: str) -> bool:
        """Check if type is primitive (like Go's IsPrimitive)"""
        return ocaml_type in ["bool", "int", "int32", "int64", "float", "unit"]

    def is_string(self, c_type: str) -> bool:
        """Check if type is string"""
        return "StringHandle" in c_type or (c_type.endswith("*") and "char" in c_type)

    def is_handle(self, c_type: str) -> bool:
        """Check if type is a handle (non-primitive)"""
        return "Handle" in c_type and "StringHandle" not in c_type

    def find_module_path(self, header_path: Path, type_name: str) -> Optional[str]:
        """
        Find the OCaml module path for a given type by scanning header includes.
        Similar to Go's findGoImport.

        Returns: "Physics.Device_structures.Connection" or None
        """
        if not header_path.exists():
            print(f"  WARNING: Header path doesn't exist: {header_path}")
            return None

        content = header_path.read_text()

        # Search pattern
        search = f"/{type_name}_c_api.h"

        print(f"  Searching for '{search}' in {header_path.name}")

        # Find #include statements
        include_re = re.compile(r'#include\s+"([^"]+)"')

        for match in include_re.finditer(content):
            include_path = match.group(1)

            # Found direct include
            if search in include_path:
                print(f"    FOUND: {include_path}")
                # Extract path: "falcon_core/physics/device_structures/Connection_c_api.h"
                if "falcon_core/" in include_path:
                    # Remove "falcon_core/" prefix and "_c_api.h" suffix
                    rel = include_path.split("falcon_core/", 1)[1]
                    rel = rel.rsplit("/", 1)[0]  # Remove filename
                    # Convert "physics/device_structures" -> ["Physics", "Device_structures"]
                    parts = [p.capitalize() for p in rel.split("/")]
                    # Add the type name module
                    parts.append(type_name)
                    return ".".join(parts)
                return type_name

        # Recurse into included headers
        for match in include_re.finditer(content):
            include_path = match.group(1)
            full_path = self.include_dir / include_path
            if full_path.exists():
                result = self.find_module_path(full_path, type_name)
                if result:
                    return result

        return None

    def _get_qualified_module_path(
        self, c_type: str, current_class: ClassDef
    ) -> Optional[str]:
        """
        Get the fully qualified dune module path for a handle type.
        Returns e.g. "Physics.Device_structures.Connection" or None for self-references.
        Caches results.
        """
        if not c_type.endswith("Handle") or "StringHandle" in c_type:
            return None

        type_name = c_type.replace("Handle", "").strip()

        # Self-reference
        if type_name.lower() == current_class.name.lower():
            return None

        # Check cache
        cache_key = f"{type_name}:{current_class.include_path}"
        if cache_key in self._module_path_cache:
            return self._module_path_cache[cache_key]

        header_path = Path(current_class.include_path)
        module_path = self.find_module_path(header_path, type_name)
        self._module_path_cache[cache_key] = module_path
        return module_path

    def resolve_type_path(self, c_type: str, current_class: ClassDef) -> str:
        """Resolve module path for a type.

        With (include_subdirs unqualified), all modules are in a flat namespace.
        The file 'connection.ml' defines file-module 'Connection', which contains
        'module Connection = struct type t = ... end'.

        From outside, the type is accessed as: Connection.Connection.t
        (file_module.inner_module.t)

        BUT: since the file module name (Connection) equals the inner module name
        (Connection), and we can just reference the inner module directly as
        {InnerModule}.t — OCaml will find it through the file module automatically
        because the file module IS the namespace.

        Actually with unqualified, the file connection.ml is module Connection.
        Inside it, 'module Connection = struct ... end' creates Connection.Connection.
        To reference the type from outside: Connection.Connection.t

        But we need to be careful: the file module name is capitalize(filename),
        and the inner module name is cls.name. These may differ in casing.
        File: connection.ml -> file module: Connection
        Inner: module Connection = struct ... -> inner: Connection
        So type = Connection.Connection.t? No, that's redundant.

        The simpler approach: since we open nothing and the file module is Connection,
        and inside it is module Connection, from OUTSIDE we write Connection.Connection.t.
        But from the SAME file, it's just 't' (self-reference).

        Actually, the simplest correct approach: just use {cls.name}.t for cross-module
        references. Because the file IS the module — when you write Connection.t in
        another file, OCaml finds file module Connection, then looks for type t,
        but t doesn't exist at the file-module level. It exists inside the INNER
        module Connection.Connection.

        So the correct path is: {FileName_Module}.{InnerModule}.t
        With our naming: Capitalize(lowercase(type_name)).{type_name}.t
        e.g. Connection.Connection.t, Symbolunit.SymbolUnit.t
        """
        if c_type in self.primitive_map:
            return self.primitive_map[c_type]

        if "StringHandle" in c_type:
            return "string"

        if c_type.endswith("Handle"):
            type_name = c_type.replace("Handle", "").strip()

            # Self-reference: just use "t"
            if type_name.lower() == current_class.name.lower():
                return "t"

            # File module name: capitalize(lowercase(type_name))
            # e.g. SymbolUnit -> symbolunit -> Symbolunit
            lowercase_name = type_name.lower()
            file_module = lowercase_name[0].upper() + lowercase_name[1:]

            # Inner module name: the original class name as written
            inner_module = type_name

            return f"{file_module}.{inner_module}.t"

        return c_type

    def resolve_class_constructor(self, c_type: str, current_class: ClassDef) -> str:
        """Resolve the class constructor name for 'new c_<type>'.

        With unqualified subdirs, just use FileModule.c_typename.
        """
        if not c_type.endswith("Handle") or "StringHandle" in c_type:
            return ""

        type_name = c_type.replace("Handle", "").strip()
        class_name = f"c_{type_name.lower()}"

        # Self-reference
        if type_name.lower() == current_class.name.lower():
            return class_name

        # File module name
        lowercase_name = type_name.lower()
        file_module = lowercase_name[0].upper() + lowercase_name[1:]

        return f"{file_module}.{class_name}"

    def c_to_ocaml_type(self, c_type: str, class_def: ClassDef) -> str:
        """Convert C types to OCaml types with proper module paths"""
        c_type = c_type.strip()

        # Handle pointers
        if c_type.endswith("*"):
            base = c_type[:-1].strip()
            if base == "char":
                return "string"
            if base in self.primitive_map:
                return self.primitive_map[base]

        # Use resolver for handles and complex types
        return self.resolve_type_path(c_type, class_def)

    def c_to_ctypes(self, c_type: str) -> str:
        """Convert C type to Ctypes binding type"""
        c_type = c_type.strip()

        if "Handle" in c_type:
            return "ptr void"

        if c_type.endswith("*"):
            base = c_type[:-1].strip()
            if base == "char":
                return "string"
            if base in ["int", "double", "float", "bool", "size_t"]:
                return f"ptr {self.primitive_map.get(base, base)}"

        if c_type == "bool":
            return "bool"
        if c_type == "long long":
            return "int64_t"
        if c_type == "size_t":
            return "size_t"

        if c_type == "void":
            return "void"

        # Map other primitives
        primitive_ctypes = {
            "int": "int",
            "double": "double",
            "float": "float",
            "char": "char",
            "int8_t": "int8_t",
            "int16_t": "int16_t",
            "int32_t": "int32_t",
            "int64_t": "int64_t",
            "uint8_t": "uint8_t",
            "uint16_t": "uint16_t",
            "uint32_t": "uint32_t",
            "uint64_t": "uint64_t",
        }

        return primitive_ctypes.get(c_type, "void")

    def extract_namespace_path(self, header_path: Path) -> list[str]:
        """Extract namespace path from header file path"""
        try:
            rel_path = header_path.relative_to(self.include_dir)
            parts = list(rel_path.parts[:-1])  # Exclude filename

            # Skip 'falcon_core' directory if it's the first part
            if parts and parts[0] == "falcon_core":
                parts = parts[1:]

            return parts if parts else []
        except ValueError:
            return []

    def parse_header(self, header_path: Path):
        """Parse C-API header using @category annotations"""
        content = header_path.read_text()
        namespace_path = self.extract_namespace_path(header_path)

        # Find Handle typedef
        handle_re = re.compile(
            r"typedef\s+(?:void|struct\s+\w+)?\s*\*\s*(\w+Handle)\s*;"
        )
        current_classes = {}
        for match in handle_re.finditer(content):
            handle_type = match.group(1)
            if handle_type.endswith("Handle"):
                class_name = handle_type[:-6]
                cls = ClassDef(
                    name=class_name,
                    handle_type=handle_type,
                    namespace_path=namespace_path,
                    include_path=str(header_path),
                )
                current_classes[class_name] = cls

        # Parse functions with categories
        lines = content.split("\n")
        current_category = ""
        func_lines = []
        in_block_comment = False

        for line in lines:
            line, in_block_comment = self.strip_block_comment(line, in_block_comment)
            if not line.strip():
                continue

            # Check for @category annotation
            if line.strip().startswith("// @category:"):
                current_category = line.split(":", 1)[1].strip()
                continue

            if not current_category:
                continue

            # Accumulate function lines
            func_lines.append(line.strip())
            if not line.strip().endswith(");"):
                continue

            # Parse complete function signature
            full_sig = " ".join(func_lines)
            func_lines = []

            func = self.parse_function_signature(full_sig, current_category)
            if not func:
                current_category = ""
                continue

            # Associate function with class
            for cls_name, cls in current_classes.items():
                if func.name.startswith(cls_name + "_"):
                    if current_category == "deallocation":
                        cls.destructor = func
                    elif current_category == "allocation":
                        cls.constructors.append(func)
                    else:
                        cls.methods.append(func)
                    break

            current_category = ""

        self.classes.extend(current_classes.values())

    def strip_block_comment(self, line: str, in_block: bool) -> tuple[str, bool]:
        """Strip C-style block comments"""
        trimmed = line.strip()
        while True:
            if in_block:
                end = trimmed.find("*/")
                if end == -1:
                    return "", True
                trimmed = trimmed[end + 2 :].strip()
                in_block = False
                continue
            start = trimmed.find("/*")
            if start == -1:
                break
            end = trimmed.find("*/", start + 2)
            if end == -1:
                trimmed = trimmed[:start]
                in_block = True
                break
            trimmed = (trimmed[:start] + trimmed[end + 2 :]).strip()
        return trimmed, in_block

    def parse_function_signature(self, sig: str, category: str) -> Optional[Function]:
        """Parse C function signature"""
        sig = sig.replace("FALCON_CORE_C_API", "").strip()

        match = re.match(r"([\w\s\*]+?)\s+(\w+)\s*\(([^)]*)\)\s*;", sig)
        if not match:
            return None

        ret_type = match.group(1).strip()
        func_name = match.group(2).strip()
        params_str = match.group(3).strip()

        args = []
        if params_str and params_str != "void":
            for param in params_str.split(","):
                param = param.strip()
                # Handle "long long" specially
                if "long long" in param:
                    parts = param.replace("long long", "longlong").split()
                    arg_name = (
                        parts[-1].replace("[", "").replace("]", "").replace("*", "")
                    )
                    is_ptr = "*" in param or "[" in param
                    arg_type = "long long"
                else:
                    parts = param.split()
                    if not parts:
                        continue
                    arg_name = (
                        parts[-1].replace("[", "").replace("]", "").replace("*", "")
                    )
                    is_ptr = "*" in param or "[" in param
                    arg_type = (
                        " ".join(parts[:-1])
                        .replace("const", "")
                        .replace("*", "")
                        .strip()
                    )

                args.append(Argument(type_name=arg_type, name=arg_name, is_ptr=is_ptr))

        return Function(
            name=func_name,
            return_type=ret_type,
            args=args,
            category=category,
            raw_sig=sig,
        )

    def snake_to_camel_lower(self, name: str) -> str:
        """Convert snake_case to camelCase, handling special cases"""
        if name.startswith("__"):
            name = "_" + name[2:]

        parts = name.split("_")
        if not parts:
            return name

        if parts[0] == "":
            return "_" + parts[1].lower() + "".join(p.capitalize() for p in parts[2:])

        return parts[0].lower() + "".join(p.capitalize() for p in parts[1:])

    def generate_c_arg_call(self, arg: Argument, class_def: ClassDef) -> str:
        """
        Generate the C argument call expression.
        Similar to Go's MakeCArgs function.
        """
        ocaml_type = self.c_to_ocaml_type(arg.type_name, class_def)
        arg_name = self.safe_name(arg.name)

        # String conversion (like Go's str.New)
        if self.is_string(arg.type_name):
            return f"(Capi_bindings.string_wrap {arg_name})"

        # Handle types need raw extraction (like Go's .CAPIHandle())
        elif self.is_handle(arg.type_name):
            return f"{arg_name}#raw"

        # Primitives passed directly
        elif self.is_primitive(ocaml_type):
            if arg.type_name == "size_t":
                return f"(Unsigned.Size_t.of_int {arg_name})"
            elif arg.type_name == "long long":
                return f"(Int64.of_int {arg_name})"
            else:
                return arg_name

        else:
            return arg_name

    def generate_method_impl(
        self, func: Function, class_def: ClassDef, is_instance: bool
    ) -> list[str]:
        """
        Generate complete method implementation.
        Handles all special cases from Go's genFile.
        """
        lines = []

        method_name = func.name.replace(f"{class_def.name}_", "")
        ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))

        # Determine return type
        ret_type_ocaml = self.c_to_ocaml_type(func.return_type, class_def)
        ret_is_handle = self.is_handle(func.return_type)
        ret_is_string = self.is_string(func.return_type)
        ret_is_primitive = self.is_primitive(ret_type_ocaml)

        # Build parameter list (skip first if instance method)
        params = []
        args_start = 1 if is_instance else 0
        for arg in func.args[args_start:]:
            param_type = self.c_to_ocaml_type(arg.type_name, class_def)
            params.append((self.safe_name(arg.name), param_type))

        # Check for special case: out_buffer pattern
        has_out_buffer = any(arg.name == "out_buffer" for arg in func.args)

        # Count handles for error wrapper selection
        handle_args = [
            arg for arg in func.args[args_start:] if self.is_handle(arg.type_name)
        ]

        if func.category == "allocation":
            return self.generate_constructor(func, class_def, params)

        elif func.category == "read":
            if has_out_buffer:
                return self.generate_out_buffer_method(func, class_def, is_instance)
            else:
                return self.generate_read_method(
                    func, class_def, is_instance, params, handle_args
                )

        elif func.category == "write":
            return self.generate_write_method(
                func, class_def, is_instance, params, handle_args
            )

        return lines

    def generate_constructor(
        self, func: Function, class_def: ClassDef, params: list[tuple[str, str]]
    ) -> list[str]:
        """Generate constructor method"""
        lines = []

        method_name = func.name.replace(f"{class_def.name}_", "")
        if "create" in method_name:
            method_name = method_name.replace("create_", "").replace("create", "make")
        if "from_json_string" in method_name:
            method_name = "fromJson"

        ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))

        # BUILD PARAMETERS FROM FUNCTION ARGUMENTS
        param_list = []
        for arg in func.args:
            param_type = self.c_to_ocaml_type(arg.type_name, class_def)
            param_name = self.safe_name(arg.name)
            param_list.append((param_name, param_type))

        # Build parameter string
        if param_list:
            param_strs = [f"({name} : {typ})" for name, typ in param_list]
            param_str = " ".join(param_strs)
        else:
            param_str = "()"

        lines.append(f"  let {ocaml_name} {param_str} : t =")

        # Build C function call arguments with proper conversions
        c_args = []
        for arg in func.args:
            c_args.append(self.generate_c_arg_call(arg, class_def))

        c_call = f"Capi_bindings.{func.name.lower()}"
        if c_args:
            c_call += " " + " ".join(c_args)
        else:
            c_call += " ()"

        # Handle errors based on number of handle parameters
        handle_params = [arg for arg in func.args if self.is_handle(arg.type_name)]

        if len(handle_params) == 0:
            lines.append(f"    let ptr = {c_call} in")
            lines.append("    Error_handling.raise_if_error ();")
            lines.append(f"    new c_{class_def.name.lower()} ptr")
        elif len(handle_params) == 1:
            handle_name = self.safe_name(handle_params[0].name)
            lines.append(f"    Error_handling.read {handle_name} (fun () ->")
            lines.append(f"      let ptr = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            lines.append(f"      new c_{class_def.name.lower()} ptr")
            lines.append("    )")
        else:
            handle_names = [self.safe_name(arg.name) for arg in handle_params]
            lines.append(
                f"    Error_handling.multi_read [{'; '.join(handle_names)}] (fun () ->"
            )
            lines.append(f"      let ptr = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            lines.append(f"      new c_{class_def.name.lower()} ptr")
            lines.append("    )")

        return lines

    def generate_read_method(
        self,
        func: Function,
        class_def: ClassDef,
        is_instance: bool,
        params: list[tuple[str, str]],
        handle_args: list[Argument],
    ) -> list[str]:
        """Generate read method with proper error handling"""
        lines = []

        method_name = func.name.replace(f"{class_def.name}_", "")
        ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))
        ret_type_ocaml = self.c_to_ocaml_type(func.return_type, class_def)

        # Build parameter string
        param_strs = [f"({name} : {typ})" for name, typ in params]
        param_str = " ".join(param_strs) if param_strs else ""

        if is_instance:
            lines.append(f"  method {ocaml_name} {param_str} : {ret_type_ocaml} =")
        else:
            lines.append(f"  let {ocaml_name} {param_str} : {ret_type_ocaml} =")

        # Build C call
        c_args = []
        if is_instance:
            c_args.append("raw_val")
        for arg in func.args[1 if is_instance else 0 :]:
            c_args.append(self.generate_c_arg_call(arg, class_def))

        c_call = f"Capi_bindings.{func.name.lower()}"
        if c_args:
            c_call += " " + " ".join(c_args)
        else:
            c_call += " ()"

        # Determine wrapper based on handle count
        total_handles = len(handle_args) + (1 if is_instance else 0)

        if total_handles == 0:
            lines.append(f"    let result = {c_call} in")
            lines.append("    Error_handling.raise_if_error ();")
            self._add_return_conversion(
                lines, func.return_type, ret_type_ocaml, "result", 4, class_def
            )
        elif total_handles == 1:
            handle_ref = "self" if is_instance else self.safe_name(handle_args[0].name)
            lines.append(f"    Error_handling.read {handle_ref} (fun () ->")
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            self._add_return_conversion(
                lines, func.return_type, ret_type_ocaml, "result", 6, class_def
            )
            lines.append("    )")
        else:
            if is_instance:
                handle_names = ["self"] + [
                    self.safe_name(arg.name) for arg in handle_args
                ]
            else:
                handle_names = [self.safe_name(arg.name) for arg in handle_args]
            lines.append(
                f"    Error_handling.multi_read [{'; '.join(handle_names)}] (fun () ->"
            )
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            self._add_return_conversion(
                lines, func.return_type, ret_type_ocaml, "result", 6, class_def
            )
            lines.append("    )")

        return lines

    def generate_write_method(
        self,
        func: Function,
        class_def: ClassDef,
        is_instance: bool,
        params: list[tuple[str, str]],
        handle_args: list[Argument],
    ) -> list[str]:
        """Generate write method"""
        lines = []

        method_name = func.name.replace(f"{class_def.name}_", "")
        ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))

        param_strs = [f"({name} : {typ})" for name, typ in params]
        param_str = " ".join(param_strs) if param_strs else ""

        if is_instance:
            lines.append(f"  method {ocaml_name} {param_str} : unit =")
        else:
            lines.append(f"  let {ocaml_name} {param_str} : unit =")

        # Build C call
        c_args = []
        if is_instance:
            c_args.append("raw_val")
        for arg in func.args[1 if is_instance else 0 :]:
            c_args.append(self.generate_c_arg_call(arg, class_def))

        c_call = f"Capi_bindings.{func.name.lower()}"
        if c_args:
            c_call += " " + " ".join(c_args)

        # Determine wrapper based on handle count
        total_handles = len(handle_args) + (1 if is_instance else 0)

        if total_handles == 0:
            lines.append(f"    let result = {c_call} in")
            lines.append("    Error_handling.raise_if_error ();")
            lines.append("    result")
        elif total_handles == 1:
            handle_ref = "self" if is_instance else self.safe_name(handle_args[0].name)
            lines.append(f"    Error_handling.write {handle_ref} (fun () ->")
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            lines.append("      result")
            lines.append("    )")
        else:
            if is_instance:
                handle_names = ["self"] + [
                    self.safe_name(arg.name) for arg in handle_args
                ]
            else:
                handle_names = [self.safe_name(arg.name) for arg in handle_args]
            lines.append(
                f"    Error_handling.read_write (List.hd [{'; '.join(handle_names)}]) (List.tl [{'; '.join(handle_names)}]) (fun () ->"
            )
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            lines.append("      result")
            lines.append("    )")

        return lines

    def generate_out_buffer_method(
        self, func: Function, class_def: ClassDef, is_instance: bool
    ) -> list[str]:
        """Generate method with out_buffer pattern"""
        lines = []

        method_name = func.name.replace(f"{class_def.name}_", "")
        ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))
        ret_type_ocaml = self.c_to_ocaml_type(func.return_type, class_def)

        # Build parameter list
        params = []
        args_start = 1 if is_instance else 0
        for arg in func.args[args_start:]:
            param_type = self.c_to_ocaml_type(arg.type_name, class_def)
            params.append((self.safe_name(arg.name), param_type))

        param_strs = [f"({name} : {typ})" for name, typ in params]
        param_str = " ".join(param_strs) if param_strs else ""

        if is_instance:
            lines.append(f"  method {ocaml_name} {param_str} : {ret_type_ocaml} =")
        else:
            lines.append(f"  let {ocaml_name} {param_str} : {ret_type_ocaml} =")

        # Build C call
        c_args = []
        if is_instance:
            c_args.append("raw_val")
        for arg in func.args[1 if is_instance else 0 :]:
            c_args.append(self.generate_c_arg_call(arg, class_def))

        c_call = f"Capi_bindings.{func.name.lower()}"
        if c_args:
            c_call += " " + " ".join(c_args)

        # Count handles
        handle_args = [
            arg for arg in func.args[args_start:] if self.is_handle(arg.type_name)
        ]
        total_handles = len(handle_args) + (1 if is_instance else 0)

        if total_handles <= 1:
            handle_ref = (
                "self"
                if is_instance
                else (self.safe_name(handle_args[0].name) if handle_args else "self")
            )
            lines.append(f"    Error_handling.read {handle_ref} (fun () ->")
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            lines.append("      result")
            lines.append("    )")
        else:
            if is_instance:
                handle_names = ["self"] + [
                    self.safe_name(arg.name) for arg in handle_args
                ]
            else:
                handle_names = [self.safe_name(arg.name) for arg in handle_args]
            lines.append(
                f"    Error_handling.multi_read [{'; '.join(handle_names)}] (fun () ->"
            )
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            lines.append("      result")
            lines.append("    )")

        return lines

    def generate_bindings(self):
        """Generate Ctypes FFI bindings"""
        lines = [
            "open Ctypes",
            "open Foreign",
            "",
            'let lib = Dl.dlopen ~filename:"libfalcon_core_c_api.so" ~flags:[Dl.RTLD_NOW]',
            "",
            "(* String conversion helpers - delegate to Falcon_string module *)",
            "let string_wrap = Falcon_string.of_string",
            "let string_to_ocaml = Falcon_string.to_string",
            "",
            "(* Raw C bindings *)",
        ]

        # Generate bindings for each class
        for cls in self.classes:
            lines.append(f"(* === {cls.name} === *)")

            # All functions
            all_funcs = []
            if cls.destructor:
                all_funcs.append(cls.destructor)
            all_funcs.extend(cls.constructors)
            all_funcs.extend(cls.methods)

            for func in all_funcs:
                binding_name = func.name.lower()

                # Build Ctypes signature
                param_types = []
                for arg in func.args:
                    param_types.append(self.c_to_ctypes(arg.type_name))

                ret_ctypes = self.c_to_ctypes(func.return_type)
                if self.is_handle(func.return_type):
                    ret_ctypes = "ptr void"

                if not param_types:
                    sig_str = f"void @-> returning ({ret_ctypes})"
                else:
                    sig_parts = " @-> ".join(param_types)
                    sig_str = f"{sig_parts} @-> returning ({ret_ctypes})"

                lines.append(
                    f'let {self.safe_name(binding_name)} = foreign ~from:lib "{func.name}" ({sig_str})'
                )

            lines.append("")

        # Write file
        bindings_path = self.output_dir / "src" / "capi_bindings.ml"
        bindings_path.parent.mkdir(parents=True, exist_ok=True)
        bindings_path.write_text("\n".join(lines))
        print(f"Generated {bindings_path}")

    def generate_error_handling_module(self) -> str:
        """Generate error handling module with actual C-API error checking"""
        return """(* Error handling module - similar to Go's cmemoryallocation/errorhandling *)
    open Ctypes
    open Foreign

    let lib = Dl.dlopen ~filename:"libfalcon_core_c_api.so" ~flags:[Dl.RTLD_NOW]

    (* External C functions for error handling *)
    let c_get_last_error_code = 
        foreign ~from:lib "get_last_error_code" (void @-> returning int)

    let c_get_last_error_msg = 
        foreign ~from:lib "get_last_error_msg" (void @-> returning string)

    let c_set_last_error = 
        foreign ~from:lib "set_last_error" (int @-> string @-> returning void)

    exception CApiError of string

    (* Check for C-API errors after a call *)
    let check_error () : string option =
        let code = c_get_last_error_code () in
        if code = 0 then
        None
        else
        let msg = c_get_last_error_msg () in
        Some msg

    let raise_if_error () =
        match check_error () with
        | Some err -> 
            (* Reset error before raising *)
            c_set_last_error 0 "";
            raise (CApiError err)
        | None -> ()

    (* Reset error state *)
    let reset_error () =
        c_set_last_error 0 ""

    (* Read wrapper - validates handle and checks errors *)
    let read (handle : 'a) (f : unit -> 'b) : 'b =
        let result = f () in
        raise_if_error ();
        result

    (* Write wrapper - checks errors after write operation *)
    let write (handle : 'a) (f : unit -> unit) : unit =
        f ();
        raise_if_error ()

    (* MultiRead - validates multiple handles *)
    let multi_read (handles : 'a list) (f : unit -> 'b) : 'b =
        let result = f () in
        raise_if_error ();
        result

    (* ReadWrite - combination of read and write *)
    let read_write (write_handle : 'a) (read_handles : 'b list) (f : unit -> unit) : unit =
        f ();
        raise_if_error ()
        
    (* Helper to wrap C calls that might fail *)
    let with_error_check (f : unit -> 'a) : 'a =
        let result = f () in
        raise_if_error ();
        result
    """

    def generate_error_handling_file(self):
        """Generate standalone error_handling.ml file"""
        eh_path = self.output_dir / "src" / "error_handling.ml"
        eh_path.parent.mkdir(parents=True, exist_ok=True)
        eh_path.write_text(self.generate_error_handling_module())
        print(f"Generated {eh_path}")

    def generate_class_wrapper(self, cls: ClassDef) -> list[str]:
        """Generate complete wrapper for a class"""
        lines = []

        # Separate instance methods from static methods
        instance_methods = []
        static_methods = []

        for method in cls.methods:
            is_instance = (
                len(method.args) > 0
                and method.args[0].type_name + "Handle" == cls.handle_type
            )
            if is_instance:
                instance_methods.append(method)
            else:
                static_methods.append(method)

        # Class definition - ONLY instance methods
        class_name_ml = f"c_{cls.name.lower()}"
        lines.append(f"class {class_name_ml} (h : unit ptr) = object(self)")
        lines.append("  val raw_val = h")
        lines.append("  method raw = raw_val")

        # Generate ONLY instance methods (those that use self)
        for method in instance_methods:
            method_lines = self.generate_instance_method(method, cls)
            lines.extend(method_lines)

        # Finalizer - FIXED: use Error_handling not ErrorHandling
        if cls.destructor:
            lines.append("  initializer Gc.finalise (fun _ ->")
            lines.append(f"    Capi_bindings.{cls.destructor.name.lower()} raw_val;")
            lines.append("    Error_handling.raise_if_error ()")
            lines.append("  ) self")

        lines.append("end")
        lines.append("")

        # Module with constructors AND static methods
        lines.append(f"module {cls.name} = struct")
        lines.append(f"  type t = {class_name_ml}")
        lines.append("")

        # Constructors
        for ctor in cls.constructors:
            ctor_lines = self.generate_constructor(ctor, cls, [])
            lines.extend(ctor_lines)
            lines.append("")

        # Static methods (functions that take handle as parameter)
        for method in static_methods:
            static_lines = self.generate_static_method(method, cls)
            lines.extend(static_lines)
            lines.append("")

        lines.append("end")

        return lines

    def generate_instance_method(
        self, func: Function, class_def: ClassDef
    ) -> list[str]:
        """Generate instance method (uses self, no handle parameter)"""
        lines = []

        method_name = func.name.replace(f"{class_def.name}_", "")
        ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))
        ret_type_ocaml = self.c_to_ocaml_type(func.return_type, class_def)

        # Build parameter list (skip first arg - it's self)
        params = []
        for arg in func.args[1:]:
            param_type = self.c_to_ocaml_type(arg.type_name, class_def)
            params.append((self.safe_name(arg.name), param_type))

        param_strs = [f"({name} : {typ})" for name, typ in params]
        param_str = " ".join(param_strs) if param_strs else ""

        if func.return_type == "void":
            lines.append(f"  method {ocaml_name} {param_str} : unit =")
        else:
            lines.append(f"  method {ocaml_name} {param_str} : {ret_type_ocaml} =")

        # Build C call
        c_args = ["raw_val"]
        for arg in func.args[1:]:
            c_args.append(self.generate_c_arg_call(arg, class_def))

        c_call = f"Capi_bindings.{func.name.lower()}"
        c_call += " " + " ".join(c_args)

        # Count extra handle args (beyond self)
        handle_args = [arg for arg in func.args[1:] if self.is_handle(arg.type_name)]

        if func.category == "read":
            if len(handle_args) == 0:
                lines.append("    Error_handling.read self (fun () ->")
                lines.append(f"      let result = {c_call} in")
                lines.append("      Error_handling.raise_if_error ();")
                self._add_return_conversion(
                    lines, func.return_type, ret_type_ocaml, "result", 6, class_def
                )
                lines.append("    )")
            else:
                handle_names = ["self"] + [
                    self.safe_name(arg.name) for arg in handle_args
                ]
                lines.append(
                    f"    Error_handling.multi_read [{'; '.join(handle_names)}] (fun () ->"
                )
                lines.append(f"      let result = {c_call} in")
                lines.append("      Error_handling.raise_if_error ();")
                self._add_return_conversion(
                    lines, func.return_type, ret_type_ocaml, "result", 6, class_def
                )
                lines.append("    )")

        elif func.category == "write":
            if len(handle_args) == 0:
                lines.append("    Error_handling.write self (fun () ->")
                lines.append(f"      let result = {c_call} in")
                lines.append("      Error_handling.raise_if_error ();")
                lines.append("      result")
                lines.append("    )")
            else:
                handle_names = ["self"] + [
                    self.safe_name(arg.name) for arg in handle_args
                ]
                lines.append(
                    f"    Error_handling.read_write (List.hd [{'; '.join(handle_names)}]) (List.tl [{'; '.join(handle_names)}]) (fun () ->"
                )
                lines.append(f"      let result = {c_call} in")
                lines.append("      Error_handling.raise_if_error ();")
                lines.append("      result")
                lines.append("    )")

        return lines

    def generate_static_method(self, func: Function, class_def: ClassDef) -> list[str]:
        """Generate static method (takes handle as explicit parameter)"""
        lines = []

        method_name = func.name.replace(f"{class_def.name}_", "")
        ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))
        ret_type_ocaml = self.c_to_ocaml_type(func.return_type, class_def)

        # Build parameter list including handle
        params = []
        for arg in func.args:
            param_type = self.c_to_ocaml_type(arg.type_name, class_def)
            params.append((self.safe_name(arg.name), param_type))

        param_strs = [f"({name} : {typ})" for name, typ in params]
        param_str = " ".join(param_strs)

        lines.append(f"  let {ocaml_name} {param_str} : {ret_type_ocaml} =")

        # Build C call
        c_args = []
        for arg in func.args:
            c_args.append(self.generate_c_arg_call(arg, class_def))

        c_call = f"Capi_bindings.{func.name.lower()}"
        if c_args:
            c_call += " " + " ".join(c_args)

        # Determine error wrapper
        handle_args = [arg for arg in func.args if self.is_handle(arg.type_name)]

        if len(handle_args) == 0:
            lines.append(f"    let result = {c_call} in")
            lines.append("    Error_handling.raise_if_error ();")
            self._add_return_conversion(
                lines, func.return_type, ret_type_ocaml, "result", 4, class_def
            )
        elif len(handle_args) == 1:
            handle_name = self.safe_name(handle_args[0].name)
            lines.append(f"    Error_handling.read {handle_name} (fun () ->")
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            self._add_return_conversion(
                lines, func.return_type, ret_type_ocaml, "result", 6, class_def
            )
            lines.append("    )")
        else:
            handle_names = [self.safe_name(arg.name) for arg in handle_args]
            lines.append(
                f"    Error_handling.multi_read [{'; '.join(handle_names)}] (fun () ->"
            )
            lines.append(f"      let result = {c_call} in")
            lines.append("      Error_handling.raise_if_error ();")
            self._add_return_conversion(
                lines, func.return_type, ret_type_ocaml, "result", 6, class_def
            )
            lines.append("    )")

        return lines

    def _add_return_conversion(
        self,
        lines: list[str],
        c_return_type: str,
        ocaml_type: str,
        var_name: str,
        indent: int,
        class_def: ClassDef | None = None,
    ) -> None:
        """Helper to add return value conversion.
        Uses fully qualified class constructor for cross-module handle types."""
        spaces = " " * indent

        if self.is_handle(c_return_type):
            if class_def:
                constructor = self.resolve_class_constructor(c_return_type, class_def)
            else:
                type_name = c_return_type.replace("Handle", "").strip().lower()
                constructor = f"c_{type_name}"
            lines.append(f"{spaces}new {constructor} {var_name}")
        elif self.is_string(c_return_type):
            lines.append(f"{spaces}Capi_bindings.string_to_ocaml {var_name}")
        else:
            lines.append(f"{spaces}{var_name}")

    def run(self):
        """Main generation entry point"""
        for header in sorted(self.include_dir.rglob("*_c_api.h")):
            self.parse_header(header)

        print(f"Parsed {len(self.classes)} classes.")

        self.generate_error_handling_file()
        self.generate_bindings()
        self.generate_wrappers()

    def generate_wrappers(self):
        """Generate high-level wrappers - ONE FILE PER MODULE"""
        for cls in self.classes:
            if cls.name in self.SKIP_TYPES:
                print(f"Skipping {cls.name} (handled specially)")
                continue
            self.generate_single_module_file(cls)

    def generate_single_module_file(self, cls: ClassDef):
        """Generate a single file for one module"""
        ml_lines = []
        ml_lines.append("open Ctypes")
        ml_lines.append("open Capi_bindings")
        ml_lines.append("open Error_handling")
        ml_lines.append("")
        ml_lines.append(IMPORT_WATERMARK)
        ml_lines.append("")

        class_lines = self.generate_class_wrapper(cls)
        ml_lines.extend(class_lines)

        # Create directory structure (still use subdirs for file organization)
        namespace_parts = cls.namespace_path if cls.namespace_path else []
        dir_path = self.output_dir / "src"
        for part in namespace_parts:
            dir_path = dir_path / part.lower()
        dir_path.mkdir(parents=True, exist_ok=True)

        ml_path = dir_path / f"{cls.name.lower()}.ml"
        ml_path.write_text("\n".join(ml_lines))

        mli_lines = self.generate_module_interface(cls)
        mli_path = dir_path / f"{cls.name.lower()}.mli"
        mli_path.write_text("\n".join(mli_lines))

        # Replace watermark in BOTH files
        self.inject_imports(ml_path, cls)
        self.inject_imports(mli_path, cls)

        print(f"Generated {ml_path} and {mli_path}")

    def generate_module_interface(self, cls: ClassDef) -> list[str]:
        """Generate OCaml module interface (.mli file)"""
        lines = []
        lines.append("open Ctypes")
        lines.append("")
        lines.append(IMPORT_WATERMARK)
        lines.append("")

        class_name = f"c_{cls.name.lower()}"

        # Class type
        lines.append(f"(** Opaque handle for {cls.name} *)")
        lines.append(f"class type {class_name}_t = object")
        lines.append("  method raw : unit ptr")

        # Instance methods in class type
        for method in cls.methods:
            is_instance = (
                len(method.args) > 0
                and method.args[0].type_name + "Handle" == cls.handle_type
            )
            if is_instance:
                method_name = method.name.replace(f"{cls.name}_", "")
                ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))
                ret_type = self.c_to_ocaml_type(method.return_type, cls)

                params = []
                for arg in method.args[1:]:
                    param_type = self.c_to_ocaml_type(arg.type_name, cls)
                    params.append(param_type)

                if params:
                    param_str = " -> ".join(params) + " -> "
                else:
                    param_str = ""

                lines.append(f"  method {ocaml_name} : {param_str}{ret_type}")

        lines.append("end")
        lines.append("")
        lines.append(f"class {class_name} : unit ptr -> {class_name}_t")
        lines.append("")

        # Module signature
        lines.append(f"module {cls.name} : sig")
        lines.append(f"  type t = {class_name}")
        lines.append("")

        # Constructors
        for ctor in cls.constructors:
            method_name = ctor.name.replace(f"{cls.name}_", "")
            if "create" in method_name:
                method_name = method_name.replace("create_", "").replace(
                    "create", "make"
                )
            if "from_json_string" in method_name:
                method_name = "fromJson"
            ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))

            params = []
            for arg in ctor.args:
                param_type = self.c_to_ocaml_type(arg.type_name, cls)
                params.append(param_type)

            if params:
                param_str = " -> ".join(params) + " -> "
            else:
                param_str = ""

            lines.append(f"  val {ocaml_name} : {param_str}t")

        # Static methods
        for method in cls.methods:
            is_instance = (
                len(method.args) > 0
                and method.args[0].type_name + "Handle" == cls.handle_type
            )
            if not is_instance:
                method_name = method.name.replace(f"{cls.name}_", "")
                ocaml_name = self.safe_name(self.snake_to_camel_lower(method_name))
                ret_type = self.c_to_ocaml_type(method.return_type, cls)

                params = []
                for arg in method.args:
                    param_type = self.c_to_ocaml_type(arg.type_name, cls)
                    params.append(param_type)

                if params:
                    param_str = " -> ".join(params) + " -> "
                else:
                    param_str = ""

                lines.append(f"  val {ocaml_name} : {param_str}{ret_type}")

        lines.append("end")

        return lines

    def inject_imports(self, file_path: Path, cls: ClassDef):
        """Inject imports at the watermark"""
        content = file_path.read_text()
        lines = content.split("\n")

        # SIMPLE FIX: Don't add ANY open statements!
        # With (include_subdirs qualified), all modules are already visible

        # Replace watermark with nothing
        out = []
        for line in lines:
            if IMPORT_WATERMARK in line:
                out.append("(* No opens needed - using qualified names *)")
            else:
                out.append(line)

        file_path.write_text("\n".join(out))


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("Usage: python generate_ocaml.py <include_dir> <output_dir>")
        sys.exit(1)

    include_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])
    gen = OCamlGenerator(include_path, output_path)
    gen.run()
