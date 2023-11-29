from data_structures_algorithms import *  # noqa: F403


def test_stack():
    assert StackWithList()._data == []
    assert StackWithList(1, 2, 3)._data == [1, 2, 3]

    stack: StackWithList[int] = StackWithList(1, 2, 3)
    assert str(stack) == str([1, 2, 3])
    assert repr(stack) == repr([1, 2, 3])

    assert stack.pop() == 3

    stack.push(4)
    assert stack._data == [1, 2, 4]


if __name__ == "__main__":
    test_stack()
