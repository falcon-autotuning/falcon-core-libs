import os
import json
import sys
from collections import defaultdict
from generate_wrappers import (parse_header, generate_pxd, generate_pyx, generate_wrapper_pxd, generate_registry_entry, 
                                generate_python_class, is_template_type, classify_template_type,
                                TEMPLATE_PATTERNS)

def to_snake_case(name):
    import re
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

def main():
    # Real header location
    headers_root = os.path.expanduser("~/work/wisc/playground/falcon-core/c-api/include")
    falcon_core_root = os.path.join(headers_root, "falcon_core")
    
    if not os.path.exists(headers_root):
        print(f"Error: {headers_root} not found.")
        return
        
    all_classes = []
    class_metadata = {} # name -> {rel_path_components, snake_name}
    type_map = {} # name -> module path components
    
    # Output directory for pyx files
    capi_output_dir = "src/falcon_core/_capi"
    if not os.path.exists(capi_output_dir):
        os.makedirs(capi_output_dir)
        
    # Ensure __init__.py exists in _capi
    init_path = os.path.join(capi_output_dir, "__init__.py")
    if not os.path.exists(init_path):
        with open(init_path, 'w') as f:
            pass
        
    # Output directory for python files
    python_root = "src/falcon_core"
        
    print(f"Scanning headers in {headers_root}...")
    
    # Walk the directory
    for root, dirs, files in os.walk(headers_root):
        for filename in files:
            if filename.endswith("_c_api.h"):
                filepath = os.path.join(root, filename)
                
                # Calculate include path relative to headers_root
                # e.g. falcon_core/generic/String_c_api.h
                rel_path = os.path.relpath(filepath, headers_root)
                
                # Calculate relative path components from falcon_core root for Python structure
                # e.g. falcon_core/physics/device_structures/Connection_c_api.h
                # rel_path_components = ['physics', 'device_structures']
                
                rel_dir = os.path.dirname(rel_path) # falcon_core/physics/device_structures
                rel_parts = rel_dir.split(os.sep)
                
                # We expect the first part to be 'falcon_core'
                if rel_parts[0] == "falcon_core":
                    module_parts = rel_parts[1:]
                else:
                    module_parts = rel_parts
                
                with open(filepath, 'r') as f:
                    content = f.read()
                
                classes = parse_header(content, rel_path)
                
                for cls in classes:
                    all_classes.append(cls)
                    snake_name = to_snake_case(cls.name)
                    class_metadata[cls.name] = {
                        "module_parts": module_parts,
                        "snake_name": snake_name
                    }
                    # Type map: falcon_core.part1.part2.snake_name
                    full_module_path = ["falcon_core"] + module_parts + [snake_name]
                    type_map[cls.name] = full_module_path

    # Generate PXD
    print("Generating PXD...")
    pxd_content = generate_pxd(all_classes)
    pxd_path = os.path.join(capi_output_dir, "_c_api.pxd")
    with open(pxd_path, 'w') as f:
        f.write(pxd_content)
    
    # Collect template instances by base
    template_instances = defaultdict(list)  # base -> [ClassDef]
    non_template_classes = []
    
    for cls in all_classes:
        if is_template_type(cls.name):
            classification = classify_template_type(cls.name)
            if classification:
                base, _ = classification
                template_instances[base].append(cls)
        else:
            non_template_classes.append(cls)
    
    # Generate PYX for all classes (both template and non-template)
    print("Generating Cython wrappers...")
    for cls in all_classes:
        # Generate PYX
        snake_name = to_snake_case(cls.name)
        pyx_path = os.path.join(capi_output_dir, f"{snake_name}.pyx")
        pyx_content = generate_pyx(cls, all_classes)
        with open(pyx_path, "w") as f:
            f.write(pyx_content)
            
        # Generate PXD
        wrapper_pxd_content = generate_wrapper_pxd(cls)
        wrapper_pxd_path = os.path.join(capi_output_dir, f"{snake_name}.pxd")
        with open(wrapper_pxd_path, 'w') as f:
            f.write(wrapper_pxd_content)
    
    # Generate Python Wrappers for non-template classes only
    print("Generating Python wrappers for non-template classes...")
    for cls in non_template_classes:
        # Skip String (it's a base type)
        if cls.name == "String":
            continue
            
        meta = class_metadata[cls.name]
        module_parts = meta["module_parts"]
        
        # Construct output path
        # src/falcon_core/part1/part2/snake_name.py
        output_dir = os.path.join(python_root, *module_parts)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
            
        # Ensure __init__.py
        init_path = os.path.join(output_dir, "__init__.py")
        if not os.path.exists(init_path):
            with open(init_path, 'w') as f:
                pass
                
        py_filename = f"{meta['snake_name']}.py"
        py_path = os.path.join(output_dir, py_filename)
        
        # Current module path for relative imports calculation
        current_mod_path = ["falcon_core"] + module_parts + [meta['snake_name']]
        
        py_content = generate_python_class(cls, current_mod_path, type_map)
        
        with open(py_path, 'w') as f:
            f.write(py_content)
        print(f"Generated {py_path}")

    # Generate template registries and generic wrappers
    print("Generating template registries and generic wrappers...")
    generate_template_wrappers(template_instances, class_metadata, python_root)
    
    print("\\nGeneration complete!")

def generate_template_wrappers(template_instances, class_metadata, python_root):
    """Generate generic wrapper classes and registries for template types."""
    
    # Define where each template base should live
    template_locations = {
        "List": "generic",
        "Map": "generic",
        "Pair": "generic",
        "FArray": "generic",
        "InterpretationContainer": "autotuner_interfaces/interpretations",
        "Axes": "math",
        "LabelledArrays": "math/arrays",
    }
    
    for base, instances in template_instances.items():
        if base not in template_locations:
            print(f"Warning: No location defined for template base '{base}', skipping")
            continue
            
        location = template_locations[base]
        output_dir = os.path.join(python_root, *location.split('/'))
        
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
            
        # Ensure __init__.py
        init_path = os.path.join(output_dir, "__init__.py")
        if not os.path.exists(init_path):
            with open(init_path, 'w') as f:
                pass
        
        # Generate registry
        registry_content = generate_template_registry(base, instances)
        registry_path = os.path.join(output_dir, f"_{to_snake_case(base)}_registry.py")
        with open(registry_path, 'w') as f:
            f.write(registry_content)
        print(f"Generated {registry_path}")
        
        # Generate generic wrapper (only if it doesn't exist or needs update)
        wrapper_path = os.path.join(output_dir, f"{to_snake_case(base)}.py")
        wrapper_content = generate_generic_wrapper(base, instances)
        with open(wrapper_path, 'w') as f:
            f.write(wrapper_content)
        print(f"Generated {wrapper_path}")

def generate_template_registry(base, instances):
    """Generate a registry file for a template base."""
    from generate_wrappers import get_python_type_from_suffix, classify_template_type
    
    lines = []
    lines.append("# Auto-generated template registry")
    lines.append("# Do not edit manually")
    lines.append("")
    
    # Collect all type parameters to determine what needs to be imported
    complex_types_needed = set()
    registry_entries = []
    
    for cls in instances:
        entry = generate_registry_entry(cls)
        if entry:
            _, key_str, cython_ref = entry
            registry_entries.append((key_str, cython_ref))
            
            # Extract complex types from key_str
            classification = classify_template_type(cls.name)
            if classification:
                _, type_params = classification
                for param in type_params:
                    py_type = get_python_type_from_suffix(param)
                    # If it's not a primitive type, it's a complex type
                    if py_type not in ['int', 'float', 'str', 'bool']:
                        complex_types_needed.add(py_type)
    
    # Import complex types (we'll need a type_map for this)
    # For now, let's use a simple heuristic
    type_to_module = {
        'Connection': 'falcon_core.physics.device_structures.connection',
        'Connections': 'falcon_core.physics.device_structures.connections',
        'Quantity': 'falcon_core.math.quantity',
        'Channel': 'falcon_core.autotuner_interfaces.names.channel',
        'Gname': 'falcon_core.autotuner_interfaces.names.gname',
        'Group': 'falcon_core.physics.config.core.group',
        'Impedance': 'falcon_core.physics.device_structures.impedance',
        'InstrumentPort': 'falcon_core.instrument_interfaces.names.instrument_port',
        'PortTransform': 'falcon_core.instrument_interfaces.port_transforms.port_transform',
        'Waveform': 'falcon_core.instrument_interfaces.waveform',
        'AcquisitionContext': 'falcon_core.autotuner_interfaces.contexts.acquisition_context',
        'MeasurementContext': 'falcon_core.autotuner_interfaces.contexts.measurement_context',
        'InterpretationContext': 'falcon_core.autotuner_interfaces.interpretations.interpretation_context',
        'ControlArray': 'falcon_core.math.arrays.control_array',
        'ControlArray1D': 'falcon_core.math.arrays.control_array1_d',
        'CoupledLabelledDomain': 'falcon_core.math.domains.coupled_labelled_domain',
        'Discretizer': 'falcon_core.math.discrete_spaces.discretizer',
        'DotGateWithNeighbors': 'falcon_core.physics.config.geometries.dot_gate_with_neighbors',
        'DeviceVoltageState': 'falcon_core.communications.voltage_states.device_voltage_state',
        'LabelledControlArray': 'falcon_core.math.arrays.labelled_control_array',
        'LabelledControlArray1D': 'falcon_core.math.arrays.labelled_control_array1_d',
        'LabelledDomain': 'falcon_core.math.domains.labelled_domain',
        'LabelledMeasuredArray': 'falcon_core.math.arrays.labelled_measured_array',
        'LabelledMeasuredArray1D': 'falcon_core.math.arrays.labelled_measured_array1_d',
        'MeasurementResponse': 'falcon_core.communications.messages.measurement_response',
        'MeasurementRequest': 'falcon_core.communications.messages.measurement_request',
    }
    
    for complex_type in sorted(complex_types_needed):
        if complex_type in type_to_module:
            module = type_to_module[complex_type]
            lines.append(f"from {module} import {complex_type}")
    
    if complex_types_needed:
        lines.append("")
    
    # Import all Cython wrappers
    for cls in instances:
        snake = to_snake_case(cls.name)
        lines.append(f"from falcon_core._capi.{snake} import {cls.name} as _C{cls.name}")
    
    lines.append("")
    lines.append(f"{base.upper()}_REGISTRY = {{")
    
    # Add entries, avoiding duplicates
    seen_keys = set()
    for key_str, cython_ref in registry_entries:
        if key_str not in seen_keys:
            lines.append(f"    {key_str}: {cython_ref},")
            seen_keys.add(key_str)
    
    lines.append("}")
    
    return "\n".join(lines)

def generate_generic_wrapper(base, instances):
    """Generate a generic Python wrapper class for a template base with all methods."""
    from generate_wrappers import classify_template_type, get_python_type_from_suffix
    
    lines = []
    lines.append("from __future__ import annotations")
    lines.append("from typing import Any, TypeVar, Generic, Union")
    lines.append("import collections.abc")
    lines.append(f"from ._{to_snake_case(base)}_registry import {base.upper()}_REGISTRY")
    lines.append("")
    
    # Get parameter count
    param_count, _ = TEMPLATE_PATTERNS[base]
    
    # Define type variables
    if param_count == 1:
        lines.append("T = TypeVar('T')")
    elif param_count == 2:
        lines.append("K = TypeVar('K')")
        lines.append("V = TypeVar('V')")
    lines.append("")
    
    # Analyze methods from all instances to find common interface
    # For now, we'll use the first instance as the template
    if not instances:
        return "\n".join(lines)
    
    representative = instances[0]
    
    # Factory class
    lines.append(f"class _{base}Factory:")
    lines.append(f'    """Factory for {base}[T] instances."""')
    lines.append("")
    lines.append(f"    def __init__(self, element_type, c_{to_snake_case(base)}_class):")
    lines.append(f"        self.element_type = element_type")
    lines.append(f"        self._c_class = c_{to_snake_case(base)}_class")
    lines.append("")
    lines.append(f"    def __call__(self, *args, **kwargs):")
    lines.append(f'        """Construct a new {base} instance."""')
    lines.append(f"        # This is for direct construction, not typically used")
    lines.append(f"        # Users should use class methods like {base}[T].new_empty(...)")
    lines.append(f"        raise TypeError(f'Use {base}[{{self.element_type}}].new_*() class methods to construct instances')")
    lines.append("")
    lines.append(f"    def __getattr__(self, name):")
    lines.append(f'        """Delegate class method calls to the underlying Cython class."""')
    lines.append(f"        attr = getattr(self._c_class, name, None)")
    lines.append(f"        if attr is None:")
    lines.append(f'            raise AttributeError(f"{base}[{{self.element_type}}] has no attribute {{name!r}}")')
    lines.append(f"        ")
    lines.append(f"        # If it's a class method or static method, wrap the result")
    lines.append(f"        if callable(attr):")
    lines.append(f"            def wrapper(*args, **kwargs):")
    lines.append(f"                result = attr(*args, **kwargs)")
    lines.append(f"                # Wrap the result if it's a Cython instance")
    lines.append(f"                if result is not None and hasattr(result, 'handle'):")
    lines.append(f"                    return {base}(result, self.element_type)")
    lines.append(f"                return result")
    lines.append(f"            return wrapper")
    lines.append(f"        return attr")
    lines.append("")
    
    # Main wrapper class
    lines.append(f"class {base}:")
    lines.append(f'    """Generic {base} wrapper with full method support."""')
    lines.append("")
    lines.append(f"    def __init__(self, c_obj, element_type=None):")
    lines.append(f'        """Initialize from a Cython object."""')
    lines.append(f"        self._c = c_obj")
    lines.append(f"        self._element_type = element_type")
    lines.append("")
    lines.append(f"    @classmethod")
    lines.append(f"    def __class_getitem__(cls, types):")
    
    if param_count == 1:
        lines.append(f'        """Enable {base}[T] syntax."""')
        lines.append(f"        c_class = {base.upper()}_REGISTRY.get(types)")
        lines.append(f"        if c_class is None:")
        lines.append(f'            raise TypeError(f"{base} does not support type: {{types}}")')
        lines.append(f"        return _{base}Factory(types, c_class)")
    else:
        lines.append(f'        """Enable {base}[K, V] syntax."""')
        lines.append(f"        if not isinstance(types, tuple) or len(types) != {param_count}:")
        lines.append(f'            raise TypeError(f"{base} requires {param_count} type parameters")')
        lines.append(f"        c_class = {base.upper()}_REGISTRY.get(types)")
        lines.append(f"        if c_class is None:")
        lines.append(f'            raise TypeError(f"{base} does not support types: {{types}}")')
        lines.append(f"        return _{base}Factory(types, c_class)")
    
    lines.append("")
    
    # Generate methods by delegating to _c
    # We'll generate common methods that should work across all template instances
    
    # Generic method delegation
    lines.append(f"    def __getattr__(self, name):")
    lines.append(f'        """Delegate attribute access to the underlying Cython object."""')
    lines.append(f"        if name.startswith('_'):")
    lines.append(f"            raise AttributeError(f'{{name}}')")
    lines.append(f"        ")
    lines.append(f"        attr = getattr(self._c, name, None)")
    lines.append(f"        if attr is None:")
    lines.append(f'            raise AttributeError(f"{base} has no attribute {{name!r}}")')
    lines.append(f"        ")
    lines.append(f"        # If it's a method, wrap it to handle return values")
    lines.append(f"        if callable(attr):")
    lines.append(f"            def wrapper(*args, **kwargs):")
    lines.append(f"                # Unwrap {base} arguments to their Cython objects")
    lines.append(f"                unwrapped_args = []")
    lines.append(f"                for arg in args:")
    lines.append(f"                    if isinstance(arg, {base}):")
    lines.append(f"                        unwrapped_args.append(arg._c)")
    lines.append(f"                    else:")
    lines.append(f"                        unwrapped_args.append(arg)")
    lines.append(f"                ")
    lines.append(f"                result = attr(*unwrapped_args, **kwargs)")
    lines.append(f"                ")
    lines.append(f"                # Wrap the result if it's a Cython instance of the same type")
    lines.append(f"                if result is not None and hasattr(result, 'handle'):")
    lines.append(f"                    # Check if it's the same type as self._c")
    lines.append(f"                    if type(result).__name__ == type(self._c).__name__:")
    lines.append(f"                        return {base}(result, self._element_type)")
    lines.append(f"                return result")
    lines.append(f"            return wrapper")
    lines.append(f"        return attr")
    lines.append("")
    
    # Add common operator overloads
    operator_methods = {
        '__add__': ('plus_farray', 'plus_double', 'plus_int'),
        '__sub__': ('minus_farray', 'minus_double', 'minus_int'),
        '__mul__': ('times_farray', 'times_double', 'times_int'),
        '__truediv__': ('divides_farray', 'divides_double', 'divides_int'),
        '__neg__': ('negation',),
        '__eq__': ('equality',),
        '__ne__': ('notequality',),
    }
    
    for op, method_names in operator_methods.items():
        if op == '__neg__':
            # Unary operator
            lines.append(f"    def {op}(self):")
            lines.append(f"        if hasattr(self._c, '{method_names[0]}'):")
            lines.append(f"            result = self._c.{method_names[0]}()")
            lines.append(f"            if result is not None and hasattr(result, 'handle'):")
            lines.append(f"                return {base}(result, self._element_type)")
            lines.append(f"            return result")
            lines.append(f"        raise AttributeError(f'{op} not supported')")
        else:
            # Binary operator
            lines.append(f"    def {op}(self, other):")
            lines.append(f"        # Try different method overloads based on argument type")
            for method_name in method_names:
                if 'farray' in method_name or base.lower() in method_name:
                    lines.append(f"        if isinstance(other, {base}) and hasattr(self._c, '{method_name}'):")
                    lines.append(f"            result = self._c.{method_name}(other._c)")
                    lines.append(f"            if result is not None and hasattr(result, 'handle'):")
                    lines.append(f"                return {base}(result, self._element_type)")
                    lines.append(f"            return result")
                elif 'double' in method_name or 'float' in method_name:
                    lines.append(f"        if isinstance(other, float) and hasattr(self._c, '{method_name}'):")
                    lines.append(f"            result = self._c.{method_name}(other)")
                    lines.append(f"            if result is not None and hasattr(result, 'handle'):")
                    lines.append(f"                return {base}(result, self._element_type)")
                    lines.append(f"            return result")
                elif 'int' in method_name:
                    lines.append(f"        if isinstance(other, int) and hasattr(self._c, '{method_name}'):")
                    lines.append(f"            result = self._c.{method_name}(other)")
                    lines.append(f"            if result is not None and hasattr(result, 'handle'):")
                    lines.append(f"                return {base}(result, self._element_type)")
                    lines.append(f"            return result")
            
            if op in ['__eq__', '__ne__']:
                lines.append(f"        return NotImplemented")
            else:
                lines.append(f"        raise TypeError(f'unsupported operand type(s) for {op}: {{type(self).__name__}} and {{type(other).__name__}}')")
        
        lines.append("")
    
    # Add __repr__
    lines.append(f"    def __repr__(self):")
    lines.append(f'        return f"{base}[{{self._element_type}}]({{self._c}})"')
    lines.append("")
    
    return "\n".join(lines)

if __name__ == "__main__":
    main()
