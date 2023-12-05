from typing import Callable, ParamSpec

P = ParamSpec("P")

HASH_FUNCTIONS_MAP = {"stdlib": hash}


def register(func_name: str) -> Callable[P, int]:
    def register_func(func: Callable[P, int]) -> Callable[P, int]:
        if func_name in HASH_FUNCTIONS_MAP:
            raise ValueError(f"Duplicate hash function name: {func_name}")
        HASH_FUNCTIONS_MAP[func_name] = func
        return func

    return register_func


@register("my_add_hash")
def add_hash(key: str) -> int:
    hash_value = 0
    modulus = 1000000007  # Using prime numbers will be more robust
    for c in key:
        hash_value += ord(c)
    return hash_value % modulus
