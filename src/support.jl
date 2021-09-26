const SymTuple = Tuple{Vararg{Symbol}}

gen_isin(x::SymTuple) = (∈)(x)
gen_isnotin(x::SymTuple) = (∉)(x)

gen_isin(x::SymTuple, y::SymTuple) = gen_isin( (x..., y...) )
gen_isnotin(x::SymTuple, y::SymTuple) = gen_isnotin( (x..., y...) )

function symmetricdiff(x::SymTuple, y::SymTuple)
    isnotin_x = gen_isnotin(x)
    ianotin_y = gen_isnotin(y)

    xs = x[[map(isnotin_y, x)...]]
    ys = y[[map(isnotin_x, y)...]]
    return (xs..., ys...)
end

function relativediff(x::SymTuple, y::SymTuple)
    isnotin_y = gen_isnotin(y)

    xs = x[[map(isnotin_y, x)...]]
    return xs
end

function tupleintersection(x::SymTuple, y::SymTuple)
    isin_y = gen_isin(y)

    xs = x[[map(isin_y, x)...]]
    return xs
end


# fast, nonallocating tuplejoin by jameson
@inline tuplejoin(x) = x
@inline tuplejoin(x, y) = (x..., y...)
@inline tuplejoin(x, y, z...) = (x..., tuplejoin(y, z...)...)


function tupleunion(x, y)
    isnotin_x = gen_isnotin(x)

    ys = y[[map(isnotin_x, y)...]]
    return (x..., ys...)
end

#=

julia> sabc = (sa,sb,sc)
(:a, :d, :c)

julia> tabc = (ta,tb,tc)
(:x, :d, :a)

julia> idsabc = objectid.(sabc)
(0x6b037ee92f7ed6b0, 0x0732543ad2f5dd24, 0x441f78467aaa1949)

julia> idtabc = objectid.(tabc)
(0x045fdb45d4d7609f, 0x0732543ad2f5dd24, 0x6b037ee92f7ed6b0)

julia> map(ti->map(x->iszero(xor(ti,x)), idsabc), idtabc)
((false, false, false), (false, true, false), (true, false, false))

julia> 
=#

"""
    tupleintersect

""" tupleintersect

function tupleintersect(syms1::NTuple{N1,Symbol}, syms2::NTuple{N2,Symbol}) where {N1, N2}
    idxs = filter(!isnothing, findindex(syms1, syms2))
    getindex.(Ref(syms2), idxs)
end

function tupleintersect(syms1::Tuple{Vararg{Symbol}}, syms2::Tuple{Vararg{Symbol}})
    N = min(length(syms1), length(syms2))
    result = Vector{Union{Symbol,Nothing}}(nothing, N)
    i = 1
    for s in syms1
        if s in syms2
            result[i] = s
            i += 1
        end
    end
    Tuple(filter(!isnothing, result))
end


function tupleintersect(syms1::NTuple{N1,Symbol}, syms2::NTuple{N2,Symbol}) where {N1, N2}
     result = Symbol[]
     for s in syms1
        if s in syms2
            push!(result, s)
        end
    end
    Tuple(result)
end



# syms1[ [in.(syms1, Ref(syms2))...] ]
# syms1[in.([syms1...], Ref(syms2))]
# syms1[in.(syms1, [Ref(syms2)...])]


#=
function tupleintersect(a::Tuple{Vararg{Symbol}}, b::Tuple{Vararg{Symbol}})
    ntuple(min(length(a),length(b))) do i
        n = 0
        for (j, ia) in pairs(a)
            n += ia in b
            n == i && return ia
        end
        error()
    end
end
=#

"""
    uniquely(x)
    uniquely(x, y)
    uniquely(x, ys)

maps `unique` and preserves input data type with the result
""" uniquely

@inline uniquely(x::SymTuple) = Tuple(unique(x))
uniquely(x::SymTuple, y::SymTuple) = (uniquely(x), uniquely(y))
uniquely(x::SymTuple, ys::Vararg{SymTuple}) = (uniquely(x), uniquely.(ys))

"""
    orderedunion(x, y)

The elements of x followed by the elements of y that are not shared with x.

- x, y must have no repeated entries

""" orderedunion

function unsafe_orderedunion(x::SymTuple, y::SymTuple)
    @nospecialize x y
    Tuple(union(x, relativecomplement(y, x)))
end

orderedunion(x::SymTuple, y::SymTuple) =
    unsafe_orderedunion(uniquely(x), uniquely(y))

"""
    sortedunion(x, y)

like `sort(orderedunion(x, y))`

- x, y must have no repeated entries

""" sortedunion

function unsafe_sortedunion(x::SymTuple, y::SymTuple)
    @nospecialize x y
    Tuple(sort(union(x, y)))
end

sortedunion(x::SymTuple, y::SymTuple) =
    unsafe_sortedunion(uniquely(x), uniquely(y))

"""
    relativecomplement(within, without)

A type-generalized set difference (`setdiff`).

Elements that are in `within` and are not in `without`.

Result is `within` less any elements shared with `without`.

defs:
* setA.filter(x => !setB.has(x));

""" relativecomplement

function relativecomplement(within::SymTuple, without::SymTuple)
    @nospecialize within without
    Tuple(setdiff(Set(within), Set(without)))
end

"""
    symmetricdifference(x, y)

The elements of x [resp. y] that do not appear in y [resp. x].

- the unshared elements of x appear before the unshared elements of y

defs:
*  union(a.except(b), b.except(a));
*  setwise-xor(a, b)
""" symmetricdifference

function symmetricdifference(x::SymTuple, y::SymTuple)
    @nospecialize x y
    Tuple(union(relativecomplement(x,y), relativecomplement(y,x)))
end

"""
    tuplediff(all, without)

similar to `setdiff(all, without)`

yields a tuple of symbols from `all` that are not in `without`

- `all` and `without` have no duplicate entries
- `without` is either empty, or contains symbols in `all`
- `length(all) >= length(without)`
- `length(result) = length(all) - length(without)`
- the result is ordered by appearance in `all`

from Jakob Nybo Nissen
""" tuplediff

function tuplediff(all::Tuple{Vararg{Symbol}}, without::Tuple{Vararg{Symbol}})
    ntuple(length(all) - length(without)) do i
        n = 0
        for (j, ia) in pairs(all)
            n += ia ∉ without
            n == i && return ia
        end
        error()
    end
end

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
