import pytest
from data_structures_algorithms import StackUsingList
from data_structures_algorithms.data_structures import StackOverflowError, StackUnderflowError


@pytest.fixture()
def stack_using_list():
    return StackUsingList(1, 2, 3, max_size=4)


def test_construct():
    assert StackUsingList().list_data == []
    assert StackUsingList(1, 2, 3).list_data == [1, 2, 3]
    assert StackUsingList(1, 2, max_size=5).list_data == [1, 2]
    with pytest.raises(StackOverflowError):
        StackUsingList(1, 2, max_size=1)


def test_str_repr(stack_using_list):
    assert str(stack_using_list) == str([1, 2, 3])
    assert repr(stack_using_list) == repr([1, 2, 3])


def test_pop_push(stack_using_list):
    assert stack_using_list.pop() == 3
    with pytest.raises(StackUnderflowError):
        stack_using_list.pop()
        stack_using_list.pop()
        stack_using_list.pop()

    stack_using_list.push(1)
    assert stack_using_list.list_data == [1]
    with pytest.raises(StackUnderflowError):
        stack_using_list.pop()
        stack_using_list.pop()
        stack_using_list.pop()
    


def test_size(stack_using_list):
    assert stack_using_list.size() == 3
    assert len(stack_using_list) == 3
    assert stack_using_list.is_empty() is False


def test_peek(stack_using_list):
    assert stack_using_list.peek() == 3


if __name__ == "__main__":
    pytest.main([__file__])
