from __future__ import annotations

from typing import Generic, TypeVar

__all__ = ["StackWithList"]

T = TypeVar("T")


class StackWithList(Generic[T]):
    def __init__(self, *values):
        self._data = []
        if values:
            self._data.extend(values)

    #TODO
    def __repr__(self) -> str:
        return super().__repr__()

    #TODO
    def __str__(self) -> str:
        return super().__str__()

    def push(self, data: T) -> StackWithList:
        self._data.append(data)
        return self

    def pop(self) -> T:
        return self._data.pop()
