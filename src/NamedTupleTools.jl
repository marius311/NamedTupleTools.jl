"""
     NamedTupleTools

This module provides useful NamedTuple tooling.

see [`namedtuple`](@ref),
    [`namedproto`](@ref), [`isnamedproto`](@ref),
    [`rename`](@ref), [`retype`](@ref),
    [`issame`](@ref), [`≅`](@ref), [`canonical`](@ref),
    [`select`](@ref), [`delete`](@ref), [`separate`](@ref)
    [`merge_recursive`](@ref),
    [`field_count`](@ref), [`field_names`](@ref), [`field_types`](@ref),
    [`field_values`](@ref),
    [`@newstruct`](@ref), [`construct`](@ref)
""" NamedTupleTools

module NamedTupleTools

export namedtuple, @namedtuple,
    namedproto, isnamedproto,
    issame, ≅, canonical, 
    select, delete, separate,
    merge_recursive,
    field_count, field_names, field_types, field_values,
    construct #, newstruct, @newstruct

using OrderedCollections

macro assign(var, val)
    :($(esc(var)) = $(esc(val)))
end

# field_count, field_names, field_types, field_vals
include("fieldops.jl")

"""
    namedtuple

Construct a NamedTuple (avoiding type piracy)

- namedtuple(symbols)
- namedtuple(symbols, types)
- namedtuple(symbols, values)
> where symbols, types, values are tuples 

- namedtuple(struct)
- namedtuple(::LittleDict)
- namedtuple(::AbstractDict)
- namedtuple(::Vector{Pair})
""" namedtuple

namedtuple(x::NamedTuple) = x
namedtuple(x::Type{<:NamedTuple}) = x

namedtuple(names::NTuple{N,Symbol}) where N =
   NamedTuple{names, T} where T<:Tuple
namedtuple(names::NTuple{N,Symbol}, types::NTuple{N,Type}) where N =
   NamedTuple{names,Tuple{types...}}
namedtuple(names::NTuple{N,Symbol}, values::NTuple{N,Any}) where N =
   NamedTuple{names}(values)

namedtuple(x::DataType) =
    NamedTuple{field_names(x), Tuple{field_types(x)...}}
namedtuple(x::T) where T =
    namedtuple(T)(field_values(x))

namedtuple(x::LittleDict) = NamedTuple{x.keys}(x.vals)
namedtuple(x::AbstractDict) = NamedTuple{Tuple(keys(x))}(values(x))

# from PR by pdeffebach (Vector of Pairs becomes NamedTuple)
function namedtuple(v::Vector{<:Pair{<:Symbol}})
    N = length(v)
    NamedTuple{ntuple(i -> v[i][1], N)}(ntuple(i -> v[i][2], N))
end

# with names as strings
namedtuple(names::NTuple{N,String}) where N =
   namedtuple(Symbol.(names))
namedtuple(names::NTuple{N,String}, types::NTuple{N,Type}) where N =
   namedtuple(Symbol.(names), types)
namedtuple(names::NTuple{N,String}, values::NTuple{N,Any}) where N =
   namedtuple(Symbol.(names), values)
function namedtuple(v::Vector{<:Pair{String}})
    N = length(v)
    NamedTuple{ntuple(i -> Symbol(v[i][1]), N)}(ntuple(i -> v[i][2], N))
end


# from Sebastian Pfitzner (on Slack)
macro namedtuple(vars...)
   args = Any[]
   for v in vars
       if Meta.isexpr(v, :(=)) || Meta.isexpr(v, :...)
           push!(args, esc(v))
       else
           push!(args, Expr(:(=), esc(v), esc(v)))
       end
   end
   expr = Expr(:tuple, Expr(:parameters, args...))
   return expr
end

"""
    namedproto
    @namedproto

 Constructs the type-free form of a NamedTuple

- namedproto(::NamedTuple)
- namedproto(::NTuple{N, Symbols|Strings})
- namedproto(::Varargs{Symbols|Strings})

- @namedproto(a, b, c) === NamedTuple{(:a, :b, :c)}
""" namedproto

namedproto(x::Type{NamedTuple{N,<:Tuple}}) where {N} = x
namedproto(x::Type{NamedTuple{N,T}}) where {N,T} =
   NamedTuple{N,T} where T<:Tuple
namedproto(x::NamedTuple{N,T}) where {N,T} = 
   NamedTuple{N,T} where T<:Tuple

namedproto(xs::NTuple{N,Symbol}) where {N} = NamedTuple{xs}
namedproto(xs::NTuple{N,String}) where {N} = namedproto(Symbol.(xs))
namedproto(xs...) = namedproto(xs)
namedproto(x) = namedproto(namedtuple(x))

macro namedproto(xs...)
    :(NamedTuple{$xs})
end

"""
    isnamedproto

is a NamedTuple given type-free.
""" isnamedproto

isnamedproto(@nospecialize x) = false
isnamedproto(@nospecialize T::UnionAll) = T <: NamedTuple

"""
    rename(<NamedTuple>, (<Symbols>))

Construct a namedproto with names from (<Symbols>) and types from <NamedTuple>
- convenience function
"""
function rename(x::NamedTuple{N,T}, symbols::NTuple{M,Symbol}) where {N,T,M}
    length(N) === M || throw(ErrorException("lengths must be the same"))
    return NamedTuple{symbols, T}
end

"""
    retype(<NamedTuple>, (<Types>))

Construct a namedproto with names from <NamedTuple> and types from (<Types>)
- convenience function
"""
function retype(x::NamedTuple{N,T}, types::NTuple{M,<:Type}) where {N,T,M}
    length(N) === M || throw(ErrorException("lengths must be the same"))
    return NamedTuple{N, Tuple{types...}}
end

"""
    canonical(::NamedTuple)
    canonical(::Type{NamedTuple})

Provides a canonical order, sorting over the field names
""" canonical

function canonical(x::NamedTuple{N,T}) where {N,T}
    syms = [N...]
    sort!(syms)
    return NamedTuple{Tuple(syms)}(x)
end

function canonical(x::Type{NamedTuple{N,T}}) where {N,T}
    idxs = collect(1:length(N))
    sortperm!(idxs, [N...])
    typs = Tuple{T.parameters[idxs]...}
    return NamedTuple{N[idxs],typs}
end

"""
     issame(nt1, nt2)
     nt ≊ nt2

field order independent equality

- issame((a=1, b=2), (b=2, a=1))
- (a=1, b=2) ≅ (b=2, a=1)
""" issame, ≅

function issame(x::NamedTuple{N,T}, y::NamedTuple{N1,T1}) where {N,T,N1,T1}
    length(N) === length(N1) &&
    foldl(&, foldl(.|, ((n .== N) for n=N1))) &&
    foldl(&, (getfield(x,k) === getfield(y,k) for k=N))
end

const ≅ = issame

"""
     select
"""
function select(nt::NamedTuple, keepkeys::Tuple{Vararg{Symbol}})
    syms = filter(x->x!==:_,map(k->in(k,keepkeys) ? k : :_ ,keys(nt)))
    return NamedTuple{syms}(nt)
end
select(nt::NamedTuple, keepkeys::Vector{Symbol}) = select(nt, Tuple(keepkeys))
select(nt::NamedTuple, keepkeys::Vararg{Symbol}) = select(nt, keepkeys)
select(nt::NamedTuple, keepkeys::Tuple{Vararg{String}}) = select(nt, Symbol.(keepkeys))
select(nt::NamedTuple, keepkeys::Vector{String}) = select(nt, Tuple(keepkeys))
select(nt::NamedTuple, keepkeys::Vararg{String}) = select(nt, keepkeys)

"""
     delete
"""
function delete(nt::NamedTuple, omitkeys::Tuple{Vararg{Symbol}})
    syms = filter(x->x!==:_,map(k->in(k,omitkeys) ? (:_) : k ,keys(nt)))
    return NamedTuple{syms}(nt)
end
delete(nt::NamedTuple, omitkeys::Vector{Symbol}) = delete(nt, Tuple(omitkeys))
delete(nt::NamedTuple, omitkeys::Vararg{Symbol}) = delete(nt, omitkeys)
delete(nt::NamedTuple, omitkeys::Tuple{Vararg{String}}) = delete(nt, Symbol.(omitkeys))
delete(nt::NamedTuple, omitkeys::Vector{String}) = delete(nt, Tuple(omitkeys))
delete(nt::NamedTuple, omitkeys::Vararg{String}) = delete(nt, omitkeys)

"""
    separate(namedtuple, symbol(s)|Tuple)

Generate two namedtuples, the first with only the fields in the second arg, the
second with all but the fields in the second arg, such that
`merge(separate(nt, ks)...) == nt` when `ks` contains the first fields of `nt`.
"""
function separate(nt::NamedTuple, sepkeys::Tuple{Vararg{Symbol}})
    return select(nt, sepkeys), delete(nt, sepkeys)
end
separate(nt::NamedTuple, sepkeys::Vector{Symbol}) = separate(nt, Tuple(sepkeys))
separate(nt::NamedTuple, sepkeys::Vararg{Symbol}) = separate(nt, sepkeys)
separate(nt::NamedTuple, sepkeys::Tuple{Vararg{String}}) = separate(nt, Symbol.(sepkeys))
separate(nt::NamedTuple, sepkeys::Vector{String}) = separate(nt, Tuple(sepkeys))
separate(nt::NamedTuple, sepkeys::Vararg{String}) = separate(nt, sepkeys)

# convert NamedTuple into Vector{Pair}, LittleDict, Dict, struct
# note: supplying conversions is not considered type piracy
#       altering conversions would be improper

Base.convert(::Type{Vector{Pair}}, x::NamedTuple) =
    [map(Pair, field_names(x), field_values(x))...]

Base.convert(::Type{LittleDict}, x::NamedTuple) =
    LittleDict(field_names(x), field_values(x))

Base.convert(::Type{T}, x::NamedTuple) where {T<:AbstractDict} =
    T(convert(Vector{Pair}, x))

function Base.convert(::Type{NamedTuple}, x::AbstractVector{Pair}; types::Bool=false)
    syms  = first.(x)
    other = last.(x)
    if !types
        NamedTuple{syms}(other)
    elseif all(isa.(other, (Type,)))
	NamedTuple{syms, Tuple{other...}}
    else
        throw(ErrorException("unknown type in $other"))
    end
end

namedtuple(x::DataType) =
    NamedTuple{field_names(x), Tuple{field_types(x)...}}
namedtuple(x::T) where T =
    namedtuple(T)(field_values(x))

namedtuple(x::LittleDict) = NamedTuple{x.keys}(x.vals)
namedtuple(x::AbstractDict) = NamedTuple{Tuple(keys(x))}(values(x))

# NamedTuples -> structs
"""
    construct(<struct type>, NamedTuple)

Construct an instance of the struct using the values from the NamedTuple.
- unchecked precondition: field types mutually conform
"""
function metaparsed(sname, fnames, ftypes)
    Meta.parse(strstruct(sname, fnames, ftypes))
end
function metaparsed1(sname, fnames, ftypes)
    Meta.parse(strstruct(sname, fnames, ftypes))
end

evalparsed(sname, fnames, ftypes) = eval(metaparsed(sname, fnames, ftypes))
evalparsed1(sname, fnames, ftypes) = eval(metaparsed1(sname, fnames, ftypes))

eval2parsed(sname, fnames, ftypes) = eval(evalparsed(sname, fnames, ftypes))
eval2parsed1(sname, fnames, ftypes) = eval(evalparsed1(sname, fnames, ftypes))

macro evalparsed(sname, fnames, ftypes)
    :(evalparsed($sname, esc($fnames), esc($ftypes)))
end
macro evalparsed1(sname, fnames, ftypes)
    :(evalparsed1($sname, esc($fnames), esc($ftypes)))
end
macro eval2parsed(sname, fnames, ftypes)
    :(eval2parsed($sname, esc($fnames), esc($ftypes)))
end
macro eval2parsed1(sname, fnames, ftypes)
    :(eval2parsed1($sname, esc($fnames), esc($ftypes)))
end
						
			
const prestruct = ":(\$(Expr(:toplevel, quote begin struct "
const supstruct = " <: "
const poststruct = " end; end; end)))"
const prestruct1 = "(Expr(:toplevel, quote begin struct "
const poststruct1 = " end; end; end))"
	
function strstruct(sname, fnames, ftypes; abstract=Any)
	string(prestruct, sname, abstype(abstract), midstruct(fnames, ftypes), poststruct)
end
function strstruct1(sname, fnames, ftypes; abstract=Any)
	string(prestruct1, sname, abstype(abstract), midstruct(fnames, ftypes), poststruct1)
end

abstype(abstract)	= string(supstruct, abstract, ' ')
function midstruct(names,types)
    strs = map((n,t)->string(n,"::",t,"; "),names,types)
    return join(strs)
end


construct(T::DataType, x::NamedTuple) = T(field_values(x)...)

#=
function newstruct(sname::Symbol, x::Type{NamedTuple{N,T}}) where {N,T}
     return newstruct(sname, N, (T.parameters...,))
end

newstruct(sname::Symbol, x::NamedTuple{N,T}) where {N,T} = newstruct(sname, NamedTuple{N,T})
newstruct(sname::String, x) = newstruct(Symbol(sname), x)

newstruct(sname::Symbol, names::NTuple{N,Symbol}, types::NTuple{N,Type}) where N = 
    eval(eval(parsedstruct(sname, names, types)))

						function newstruct(sname::Symbol, names::NTuple{N,Symbol}, types::NTuple{N,Type}) where N
    parsed = Meta.parse(parseable_struct(sname, names, types))
    return eval(parsed)
end

parsedstruct(sname, names, types) =
     Meta.parse(parseable_struct(sname, names, types))
=#

# Expr part from Fredrik Ekre
parseable_struct(structname, names, types) =
    "Expr(:struct,
        false,
        Expr(:curly,
             :$structname
        ),
        Expr(:block,
             map((x,y) -> Expr(:(::), x, y), $names, $types)...
        )
   )"

"""
    merge(namedtuple1, namedtuple2)
    merge(nt1, nt2, nt3, ..)

Generate a namedtuple with all fieldnames and values of namedtuple2
    and every fieldname of namedtuple1 that does not occur in namedtuple2
    along with their values.

see: [`delete!`](@ref)
"""

# merge(nt1::T1, nt2::T2, ...) exists in Julia versions >= 1.1
if VERSION < v"1.1"
	Base.merge(a::NamedTuple{an}, b::NamedTuple{bn}, c::NamedTuple{cn}) where {an, bn, cn} =
		reduce(merge,(a, b, c))
	Base.merge(a::NamedTuple{an}, b::NamedTuple{bn}, c::NamedTuple{cn}, d::NamedTuple{dn}) where {an, bn, cn, dn} =
		reduce(merge,(a, b, c, d))
	Base.merge(a::NamedTuple{an}, b::NamedTuple{bn}, c::NamedTuple{cn}, d::NamedTuple{dn}, e::NamedTuple{en}) where {an, bn, cn, dn, en} =
		reduce(merge,(a, b, c, d, e))
	Base.merge(a::NamedTuple{an}, b::NamedTuple{bn}, c::NamedTuple{cn}, d::NamedTuple{dn}, e::NamedTuple{en}, f::NamedTuple{fn}) where {an, bn, cn, dn, en, fn} =
		reduce(merge,(a, b, c, d, e, f))
	Base.merge(a::NamedTuple{an}, b::NamedTuple{bn}, c::NamedTuple{cn}, d::NamedTuple{dn}, e::NamedTuple{en}, f::NamedTuple{fn}, g::NamedTuple{gn}) where {an, bn, cn, dn, en, fn, gn} =
		reduce(merge,(a, b, c, d, e, f, g))
end

"""
    merge_recursive(nt1, nt2)
    merge_recursive(nt1, nt2, nt3, ..)

Recursively merge namedtuples. Where more than one of the namedtuple args share the same fieldname (same key),
    the leftmost argument's key's value will be propogated. Where each namedtuple has distinct fieldnames (keys),
    all of named fields will be gathered with their respective values. The named fields will appear in the same
    order they are encountered (leftmost arg, second leftmost arg, .., second rightmost arg, rightmost arg).

If there are no nested namedtuples, `merge(nt1, nts..., recursive=true)` is the same as `merge(nt1, nts...)`.
```
a = (food = (fruits = (orange = "mango", white = "pear"),
             liquids = (water = "still", wine = "burgandy")))

b = (food = (fruits = (yellow = "banana", orange = "papaya"),
             liquids = (water = "sparkling", wine = "champagne"),
             bread = "multigrain"))

merge(b,a)  == (fruits  = (orange = "mango", white = "pear"),
                liquids = (water = "still", wine = "burgandy"),
                bread   = "multigrain")

merge_recursive(b,a) ==
               (fruits  = (yellow = "banana", orange = "mango", white = "pear"),
                liquids = (water = "still", wine = "burgandy"),
                bread   = "multigrain")

merge(a,b)  == (fruits  = (yellow = "banana", orange = "papaya"),
                liquids = (water = "sparkling", wine = "champagne"),
                bread   = "multigrain")

merge_recursive(a,b) ==
               (fruits  = (orange = "papaya", white = "pear", yellow = "banana"),
                liquids = (water = "sparkling", wine = "champagne"),
                bread   = "multigrain")
```
see: [`merge`](@ref)
""" merge_recursive

#=
anonymous placeholder for unvalued namedtuple keys
(only used in recursion definitions)
=#
struct _Unvalued end
const _unvalued = _Unvalued()

merge_recursive(nt::NamedTuple) = nt

merge_recursive(::_Unvalued, ::_Unvalued) = _unvalued
merge_recursive(x, ::_Unvalued) = x
merge_recursive(m::_Unvalued, x) = merge_recursive(x, m)
merge_recursive(x, y) = y

function merge_recursive(nt1::NamedTuple, nt2::NamedTuple)
    all_keys = union(keys(nt1), keys(nt2))
    gen = Base.Generator(all_keys) do key
        v1 = get(nt1, key, _unvalued)
        v2 = get(nt2, key, _unvalued)
        key => merge_recursive(v1, v2)
    end
    return (; gen...)
end

merge_recursive(nt1::NamedTuple, nt2::NamedTuple, nts...) =
    merge_recursive(merge_recursive(nt1, nt2), nts...)

function unnest(nt::NamedTuple{N,T}; sep=".") where {N,T}
    flatkeys = []
    flatvals = []
    syms = field_names(nt)
    vals = field_values(nt)

    for idx in eachindex(syms)
        ky = syms[idx]
        vl = vals[idx]
        if isa(vl, NamedTuple)
			flat = flatten(vl, sep=sep)
			flatsyms = map(k->Symbol(string(ky, sep, k)), field_names(flat))
			append!(flatkeys, flatsyms)
			append!(flatvals, field_values(flat))
        else
			push!(flatkeys, ky)
			push!(flatvals, vl)
        end
     end

    ntkeys = (flatkeys...,)
    ntvals = (flatvals...,)
    NamedTuple{ntkeys}(ntvals)
end

end  # NamedTupleTools
