from data_structures_algorithms.data_structures.hashing.hash_map import HashMap


def test_construct():
    HashMap()
    HashMap(initial_capacity=100)


def test_set_get():
    hash_map = HashMap()
    hash_map["a"] = 1
    assert hash_map["a"] == 1
