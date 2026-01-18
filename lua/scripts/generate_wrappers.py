#!/usr/bin/env python3
"""
Enhanced wrapper generator for falcon-core Lua port
Generates complete wrapper scaffolds from C-API headers
"""

import re
import os
from pathlib import Path
from collections import defaultdict
from typing import List, Dict, Tuple

def parse_function_signature(line: str) -> Dict:
    """Parse a C function signature into components"""
    # Pattern: ReturnType FunctionName(params);
    pattern = r'(\w+(?:Handle)?)\s+(\w+)\s*\((.*?)\)\s*;'
    match = re.match(pattern, line.strip())
    
    if not match:
        return None
    
    return_type, func_name, params_str = match.groups()
    
    # Parse parameters
    params = []
    if params_str.strip() and params_str.strip() != 'void':
        for param in params_str.split(','):
            param = param.strip()
            # Simple parameter parsing (type + optional name)
            parts = param.rsplit(None, 1)
            if len(parts) == 2:
                params.append({'type': parts[0], 'name': parts[1]})
            else:
                params.append({'type': param, 'name': ''})
    
    return {
        'return_type': return_type,
        'name': func_name,
        'params': params
    }

def analyze_c_api_header(header_path: Path) -> Dict:
    """Analyze a C-API header file and extract all functions"""
    with open(header_path) as f:
        content = f.read()
    
    # Extract type name from filename
    type_name = header_path.stem.replace('_c_api', '')
    
    functions = []
    for line in content.split('\n'):
        if line.strip() and not line.strip().startswith('//') and not line.strip().startswith('/*'):
            func = parse_function_signature(line)
            if func and type_name in func['name']:
                functions.append(func)
    
    # Categorize functions
    constructors = [f for f in functions if '_create' in f['name'] or '_from_' in f['name']]
    destructors = [f for f in functions if '_destroy' in f['name']]
    getters = [f for f in functions if any(x in f['name'] for x in ['_get_', '_at', f'{type_name}_' ]) and f['return_type'] != 'void']
    setters = [f for f in functions if '_set_' in f['name'] or '_insert' in f['name'] or 'assign' in f['name']]
    converters = [f for f in functions if '_to_' in f['name'] or '_from_' in f['name']]
    operators = [f for f in functions if any(x in f['name'] for x in ['_plus_', '_minus_', '_times_', '_div'])]
    
    return {
        'type_name': type_name,
        'all': functions,
        'constructors': constructors,
        'destructors': destructors,
        'getters': getters,
        'setters': setters,
        'converters': converters,
        'operators': operators,
    }

def generate_lua_wrapper(analysis: Dict) -> str:
    """Generate Lua wrapper module from analyzed header"""
    
    type_name = analysis['type_name']
    constructors = analysis['constructors']
    getters = analysis['getters']
    setters = analysis['setters']
    
    # Generate constructor wrappers
    constructor_code = []
    for ctor in constructors[:3]:  # Top 3 constructors
        func_name = ctor['name']
        simple_name = func_name.replace(f'{type_name}_', '').replace('create_', '')
        if simple_name == 'create':
            simple_name = 'new'
        
        param_names = ', '.join(p['name'] or f'arg{i}' for i, p in enumerate(ctor['params']))
        param_call = ', '.join(p['name'] or f'arg{i}' for i, p in enumerate(ctor['params']))
        
        constructor_code.append(f"""
function {type_name}.{simple_name}({param_names})
    return cdef.lib.{func_name}({param_call})
end
""")
    
    # Generate method wrappers
    method_code = []
    for getter in getters[:5]:  # Top 5 getters
        func_name = getter['name']
        simple_name = func_name.replace(f'{type_name}_', '')
        
        # First param is usually the handle
        other_params = getter['params'][1:] if len(getter['params']) > 1 else []
        param_names = ', '.join(p['name'] or f'arg{i}' for i, p in enumerate(other_params))
        param_call = 'handle' + (', ' + ', '.join(p['name'] or f'arg{i}' for i, p in enumerate(other_params)) if other_params else '')
        
        method_code.append(f"""
function {type_name}.{simple_name}(handle{', ' + param_names if param_names else ''})
    return cdef.lib.{func_name}({param_call})
end
""")
    
    lua_code = f"""-- {type_name.lower()}.lua
-- Auto-generated wrapper for {type_name}
-- Generated from {type_name}_c_api.h

local cdef = require("falcon_core.ffi.cdef")

local {type_name} = {{}}

-- Constructors
{''.join(constructor_code)}

-- Methods
{''.join(method_code)}

return {type_name}
"""
    
    return lua_code

def generate_test(type_name: str, analysis: Dict) -> str:
    """Generate basic test file for a type"""
    
    # Find simple constructor
    ctor = None
    for c in analysis['constructors']:
        if 'create' in c['name'] and not c['params']:
            ctor = c
            break
    
    if not ctor and analysis['constructors']:
        ctor = analysis['constructors'][0]
    
    test_code = f"""-- test_{type_name.lower()}.lua
-- Auto-generated tests for {type_name}

local {type_name} = require("falcon_core.TODO.{type_name.lower()}")

local function describe(name, fn) print("\\n" .. name); fn() end
local function it(name, fn) 
    local ok, err = pcall(fn)
    if ok then
        print("  ✓ " .. name)
    else
        print("  ✗ " .. name)
        print("    " .. tostring(err))
    end
end
local function assert(cond, msg)
    if not cond then error(msg or "Assertion failed") end
end

describe("{type_name}", function()
    it("module loads successfully", function()
        assert({type_name} ~= nil, "{type_name} should load")
    end)
"""

    if ctor:
        ctor_name = ctor['name'].replace(f'{type_name}_', '').replace('create_', '')
        if ctor_name == 'create':
            ctor_name = 'new'
        test_code += f"""
    it("can create instance", function()
        local obj = {type_name}.{ctor_name}()
        assert(obj ~= nil, "{type_name} should be created")
    end)
"""
    
    test_code += """end)

print("\\n✓ " .. "{type_name} tests complete")
""".format(type_name=type_name)
    
    return test_code

def main():
    # Paths
    c_api_include = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core/c-api/include/falcon_core")
    output_dir = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core-libs/lua/falcon_core")
    test_dir = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core-libs/lua/tests/generated")
    
    # Priority types to generate first
    priority_types = [
        'MeasurementRequest',
        'MeasurementResponse',
        'AcquisitionContext',
        'MeasurementContext',
        'InterpretationContext',
        'Waveform',
        'Channel',
        'Channels',
        'UnitSpace',
        'SymbolUnit',
    ]
    
    test_dir.mkdir(parents=True, exist_ok=True)
    
    generated_count = 0
    
    # Find all C-API headers
    for header_file in c_api_include.rglob("*_c_api.h"):
        type_name = header_file.stem.replace('_c_api', '')
        
        # Skip generic types (already wrapped)
        if any(type_name.startswith(x) for x in ['List', 'Map', 'Pair', 'Axes', 'FArray']):
            continue
        
        # Skip if already manually wrapped
        existing_wrappers = [
            'Quantity', 'Vector', 'Point', 
            'MeasuredArray', 'ControlArray', 'LabelledMeasuredArray', 'LabelledControlArray',
            'Connection', 'InstrumentPort',
            'Config'
        ]
        if type_name in existing_wrappers:
            print(f"Skipping {type_name} (already wrapped)")
            continue
        
        # Only generate priority types for now
        if type_name not in priority_types:
            continue
        
        print(f"Generating wrapper for {type_name}...")
        
        try:
            # Analyze header
            analysis = analyze_c_api_header(header_file)
            
            if not analysis['constructors'] and not analysis['getters']:
                print(f"  Warning: No constructors or methods found for {type_name}")
                continue
            
            # Generate wrapper
            lua_wrapper = generate_lua_wrapper(analysis)
            
            # Determine output directory (TODO: categorize better)
            if 'Context' in type_name:
                category_dir = output_dir / 'context'
            elif any(x in type_name for x in ['Request', 'Response']):
                category_dir = output_dir / 'messaging'
            elif any(x in type_name for x in ['Channel', 'Waveform', 'Port']):
                category_dir = output_dir / 'instrument'
            elif any(x in type_name for x in ['Unit', 'Space']):
                category_dir = output_dir / 'math'
            else:
                category_dir = output_dir / 'generated'
            
            category_dir.mkdir(parents=True, exist_ok=True)
            
            # Write wrapper
            wrapper_file = category_dir / f"{type_name.lower()}.lua"
            with open(wrapper_file, 'w') as f:
                f.write(lua_wrapper)
            
            # Generate test
            test_code = generate_test(type_name, analysis)
            test_file = test_dir / f"test_{type_name.lower()}.lua"
            with open(test_file, 'w') as f:
                f.write(test_code)
            
            generated_count += 1
            print(f"  ✓ Generated wrapper: {wrapper_file}")
            print(f"  ✓ Generated test: {test_file}")
            
        except Exception as e:
            print(f"  ✗ Error generating {type_name}: {e}")
    
    print(f"\n{'='*60}")
    print(f"Generated {generated_count} wrappers")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()
