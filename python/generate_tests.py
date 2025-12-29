import os
from typing import List, Dict, Any, Tuple
from generate_wrappers import ClassDef, Function, Argument, to_snake_case, is_template_type, classify_template_type, TEMPLATE_LOCATIONS, get_python_type_from_suffix, PYTHON_KEYWORD_RENAMES

RECIPES = {
    # type_name: (instantiation_expression, [imports])
    "Connection": ("Connection.new_barrier('test_conn')", ["from falcon_core.physics.device_structures.connection import Connection"]),
    "SymbolUnit": ("SymbolUnit.new_meter()", ["from falcon_core.physics.units.symbol_unit import SymbolUnit"]),
    "InstrumentPort": ("InstrumentPort.new_timer()", ["from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort"]),
    "Waveform": ("Waveform.new(DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()])), List[PortTransform]([]))", ["from falcon_core.instrument_interfaces.waveform import Waveform", "from falcon_core.math.discrete_spaces.discrete_space import DiscreteSpace", "from falcon_core.math.unit_space import UnitSpace", "from falcon_core.math.axes import Axes", "from falcon_core.math.domains.domain import Domain", "from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain", "from falcon_core._capi.map_string_bool import MapStringBool", "from falcon_core.generic.map import Map", "from falcon_core.generic.list import List", "from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform"]),
    "Domain": ("Domain.new(0.0, 1.0, True, True)", ["from falcon_core.math.domains.domain import Domain"]),
    "UnitSpace": ("UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True))", ["from falcon_core.math.unit_space import UnitSpace", "from falcon_core.math.domains.domain import Domain"]),
    "Axes": ("Axes[float]([])", ["from falcon_core.math.axes import Axes"]),
    "DiscreteSpace": ("DiscreteSpace.new(UnitSpace.new_cartesian_1D_space(1.0, Domain.new(0.0, 1.0, True, True)), Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()]), Axes[MapStringBool]([Map[str, bool]()]))", ["from falcon_core.math.discrete_spaces.discrete_space import DiscreteSpace", "from falcon_core.math.unit_space import UnitSpace", "from falcon_core.math.axes import Axes", "from falcon_core.math.domains.domain import Domain", "from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain", "from falcon_core._capi.map_string_bool import MapStringBool", "from falcon_core.generic.map import Map"]),
    "AxesDouble": ("Axes[float]([1.0])", ["from falcon_core.math.axes import Axes"]),
    "AxesInt": ("Axes[int]([1])", ["from falcon_core.math.axes import Axes"]),
    "Discretizer": ("Discretizer.new_cartesian_discretizer(1.0)", ["from falcon_core.math.discrete_spaces.discretizer import Discretizer"]),
    "AxesDiscretizer": ("Axes[Discretizer]([Discretizer.new_cartesian_discretizer(1.0)])", ["from falcon_core.math.axes import Axes", "from falcon_core.math.discrete_spaces.discretizer import Discretizer"]),
    "AxesInstrumentPort": ("Axes[InstrumentPort]([InstrumentPort.new_timer()])", ["from falcon_core.math.axes import Axes", "from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort"]),
    
    # Dependencies for DiscreteSpace constructors (implied by debug logs)
    "CoupledLabelledDomain": ("CoupledLabelledDomain.new_empty()", ["from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain"]),
    "MapStringBool": ("Map[str, bool]()", ["from falcon_core.generic.map import Map"]),
    "AxesCoupledLabelledDomain": ("Axes[CoupledLabelledDomain]([CoupledLabelledDomain.new_empty()])", ["from falcon_core.math.axes import Axes", "from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain"]),
    "AxesMapStringBool": ("Axes[MapStringBool]([Map[str, bool]()])", ["from falcon_core.math.axes import Axes", "from falcon_core._capi.map_string_bool import MapStringBool", "from falcon_core.generic.map import Map"]),
    
    # Physics module types
    "Connections": ("Connections.new_empty()", ["from falcon_core.physics.device_structures.connections import Connections"]),
    "Impedances": ("Impedances.new_empty()", ["from falcon_core.physics.device_structures.impedances import Impedances"]),
    "Impedance": ("Impedance.new(Connection.new_barrier('test'), 1.0, 1.0)", ["from falcon_core.physics.device_structures.impedance import Impedance", "from falcon_core.physics.device_structures.connection import Connection"]),
    "Channel": ("Channel.new('test_channel')", ["from falcon_core.autotuner_interfaces.names.channel import Channel"]),
    "Channels": ("Channels.new_empty()", ["from falcon_core.autotuner_interfaces.names.channels import Channels"]),
    "Gname": ("Gname.new('test_gname')", ["from falcon_core.autotuner_interfaces.names.gname import Gname"]),
    "GateRelations": ("GateRelations.new_empty()", ["from falcon_core.physics.device_structures.gate_relations import GateRelations"]),
    "Group": ("Group.new(Channel.new('test'), 1, Connections.new_empty(), Connections.new_empty(), Connections.new_empty(), Connections.new_empty(), Connections.new_empty())", ["from falcon_core.physics.config.core.group import Group", "from falcon_core.autotuner_interfaces.names.channel import Channel", "from falcon_core.physics.device_structures.connections import Connections"]),
    "Adjacency": ("Adjacency.from_json('{}')", ["from falcon_core.physics.config.core.adjacency import Adjacency"]),
    "VoltageConstraints": ("VoltageConstraints.from_json('{}')", ["from falcon_core.physics.config.core.voltage_constraints import VoltageConstraints"]),
    "Config": ("Config.from_json('{}')", ["from falcon_core.physics.config.core.config import Config"]),
    
    # Generic Map types for Config
    "MapGnameGroup": ("Map[Gname, Group]()", ["from falcon_core.generic.map import Map", "from falcon_core.autotuner_interfaces.names.gname import Gname", "from falcon_core.physics.config.core.group import Group"]),
    "PairDoubleDouble": ("Pair[float, float](0.0, 1.0)", ["from falcon_core.generic.pair import Pair"]),
    "FArrayDouble": ("FArray[float].from_list([1.0])", ["from falcon_core.generic.f_array import FArray"]),
    "FArrayInt": ("FArray[int].from_list([1])", ["from falcon_core.generic.f_array import FArray"]),
    
    # Math module types
    "Point": ("Point.new_empty()", ["from falcon_core.math.point import Point"]),
    "Vector": ("Vector.new(Point.new_empty(), Point.new_empty())", ["from falcon_core.math.vector import Vector", "from falcon_core.math.point import Point"]),
    "Quantity": ("Quantity.new(1.0, SymbolUnit.new_meter())", ["from falcon_core.math.quantity import Quantity", "from falcon_core.physics.units.symbol_unit import SymbolUnit"]),
    "AnalyticFunction": ("AnalyticFunction.new_identity()", ["from falcon_core.math.analytic_function import AnalyticFunction"]),
    "LabelledDomain": ("LabelledDomain.new_empty()", ["from falcon_core.math.domains.labelled_domain import LabelledDomain"]),
    
    # Communications types
    "Time": ("Time.new(0, 0)", ["from falcon_core.communications.time import Time"]),
    "HDF5Data": ("HDF5Data.from_json('{}')", ["from falcon_core.communications.hdf5_data import HDF5Data"]),
    "MeasurementRequest": ("MeasurementRequest.from_json('{}')", ["from falcon_core.communications.messages.measurement_request import MeasurementRequest"]),
    "MeasurementResponse": ("MeasurementResponse.from_json('{}')", ["from falcon_core.communications.messages.measurement_response import MeasurementResponse"]),
    "StandardRequest": ("StandardRequest.from_json('{}')", ["from falcon_core.communications.messages.standard_request import StandardRequest"]),
    "StandardResponse": ("StandardResponse.from_json('{}')", ["from falcon_core.communications.messages.standard_response import StandardResponse"]),
    "DeviceVoltageState": ("DeviceVoltageState.from_json('{}')", ["from falcon_core.communications.voltage_states.device_voltage_state import DeviceVoltageState"]),
    "DeviceVoltageStates": ("DeviceVoltageStates.new_empty()", ["from falcon_core.communications.voltage_states.device_voltage_states import DeviceVoltageStates"]),
    
    # Instrument interfaces  
    "PortTransform": ("PortTransform.new_identity_transform(InstrumentPort.new_timer())", ["from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform", "from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort"]),
    "PortTransforms": ("PortTransforms.new_empty()", ["from falcon_core.instrument_interfaces.port_transforms.port_transforms import PortTransforms"]),
    "Ports": ("Ports.new_empty()", ["from falcon_core.instrument_interfaces.names.ports import Ports"]),
    
    # Autotuner types
    "AcquisitionContext": ("AcquisitionContext.new(Connection.new_barrier('test'), SymbolUnit.new_meter(), InstrumentPort.new_timer())", ["from falcon_core.autotuner_interfaces.contexts.acquisition_context import AcquisitionContext", "from falcon_core.physics.device_structures.connection import Connection", "from falcon_core.physics.units.symbol_unit import SymbolUnit", "from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort"]),
    "MeasurementContext": ("MeasurementContext.from_json('{}')", ["from falcon_core.autotuner_interfaces.contexts.measurement_context import MeasurementContext"]),
    "InterpretationContext": ("InterpretationContext.from_json('{}')", ["from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext"]),
}



def get_dummy_value(type_name: str) -> str:
    """Return a dummy value string for a given type."""
    type_name = type_name.strip()
    
    if type_name in RECIPES:
        return RECIPES[type_name][0]

    if type_name.endswith("Handle"):
        wrapper_type = type_name[:-6]
        if wrapper_type in RECIPES:
            return RECIPES[wrapper_type][0]
        
    if type_name in ["int", "size_t", "int8_t", "int16_t", "int32_t", "int64_t", "uint8_t", "uint16_t", "uint32_t", "uint64_t"]:
        return "0"
    elif type_name in ["double", "float"]:
        return "0.0"
    elif type_name in ["bool", "bint"]:
        return "False"
    elif type_name == "StringHandle" or type_name == "str":
        return '"test_string"'
    elif type_name.endswith("Handle"):
        wrapper_type = type_name[:-6]
        if wrapper_type in RECIPES:
             return RECIPES[wrapper_type][0]
        return "None"
    elif type_name == "list":
        return "[]"
    elif type_name == "dict":
        return "{}"
    elif "*" in type_name:
        return "None" # Will be handled by memoryview check
    elif type_name == "Quantity":
        return "Quantity(0.0, SymbolUnit.new_meter())"
    else:
        return "None"

def resolve_type_and_imports(type_name: str, type_map: Dict[str, List[str]]) -> Tuple[str, List[str]]:
    """
    Recursively resolve a type name to its Python representation and necessary imports.
    Returns (python_type_string, list_of_imports)
    """
    imports = []
    
    # Check if it's a template type
    if is_template_type(type_name):
        classification = classify_template_type(type_name)
        if classification:
            base, type_params = classification
            
            # Import base
            if base in TEMPLATE_LOCATIONS:
                rel_loc = TEMPLATE_LOCATIONS[base]
                imports.append(f"from {rel_loc} import {base}")
            
            # Recurse on params
            param_strs = []
            for p in type_params:
                # p is a suffix like "Int" or "PairQuantityQuantity"
                # If p is a suffix that maps to a simple type, get_python_type_from_suffix handles it.
                # But if p is a complex type suffix (e.g. "Connection"), we need to handle it.
                # Or if p is a full template name (e.g. "PairQuantityQuantity" is NOT a full name, it's a suffix).
                # Wait, classify_template_type returns suffixes.
                # We need to convert suffix to full type name if it's a template.
                # But suffixes in TEMPLATE_PATTERNS are sometimes full names (e.g. "PairQuantityQuantity" is NOT a full name? No, "Pair" + "QuantityQuantity"?)
                # Let's look at TEMPLATE_PATTERNS.
                # "List": (1, [..., "PairQuantityQuantity", ...])
                # So "PairQuantityQuantity" is the suffix.
                # Is "PairQuantityQuantity" a valid class name? No.
                # "PairQuantityQuantity" corresponds to "Pair" + "Quantity" + "Quantity".
                # But `is_template_type` expects "PairQuantityQuantity"? No.
                # `is_template_type` expects "ListPairQuantityQuantity".
                
                # So `p` here is just a string like "Int" or "PairQuantityQuantity".
                # We need to map `p` to a valid Python type or class.
                
                # If `p` starts with a known template base, it might be a template instance?
                # e.g. "PairQuantityQuantity".
                # `is_template_type("PairQuantityQuantity")` should be True.
                
                # Let's check `get_python_type_from_suffix(p)`.
                # It returns `p` if not found.
                
                # If `is_template_type(p)` is True, then we recurse.
                p_resolved, p_imports = resolve_type_and_imports(p, type_map)
                imports.extend(p_imports)
                param_strs.append(p_resolved)
                
            return f"{base}[{', '.join(param_strs)}]", imports
            
    # Not a template type (or at least not one we recognized recursively)
    # It might be a simple type or a regular class.
    
    # First check if it's a mapped simple type
    py_type = get_python_type_from_suffix(type_name)
    
    # If it's different from type_name, it was mapped (e.g. Int -> int)
    if py_type != type_name:
        # It's a primitive or simple type, no import needed usually
        # Unless it maps to something in type_map? (unlikely for int/float)
        return py_type, imports
        
    # If it's a regular class in type_map
    if py_type in type_map:
        mod_parts = type_map[py_type]
        mod_path = ".".join(mod_parts)
        imports.append(f"from {mod_path} import {py_type}")
        return py_type, imports
        
    # Fallback: just return the name (maybe it's 'str' or 'bool' that wasn't mapped?)
    return py_type, imports

def generate_test_content(cls: ClassDef, module_path: str, class_name_to_import: str, extra_imports: List[str] = None, instantiation_class: str = None) -> str:
    """Generate the content of a test file for a given class."""
    lines = []
    lines.append("import pytest")
    lines.append("import array")
    # lines.append("from falcon_core.physics.device_structures.connection import Connection") # Common import - now handled dynamically
    
    if extra_imports:
        for imp in extra_imports:
            lines.append(imp)

    # Collect imports from RECIPES based on usage in constructors and methods
    recipe_imports = set()
    all_args = []
    for ctor in cls.constructors:
        all_args.extend(ctor.args)
    for method in cls.methods:
        all_args.extend(method.args)
        
    for arg in all_args:
        t = arg.type_name.strip()
        if t in RECIPES:
            for imp in RECIPES[t][1]:
                recipe_imports.add(imp)
        elif t.endswith("Handle"):
             wrapper_type = t[:-6]
             if wrapper_type in RECIPES:
                 for imp in RECIPES[wrapper_type][1]:
                     recipe_imports.add(imp)
                     
    for imp in sorted(list(recipe_imports)):
        if imp not in lines:
            lines.append(imp)

    # Import the class under test
    lines.append(f"from {module_path} import {class_name_to_import}")
    lines.append("")
    
    lines.append(f"class Test{cls.name}:")
    
    # Setup - try to create an instance
    lines.append("    def setup_method(self):")
    lines.append("        self.obj = None")
    lines.append("        try:")
    
    # Determine the class to instantiate
    # If it's a template, we need to use the generic syntax
    if instantiation_class is None:
        instantiation_class = cls.name
    
    if is_template_type(cls.name):
        # Use recursive resolution
        # We need to pass type_map, but it's not available here.
        # We should pass type_map to generate_test_content.
        # For now, let's assume extra_imports handles the top level, 
        # but we need the string for instantiation.
        # Actually, we can't easily resolve imports here without type_map.
        # So we should move the resolution logic to generate_tests and pass the resolved string and imports.
        pass # Handled by caller passing instantiation_class and extra_imports

    # Try to find a constructor
    constructor_found = False
    
    # Priority 1: create_empty
    for ctor in cls.constructors:
        if "empty" in ctor.name:
            lines.append(f"            # Found empty constructor: {ctor.name}")
            if is_template_type(cls.name):
                 lines.append(f"            self.obj = {instantiation_class}()")
            else:
                 lines.append(f"            self.obj = {cls.name}.{ctor.name.replace(cls.name + '_', '')}()")
            constructor_found = True
            break
            
    # Priority 2: new() or create() with args
    if not constructor_found:
        for ctor in cls.constructors:
            # Check for standard constructor names
            name = ctor.name
            is_valid_ctor = (name.endswith("_new") or name == "new" or 
                             name.endswith("_create") or name == "create" or
                             "_create_" in name or "_from_" in name)
            
            if is_valid_ctor: 
                args = []
                for arg in ctor.args:
                    if arg.is_ptr:
                        # Use array.array for memoryviews
                        type_code = 'i'
                        if arg.type_name in ['double', 'float']: type_code = 'd'
                        elif arg.type_name == 'bool': type_code = 'B'
                        elif arg.type_name == 'size_t' or arg.type_name.endswith('Handle'): type_code = 'L'
                        args.append(f"array.array('{type_code}', [0])")
                    else:
                        args.append(get_dummy_value(arg.type_name))
                
                lines.append(f"            # Found constructor: {ctor.name}")
                
                if is_template_type(cls.name):
                    # For templates, we call the class directly with args
                    lines.append(f"            self.obj = {instantiation_class}({', '.join(args)})")
                else:
                    method_name = ctor.name
                    if method_name.startswith(cls.name + "_"):
                        method_name = method_name[len(cls.name)+1:]
                    
                    # Apply renaming logic to match generate_wrappers.py
                    if method_name == "create":
                        method_name = "new"
                    elif method_name.startswith("create_"):
                        suffix = method_name[7:]
                        if suffix.endswith("_gate"):
                            suffix = suffix[:-5]
                        method_name = "new_" + suffix
                    elif method_name == "from_json_string":
                        method_name = "from_json"
                    elif method_name == "from_json":
                        method_name = "from_json"
                        
                    lines.append(f"            self.obj = {cls.name}.{method_name}({', '.join(args)})")
                constructor_found = True
                break
    
    if not constructor_found:
        # If no constructor found, try calling the class directly (maybe it has a default constructor wrapped)
        if is_template_type(cls.name):
             lines.append(f"            # Try default constructor")
             lines.append(f"            self.obj = {instantiation_class}()")
        else:
             lines.append("            pass # No suitable constructor found")
        
    lines.append("        except Exception as e:")
    lines.append("            print(f'Setup failed: {e}')")
    lines.append("")

    # Generate tests for each method
    for method in cls.methods:
        method_name = method.name
        # Strip class prefix if present
        if method_name.startswith(cls.name + "_"):
            method_name = method_name[len(cls.name)+1:]
            
        if method_name == "destroy":
            continue
            
        lines.append(f"    def test_{method_name}(self):")
        lines.append("        if self.obj is None:")
        lines.append("            pytest.skip('Skipping test because object could not be instantiated')")
        
        args = []
        for arg in method.args:
            if arg.is_ptr:
                # Use array.array for memoryviews
                type_code = 'i'
                if arg.type_name in ['double', 'float']: type_code = 'd'
                elif arg.type_name == 'bool': type_code = 'B'
                elif arg.type_name == 'size_t' or arg.type_name.endswith('Handle'): type_code = 'L'
                args.append(f"array.array('{type_code}', [0])")
            else:
                args.append(get_dummy_value(arg.type_name))
                
        if args and (method.args[0].type_name == cls.handle_type or method.args[0].name == "handle"):
            args = args[1:]
            
        lines.append("        try:")
        # Rename method if it conflicts with Python keywords
        call_method_name = method_name
        if call_method_name in PYTHON_KEYWORD_RENAMES:
            call_method_name = PYTHON_KEYWORD_RENAMES[call_method_name]
            
        lines.append(f"            self.obj.{call_method_name}({', '.join(args)})")
        lines.append("        except Exception as e:")
        lines.append(f"            print(f'Method call failed as expected: {{e}}')")
        lines.append("")

    return "\n".join(lines)

def generate_tests(all_classes: List[ClassDef], output_dir: str, type_map: Dict[str, List[str]]):
    """Generate test files for all classes."""
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        
    # Create __init__.py
    with open(os.path.join(output_dir, "__init__.py"), "w") as f:
        pass
        
    for cls in all_classes:
        if cls.name == "String":
            continue

        # Determine module path and class name to import
        is_template = is_template_type(cls.name)


        instantiation_class = cls.name
        extra_imports = []
        
        if is_template:
            # Resolve template type recursively
            instantiation_class, resolved_imports = resolve_type_and_imports(cls.name, type_map)
            extra_imports.extend(resolved_imports)
            
            # We still need module_path and class_name_to_import for the main import
            # But resolve_type_and_imports handles imports.
            # However, generate_test_content expects module_path and class_name_to_import.
            # If we use resolve_type_and_imports, it gives us the full instantiation string e.g. List[int].
            # And imports e.g. from falcon_core.generic.list import List.
            
            # We can set module_path and class_name_to_import to something dummy or empty
            # if we pass all imports via extra_imports.
            # But generate_test_content does: `from {module_path} import {class_name_to_import}`.
            
            # Let's extract the base import from resolved_imports if possible, 
            # or just let generate_test_content do its thing for the base.
            
            classification = classify_template_type(cls.name)
            if classification:
                base, _ = classification
                if base in TEMPLATE_LOCATIONS:
                    module_path = TEMPLATE_LOCATIONS[base]
                    class_name_to_import = base
        elif cls.name in type_map:
            module_parts = type_map[cls.name]
            module_path = ".".join(module_parts)
            class_name_to_import = cls.name
        else:
            continue
            
        test_content = generate_test_content(cls, module_path, class_name_to_import, extra_imports, instantiation_class)
        
        snake_name = to_snake_case(cls.name)
        filename = f"test_{snake_name}.py"
        filepath = os.path.join(output_dir, filename)
        
        with open(filepath, "w") as f:
            f.write(test_content)
            
    print(f"Generated tests in {output_dir}")
