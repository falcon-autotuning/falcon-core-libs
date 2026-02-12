#!/usr/bin/env python3
import os
import re
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Optional, Dict, Tuple, Set

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
    args: List[Argument]
    raw_sig: str

@dataclass
class ClassDef:
    name: str
    handle_type: str
    include_path: str = ""
    methods: List[Function] = field(default_factory=list)
    constructors: List[Function] = field(default_factory=list)
    destructor: Optional[Function] = None

class OCamlGenerator:
    def __init__(self, include_dir: Path, output_dir: Path):
        self.include_dir = include_dir
        self.output_dir = output_dir
        self.classes: List[ClassDef] = []
        
        self.primitive_map = {
            "int": "int",
            "size_t": "size_t",
            "bool": "bool",
            "double": "double",
            "float": "float",
            "void": "void",
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

        self.ocaml_keywords = {
            "type", "end", "method", "object", "module", "class", "val", "let", "in", "match", 
            "with", "try", "raise", "exception", "external", "open", "include", "constraint", 
            "done", "if", "then", "else", "for", "while", "do", "to", "downto", "begin", 
            "rec", "mutable", "virtual", "private", "as", "fun", "function", "initializer", 
            "lazy", "assert", "asr", "land", "lor", "lsl", "lsr", "lxor", "mod", "or", "sig", "struct"
        }

        self.custom_helpers = {
            "String": [
                "  let of_string s = wrap s"
            ],
            "Connections": [
                "  let from_list l =",
                "    let c = new_empty () in",
                "    List.iter (fun v -> ignore (push_back c#raw v#raw)) l;",
                "    c"
            ],
            "Adjacency": [
                "  let of_arrays ~data ~shape indexes =",
                "    let ndim = Array.length shape in",
                "    let data_ptr = Ctypes.allocate_n Ctypes.int ~count:(Array.length data) in",
                "    Array.iteri (fun i v -> Ctypes.((data_ptr +@ i) <-@ v)) data;",
                "    let shape_ptr = Ctypes.allocate_n Ctypes.size_t ~count:ndim in",
                "    Array.iteri (fun i v -> Ctypes.((shape_ptr +@ i) <-@ Unsigned.Size_t.of_int v)) shape;",
                "    make data_ptr shape_ptr (Unsigned.Size_t.of_int ndim) indexes#raw"
            ],
            "Channel": [
                "  let of_string s = make (String.wrap s)"
            ],
            "Gname": [
                "  let of_string s = make (String.wrap s)"
            ],
            "Config": [
                "  let create ~screening_gates ~plunger_gates ~ohmics ~barrier_gates ~reservoir_gates ~groups ~wiring_dc ~constraints =",
                "    make screening_gates#raw plunger_gates#raw ohmics#raw barrier_gates#raw reservoir_gates#raw groups#raw wiring_dc#raw constraints#raw"
            ]
        }

    def safe_name(self, name: str) -> str:
        if name in self.ocaml_keywords:
            return name + "_"
        return name

    def parse_header(self, header_path: Path):
        content = header_path.read_text()
        include_rel = header_path.relative_to(self.include_dir.parent.parent)
        
        # 1. Find Handle definitions
        handle_re = re.compile(r'typedef\s+(?:void|struct\s+\w+|[\w\s]+)\s*\*\s*(\w+Handle)\s*;')
        current_classes = {}
        for match in handle_re.finditer(content):
            handle_type = match.group(1)
            if handle_type.endswith("Handle"):
                class_name = handle_type[:-6]
                cls = ClassDef(name=class_name, handle_type=handle_type, include_path=str(include_rel))
                current_classes[class_name] = cls

        # 2. Parse functions
        # Clean up content
        content = re.sub(r'//.*', '', content)
        content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        content = ' '.join(content.split())
        
        func_re = re.compile(r'([\w\s\*]+?)\s+(\w+)\s*\(([^)]*)\)\s*;')
        for match in func_re.finditer(content):
            ret_type_raw = match.group(1).strip()
            func_name = match.group(2).strip()
            args_raw = match.group(3).strip()
            
            if func_name == "typedef": continue

            args = []
            if args_raw and args_raw != "void":
                for arg_s in args_raw.split(','):
                    arg_s = arg_s.strip()
                    parts = arg_s.split()
                    if not parts: continue
                    
                    arg_name = parts[-1]
                    is_ptr = '*' in arg_s or '[' in arg_s
                    arg_type = ' '.join(parts[:-1]).replace('const', '').replace('*', '').strip()
                    args.append(Argument(type_name=arg_type, name=arg_name, is_ptr=is_ptr))

            func = Function(name=func_name, return_type=ret_type_raw, args=args, raw_sig=match.group(0))
            
            # Associate with class
            for cls_name, cls in current_classes.items():
                if func_name.startswith(cls_name + "_"):
                    suffix = func_name[len(cls_name) + 1:]
                    if suffix == "destroy":
                        cls.destructor = func
                    elif any(suffix.startswith(x) for x in ["create", "from_json", "allocate", "fill"]):
                        cls.constructors.append(func)
                    else:
                        cls.methods.append(func)
                    break
        
        self.classes.extend(current_classes.values())

    def run(self):
        for header in self.include_dir.rglob("*_c_api.h"):
            self.parse_header(header)
        
        print(f"Parsed {len(self.classes)} classes.")
        
        # Generation logic will go here
        self.generate_bindings()
        self.generate_wrappers()
        self.generate_coverage_tests()

    def map_type(self, type_name: str, is_ptr: bool) -> str:
        if type_name.endswith("Handle"):
            return "(ptr void)"
        
        base = self.primitive_map.get(type_name, "void")
        if is_ptr:
            if base == "char": return "string"
            return f"(ptr {base})"
        return base

    def clean_arg_name(self, name: str) -> str:
        # Remove array bracket suffixes like [16]
        name = name.split('[')[0]
        return self.safe_name(name)

    def generate_bindings(self):
        lines = [
            "open Ctypes",
            "open Foreign",
            "",
            "let lib = Dl.dlopen ~filename:\"libfalcon_core_c_api.so\" ~flags:[Dl.RTLD_NOW]",
            "",
            "(* Raw bindings *)"
        ]
        
        for cls in self.classes:
            lines.append(f"(* {cls.name} *)")
            all_funcs = (cls.constructors or []) + ([cls.destructor] if cls.destructor else []) + cls.methods
            for func in all_funcs:
                # Map return type
                ret = self.map_type(func.return_type.replace("const", "").replace("*", "").strip(), 
                                   "*" in func.return_type)
                
                # Map arguments
                args = []
                for arg in func.args:
                    args.append(self.map_type(arg.type_name, arg.is_ptr))
                
                if not args:
                    args = ["void"]
                
                args_str = " @-> ".join(args)
                # OCaml identifiers MUST be lowercase
                ml_func_name = self.safe_name(func.name.lower())
                lines.append(f"let {ml_func_name} = foreign ~from:lib \"{func.name}\" ({args_str} @-> returning {ret})")
            lines.append("")

        output_path = self.output_dir / "src" / "capi_bindings.ml"
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text("\n".join(lines))
        print(f"Generated {output_path}")

    def generate_wrappers(self):
        # Identify template groups
        templates = {} # base -> List[ClassDef]
        template_bases = ["List", "Map", "Pair", "Axes", "FArray"]
        
        standalone_classes = []
        for cls in self.classes:
            is_template = False
            for base in template_bases:
                if cls.name.startswith(base) and cls.name != base:
                    if base not in templates: templates[base] = []
                    templates[base].append(cls)
                    is_template = True
                    break
            if not is_template:
                standalone_classes.append(cls)

        lines = [
            "open Capi_bindings",
            "open Ctypes",
            "",
            "type 'a handle = {",
            "  raw : unit ptr;",
            "  mutable owned : bool;",
            "}",
            "",
        ]
        
        # Define phantom types for templates
        for base in template_bases:
            lines.append(f"type {base.lower()}_handle")
        lines.append("")

        templates_lines = []
        # Generate Template GADTs
        for base, instantiations in templates.items():
            templates_lines.append(f"module {base} = struct")
            templates_lines.append(f"  type 'a t = {base.lower()}_handle handle")
            templates_lines.append("")
            templates_lines.append("  type _ ty = ")
            for inst in instantiations:
                suffix = inst.name[len(base):]
                # Map suffix to OCaml type
                if suffix == "Int": ml_type = "int"
                elif suffix == "Float": ml_type = "float"
                elif suffix == "Double": ml_type = "float"
                elif suffix == "Bool": ml_type = "bool"
                elif suffix == "SizeT": ml_type = "Unsigned.size_t"
                elif suffix == "Int32": ml_type = "int32"
                elif suffix == "Int64": ml_type = "int64"
                else: 
                    ml_type = f"{inst.name}.t"
                templates_lines.append(f"    | {suffix} : {ml_type} ty")
            templates_lines.append("")
            
            if base == "List":
                templates_lines.append("  let push_back (type a) (ty : a ty) (l : a t) (v : a) = ")
                templates_lines.append("    match ty with")
                for inst in instantiations:
                    suffix = inst.name[len(base):]
                    ml_binding = self.safe_name(('List' + suffix + '_push_back').lower())
                    if suffix in ["Int", "Float", "Double", "Bool", "SizeT", "Int32", "Int64"]:
                        templates_lines.append(f"    | {suffix} -> {ml_binding} l.raw v")
                    else:
                        ml_type_cls = f"c_{inst.name.lower()}"
                        templates_lines.append(f"    | {suffix} -> {ml_binding} l.raw (v : {ml_type_cls})#raw")
                templates_lines.append("")

            templates_lines.append("end")
            templates_lines.append("")

        for cls in self.classes:
            # Distinguish instance vs static methods
            instance_methods = []
            static_methods = []
            for m in cls.methods:
                if m.args and m.args[0].type_name + "Handle" == cls.handle_type:
                    instance_methods.append(m)
                else:
                    static_methods.append(m)

            class_name_ml = f"c_{cls.name.lower()}"
            lines.append(f"class {class_name_ml} (h : unit ptr) = object(self)")
            lines.append(f"  val raw_val = h")
            lines.append(f"  method raw = raw_val")
            
            # Instance Methods
            for method in instance_methods:
                name = method.name.replace(f"{cls.name}_", "")
                name = self.safe_name(name.lower())
                other_args = " ".join([self.clean_arg_name(arg.name) for arg in method.args[1:]])
                call_args = "raw_val " + " ".join([self.clean_arg_name(arg.name) for arg in method.args[1:]])
                ml_binding = self.safe_name(method.name.lower())
                lines.append(f"  method {name} {other_args} = {ml_binding} {call_args}")

            if cls.destructor:
                ml_dest_binding = self.safe_name(cls.destructor.name.lower())
                lines.append(f"  initializer Gc.finalise (fun _ -> ignore ({ml_dest_binding} raw_val)) self")
            lines.append("end")
            lines.append("")
            
            lines.append(f"module {cls.name} = struct")
            lines.append(f"  type t = {class_name_ml}")
            
            # Constructors
            for ctor in cls.constructors:
                name = ctor.name.replace(f"{cls.name}_", "").replace("create_", "new_")
                if name == "create": name = "make"
                name = self.safe_name(name.lower())
                
                if not ctor.args:
                    lines.append(f"  let {name} () = new {class_name_ml} ({self.safe_name(ctor.name.lower())} ())")
                else:
                    args_params = " ".join([self.clean_arg_name(arg.name) for arg in ctor.args])
                    call_args = " ".join([self.clean_arg_name(arg.name) for arg in ctor.args])
                    ml_ctor_binding = self.safe_name(ctor.name.lower())
                    lines.append(f"  let {name} {args_params} = new {class_name_ml} ({ml_ctor_binding} {call_args})")

            # Static Methods
            for method in static_methods:
                name = method.name.replace(f"{cls.name}_", "")
                name = self.safe_name(name.lower())
                if not method.args:
                    lines.append(f"  let {name} () = {self.safe_name(method.name.lower())} ()")
                else:
                    args_params = " ".join([self.clean_arg_name(arg.name) for arg in method.args])
                    call_args = " ".join([self.clean_arg_name(arg.name) for arg in method.args])
                    lines.append(f"  let {name} {args_params} = {self.safe_name(method.name.lower())} {call_args}")

            if cls.name in self.custom_helpers:
                lines.extend(self.custom_helpers[cls.name])

            lines.append("end")
            lines.append("")

        # Add templates at the end
        lines.extend(templates_lines)

        output_path = self.output_dir / "src" / "falcon_core.ml"
        output_path.write_text("\n".join(lines))
        print(f"Generated {output_path}")

    def generate_coverage_tests(self):
        lines = [
            "open Falcon_core",
            "",
            "let () =",
            "  print_endline \"Running coverage tests... \";"
        ]
        
        tested_count = 0
        for cls in self.classes:
            lines.append(f"  (* Testing {cls.name} *)")
            if cls.constructors:
                ctor = cls.constructors[0]
                name = ctor.name.replace(f"{cls.name}_", "").replace("create_", "new_")
                if name == "create": name = "make"
                name = self.safe_name(name.lower())
                
                if not ctor.args:
                    lines.append(f"  ignore ({cls.name}.{name} ());")
                    tested_count += 1
                else:
                    lines.append(f"  (* TODO: call {cls.name}.{name} with dummy args *)")
        
        lines.append(f"  Printf.printf \"\\nCoverage Summary: %d / %d classes instantiated.\\n\" {tested_count} {len(self.classes)};")
        lines.append("  print_endline \"Done.\"")

        output_path = self.output_dir / "tests" / "generated" / "coverage_test.ml"
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text("\n".join(lines))
        print(f"Generated {output_path}")

if __name__ == "__main__":
    include_path = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core/c-api/include/falcon_core")
    output_path = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core-libs/ocaml")
    gen = OCamlGenerator(include_path, output_path)
    gen.run()
