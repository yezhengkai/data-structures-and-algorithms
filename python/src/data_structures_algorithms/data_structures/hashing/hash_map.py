from typing import Callable, Generic, Iterator, MutableMapping, TypeVar

from .utils import HASH_FUNCTIONS_MAP

K = TypeVar("K")
V = TypeVar("V")
T = TypeVar("T", str, bool, int, float, tuple, object)


class Pair(Generic[K, V]):
    def __init__(self, key: K, value: V) -> None:
        self.key = key
        self.value = value


class HashMap(MutableMapping[K, V], Generic[K, V]):
    def __init__(self, initial_capacity=10, hash_func_name: str | None = None) -> None:
        self.buckets: list[Pair | None] = [None] * initial_capacity
        self._set_hash_func(hash_func_name)

    def _set_hash_func(self, func_name: str | None) -> Callable[[T], int]:
        self.hash_func = HASH_FUNCTIONS_MAP.get(func_name, hash)

    def __setitem__(self, key: K, value: V) -> None:
        idx: int = self._get_bucket_idx(key)
        self.buckets[idx] = Pair(key, value)

    def __getitem__(self, key: K) -> V:
        idx: int = self._get_bucket_idx(key)
        pair: Pair = self.buckets[idx]
        return pair.value

    def __delitem__(self, key: K) -> None:
        idx: int = self._get_bucket_idx(key)
        self.buckets[idx] = None

    def __len__(self) -> int:
        return super().__len__()

    def __iter__(self) -> Iterator[K]:
        return super().__iter__()

    def _get_bucket_idx(self, key: K) -> int:
        return self.hash_func(key) % len(self.buckets)

    def get(self, key: K, default=None) -> V:
        value = self.__getitem__(key)
        return value if value is None else default
