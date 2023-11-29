from __future__ import annotations

from typing import Generic, TypeVar

__all__ = ["StackWithList"]

T = TypeVar("T")


class StackWithList(Generic[T]):
    def __init__(self, *values) -> None:
        self._data: list[T] = []
        if values:
            self._data.extend(values)

    def __repr__(self) -> str:
        return self._data.__repr__()

    def __str__(self) -> str:
        return self._data.__str__()
    
    def is_empty(self) -> bool:
        return not bool(self._data)
    
    def size(self) -> int:
        """Return the size of the stack."""
        return len(self._data)

    def push(self, data: T) -> StackWithList:
        self._data.append(data)
        return self

    def pop(self) -> T:
        return self._data.pop()
    
    def peek(self) -> T:
        return self._data[-1]
