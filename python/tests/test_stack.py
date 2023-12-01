import pytest
from data_structures_algorithms.stack import StackWithList


@pytest.fixture()
def stack_with_list():
    return StackWithList(1, 2, 3)


def test_construct():
    assert StackWithList()._data == []
    assert StackWithList(1, 2, 3)._data == [1, 2, 3]


def test_str_repr(stack_with_list):
    assert str(stack_with_list) == str([1, 2, 3])
    assert repr(stack_with_list) == repr([1, 2, 3])


def test_pop_push(stack_with_list):
    assert stack_with_list.pop() == 3

    stack_with_list.push(4)
    assert stack_with_list._data == [1, 2, 4]


def test_size(stack_with_list):
    assert stack_with_list.size() == 3
    assert len(stack_with_list) == 3
    assert stack_with_list.is_empty() is False


def test_peek(stack_with_list):
    assert stack_with_list.peek() == 3


if __name__ == "__main__":
    pytest.main([__file__])
