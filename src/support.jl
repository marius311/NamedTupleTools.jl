"""
    isbijection(nt1, nt2)
    nt1 ↔ nt2

- "↔" is entered in the REPL as \\:left_right_arrow:<tab>

field order independent equality
- isbijection((a=1, b=2), (b=2, a=1))
- (a=1, b=2) ↔ (b=2, a=1)
""" isbijection, ↔

function isbijection(x::NamedTuple, y::NamedTuple)
    length(x) === length(y) &&
    NamedTuple{keys(x)}(y) === x
end

const ↔ = isbijection
#=
function isbijection(x::NamedTuple{N,T}, y::NamedTuple{N1,T1}) where {N,T,N1,T1}
    length(N) === length(N1) &&
    foldl(&, foldl(.|, ((n .== N) for n=N1))) &&
    foldl(&, (getfield(x,k) === getfield(y,k) for k=N))
end
=#

"""
    canoncialize(::NamedTuple)
    canoncialize(::Type{NamedTuple})

Put the fields into a canonical order
by sorting over the field names.

""" canonicalize

function canonicalize(x::NamedTuple{N,T}) where {N,T}
    names = Tuple(sort([N...]))
    return NamedTuple{names}(x)
end

function canonicalize(x::Type{NamedTuple{N}}) where {N}
    names = Tuple(sort([N...]))
    return NamedTuple{names}
end

function canonicalize(x::Type{NamedTuple{N,T}}) where {N,T}
    namesperm = sortperm([N...])
    names = N[namesperm]
    types = T.parameters[namesperm]
    return NamedTuple{names, Tuple{types...}}
end

"""
    unsafe_align(nt1, nt2)

    - nt1 and nt2 must use the same fieldnames
    - the order of the fieldnames may differ in each
reorders nt2 to match the order of the keys in nt1

from ericphanson discourse Reordering NamedTuples
""" unsafe_align

unsafe_align(nt1::NamedTuple, nt2::NamedTuple) =
    NamedTuple{keys(nt1)}(nt2)

"""
    align(nt1, nt2)

reorders nt2 using the order of the keys in nt1
- only keys that are common to nt1 and nt2 are used

idea from ericphanson discourse Reordering NamedTuples
""" align

align(nt1::NamedTuple, nt2::NamedTuple) =
    NamedTuple{Tuple(intersect(keys(nt1), keys(nt2)))}(nt2)

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

getindices(x, idx::Integer) = getindex(x, idx)
getindices(x, idxs::NTuple{L,Symbol}) where {L} = getindex(x, idxs)
getindices(x, idx::Union{Int32, Int64, Symbol}) = getindex(x, idx)

getindices(x, idxs::NTuple{L,T}) where {L, T<:Integer} =
    Tuple(map(i->getindex(x, i), idxs))


    """
    findindex(::Symbol, ::Union{Tuple, NamedTuple})
    findindex(::NTuple{N,Symbol}, ::Union{Tuple, NamedTuple})

returns the index/indices (1, 2,..) where the symbol is found or else, `nothing`
""" findindex

# map field (a Symbol) to a Tuple field index(an Int, or `nothing`)
@inline findindex(x::Symbol, syms::NTuple{N2,Symbol}) where {N1,N2} =
    findfirst(isequal(x), syms)
@inline findindex(xs::NTuple{N1,Symbol}, syms::NTuple{N2,Symbol}) where {N1,N2} =
    findfirst.(isequal.(xs), Ref(syms))
# map field name (a Symbol) to a NamedTuple field index (an Int, or `nothing`)
findindex(x::Symbol, nt::NamedTuple{N,T}) where {N,T} = 
    findindex(x, N)
findindex(xs::NTuple{M, Symbol}, nt::NamedTuple{N,T}) where {M,N,T} =
    findindex(xs, N)

#=
    lower level assistance for specific restructureables
=#

# support for LittleDicts, extended to other OrderedCollections
isfrozen(@nospecialize x::LittleDict{K,V,T1,T2}) where {K,V,T1<:Tuple,T2<:Tuple} = true
isfrozen(@nospecialize x::LittleDict{K,V,T1,T2}) where {K,V,T1<:Vector,T2<:Vector} = false
isfrozen(@nospecialize x::AbstractDict) = false
isfrozen(@nospecialize x::OrderedSet)  = true
# OrderedCollections exports `frozen = freeze(::LittleDict)`
unfreeze(@nospecialize x::LittleDict{K,V,T1,T2}) where {K,V,T1<:Tuple,T2<:Tuple} =
    LittleDict(keys(x), values(x))
