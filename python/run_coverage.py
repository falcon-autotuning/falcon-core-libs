#!/usr/bin/env python3
"""
Run auto-generated tests individually and collect cumulative coverage.
This works around exit-time crashes by running each test file in a separate process.
"""

import os
import subprocess
import sys
import re
from pathlib import Path

def get_test_files(test_dir: Path) -> list:
    """Get all test files in the auto_generated directory."""
    return sorted(test_dir.glob("test_*.py"))

def run_test_with_coverage(test_file: Path, cov_data_dir: Path, index: int, python_dir: Path) -> dict:
    """Run a single test file with coverage and return results."""
    test_name = test_file.stem
    cov_file = cov_data_dir / f".coverage.{index:03d}.{test_name}"
    
    env = os.environ.copy()
    env["COVERAGE_FILE"] = str(cov_file)
    
    # Use coverage run with pytest
    cmd = [
        sys.executable, "-m", "coverage", "run",
        "--source=src",
        "--parallel-mode",
        "-m", "pytest",
        str(test_file),
        "--tb=no",
        "-q"
    ]
    
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=60,
            env=env,
            cwd=str(python_dir)
        )
    except subprocess.TimeoutExpired:
        return {
            'file': test_name,
            'passed': 0,
            'skipped': 0,
            'failed': 0,
            'exit_code': -999,
            'crashed': False,
            'timeout': True
        }
    
    # Parse output for pass/skip/fail counts
    output = result.stdout + result.stderr
    passed = skipped = failed = 0
    
    # Look for summary line like "12 passed" or "3 passed, 2 skipped"
    for line in output.split('\n'):
        matches = re.findall(r'(\d+) (passed|skipped|failed)', line.lower())
        for count, status in matches:
            if status == 'passed':
                passed = int(count)
            elif status == 'skipped':
                skipped = int(count)
            elif status == 'failed':
                failed = int(count)
    
    crashed = result.returncode == -11 or result.returncode == 139 or 'Segmentation fault' in output
    
    return {
        'file': test_name,
        'passed': passed,
        'skipped': skipped,
        'failed': failed,
        'exit_code': result.returncode,
        'crashed': crashed,
        'timeout': False
    }

def combine_coverage(python_dir: Path):
    """Combine all coverage data files and generate report."""
    env = os.environ.copy()
    env["COVERAGE_FILE"] = str(python_dir / ".coverage")
    
    # Combine coverage files
    cmd = [sys.executable, "-m", "coverage", "combine"]
    result = subprocess.run(cmd, env=env, cwd=str(python_dir), capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Warning: coverage combine: {result.stderr}")
    
    # Generate text report
    cmd = [sys.executable, "-m", "coverage", "report", "--show-missing", "--skip-covered"]
    result = subprocess.run(cmd, env=env, cwd=str(python_dir), capture_output=True, text=True)
    print(result.stdout)
    if result.stderr:
        print(result.stderr)
    
    # Generate HTML report
    html_dir = python_dir / "htmlcov"
    cmd = [sys.executable, "-m", "coverage", "html", "-d", str(html_dir)]
    subprocess.run(cmd, env=env, cwd=str(python_dir))
    print(f"\nHTML coverage report: {html_dir / 'index.html'}")

def main():
    # Paths
    script_dir = Path(__file__).parent
    python_dir = script_dir
    test_dir = python_dir / "tests" / "auto_generated"
    
    # Clean up old coverage data
    import shutil
    for f in python_dir.glob(".coverage*"):
        if f.is_dir():
            shutil.rmtree(f)
        else:
            f.unlink()
    
    test_files = get_test_files(test_dir)
    print(f"Found {len(test_files)} test files")
    print("=" * 70)
    
    results = []
    total_passed = 0
    total_skipped = 0
    total_failed = 0
    total_crashed = 0
    total_timeout = 0
    
    for i, test_file in enumerate(test_files):
        print(f"[{i+1:3d}/{len(test_files)}] {test_file.stem[:45]:<45}", end=" ", flush=True)
        
        result = run_test_with_coverage(test_file, python_dir, i, python_dir)
        results.append(result)
        
        total_passed += result['passed']
        total_skipped += result['skipped']
        total_failed += result['failed']
        
        if result['timeout']:
            print("TIMEOUT")
            total_timeout += 1
        elif result['crashed']:
            print(f"✓ {result['passed']:2d}p/{result['skipped']:2d}s (exit crash)")
            total_crashed += 1
        elif result['exit_code'] == 0:
            print(f"✓ {result['passed']:2d}p/{result['skipped']:2d}s")
        elif result['exit_code'] == 5:  # No tests collected
            print("(no tests)")
        else:
            print(f"? {result['passed']:2d}p/{result['skipped']:2d}s (exit {result['exit_code']})")
    
    print("=" * 70)
    print(f"TOTALS: {total_passed} passed, {total_skipped} skipped, {total_failed} failed")
    print(f"Exit crashes: {total_crashed}, Timeouts: {total_timeout}")
    print()
    
    # Combine coverage
    print("Combining coverage data...")
    combine_coverage(python_dir)
    
    # Summary of files with most passes
    print("\n" + "=" * 70)
    print("Top test files by passed tests:")
    top_files = sorted(results, key=lambda x: x['passed'], reverse=True)[:10]
    for r in top_files:
        if r['passed'] > 0:
            print(f"  {r['file']}: {r['passed']} passed")

if __name__ == "__main__":
    main()
