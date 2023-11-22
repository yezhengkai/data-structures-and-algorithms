abstract type AbstractLinkedList{T} end
abstract type AbstractListNode{T} end

# >> start singly linked list node <<
# https://stackoverflow.com/questions/76161659/why-is-no-explicit-reference-required-in-this-linked-list
mutable struct SinglyListNode{T} <: AbstractListNode{T}
    # Field
    data::T
    next::SinglyListNode{T}  # next node

    # Inner Constructor
    function SinglyListNode{T}() where {T}
        # The following syntax is incomplete initialization. (ref: https://docs.julialang.org/en/v1/manual/constructors/#Incomplete-Initialization)
        node = new{T}()
        node.next = node  # circular reference.
        return node
    end
    function SinglyListNode{T}(data) where {T}
        node = new{T}(data)  # Now node.next is undefined. So if you access node.next you will get `ERROR: UndefRefError: access to undefined reference`
        node.next = node  # circular reference.
        return node
    end
    function SinglyListNode{T}(data::T, next::SinglyListNode{T}) where {T}
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
function SinglyListNode(data, next::SinglyListNode{T}) where {T}
    return SinglyListNode{T}(data, next)
end
# >> end singly linked list node <<

# >> start singly linked list <<
mutable struct SinglyLinkedList{T} <: AbstractLinkedList{T}
    len::Int
    head::SinglyListNode{T}  # head node
    tail::SinglyListNode{T}  # tail node

    # Inner Constructor
    function SinglyLinkedList{T}() where {T}
        list = new{T}()
        list.len = 0
        list.head = list.tail = SinglyListNode{T}()  # head node and tail node are the same
        return list
    end
end

# Outer Constructor
function SinglyLinkedList()
    return SinglyLinkedList{Any}()
end

function SinglyLinkedList{T}(elements...) where {T}
    list = SinglyLinkedList{T}()
    for element in elements
        push!(list, element)
    end
    return list
end
# >> end singly linked list <<

# >> start show linked list and list node <<
# ref: https://schurkus.com/2018/01/05/julia-print-show-display-dump-what-to-override-what-to-use/
#   - override show(io, x) with the undecorated form for print.
#   - override show(io, mime::MIME..., x) with the most useful interactive output with a given multimedia capability (MIME…). E.g. for the REPL version use mime::MIME"text/plain". This will be used for display.
function Base.show(io::IO, node::AbstractListNode)
    x = node.data
    print(io, "$(typeof(node))($x)")
end
function Base.show(io::IO, list::AbstractLinkedList)
    print(io, typeof(list), '(')
    join(io, list, ", ")
    print(io, ')')
end
# >> end show linked list and list node <<


# >> start iteration interface <<
# ref: https://docs.julialang.org/en/v1/manual/interfaces/
#
#   for item in iter   # or  "for item = iter"
#      # body
#   end
# is translated into:
#   next = iterate(iter)
#   while next !== nothing
#       (item, state) = next
#       # body
#       next = iterate(iter, state)
#   end
Base.length(list::AbstractLinkedList) = list.len
Base.eltype(::AbstractLinkedList{T}) where {T} = T
function Base.isdone(::AbstractLinkedList, node::AbstractListNode)
    return node == node.next
end
function Base.iterate(list::AbstractLinkedList, node::AbstractListNode=list.head)
    # If no elements remain, nothing should be returned. Otherwise, a 2-tuple of the next element and the new iteration state should be returned.
    if node.next == node
        return nothing
    else
        return (node.data, node.next)
    end
end
# TODO reverse order
# >> end iteration interface <<

# >> start insert to tail <<
function Base.push!(list::SinglyLinkedList{T}, item) where {T}
    list.tail.next.data = item
    list.tail = list.tail.next
    list.tail.next = SinglyListNode{T}()
    list.len += 1
    return list
end
function Base.push!(list::AbstractLinkedList, items...)
    return Base.append!(list, items)
end

function Base.append!(list::AbstractLinkedList, collection)
    for item in collection
        push!(list, item)
    end
    return list
end
function Base.append!(list::AbstractLinkedList, collections...)
    for collection in collections
        append!(list, collection)
    end
    return list
end
# >> end insert to tail <<

# >> start insert to head <<
function Base.pushfirst!(list::SinglyLinkedList{T}, item) where {T}
    list.head = SinglyListNode{T}(item, list.head)
    if list.len == 0
        list.tail = list.head
    end
    list.len += 1
    return list
end
function Base.pushfirst!(list::AbstractLinkedList, items...)
    return Base.prepend!(list, items)
end

function Base.prepend!(list::AbstractLinkedList, collection)
    for item in Iterators.reverse(collection)
        pushfirst!(list, item)
    end
    return list
end
function Base.prepend!(list::AbstractLinkedList, collections...)
    for collection in Iterators.reverse(collections)
        prepend!(list, collection)
    end
    return list
end
# >> end insert to head <<
