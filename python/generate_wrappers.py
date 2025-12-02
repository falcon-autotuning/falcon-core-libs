import os
import re
import sys
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

# Template pattern configuration
# Maps template base name to (type_param_count, known_suffixes)
TEMPLATE_PATTERNS = {
    "List": (1, ["Int", "Double", "Float", "String", "Bool", "SizeT", "Connection", "Connections", 
                 "Channel", "Gname", "Group", "Impedance", "InstrumentPort", "PortTransform",
                 "Quantity", "Waveform", "AcquisitionContext", "MeasurementContext",
                 "InterpretationContext", "ControlArray", "ControlArray1D", "CoupledLabelledDomain",
                 "Discretizer", "DotGateWithNeighbors", "DeviceVoltageState", "LabelledControlArray",
                 "LabelledControlArray1D", "LabelledDomain", "LabelledMeasuredArray",
                 "LabelledMeasuredArray1D", "MapStringBool", "PairChannelConnections",
                 "PairConnectionConnections", "PairConnectionDouble", "PairConnectionFloat",
                 "PairConnectionPairQuantityQuantity", "PairConnectionQuantity", "PairFloatFloat",
                 "PairGnameGroup", "PairInstrumentPortPortTransform", "PairInterpretationContextDouble",
                 "PairInterpretationContextQuantity", "PairInterpretationContextString",
                 "PairIntFloat", "PairIntInt", "PairQuantityQuantity", "PairSizeTSizeT",
                 "PairStringBool", "PairStringDouble", "PairStringString", "ListSizeT", "FArrayDouble"]),
    "Map": (2, [("Int", "Int"), ("String", "String"), ("String", "Double"), ("String", "Bool"),
                ("Connection", "Float"), ("Connection", "Double"), ("Connection", "Quantity"),
                ("Channel", "Connections"), ("Gname", "Group"), ("InstrumentPort", "PortTransform"),
                ("InterpretationContext", "Double"), ("InterpretationContext", "Quantity"),
                ("InterpretationContext", "String"), ("Float", "Float")]),
    "Pair": (2, [("Int", "Int"), ("Int", "Float"), ("Float", "Float"), ("Double", "Double"),
                 ("String", "String"), ("String", "Double"), ("String", "Bool"),
                 ("SizeT", "SizeT"), ("Connection", "Connection"), ("Connection", "Connections"),
                 ("Connection", "Double"), ("Connection", "Float"), ("Connection", "Quantity"),
                 ("Connection", "PairQuantityQuantity"), ("Channel", "Connections"),
                 ("Gname", "Group"), ("InstrumentPort", "PortTransform"),
                 ("InterpretationContext", "Double"), ("InterpretationContext", "Quantity"),
                 ("InterpretationContext", "String"), ("Quantity", "Quantity"),
                 ("MeasurementResponse", "MeasurementRequest")]),
    "FArray": (1, ["Double", "Int"]),
    "InterpretationContainer": (1, ["Double", "Quantity", "String"]),
    "Axes": (1, ["Double", "Int", "ControlArray", "ControlArray1D", "CoupledLabelledDomain",
                 "Discretizer", "InstrumentPort", "LabelledControlArray", "LabelledControlArray1D",
                 "LabelledMeasuredArray", "LabelledMeasuredArray1D", "MapStringBool", "MeasurementContext"]),
    "LabelledArrays": (1, ["LabelledControlArray1D", "LabelledControlArray",
                           "LabelledMeasuredArray1D", "LabelledMeasuredArray"]),
}

# Define where each template base should live
TEMPLATE_LOCATIONS = {
    "List": "falcon_core.generic.list",
    "Map": "falcon_core.generic.map",
    "Pair": "falcon_core.generic.pair",
    "FArray": "falcon_core.generic.f_array",
    "InterpretationContainer": "falcon_core.autotuner_interfaces.interpretations.interpretation_container",
    "Axes": "falcon_core.math.axes",
    "LabelledArrays": "falcon_core.math.arrays.labelled_arrays",
}

# Type suffix to Python type mapping
TYPE_SUFFIX_TO_PYTHON = {
    "Int": "int",
    "Double": "float",
    "Float": "float",
    "String": "str",
    "Bool": "bool",
    "SizeT": "int",
    # Complex types map to themselves
}

# Rename Python keywords to avoid syntax errors
PYTHON_KEYWORD_RENAMES = {
    "in": "contains",
    "range": "get_range",
    "is": "is_value",
    "import": "import_data",
    "from": "from_value",
    "class": "class_value",
    "def": "def_value",
    "return": "return_value",
    "for": "for_value",
    "while": "while_value",
    "if": "if_value",
    "else": "else_value",
    "elif": "elif_value",
    "try": "try_value",
    "except": "except_value",
    "finally": "finally_value",
    "with": "with_value",
    "as": "as_value",
    "pass": "pass_value",
    "break": "break_value",
    "continue": "continue_value",
    "raise": "raise_value",
    "yield": "yield_value",
    "lambda": "lambda_value",
    "global": "global_value",
    "nonlocal": "nonlocal_value",
    "del": "del_value",
    "and": "and_value",
    "or": "or_value",
    "not": "not_value",
}


def parse_header(content: str, include_path: str = "") -> List[ClassDef]:
    """
    Parses C header content and returns a list of ClassDef objects.
    Assumes a specific coding style:
    - typedef void* XHandle;
    - XHandle X_create(...);
    - void X_destroy(XHandle);
    - ReturnType X_method(XHandle, ...);
    """
    classes: Dict[str, ClassDef] = {}
    
    # 1. Find Handle definitions
    # typedef void* GnameHandle;
    # typedef struct string* StringHandle;
    handle_re = re.compile(r'typedef\s+(?:void|struct\s+\w+|[\w\s]+)\s*\*\s*(\w+Handle)\s*;')
    for match in handle_re.finditer(content):
        handle_type = match.group(1)
        # Assuming ClassName is HandleName minus "Handle"
        if handle_type.endswith("Handle"):
            class_name = handle_type[:-6]
            classes[class_name] = ClassDef(name=class_name, handle_type=handle_type, include_path=include_path)

    # 2. Parse all functions
    # This is a simplified parser. It assumes functions are declared on one line or split lines, 
    # but end with );
    # We'll try to capture the whole function signature.
    
    # Remove comments
    content = re.sub(r'//.*', '', content)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
    
    # Normalize whitespace
    content = ' '.join(content.split())
    
    # Find function declarations: ReturnType FuncName(Args);
    # We look for patterns that look like function declarations.
    # Exclude typedefs.
    
    # Regex to capture return type, function name, and args
    # ([\w\*\s]+?)\s+(\w+)\(([^)]*)\);
    # This is tricky because return type can be "const char *" or "unsigned int" etc.
    
    func_re = re.compile(r'([\w\s\*]+?)\s+(\w+)\s*\(([^)]*)\)\s*;')
    
    for match in func_re.finditer(content):
        ret_type_raw = match.group(1).strip()
        if ret_type_raw.startswith("const "):
            ret_type_raw = ret_type_raw[6:].strip()
            
        func_name = match.group(2).strip()
        args_raw = match.group(3).strip()
        
        if func_name == "typedef":
            continue
            
        # Parse args
        args = []
        if args_raw and args_raw != "void":
            arg_splits = args_raw.split(',')
            for arg_s in arg_splits:
                arg_s = arg_s.strip()
                # Parse "const char* name" or "int num" or "Type value = default"
                # Remove default values for now
                if '=' in arg_s:
                    arg_s = arg_s.split('=')[0].strip()
                
                # Split into type and name
                # Last word is name, rest is type
                parts = arg_s.split()
                if not parts: 
                    continue
                
                arg_name = parts[-1]
                # Handle pointer * attached to name
                if arg_name.startswith('*'):
                    arg_name = arg_name[1:]
                    parts[-1] = '*' # Put back the pointer indicator to type part effectively
                
                # Re-assemble type
                arg_type_parts = parts[:-1]
                # Check for * in the last type part if name didn't have it
                if arg_type_parts and arg_type_parts[-1].endswith('*'):
                     pass # already has ptr
                
                arg_type = ' '.join(arg_type_parts)
                
                # Refined pointer check
                is_ptr = '*' in arg_type or '*' in parts[-1] # Check original last part
                is_const = 'const' in arg_type
                
                # Clean up type
                arg_type = arg_type.replace('const', '').replace('*', '').strip()
                
                args.append(Argument(type_name=arg_type, name=arg_name, is_ptr=is_ptr, is_const=is_const))
        
        func = Function(name=func_name, return_type=ret_type_raw, args=args, raw_sig=match.group(0))
        
        # Associate with class
        # Heuristic: Function name starts with ClassName_
        matched_class = None
        for cls_name in classes:
            if func_name.startswith(cls_name + "_"):
                matched_class = classes[cls_name]
                break
        
        if matched_class:
            suffix = func_name[len(matched_class.name) + 1:]
            
            if suffix == "destroy":
                matched_class.destructor = func
            elif suffix.startswith("create") or suffix.startswith("from_json"):
                matched_class.constructors.append(func)
            else:
                matched_class.methods.append(func)
    
    return list(classes.values())

def classify_template_type(class_name: str) -> Optional[Tuple[str, Tuple[str, ...]]]:
    """
    Classify a class as a template instance and extract its base and type parameters.
    
    Returns: (base_name, (type_params...)) or None if not a template
    Example: "ListInt" -> ("List", ("Int",))
             "MapIntString" -> ("Map", ("Int", "String"))
    """
    for base, (param_count, suffixes) in TEMPLATE_PATTERNS.items():
        if class_name.startswith(base):
            remainder = class_name[len(base):]
            if not remainder:
                continue
                
            if param_count == 1:
                # Single parameter template
                if remainder in suffixes:
                    return (base, (remainder,))
            elif param_count == 2:
                # Two parameter template - try to match known pairs
                for suffix_pair in suffixes:
                    if isinstance(suffix_pair, tuple):
                        expected = suffix_pair[0] + suffix_pair[1]
                        if remainder == expected:
                            return (base, suffix_pair)
    
    return None

def get_python_type_from_suffix(suffix: str) -> str:
    """Convert a type suffix to its Python type representation."""
    return TYPE_SUFFIX_TO_PYTHON.get(suffix, suffix)

def is_template_type(class_name: str) -> bool:
    """Check if a class name represents a template instance."""
    return classify_template_type(class_name) is not None

def topological_sort_classes(classes):
    # Topological sort classes to ensure dependencies come first
    from collections import defaultdict
    
    # Build graph
    adj = defaultdict(set)
    name_to_cls = {c.name: c for c in classes}
    
    for cls in classes:
        deps = set()
        all_funcs = (cls.constructors or []) + ([cls.destructor] if cls.destructor else []) + cls.methods
        for func in all_funcs:
            # Check args
            for arg in func.args:
                if arg.type_name.endswith("Handle"):
                    dep_name = arg.type_name[:-6]
                    if dep_name in name_to_cls and dep_name != cls.name:
                        deps.add(dep_name)
            # Check return type
            if func.return_type.endswith("Handle"):
                dep_name = func.return_type[:-6]
                if dep_name in name_to_cls and dep_name != cls.name:
                    deps.add(dep_name)
        adj[cls.name] = deps

    # Sort
    visited = set()
    temp_visited = set()
    order = []
    
    def visit(name):
        if name in temp_visited:
            return # Cycle detected
        if name in visited:
            return
            
        temp_visited.add(name)
        for dep in adj[name]:
            visit(dep)
        temp_visited.remove(name)
        visited.add(name)
        order.append(name)
        
    for cls in classes:
        visit(cls.name)
            
    return [name_to_cls[name] for name in order]

def generate_pxd(classes: List[ClassDef]) -> str:
    lines = []
    lines.append('from libc.stddef cimport size_t')
    lines.append(f'from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t')
    lines.append(f'')
    
    # Define StringStruct and StringHandle to match C API header
    lines.append(f'cdef extern from "falcon_core/generic/String_c_api.h":')
    lines.append(f'    ctypedef struct string:')
    lines.append(f'        const char* raw')
    lines.append(f'        size_t length')
    lines.append(f'    ctypedef string* StringHandle')
    lines.append(f'')
    
    # Define all other handles at module level
    for cls in classes:
        if cls.name != "String":
             lines.append(f'ctypedef void* {cls.handle_type}')
             
    lines.append(f'')
    
    # Topologically sort classes to ensure dependencies are defined before use
    # (Though with module level typedefs, this is less critical for types, but still good for functions)
    sorted_classes = topological_sort_classes(classes)
    
    print(f"DEBUG: Topologically sorted classes: {[c.name for c in sorted_classes[:10]]}")
    
    for cls in sorted_classes:
        lines.append(f'# {cls.name}')
        
        # Determine include path
        # If cls.include_path is set, use it. Otherwise assume standard location.
        path = cls.include_path if cls.include_path else f"falcon_core/.../{cls.name}_c_api.h"
        lines.append(f'cdef extern from "{path}":')
        # StringStruct is now defined at module level, no need to redefine
        # else:
            # lines.append(f'    ctypedef void* {cls.handle_type}') # Moved to top level
        
        all_funcs = (cls.constructors or []) + ([cls.destructor] if cls.destructor else []) + cls.methods
        for func in all_funcs:
            def fmt_arg(a: Argument):
                t = a.type_name
                if t == "bool":
                    t = "bint"
                
                if t.endswith("Handle"):
                    t = t 
                elif t == "char" and a.is_ptr and a.is_const:
                    t = "const char*"
                elif t == "char" and a.is_ptr:
                    t = "char*"
                elif a.is_ptr:
                    t = f"{t}*"
                return f"{t} {a.name}"

            args_str = ", ".join([fmt_arg(a) for a in func.args])
            ret = func.return_type
            if ret == "bool":
                ret = "bint"
            lines.append(f'    {ret} {func.name}({args_str})')
        lines.append('')
        
    return "\n".join(lines)

def to_snake_case(name):
    import re
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    res = re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
    # print(f"DEBUG: to_snake_case({name}) -> {res}")
    return res

def generate_pyx(cls: ClassDef, all_classes: List[ClassDef]) -> str:
    lines = []
    lines.append(f'cimport _c_api')
    
    # Import all handles explicitly
    # We need to import all handles because they might be used as arguments or return types
    # And we want to use them without c_api. prefix to avoid issues
    # Import all handles explicitly - REMOVED
    # We rely on c_api.Prefix for all handles
    pass
    
    lines.append(f'from cpython.bytes cimport PyBytes_FromStringAndSize')
    lines.append(f'from libc.stddef cimport size_t')
    

    
    # Collect required imports
    required_imports = set()
    
    # Check constructors args
    for ctor in cls.constructors:
        for arg in ctor.args:
            if arg.type_name.endswith("Handle") and arg.type_name != "StringHandle":
                wrapper = arg.type_name[:-6]
                if wrapper != cls.name:
                    required_imports.add(wrapper)
                    
    # Check methods args and return types
    for method in cls.methods:
        # Args
        for arg in method.args:
            if arg.type_name.endswith("Handle") and arg.type_name != "StringHandle":
                wrapper = arg.type_name[:-6]
                if wrapper != cls.name:
                    required_imports.add(wrapper)
        
        # Return type
        ret = method.return_type
        if ret.endswith("Handle") and ret != "StringHandle":
            wrapper = ret[:-6]
            if wrapper != cls.name:
                required_imports.add(wrapper)

    # Add imports
    # Imports
    for imp in sorted(required_imports):
        snake_imp = to_snake_case(imp)
        lines.append(f'from . cimport {snake_imp}')
        
    lines.append('')
    
    lines.append(f'cdef class {cls.name}:')
    
    # __cinit__
    lines.append(f'    def __cinit__(self):')
    lines.append(f'        self.handle = <_c_api.{cls.handle_type}>0')
    lines.append(f'        self.owned = False')
    lines.append(f'')
    
    # __dealloc__
    lines.append(f'    def __dealloc__(self):')
    lines.append(f'        if self.handle != <_c_api.{cls.handle_type}>0 and self.owned:')
    if cls.destructor:
        lines.append(f'            _c_api.{cls.destructor.name}(self.handle)')
    else:
        lines.append(f'            pass')
    lines.append(f'        self.handle = <_c_api.{cls.handle_type}>0')
    lines.append('')
    
    lines.append(f'')

    # Operator mapping
    # Map C method name suffix to Python special method name
    # Key: C method name suffix (e.g. "equal")
    # Value: Python special method name (e.g. "__eq__")
    operator_mapping = {
        "equal": "__eq__",
        "not_equal": "__ne__",
        "less_than": "__lt__",
        "less_than_or_equal": "__le__",
        "greater_than": "__gt__",
        "greater_than_or_equal": "__ge__",
        "addition": "__add__",
        "subtraction": "__sub__",
        "multiplication": "__mul__",
        "division": "__truediv__",
        "negation": "__neg__",
    }

    # Factory function for creating from handle
    lines.append(f'cdef {cls.name} _{to_snake_case(cls.name)}_from_capi(_c_api.{cls.handle_type} h):')
    lines.append(f'    if h == <_c_api.{cls.handle_type}>0:')
    lines.append(f'        return None')
    lines.append(f'    cdef {cls.name} obj = {cls.name}.__new__({cls.name})')
    lines.append(f'    obj.handle = h')
    lines.append(f'    obj.owned = True')
    lines.append(f'    return obj')
    lines.append(f'')

    # Constructors
    for ctor in cls.constructors:
        method_name = ctor.name[len(cls.name)+1:]
        if method_name.startswith("create_"):
            method_name = method_name[7:]
        elif method_name == "create":
            method_name = "create" # Keep as create if it's just create
            
        py_args = []
        call_args = []
        pre_call_lines = []
        post_call_lines = []
        
        for arg in ctor.args:
            if arg.type_name == "StringHandle":
                py_args.append(f'str {arg.name}')
                # Convert str to StringHandle
                pre_call_lines.append(f'        cdef bytes b_{arg.name} = {arg.name}.encode("utf-8")')
                pre_call_lines.append(f'        cdef StringHandle s_{arg.name} = _c_api.String_create(b_{arg.name}, len(b_{arg.name}))')
                call_args.append(f's_{arg.name}')
                post_call_lines.append(f'_c_api.String_destroy(s_{arg.name})')
            elif arg.type_name.endswith("Handle"):
                # For handles, we expect the wrapper object
                wrapper_type = arg.type_name[:-6]
                py_args.append(f'{wrapper_type} {arg.name}')
                call_args.append(f'{arg.name}.handle')
            else:
                py_args.append(f'{arg.type_name} {arg.name}')
                call_args.append(arg.name)
            
        lines.append(f'    @classmethod')
        lines.append(f'    def {method_name}(cls, {", ".join(py_args)}):')
        for l in pre_call_lines:
            lines.append(l)
            
        lines.append(f'        cdef _c_api.{cls.handle_type} h')
        if post_call_lines:
            lines.append(f'        try:')
            lines.append(f'            h = _c_api.{ctor.name}({", ".join(call_args)})')
            lines.append(f'        finally:')
            for l in post_call_lines:
                lines.append(f'            {l}')
        else:
            lines.append(f'        h = _c_api.{ctor.name}({", ".join(call_args)})')
            
        lines.append(f'        if h == <_c_api.{cls.handle_type}>0:')
        lines.append(f'            raise MemoryError("Failed to create {cls.name}")')
        lines.append(f'        cdef {cls.name} obj = <{cls.name}>cls.__new__(cls)')
        lines.append(f'        obj.handle = h')
        lines.append(f'        obj.owned = True')
        lines.append(f'        return obj')
        lines.append('')

    # Methods
    for method in cls.methods:
        # Strip the class name prefix to get the actual method name
        method_name = method.name[len(cls.name)+1:] if method.name.startswith(cls.name + '_') else method.name
        
        # Rename Python keywords
        method_name = PYTHON_KEYWORD_RENAMES.get(method_name, method_name)
        
        if method_name == "to_json_string":
            continue
        
        # Determine if static or instance
        is_static = True
        start_idx = 0
        
        if len(method.args) > 0 and method.args[0].type_name == cls.handle_type:
            is_static = False
            start_idx = 1
            
        py_args = []
        call_args = []
        pre_call_lines = []
        post_call_lines = []
        arg_names = []
        
        if not is_static:
            call_args.append("self.handle")
            
        for i in range(start_idx, len(method.args)):
            arg = method.args[i]
            arg_names.append(arg.name)
            if arg.type_name == "StringHandle":
                py_args.append(f'str {arg.name}')
                # Convert str to StringHandle
                pre_call_lines.append(f'        cdef bytes b_{arg.name} = {arg.name}.encode("utf-8")')
                pre_call_lines.append(f'        cdef StringHandle s_{arg.name} = _c_api.String_create(b_{arg.name}, len(b_{arg.name}))')
                call_args.append(f's_{arg.name}')
                post_call_lines.append(f'_c_api.String_destroy(s_{arg.name})')
            elif arg.type_name.endswith("Handle"):
                # For handles, we expect the wrapper object
                wrapper_type = arg.type_name[:-6]
                py_args.append(f'{wrapper_type} {arg.name}')
                call_args.append(f'{arg.name}.handle')
            else:
                py_args.append(f'{arg.type_name} {arg.name}')
                call_args.append(arg.name)
        
        if is_static:
            lines.append(f'    @staticmethod')
            lines.append(f'    def {method_name}({", ".join(py_args)}):')
        else:
            lines.append(f'    def {method_name}(self, {", ".join(py_args)}):')
        
        for l in pre_call_lines:
            lines.append(l)
            
        call_expr = f'_c_api.{method.name}({", ".join(call_args)})'
        ret = method.return_type
        
        if ret == "void":
            lines.append(f'        {call_expr}')
            for l in post_call_lines:
                lines.append(f'        {l}')
        elif ret == "StringHandle":
            # Convert StringHandle to str
            lines.append(f'        cdef StringHandle s_ret')
            if post_call_lines:
                 lines.append(f'        try:')
                 lines.append(f'            s_ret = {call_expr}')
                 lines.append(f'        finally:')
                 for l in post_call_lines:
                     lines.append(f'            {l}')
            else:
                 lines.append(f'        s_ret = {call_expr}')
                 
            lines.append(f'        if s_ret == <StringHandle>0:')
            lines.append(f'            return ""')
            lines.append(f'        try:')
            lines.append(f'            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")')
            lines.append(f'        finally:')
            lines.append(f'            _c_api.String_destroy(s_ret)')
        elif ret.endswith("Handle"):
             # Wrap returned handle
             wrapper_class = ret[:-6] # Remove Handle
             lines.append(f'        cdef _c_api.{ret} h_ret = {call_expr}')
             for l in post_call_lines:
                 lines.append(f'        {l}')
             
             lines.append(f'        if h_ret == <_c_api.{ret}>0:')
             lines.append(f'            return None')
             
             # Use factory function
             if wrapper_class == cls.name:
                 snake_name = to_snake_case(cls.name)
                 lines.append(f'        return _{snake_name}_from_capi(h_ret)')
             else:
                 snake_wrapper = to_snake_case(wrapper_class)
                 lines.append(f'        return {snake_wrapper}._{snake_wrapper}_from_capi(h_ret)')

        else:
            if post_call_lines:
                 lines.append(f'        cdef {ret} ret_val')
                 lines.append(f'        try:')
                 lines.append(f'            ret_val = {call_expr}')
                 lines.append(f'        finally:')
                 for l in post_call_lines:
                     lines.append(f'            {l}')
                 lines.append(f'        return ret_val')
            else:
                 lines.append(f'        return {call_expr}')
            
        lines.append('')
        
        # Generate operator overload if applicable
        if method_name in operator_mapping:
            op_name = operator_mapping[method_name]
            lines.append(f'    def {op_name}(self{", " if py_args else ""}{", ".join(py_args)}):')
            
            # Special handling for __eq__ and __ne__ to return NotImplemented if types mismatch
            if op_name in ["__eq__", "__ne__"]:
                 if py_args:
                     lines.append(f'        if not hasattr({arg_names[0]}, "handle"):')
                     lines.append(f'            return NotImplemented')
                 
            lines.append(f'        return self.{method_name}({", ".join(arg_names)})')
            lines.append('')

    return "\n".join(lines)

def generate_wrapper_pxd(cls: ClassDef) -> str:
    lines = []
    lines.append(f'cimport _c_api')
    lines.append(f'')
    lines.append(f'cdef class {cls.name}:')
    lines.append(f'    cdef _c_api.{cls.handle_type} handle')
    lines.append(f'    cdef bint owned')
    lines.append(f'')
    lines.append(f'cdef {cls.name} _{to_snake_case(cls.name)}_from_capi(_c_api.{cls.handle_type} h)')
    
    return "\n".join(lines)

def generate_python_class(cls: ClassDef, current_module_path: List[str], type_map: Dict[str, List[str]]) -> str:
    """
    Generates the Python wrapper class.
    
    Args:
        cls: The class definition.
        current_module_path: Path components of the current module (e.g. ['falcon_core', 'physics', 'device_structures', 'connection'])
                             Note: We assume src/falcon_core is the root, so path starts with 'falcon_core'.
        type_map: Mapping from class name to its module path components.
    """
    lines = []
    lines.append("from __future__ import annotations")
    lines.append("from typing import Any, List, Dict, Tuple, Optional")
    
    # Imports
    # We need to import the Cython wrapper
    # Cython wrappers are in falcon_core._capi.module_name
    # We assume current_module_path starts with 'falcon_core'
    
    # Calculate relative import to _capi
    # current: falcon_core.physics.device_structures.connection
    # _capi: falcon_core._capi.connection
    
    # We can use absolute imports for simplicity if we assume the package is installed or in path
    # from falcon_core._capi.module_name import Class as _CClass
    
    capi_module = to_snake_case(cls.name)
    lines.append(f'from falcon_core._capi.{capi_module} import {cls.name} as _C{cls.name}')
    
    # Collect other imports
    required_types = set()
    
    # Check constructors
    for ctor in cls.constructors:
        for arg in ctor.args:
             t = arg.type_name
             if t.endswith("Handle"): t = t[:-6]
             if t not in ["String", "Int", "Double", "Float", "Bool", "SizeT", "void", cls.name]:
                 required_types.add(t)
                 
    for method in cls.methods:
        for arg in method.args:
            t = arg.type_name
            if t.endswith("Handle"):
                t = t[:-6]
            if t not in ["String", "Int", "Double", "Float", "Bool", "SizeT", "void", cls.name]:
                required_types.add(t)
        ret = method.return_type
        if ret.endswith("Handle"):
            ret = ret[:-6]
        if ret not in ["String", "Int", "Double", "Float", "Bool", "SizeT", "void", cls.name]:
            required_types.add(ret)
            
    # Add imports for required types
    for t in sorted(required_types):
        # Check if it's a template type
        classification = classify_template_type(t)
        if classification:
            base, _ = classification
            if base in TEMPLATE_LOCATIONS:
                mod_path = TEMPLATE_LOCATIONS[base]
                # Import the generic wrapper class
                # from module import Base
                lines.append(f'from {mod_path} import {base}')
            else:
                # Fallback or warning?
                pass
        elif t in type_map:
            # Import the wrapper class
            # from module import Class
            mod_path = ".".join(type_map[t])
            lines.append(f'from {mod_path} import {t}')
            
    lines.append('')
    lines.append(f'class {cls.name}:')
    lines.append(f'    """Python wrapper for {cls.name}."""')
    lines.append('')
    lines.append(f'    def __init__(self, c_obj):')
    lines.append(f'        self._c = c_obj')
    lines.append('')
    
    # Factory for internal use
    lines.append(f'    @classmethod')
    lines.append(f'    def _from_capi(cls, c_obj):')
    lines.append(f'        if c_obj is None:')
    lines.append(f'            return None')
    lines.append(f'        return cls(c_obj)')
    lines.append('')
    
    # Constructors
    for ctor in cls.constructors:
        # ctor.name is e.g. "create_barrier_gate" or "create" or "from_json_string"
        # We want to map it to a classmethod
        
        # If name is "create", map to "new" (or __init__ wrapper? No, __init__ takes c_obj)
        # If name is "create_X", map to "new_X"
        # If name is "from_json_string", map to "from_json"
        
        method_name = ctor.name
        if method_name == "create":
            py_name = "new"
        elif method_name.startswith("create_"):
            py_name = "new_" + method_name[7:]
        elif method_name == "from_json_string":
            py_name = "from_json"
        else:
            py_name = method_name
            
        # Args
        py_args = []
        call_args = []
        
        for arg in ctor.args:
            arg_name = arg.name
            arg_type = arg.type_name
            
            # Type hint
            py_type = "Any"
            if arg_type == "StringHandle": py_type = "str"
            elif arg_type in ["Int", "SizeT"]: py_type = "int"
            elif arg_type in ["Double", "Float"]: py_type = "float"
            elif arg_type == "Bool": py_type = "bool"
            elif arg_type.endswith("Handle"):
                base = arg_type[:-6]
                classification = classify_template_type(base)
                if classification:
                    py_type = classification[0] # Use generic base name
                else:
                    py_type = base
            
            py_args.append(f"{arg_name}: {py_type}")
            
            # Call arg conversion
            if arg_type.endswith("Handle") and arg_type != "StringHandle":
                 call_args.append(f"{arg_name}._c")
            else:
                call_args.append(arg_name)
                
        lines.append(f'    @classmethod')
        lines.append(f'    def {py_name}(cls, {", ".join(py_args)}) -> {cls.name}:')
        lines.append(f'        return cls(_C{cls.name}.{py_name}({", ".join(call_args)}))')
        lines.append('')

    # Methods
    for method in cls.methods:
        # Strip the class name prefix to get the actual method name
        method_name = method.name[len(cls.name)+1:] if method.name.startswith(cls.name + '_') else method.name

        if method_name == "to_json_string":
            continue
        
        # Skip destructor (handled by Cython)
        if method_name == "destroy":
            continue
            
        # Determine if static
        is_static = True
        start_idx = 0
        if method.args:
            first_arg = method.args[0]
            if first_arg.type_name == cls.handle_type or first_arg.type_name == cls.name:
                is_static = False
                start_idx = 1
        
        # Args
        py_args = []
        call_args = []
        
        if not is_static:
            pass
            
        for arg in method.args[start_idx:]:
            arg_name = arg.name
            arg_type = arg.type_name
            
            # Type hint
            py_type = "Any"
            if arg_type == "StringHandle": py_type = "str"
            elif arg_type in ["Int", "SizeT"]: py_type = "int"
            elif arg_type in ["Double", "Float"]: py_type = "float"
            elif arg_type == "Bool": py_type = "bool"
            elif arg_type.endswith("Handle"):
                base = arg_type[:-6]
                classification = classify_template_type(base)
                if classification:
                    py_type = classification[0] # Use generic base name
                else:
                    py_type = base
            
            py_args.append(f"{arg_name}: {py_type}")
            
            # Call arg conversion
            if arg_type.endswith("Handle") and arg_type != "StringHandle":
                # If it's a wrapper, pass ._c
                # Check if it's generic
                base = arg_type[:-6]
                if classify_template_type(base): # Check if it's a generic type
                     call_args.append(f"{arg_name}._c")
                else:
                     call_args.append(f"{arg_name}._c")
            else:
                call_args.append(arg_name)
                
        # Return type
        ret = method.return_type
        py_ret = "None"
        if ret == "StringHandle": py_ret = "str"
        elif ret in ["Int", "SizeT"]: py_ret = "int"
        elif ret in ["Double", "Float"]: py_ret = "float"
        elif ret == "Bool": py_ret = "bool"
        elif ret.endswith("Handle"):
            base = ret[:-6]
            classification = classify_template_type(base)
            if classification:
                py_ret = classification[0]
            else:
                py_ret = base
            
        # Generate method
        if is_static:
            lines.append(f'    @classmethod')
            lines.append(f'    def {method_name}(cls, {", ".join(py_args)}) -> {py_ret}:')
            lines.append(f'        ret = _C{cls.name}.{method_name}({", ".join(call_args)})')
        else:
            lines.append(f'    def {method_name}(self, {", ".join(py_args)}) -> {py_ret}:')
            lines.append(f'        ret = self._c.{method_name}({", ".join(call_args)})')
            
        # Return handling
        if ret == "StringHandle":
            lines.append(f'        return ret')
        elif ret.endswith("Handle") and ret != "StringHandle":
            base = ret[:-6]
            classification = classify_template_type(base)
            
            if classification:
                generic_base = classification[0]
                lines.append(f'        if ret is None: return None')
                lines.append(f'        return {generic_base}(ret)')
            elif base == cls.name:
                lines.append(f'        return cls._from_capi(ret)')
            else:
                lines.append(f'        if ret is None: return None')
                lines.append(f'        return {base}._from_capi(ret)')
        else:
            lines.append(f'        return ret')
            
        lines.append('')
    
    # After all methods, generate operator overloads
    # Collect methods by operator pattern
    operator_methods = {
        'plus': [],
        'minus': [],
        'times': [],
        'divides': [],
        'negation': [],
        'equality': [],
        'notequality': [],
    }
    
    for method in cls.methods:
        # Strip the class name prefix to get the actual method name
        method_name = method.name[len(cls.name)+1:] if method.name.startswith(cls.name + '_') else method.name
        
        # Check for operator patterns
        # Pattern 1: plus_X, minus_X, times_X, divides_X (arrays)
        if method_name.startswith('plus_'):
            operator_methods['plus'].append((method, method_name))
        elif method_name.startswith('minus_') and method_name != 'minus':
            operator_methods['minus'].append((method, method_name))
        elif method_name.startswith('times_'):
            operator_methods['times'].append((method, method_name))
        elif method_name.startswith('divides_'):
            operator_methods['divides'].append((method, method_name))
        
        # Pattern 2: add_X, subtract_X, multiply_X, divide_X (Quantity)
        elif method_name.startswith('add_'):
            operator_methods['plus'].append((method, method_name))
        elif method_name.startswith('subtract_'):
            operator_methods['minus'].append((method, method_name))
        elif method_name.startswith('multiply_'):
            operator_methods['times'].append((method, method_name))
        elif method_name.startswith('divide_'):
            operator_methods['divides'].append((method, method_name))
        
        # Pattern 3: addition, subtraction, multiplication, division (Point, Vector)
        elif method_name == 'addition':
            operator_methods['plus'].append((method, method_name))
        elif method_name == 'subtraction':
            operator_methods['minus'].append((method, method_name))
        elif method_name in ['multiplication', 'double_multiplication', 'int_multiplication']:
            operator_methods['times'].append((method, method_name))
        elif method_name in ['division', 'double_division', 'int_division']:
            operator_methods['divides'].append((method, method_name))
        
        # Negation patterns
        elif method_name in ['negation', 'negate']:
            operator_methods['negation'].append((method, method_name))
        
        # Equality patterns
        elif method_name in ['equality', 'equal']:
            operator_methods['equality'].append((method, method_name))
        elif method_name in ['notequality', 'not_equal']:
            operator_methods['notequality'].append((method, method_name))
    
    # Generate __add__ if we have plus/add/addition methods
    if operator_methods['plus']:
        lines.append(f'    def __add__(self, other):')
        lines.append(f'        """Operator overload for +"""')
        for method, method_name in operator_methods['plus']:
            # Determine type checking based on method name pattern
            if method_name == 'addition':
                # Point/Vector: addition(other: Point/Vector)
                lines.append(f'        if isinstance(other, {cls.name}):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('add_'):
                # Quantity: add_quantity
                suffix = method_name[4:]  # Remove 'add_'
                if suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('plus_'):
                # Arrays: plus_measured_array, plus_farray, plus_double, plus_int
                suffix = method_name[5:]  # Remove 'plus_'
                
                if suffix in ['double', 'float']:
                    lines.append(f'        if isinstance(other, float):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'int':
                    lines.append(f'        if isinstance(other, int):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'farray':
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix.endswith('_array') or suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
        
        lines.append(f'        return NotImplemented')
        lines.append('')
    
    # Generate __sub__ if we have minus/subtract/subtraction methods
    if operator_methods['minus']:
        lines.append(f'    def __sub__(self, other):')
        lines.append(f'        """Operator overload for -"""')
        for method, method_name in operator_methods['minus']:
            if method_name == 'subtraction':
                lines.append(f'        if isinstance(other, {cls.name}):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('subtract_'):
                suffix = method_name[9:]  # Remove 'subtract_'
                if suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('minus_'):
                suffix = method_name[6:]  # Remove 'minus_'
                
                if suffix in ['double', 'float']:
                    lines.append(f'        if isinstance(other, float):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'int':
                    lines.append(f'        if isinstance(other, int):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'farray':
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix.endswith('_array') or suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
        
        lines.append(f'        return NotImplemented')
        lines.append('')
    
    # Generate __mul__ if we have times/multiply/multiplication methods
    if operator_methods['times']:
        lines.append(f'    def __mul__(self, other):')
        lines.append(f'        """Operator overload for *"""')
        for method, method_name in operator_methods['times']:
            if method_name == 'multiplication':
                # Point: multiplication(scalar)
                lines.append(f'        if isinstance(other, (int, float)):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name == 'double_multiplication':
                lines.append(f'        if isinstance(other, float):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name == 'int_multiplication':
                lines.append(f'        if isinstance(other, int):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('multiply_'):
                suffix = method_name[9:]  # Remove 'multiply_'
                if suffix in ['int', 'double', 'float']:
                    type_check = 'int' if suffix == 'int' else 'float'
                    lines.append(f'        if isinstance(other, {type_check}):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('times_'):
                suffix = method_name[6:]  # Remove 'times_'
                
                if suffix in ['double', 'float']:
                    lines.append(f'        if isinstance(other, float):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'int':
                    lines.append(f'        if isinstance(other, int):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'farray':
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix.endswith('_array') or suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
        
        lines.append(f'        return NotImplemented')
        lines.append('')
    
    # Generate __truediv__ if we have divides/divide/division methods
    if operator_methods['divides']:
        lines.append(f'    def __truediv__(self, other):')
        lines.append(f'        """Operator overload for /"""')
        for method, method_name in operator_methods['divides']:
            if method_name == 'division':
                # Point: division(scalar)
                lines.append(f'        if isinstance(other, (int, float)):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name == 'double_division':
                lines.append(f'        if isinstance(other, float):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name == 'int_division':
                lines.append(f'        if isinstance(other, int):')
                lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('divide_'):
                suffix = method_name[7:]  # Remove 'divide_'
                if suffix in ['int', 'double', 'float']:
                    type_check = 'int' if suffix == 'int' else 'float'
                    lines.append(f'        if isinstance(other, {type_check}):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
            elif method_name.startswith('divides_'):
                suffix = method_name[8:]  # Remove 'divides_'
                
                if suffix in ['double', 'float']:
                    lines.append(f'        if isinstance(other, float):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'int':
                    lines.append(f'        if isinstance(other, int):')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix == 'farray':
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:')
                    lines.append(f'            return self.{method_name}(other)')
                elif suffix.endswith('_array') or suffix == cls.name.lower():
                    lines.append(f'        if isinstance(other, {cls.name}):')
                    lines.append(f'            return self.{method_name}(other)')
                else:
                    type_name = ''.join(word.capitalize() for word in suffix.split('_'))
                    lines.append(f'        if hasattr(other, "_c") and type(other).__name__ == "{type_name}":')
                    lines.append(f'            return self.{method_name}(other)')
        
        lines.append(f'        return NotImplemented')
        lines.append('')
    
    # Generate __neg__ if we have negation method
    if operator_methods['negation']:
        lines.append(f'    def __neg__(self):')
        lines.append(f'        """Operator overload for unary -"""')
        lines.append(f'        return self.negation()')
        lines.append('')
    
    # Generate __eq__ if we have equality method
    if operator_methods['equality']:
        lines.append(f'    def __eq__(self, other):')
        lines.append(f'        """Operator overload for =="""')
        lines.append(f'        if not isinstance(other, {cls.name}):')
        lines.append(f'            return NotImplemented')
        lines.append(f'        return self.equality(other)')
        lines.append('')
    
    # Generate __ne__ if we have notequality method
    if operator_methods['notequality']:
        lines.append(f'    def __ne__(self, other):')
        lines.append(f'        """Operator overload for !="""')
        lines.append(f'        if not isinstance(other, {cls.name}):')
        lines.append(f'            return NotImplemented')
        lines.append(f'        return self.notequality(other)')
        lines.append('')

    return "\n".join(lines)

def generate_registry_entry(cls: ClassDef) -> Optional[Tuple[str, str, str]]:
    """
    Generate registry entry for a template class.
    
    Returns: (template_base, python_type_key, cython_class_ref) or None
    Example: ("List", "int", "_CListInt")
             ("Map", "(int, str)", "_CMapIntString")
    """
    classification = classify_template_type(cls.name)
    if not classification:
        return None
        
    base, type_params = classification
    
    # Convert type parameters to Python types
    py_types = tuple(get_python_type_from_suffix(t) for t in type_params)
    
    # Format the key based on parameter count
    if len(py_types) == 1:
        key_str = py_types[0]
    else:
        key_str = f"({', '.join(py_types)})"
    
    cython_ref = f"_C{cls.name}"
    
    return (base, key_str, cython_ref)


def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_wrappers.py <header_file> [header_file ...]")
        return

    all_classes = []
    for header_path in sys.argv[1:]:
        with open(header_path, 'r') as f:
            content = f.read()
            classes = parse_header(content)
            all_classes.extend(classes)
            
    # Output pxd
    print("### Generated PXD ###")
    print(generate_pxd(all_classes))
    print()
    
    # Output pyx
    for cls in all_classes:
        print(f"### Generated PYX for {cls.name} ###")
        print(generate_pyx(cls))
        print()

    # Output Registry Entries
    print("### Generated Registry Entries ###")
    print("# Paste these into the corresponding generic file (list.py, map.py, pair.py)")
    
    list_entries = []
    map_entries = []
    pair_entries = []
    
    for cls in all_classes:
        entry = generate_registry_entry(cls)
        if entry:
            if cls.name.startswith("List"):
                list_entries.append(entry)
            elif cls.name.startswith("Map"):
                map_entries.append(entry)
            elif cls.name.startswith("Pair"):
                pair_entries.append(entry)
    
    if list_entries:
        print("\n# _C_LIST_REGISTRY")
        print("\n".join(list_entries))
        
    if map_entries:
        print("\n# _C_MAP_REGISTRY")
        print("\n".join(map_entries))
        
    if pair_entries:
        print("\n# _C_PAIR_REGISTRY")
        print("\n".join(pair_entries))

if __name__ == "__main__":
    main()
