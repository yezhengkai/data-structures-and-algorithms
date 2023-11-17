using Test, DataStructuresAlgorithms


node = SinglyListNode{Int}()
@test typeof(node.data) == Int
@test node.next == node

node1 = SinglyListNode{Int}(1)
@test node1.data == 1
@test node1.next == node1

node2 = SinglyListNode{Int}(2, node1)
@test node2.data == 2
@test node2.next == node1

@test_nowarn SinglyListNode()
@test SinglyListNode(1).data == 1

node3 = SinglyListNode(3, node2)
@test node3.data == 3
@test node3.next == node2
