@testset "Singly Linked Node" begin
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
end

@testset "Singly Linked List" begin
  @test_nowarn SinglyLinkedList{Int}()
  @test_nowarn SinglyLinkedList()
  @test SinglyLinkedList().len == 0

  list = SinglyLinkedList{Int}(1)
  @test length(list) == 1
  @test list.head == list.tail
  @test list.head.data == list.tail.data == 1

  @test length(push!(list, 2)) == 2
  @test list.head != list.tail
  @test list.head.data == 1
  @test list.tail.data == 2

  @test length(push!(list, 3, 4)) == 4
  @test list.head != list.tail
  @test list.head.data == 1
  @test list.tail.data == 4

  @test length(append!(list, [5, 6])) == 6
  @test list.head != list.tail
  @test list.head.data == 1
  @test list.tail.data == 6

end
