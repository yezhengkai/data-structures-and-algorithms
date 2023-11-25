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

# >> start indexing interface <<
# https://docs.julialang.org/en/v1/manual/interfaces/#Indexing
@inline function Base.getindex(list::AbstractLinkedList, idx::Int)
    @boundscheck 0 < idx <= list.len || throw(BoundsError(list, idx))
    node = @inbounds get_node(list, idx)
    return node.data
end

function Base.setindex!(list::AbstractLinkedList{T}, data, idx::Int) where T
    @boundscheck 0 < idx <= list.len || throw(BoundsError(list, idx))
    node = @inbounds get_node(list, idx)
    node.data = convert(T, data)
    return list
end

function Base.firstindex(list::AbstractLinkedList)
    isempty(list) && throw(BoundsError(list))
    return 1
end

function Base.lastindex(list::AbstractLinkedList)
    isempty(list) && throw(BoundsError(list))
    return length(list)
end

function Base.first(list::AbstractLinkedList)
    isempty(list) && throw(ArgumentError("List is empty"))
    return list.head.data
end

function Base.last(list::AbstractLinkedList)
    isempty(list) && throw(ArgumentError("List is empty"))
    return list.tail.data
end
# >> end indexing interface <<

# >> start general functions <<
Base.:(==)(l1::AbstractLinkedList{T}, l2::AbstractLinkedList{S}) where {T,S} = false

function Base.:(==)(l1::AbstractLinkedList{T}, l2::AbstractLinkedList{T}) where T
    length(l1) == length(l2) || return false
    for (i, j) in zip(l1, l2)
        i == j || return false
    end
    return true
end

# Ref: https://discourse.julialang.org/t/extract-type-name-only-from-parametric-type/14188/20
function Base.map(f::Base.Callable, list::AbstractLinkedList{T}) where T
    if isempty(list) && f isa Function
        # Core.Compiler.return_type(sqrt, Tuple{Int}) -> Float64
        S = Core.Compiler.return_type(f, Tuple{T})
        # Base.typename(Vector{Int}).wrapper -> Array
        return Base.typename(typeof(list)).wrapper{S}()
    elseif isempty(list) && f isa Type
        return Base.typename(typeof(list)).wrapper{f}()
    else
        S = typeof(f(first(list)))
        new_list = Base.typename(typeof(list)).wrapper{S}()
        for data in list
            new_data = f(data)
            if new_data isa S
                push!(new_list, new_data)
            else
                # typejoin(Int, Float64) -> Real
                # typejoin(Int, Float64, ComplexF32) -> Number
                R = typejoin(S, typeof(new_data))
                new_list = Base.typename(typeof(list)).wrapper{R}(collect(new_list)...)
                push!(new_list, new_data)
            end
        end
        return new_list
    end
end

function Base.filter(f::Function, list::AbstractLinkedList{T}) where T
    new_list = typeof(list)()
    for data in list
        if f(data)
            push!(new_list, data)
        end
    end
    return new_list
end

function Base.reverse(list::AbstractLinkedList{T}) where T
    new_list = typeof(list)()
    for data in list
        pushfirst!(new_list, data)
    end
    return new_list
end

function Base.copy(list::AbstractLinkedList{T}) where T
    new_list = typeof(list)()
    for data in list
        push!(new_list, data)
    end
    return new_list
end
# >> end general functions <<

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

# >> start insert to ith <<
function Base.insert!(list::AbstractLinkedList, idx::Int, data)
    if idx > list.len + 1
        throw(BoundsError(list, idx))
    elseif idx == 1 || isempty(list)
        return pushfirst!(list, data)
    elseif idx == list.len + 1
        return push!(list, data)
    elseif 2 <= idx <= list.len
        current_node = @inbounds get_node(list, idx - 1)
        current_node.next = typeof(current_node)(data, current_node.next)
        list.len += 1
        return list
    else
        throw(BoundsError(list, idx))
    end
end
# >> end insert to ith <<

# >> start delete tail <<
function Base.pop!(list::SinglyLinkedList)
    isempty(list) && throw(ArgumentError("List must be non-empty"))
    data = list.tail.data
    node_last_prev = @inbounds get_node(list, list.len - 1)
    node_last_prev.next = node_last_prev.next.next
    list.tail = node_last_prev
    list.len -= 1
    return data
end
# >> end delete tail <<

# >> start delete head <<
function Base.popfirst!(list::SinglyLinkedList)
    isempty(list) && throw(ArgumentError("List must be non-empty"))
    data = list.head.data
    list.head = list.head.next
    list.len -= 1
    return data
end
# >> end delete head <<

# >> start delete at ith <<
function Base.deleteat!(list::AbstractLinkedList, idx::Int)
    @boundscheck 0 < idx <= list.len || throw(BoundsError(list, idx))
    node_prev = @inbounds get_node(list, idx - 1)
    node_prev.next = node_prev.next.next
    list.len -= 1
    return list
end
# >> end delete at ith <<

# >> start find <<
function Base.findfirst(predicate::Function, list::AbstractLinkedList)
    for (idx, data) in enumerate(list)
        if predicate(data)
            return idx
        end
    end
    return nothing
end
function Base.findfirst(data::T, list::AbstractLinkedList{T}) where T
    return findfirst(isequal(data), list)
end
# >> end find <<

# >> start helper function <<
function get_node(list::AbstractLinkedList, idx::Int)
    @boundscheck 0 < idx <= list.len || throw(BoundsError(list, idx))
    node = list.head
    for _ in 2:idx
        node = node.next
    end
    return node
end
# >> end helper function <<
