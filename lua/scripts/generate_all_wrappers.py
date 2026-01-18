#!/usr/bin/env python3
"""
Generate ALL remaining wrappers for complete coverage
"""

import sys
sys.path.append('.')
from generate_wrappers import *

def main():
    # Paths
    c_api_include = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core/c-api/include/falcon_core")
    output_dir = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core-libs/lua/falcon_core")
    test_dir = Path("/home/daniel/work/wisc/playground/python-port-playground/falcon-core-libs/lua/tests/generated")
    
    test_dir.mkdir(parents=True, exist_ok=True)
    
    # Already wrapped (manual + first batch)
    already_wrapped = {
        # Generic (skip these)
        'List', 'Map', 'Pair', 'Axes', 'FArray',
        # Manual
        'Quantity', 'Vector', 'Point', 
        'MeasuredArray', 'ControlArray', 'LabelledMeasuredArray', 'LabelledControlArray',
        'Connection', 'InstrumentPort', 'Config',
        # First generated batch
        'MeasurementRequest', 'MeasurementResponse',
        'AcquisitionContext', 'MeasurementContext', 'InterpretationContext',
        'Waveform', 'Channel', 'Channels',
        'UnitSpace', 'SymbolUnit',
    }
    
    generated_count = 0
    skipped_count = 0
    
    # Find all C-API headers
    for header_file in sorted(c_api_include.rglob("*_c_api.h")):
        type_name = header_file.stem.replace('_c_api', '')
        
        # Skip generic types patterns
        if any(type_name.startswith(x) for x in ['List', 'Map', 'Pair', 'Axes']):
            continue
        if type_name.startswith('FArray'):
            continue
            
        # Skip macros and utilities
        if 'Macro' in type_name or type_name in ['String', 'ErrorHandling', 'Precompiled', 'CerealMacro', 'DestroyMacro', 'CopyMacro', 'EqualityMacro']:
            skipped_count += 1
            continue
        
        # Skip if already wrapped
        if type_name in already_wrapped:
            continue
        
        print(f"Generating wrapper for {type_name}...")
        
        try:
            # Analyze header
            analysis = analyze_c_api_header(header_file)
            
            if not analysis['constructors'] and not analysis['getters'] and len(analysis['all']) < 2:
                print(f"  ⚠ Skipping {type_name} (no useful methods found)")
                skipped_count += 1
                continue
            
            # Generate wrapper
            lua_wrapper = generate_lua_wrapper(analysis)
            
            # Categorize type
            if 'Context' in type_name:
                category_dir = output_dir / 'context'
            elif any(x in type_name for x in ['Request', 'Response']):
                category_dir = output_dir / 'messaging'
            elif any(x in type_name for x in ['Channel', 'Waveform', 'Port', 'Impedance']):
                category_dir = output_dir / 'instrument'
            elif any(x in type_name for x in ['Unit', 'Space', 'Domain', 'Discretizer', 'Function', 'Alignment']):
                category_dir = output_dir / 'math'
            elif any(x in type_name for x in ['Group', 'Adjacency', 'Voltage', 'Gate', 'Dot']):
                category_dir = output_dir / 'physics'
            elif any(x in type_name for x in ['Array', 'Measured', 'Control', 'Labelled']):
                category_dir = output_dir / 'arrays'
            elif any(x in type_name for x in ['HDF5', 'Loader', 'Time']):
                category_dir = output_dir / 'io'
            else:
                category_dir = output_dir / 'other'
            
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
            print(f"  ✓ Generated: {category_dir.name}/{wrapper_file.name}")
            
        except Exception as e:
            print(f"  ✗ Error: {e}")
            skipped_count += 1
    
    print(f"\n{'='*60}")
    print(f"Generated: {generated_count} wrappers")
    print(f"Skipped: {skipped_count} types")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()
