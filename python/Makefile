install:
	uv venv --clear
	uv pip install Cython setuptools pytest coverage
	uv pip install -e .

test:
	uv run pytest --tb=short

coverage:
	uv run python run_coverage.py
