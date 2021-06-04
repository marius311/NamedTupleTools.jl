"""
    getindices(x::NamedTuple, <indices>)

`getindices` extends and is compatible with `Base.getindex` for `NamedTuples`.

- Integer indices are ordinal positions within `x`.
- Symbol indices are field names appearing in `x`.

(a) A single position or a single field name may be used for <indices>.
In these cases `getindices` follows `getindex`, returning a value.

(b) A `Tuple` of field names may be used for <indices>.
In this case `getindicies` follows `getindex`, returning a `NamedTuple`.

(c) A `Tuple` of positions may be used for <indices>.
In this case `getindicies` extends `getindex`, returning a `NamedTuple`.
"""

@nospecialize getindices(@nospecialize x, @nospecialize idx::Union{Int32, Int64, Symbol}) = getindex(x, idx)
getindices(@nospecialize x, @nospecialize idx::Integer) = getindex(x, idx)
getindices(@nospecialize x, @nospecialize idxs::NTuple{L,T}) where {L, T<:Integer} = Tuple(map(i->getindex(x, i), idxs))
getindices(@nospecialize x, @nospecialize idxs::NTuple{L,Symbol}) where {L} = getindex(x, idxs)

        
#=
    lower level assistance for specific restructureables
=#
    
# support for LittleDicts, extended to other OrderedCollections
isfrozen(@nospecialize x::LittleDict{K,V, <:Tuple, <:Tuple}) where {K,V} = true
isfrozen(@nospecialize x::LittleDict{K,V, <:Vector, <:Vector) where {K,V} = false
isfrozen(@nospecialize x::AbstractDict) = false
isfrozen(@nospecialize x::OrderedSet)  = true
# OrderedCollections exports `frozen = freeze(::LittleDict)`
unfreeze(@nospecialize x::LittleDict{K,V, <:Tuple, <:Tuple) where {K,V} =
    LittleDict(keys(x), values(x))
