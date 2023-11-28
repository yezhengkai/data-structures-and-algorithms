from data_structures_algorithms import *

def test_stack():
    assert StackWithList()._data == []
    assert StackWithList(1, 2, 3)._data == [1, 2, 3]
