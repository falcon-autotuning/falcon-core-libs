install:
	uv venv -- -y
	uv pip install -e .

test:
	pytest --cov=. --cov-report=term-missing
