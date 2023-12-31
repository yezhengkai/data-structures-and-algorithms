from __future__ import annotations

from typing import Generic, TypeVar

from .utils import StackOverflowError, StackUnderflowError

T = TypeVar("T")


class StackUsingList(Generic[T]):
    def __init__(self, *data: T, max_size: int = 10) -> None:
        self.list_data: list[T] = []
        self.max_size = max_size
        if data:
            if len(data) <= max_size:
                self.list_data.extend(data)
            else:
                raise StackOverflowError

    @classmethod
    def from_iterable(cls, iterable: T, max_size: int = 10) -> StackUsingList:
        return cls(*iterable, max_size=max_size)

    def __repr__(self) -> str:
        return self.list_data.__repr__()

    def __str__(self) -> str:
        return self.list_data.__str__()

    def __bool__(self) -> bool:
        return bool(self.list_data)

    def is_empty(self) -> bool:
        return not bool(self.list_data)

    def size(self) -> int:
        """Return the size of the stack."""
        return len(self.list_data)

    def __len__(self) -> int:
        return len(self.list_data)

    def push(self, data: T) -> StackUsingList:
        """
        Push an element to the top of the stack.
        If the stack exceeds `max_size`, raise `StackOverflowError`
        Time complexity: O(1)
        """
        if len(self.list_data) >= self.max_size:
            raise StackOverflowError
        self.list_data.append(data)
        return self

    def pop(self) -> T:
        """
        Pop an element off of the top of the stack.
        If the stack is empty, raise `StackUnderflowError`
        Time complexity: O(1)
        """
        if not self.list_data:
            raise StackUnderflowError
        return self.list_data.pop()

    def peek(self) -> T:
        """
        Peek at the top-most element of the stack.
        If the stack is empty, raise `StackUnderflowError`
        Time complexity: O(1)
        """
        if not self.list_data:
            raise StackUnderflowError
        return self.list_data[-1]

    def to_list(self) -> list[T]:
        return self.list_data
