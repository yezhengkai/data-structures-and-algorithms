abstract type AbstractLinkedList{T} end
abstract type AbstractListNode{T} end

# >> start singly linked list node <<
# https://stackoverflow.com/questions/76161659/why-is-no-explicit-reference-required-in-this-linked-list
mutable struct SinglyListNode{T} <: AbstractListNode{T}
    # Field
    data::T
    next::SinglyListNode{T}  # next node

    # Inner Constructor
    function SinglyListNode{T}() where T
        # The following syntax is incomplete initialization. (ref: https://docs.julialang.org/en/v1/manual/constructors/#Incomplete-Initialization)
        node = new{T}()
        node.next = node  # circular reference.
        return node
    end
    function SinglyListNode{T}(data) where T
        node = new{T}(data)  # Now node.next is undefined. So if you access node.next you will get `ERROR: UndefRefError: access to undefined reference`
        node.next = node  # circular reference.
        return node
    end
    function SinglyListNode{T}(data::T, next::SinglyListNode{T}) where T
        new{T}(data, next)
    end
end

# Outer Constructor
function SinglyListNode()
    return SinglyListNode{Any}()  # SinglyListNode{Any}(#undef, SinglyListNode{Any}(#= circular reference @-1 =#))
end
function SinglyListNode(data)
    return SinglyListNode{typeof(data)}(data)
end
function SinglyListNode(data, next::SinglyListNode{T}) where T
    return SinglyListNode{T}(data, next)
end
# >> end singly linked list node <<

# >> start singly linked list <<
mutable struct SinglyLinkedList{T} <: AbstractLinkedList{T}
    len::Int
    head::SinglyListNode{T}  # point to head node

    # Inner Constructor
    function SinglyLinkedList{T}() where T
        list = new{T}()
        list.len = 0
        list.head = SinglyListNode{T}()
        return list
    end
end

function SinglyLinkedList()
    return SinglyLinkedList{Any}()
end
# >> end singly linked list <<
