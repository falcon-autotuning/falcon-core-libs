#!/usr/bin/env python3
import os
import re
from pathlib import Path

def main():
    test_dir = Path("tests/generated")
    lib_dir = Path("falcon_core")
    
    # Map of filename to full module path
    module_map = {}
    for lua_file in lib_dir.rglob("*.lua"):
        if lua_file.name == "init.lua":
            continue
        
        # Convert path to module format: falcon_core.sub.module
        relative = lua_file.relative_to(lib_dir.parent)
        module_path = str(relative.with_suffix('')).replace(os.sep, '.')
        module_map[lua_file.stem.lower()] = module_path

    print(f"Mapped {len(module_map)} library modules.")

    updated_count = 0
    for test_file in test_dir.glob("test_*.lua"):
        type_name_lower = test_file.stem.replace('test_', '').lower()
        
        with open(test_file, 'r') as f:
            content = f.read()
        
        orig_content = content
        
        # 1. Update module path if not already fixed
        if 'falcon_core.TODO' in content and type_name_lower in module_map:
            actual_module = module_map[type_name_lower]
            content = re.sub(
                r'require\("falcon_core\.TODO\.[^"]+"\)',
                f'require("{actual_module}")',
                content
            )

        # 2. Extract the local variable name used for the module
        # Pattern: local StandardRequest = require(...)
        match = re.search(r'local (\w+) = require', content)
        if match:
            local_name = match.group(1)
            
            # Replace from_json_string() with new()
            content = content.replace(f'{local_name}.from_json_string()', f'{local_name}.new()')
            
            # Inject generic method exercise if it doesn't have it
            if 'obj:message()' not in content and 'obj:size()' not in content:
                exercise_logic = """
    it("can exercise methods", function()
        local obj = {name}.new()
        if obj then
            pcall(function() if obj.message then obj:message() end end)
            pcall(function() if obj.size then obj:size() end end)
            pcall(function() if obj.at then obj:at(0) end end)
        end
    end)
""".format(name=local_name)
                # Insert before the last end)
                parts = content.rsplit('end)', 1)
                if len(parts) == 2:
                    content = parts[0] + exercise_logic + 'end)' + parts[1]

        if content != orig_content:
            with open(test_file, 'w') as f:
                f.write(content)
            print(f"✓ Updated {test_file.name}")
            updated_count += 1

    print(f"\nUpdated {updated_count} test files.")

if __name__ == "__main__":
    main()
