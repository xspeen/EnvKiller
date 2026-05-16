# Contributing to EnvKiller

## Code Style

- Follow PEP 8 for Python
- Use Cython for performance-critical modules
- Add docstrings to all functions

## Adding New Secret Patterns

Edit `core/scanner.pyx` and add to the `patterns` dict:

```python
'NEW_PATTERN_NAME': r'regex_pattern_here'
```

Adding New Scanners

Create new file in modules/:

```python
# modules/new_scanner.pyx
cdef class NewScanner:
    cpdef dict scan(self, str target):
        # Implementation
        return {'findings': []}
```

Testing

```bash
python -m pytest tests/
```

Pull Requests

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

```

---
