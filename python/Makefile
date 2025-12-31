install:
	rm -rf .venv
	uv venv
	uv pip install -e .

test:
	pytest --cov=. --cov-report=term-missing
