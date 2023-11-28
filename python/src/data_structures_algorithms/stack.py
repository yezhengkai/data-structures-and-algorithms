from typing import TypeVar, Generic

__all__ = ["StackWithList"]

T = TypeVar('T')

class StackWithList(Generic[T]):
    def __init__(self, *values):
        self._data = []
        if values:
            self._data.extend(values)

    def __repr__(self) -> str:
        return super().__repr__()

    def __str__(self) -> str:
        return super().__str__()
