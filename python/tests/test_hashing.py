import pytest
from data_structures_algorithms.data_structures.hashing.hash_map import HashMap


def test_construct():
    HashMap()
    HashMap(initial_capacity=100)
    HashMap(hash_func_name="my_add_hash")


def test_set_get():
    hash_map = HashMap()
    hash_map["a"] = 1
    assert hash_map["a"] == 1


def test_simple_hash():
    # Simple hash implementation only supports `str`
    hash_map = HashMap(hash_func_name="my_add_hash")
    with pytest.raises(TypeError):
        hash_map[1] = 1
