"""
     NamedTupleTools

This module provides useful NamedTuple tooling.

see [`namedtuple`](@ref),
    [`prototype`](@ref), [`isprototype`](@ref),
    [`rename`](@ref), [`retype`](@ref),
    [`issame`](@ref), [`≅`](@ref), [`canonical`](@ref),
    [`select`](@ref), [`delete`](@ref), [`separate`](@ref)
    [`merge_recursive`](@ref),
    [`field_count`](@ref), [`field_names`](@ref), [`field_types`](@ref),
    [`field_values`](@ref)
""" NamedTupleTools

module NamedTupleTools

export namedtuple, @namedtuple,
    prototype, isprototype,
    issame, ≅, canonical, 
    select, delete, separate,
    merge_recursive,
    field_count, field_names, field_types, field_values

using OrderedCollections

#=
   renaming avoids typed-method piracy
   Base: fieldcount, fieldnames, fieldtypes work with types only
   these work with types and instances both
   and are helpful with NamedTuples, structs, LittleDicts
=#

"""
    field_count

tally the number of fields in a NamedTuple, LittleDict, struct
- works with Types and instances both
""" field_count

"""
    field_names

obtains the names of the fields in a NamedTuple, LittleDict, struct
- works with Types and instances both
""" field_names

"""
    field_types

obtains the types of the fields in a NamedTuple, LittleDict, struct
- works with Types and instances both
""" field_types

"""
    field_values

obtains the values of the fields in a NamedTuple, LittleDict, struct
""" field_values

field_count(x::DataType)  = fieldcount(x)
field_count(x::T) where T = fieldcount(T)
field_count(x::LittleDict) = length(x.keys)

field_names(x::DataType)  = fieldnames(x)
field_names(x::T) where T = fieldnames(T)
field_names(x::LittleDict) = x.keys

field_types(x::DataType)  = fieldtypes(x)
field_types(x::T) where T = fieldtypes(T)
field_types(x::LittleDict) = (typeof(x.vals).parameters...,)

field_values(x::NamedTuple) = values(x)
field_values(x::T) where T = getfield.((x,), field_names(x))
field_values(x::LittleDict) = x.vals

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

"""
    prototype
    @prototype

 Constructs the type-free form of a NamedTuple

- prototype(::NamedTuple)
- prototype(::NTuple{N, Symbols|Strings})
- prototype(::Varargs{Symbols|Strings})

- @prototype(a, b, c) === NamedTuple{(:a, :b, :c)}
""" prototype

prototype(x::Type{NamedTuple{N,<:Tuple}}) where {N} = x
prototype(x::Type{NamedTuple{N,T}}) where {N,T} =
   NamedTuple{N,T} where T<:Tuple
prototype(x::NamedTuple{N,T}) where {N,T} = 
   NamedTuple{N,T} where T<:Tuple

prototype(xs::NTuple{N,Symbol}) where {N} = NamedTuple{xs}
prototype(xs::NTuple{N,String}) where {N} = prototype(Symbol.(xs))
prototype(xs...) = prototype(xs)
prototype(x) = prototype(namedtuple(x))

macro prototype(xs...)
    :(NamedTuple{$xs})
end

"""
    isprototype

is a NamedTuple given type-free.
""" isprototype

isprototype(@nospecialize x) = false
isprototype(@nospecialize T::UnionAll) = T <: NamedTuple

"""
    rename(<NamedTuple>, (<Symbols>))

Construct a prototype with names from (<Symbols>) and types from <NamedTuple>
- convenience function
"""
function rename(x::NamedTuple{N,T}, symbols::NTuple{M,Symbol}) where {N,T,M}
    length(N) === M || throw(ErrorException("lengths must be the same"))
    return NamedTuple{symbols, T}
end

"""
    retype(<NamedTuple>, (<Types>))

Construct a prototype with names from <NamedTuple> and types from (<Types>)
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

# conversion to a struct type and conversion to a struct instance

structify(sname::Symbol, x::Type{NamedTuple{N,T}) where {N,T} =
     genstruct(sname, field_names(x), field_types(x))
structify(sname::Symbol, x::NamedTuple) = structify(sname, typeof(x))

structify(T::DataType, x::NamedTuple) = T(field_values(x)...)

genstruct(sname::Symbol, names::NTuple{N,Symbol}, types::NTuple{N,Type}) = 
    eval(eval(parsedstruct(structname, names, types))))

parsedstruct(sname, names, types) =
     Meta.parse(parseable_struct(sname, names, types))
	
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

	
end  # NamedTupleTools


old
fieldvalues,
    @namedtuple,
       issame,  ≅,
       namedtuple, isprototype, prototype,
       fieldvalues, fieldvalues_fast,
       merge_recursive,
       separate,
       delete,
       select,
       ntfromstruct, structfromnt,
       @structfromnt

#=
import Base: fieldnames, values, merge, split

if isdefined(Base, :fieldtypes)
     import Base: fieldtypes
end
=#

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

function Base.sort(x::NamedTuple{N,T}) where {N,T}
    names = Tuple(sort([N...]))
    return NamedTuple{names}(x)
end

# internal support for low level manipulation

# accept comma delimited values
NamedTuple{T}(xs...) where {T} = NamedTuple{T}(xs)

# obtain aspects of a NamedTuple

"""
   fieldnames( namedtuple )
   fieldnames( typeof(namedtuple) )

Retrieve, as symbols, the name of each field in appearance (first..last) order.
- Note: for any nested field, this obtains only the name of top-level field.

Technical note: With some applications, this function is used heavily.
Fortunately, the operation is completely determined by the argument's type.
"""
Base.fieldnames(x::NamedTuple{N,T}) where {N,T} = fieldnames(NamedTuple{N,T})

"""
    field_types( namedtuple )
    field_types( typeof(namedtuple) )

Retrieve the values' types as `Tuple{<types>}`.

see: [`fieldtypes`](@ref)
"""
field_types(x::T) where {N, S, T<:NamedTuple{N,S}} = S
field_types(::Type{T}) where {N, S<:Tuple, T<:NamedTuple{N,S}} = S
field_types(::Type{T}) where {N, T<:NamedTuple{N}} = NTuple{length(N),Any}
			
"""
    fieldtypes( namedtuple )
    fieldtypes( typeof(namedtuple) )

Retrieve the values' types as a tuple of types `(<types>,)`.

see: [`field_types`](@ref)
"""			
fieldtypes(x::T) where {N, S, T<:NamedTuple{N,S}} = detuple(S)
fieldtypes(::Type{T}) where {N, S<:Tuple, T<:NamedTuple{N,S}} = detuple(S)
fieldtypes(::Type{T}) where {N, T<:NamedTuple{N}} =
    ntuple(i->Any, length(N))

fieldtypes(x::T) where {T} = fieldtypes(T) # for structs
			
"""
    fieldvalues(x)

obtain values assigned to fields of a struct type (in field order)
- `NamedTuples` and `struct`s are struct types
"""
function fieldvalues(x::T) where {T}
    getfield.((x,), fieldnames(T))
end

"""
    fieldvalues_fast
	
obtain values assigned to fields (in field order)

- This generates new type-specific functions
- Use spairingly, for time-critical situations
""" fieldvalues_fast

@generated fieldvalues_fast(x) = Expr(:tuple, (:(x.$f) for f=fieldnames(x))...)
	
#=	
function fieldvalues(x::T) where {T}
     isstructtype(T) && return unsafe_fieldvalues(x)
     throw(ArgumentError("$(T) is not a struct type"))
end

unsafe_fieldvalues(x::T) where {T} = getfield.(Ref(x), fieldnames(T))
=#
	
namedtuple(x::DataType) = ntfromstruct(x)

function ntfromstruct(x::T) where {T}
    !isstructtype(T) && throw(ArgumentError("$(T) is not a struct type"))
    names = fieldnames(T)
    values = getfield.((x,), names)
    return NamedTuple{names}(values)
end



"""
    retuple( (_) )

Generate a `Tuple` with the given internal types as a `Tuple{_}`.
"""
retuple(x::Tuple) = Tuple{x...,}


"""
    detuple( Tuple{_} )

Retrieve the types that are internal to the `Tuple` as a (_).
"""


structfrom(structname::Symbol, x::Type{NamedTuple{N,T}) where {N,T} =
     structfrom(structname, field_names(nt), field_types(nt))

structfrom(structname::Symbol, names::NTuple{N,Symbol}, types::NTuple{N,Type}) = 
    eval(eval(Meta.parse(struct_from(structname, names, types))))

# Expr part from Fredrik Ekre
struct_from(structname, names, types) =
    "Expr(:struct,
        false,
        Expr(:curly,
             :$structname
        ),
        Expr(:block,
             map((x,y) -> Expr(:(::), x, y), $names, $types)...
        )
   )"


detuple(::Type{T}) where {T<:Tuple} = Tuple(T.parameters)
	
# an instance of type S, a Struct
function structfromnt(::Type{S}, x::NT) where {S, N, T, NT<:NamedTuple{N,T}}
     names = N
     values = fieldvalues(x)
     if fieldnames(S) != names
          throw(ErrorException("fields in ($S) do not match ($x)"))
     end
     return S(values...,)
end

# the Struct itself
function struct_from(structname::Union{Symbol, String}, nt::NamedTuple{N,T}) where {N,T}
    sname = Symbol(structname)
    names = N
    types = detuple(T)
    tostruct = Meta.parse(struct_from(sname, names, types))
    result = eval(tostruct) # generate Struct
    return result
end

macro structfromnt(sname, nt)
    :( eval(structfromnt($(esc(sname)), $(esc(nt)))) )
end

function structfrom(

structfrom(structname, names, types) = eval(eval(Meta.parse(struct_from(structname, names, types))))

"""
    namedtuple(namesforvalues, valuesfornames)
"""

# from kristoffer.carlsson

@inline function namedtuple(namesforvalues::NTuple{N,Symbol}, valuesfornames) where {N}
    N == length(valuesfornames) || throw(ErrorException("lengths must match"))
    return (; zip(namesforvalues, valuesfornames)...,)
end

@inline function namedtuple(namesforvalues::Vector{Symbol}, valuesfornames)
    length(namesforvalues) == length(valuesfornames) || throw(ErrorException("lengths must match"))
     return (; zip(namesforvalues, valuesfornames)...,)
end

namedtuple(namesforvalues::Vector{S}, valuesfornames) where {N,S<:AbstractString} =
    namedtuple(Symbol.(namesforvalues), valuesfornames)

namedtuple(namesforvalues::NTuple{N,S}, valuesfornames) where {N,S<:AbstractString} =
    namedtuple(Symbol.(namesforvalues), valuesfornames)


"""
    namedtuple(  name1, name2, ..  )
    namedtuple( (name1, name2, ..) )
    namedtuple(  namedtuple )

Generate a NamedTuple prototype by specifying or obtaining the fieldnames.
The prototype is applied to fieldvalues, giving a completed NamedTuple.

# Example

julia> ntprototype = namedtuple( :a, :b, :c )

NamedTuple{(:a, :b, :c),T} where T<:Tuple

julia> nt123 = ntprototype(1, 2, 3)

(a = 1, b = 2, c = 3)

julia> ntAb3 = ntprototype("A", "b", 3)

(a = "A", b = "b", c = 3)

see: [`isprototype`](@ref)
"""
namedtuple(names::NTuple{N,Symbol}) where {N} = NamedTuple{names}
namedtuple(names::Vararg{Symbol}) = NamedTuple{names}
namedtuple(names::NTuple{N,String}) where {N}  = namedtuple(Symbol.(names))
namedtuple(names::Vararg{String}) = namedtuple(Symbol.(names))
namedtuple(names::T) where {T<:AbstractVector{Symbol}} = namedtuple(names...,)
namedtuple(names::T) where {T<:AbstractVector{String}} = namedtuple(Symbol.(names))

namedtuple(nt::T) where {N,V,T<:NamedTuple{N,V}} = NamedTuple{N}

"""
    prototype(namedtuple)
    prototype(typeof(namedtuple))

provides the prototype `NamedTuple{names, T} where T<:Tuple`
    - `names` is a tuple of symbols
"""
prototype(::NamedTuple{A,B}) where {A,B} = NamedTuple{A}
prototype(::Type{NamedTuple{A,B}}) where {A,B} = NamedTuple{A}

"""
    isprototype( ntprototype )
    isprototype( namedtuple  )

Predicate that identifies NamedTuple prototypes.

see: [`namedtuple`](@ref)
"""
isprototype(::Type{T}) where {T<:NamedTuple} = eltype(T) === Any
isprototype(nt::T) where {T<:NamedTuple} = false
isprototype(::Type{UnionAll}) = false

"""
   delete(namedtuple, symbol(s)|Tuple)
   delete(ntprototype, symbol(s)|Tuple)

Generate a namedtuple [ntprototype] from the first arg omitting fields present in the second arg.

see: [`merge`](@ref)
"""
delete(a::NamedTuple, b::Symbol) = Base.structdiff(a, namedtuple(b))
delete(a::NamedTuple, b::NTuple{N,Symbol}) where {N} = Base.structdiff(a, namedtuple(b))
delete(a::NamedTuple, bs::Vararg{Symbol}) = Base.structdiff(a, namedtuple(bs))

delete(::Type{T}, b::Symbol) where {S,T<:NamedTuple{S}} = namedtuple((Base.setdiff(S,(b,))...,))
delete(::Type{T}, b::NTuple{N,Symbol}) where {S,N,T<:NamedTuple{S}} = namedtuple((Base.setdiff(S,b)...,))
delete(::Type{T}, bs::Vararg{Symbol}) where {S,N,T<:NamedTuple{S}} = namedtuple((Base.setdiff(S,bs)...,))

"""
    separate(namedtuple, symbol(s)|Tuple)

Generate two namedtuples, the first with only the fields in the second arg, the
second with all but the fields in the second arg, such that
`merge(split(nt, ks)...) == nt` when `ks` contains the first fields of `nt`.
"""
separate(nt::NamedTuple, ks::Symbol) = separate(nt, (ks,))
separate(nt::NamedTuple, ks) = select(nt, ks), delete(nt, ks)

Base.split(nt::NamedTuple, ks) = error("use `separate` instead of `split`")

"""
   select(namedtuple, symbol(s)|Tuple)
   select(ntprototype, symbol(s)|Tuple)

Generate a namedtuple [ntprototype] from the first arg, including only fields present in the second arg.

see: [`merge`](@ref)
"""

function select(nt::NamedTuple, keepkeys::Tuple{Vararg{Symbol}})
    syms = filter(x->x!==:_,map(k->in(k,keepkeys) ? k : :_ ,keys(nt)))
    return NamedTuple{syms}(nt)
end

function remove(nt::NamedTuple, omitkeys::Tuple{Vararg{Symbol}})
    syms = filter(x->x!==:_,map(k->in(k,omitkeys) ? (:_) : k ,keys(nt)))
    return NamedTuple{syms}(nt)
end

# from a discourse post by Jeff Bezanson
select(nt::NamedTuple, keys::Tuple{Vararg{Symbol}}) = NamedTuple{keys}(nt)
# developed therefrom
select(nt::NamedTuple, keys::Vararg{Symbol}) = NamedTuple{keys}(nt)
select(nt::NamedTuple, keys::AbstractVector{Symbol}) = NamedTuple{Tuple(keys)}(nt)
select(nt::NamedTuple, nt4keys::NamedTuple) = select(nt, keys(nt4keys))
#=

julia> Base.fieldnames(::Type{NamedTuple{N,T}}) where {N,T} = N

julia> Base.fieldnames(x::NamedTuple{N,T}) where {N,T} = N

julia> """
           flatten(args...) -> ::Tuple
       Flatten one or more tuples into a single tuple, such that every element of that tuple is itself not a tuple, otherwise it would also be expanded (i.e. flattened).
       """
"    flatten(args...) -> ::Tuple\nFlatten one or more tuples into a single tuple, such that every element of that tuple is itself not a tuple, otherwise it would also be expanded (i.e. flattened).\n"

julia> flatten(x::Any) = (x,)
flatten (generic function with 4 methods)

julia> flatten(t::Tuple{}) = ()
flatten (generic function with 4 methods)

julia> flatten(t::Tuple) = (flatten(t[1])..., flatten(Base.tail(t))...)
flatten (generic function with 4 methods)

julia> flatten(x, r...) = (flatten(x)..., flatten(r)...)
flatten (generic function with 4 methods)

julia> nms=(unique(flatten(fieldnames.((tnt1,tnt2))))...,)
(:a, :c, :b, :d, :e)

julia> nms=(unique(flatten(fieldnames.((nt1,nt3))))...,)
(:a, :c, :d)
=#

#=
   flatten is from https://github.com/Jutho/TupleTools.jl

   "Flatten one or more tuples into a single tuple,
    such that every element of that tuple is itself not a tuple,
    otherwise it would also be expanded (i.e. flattened)."
=#
flatten(x::Any) = (x,)
flatten(t::Tuple{}) = ()
flatten(t::Tuple) = (flatten(t[1])..., flatten(Base.tail(t))...)
flatten(x, r...) = (flatten(x)..., flatten(r)...)

#=
uniquenames(xs)
 obtains the fieldnames present in all xs..., as a unique flattened tuple
=#
uniquenames(nts::Tuple{Vararg{T}}) where {T} =
  (unique(flatten(fieldnames.(nts)))...,)

tuple_unique(xs...) = (unique(xs)...,)

#=

@pure function merge_names(an::Tuple{Vararg{Symbol}}, bn::Tuple{Vararg{Symbol}})
    @nospecialize an bn
    names = Symbol[an...]
    for n in bn
        if !sym_in(n, an)
            push!(names, n)
        end
    end
    (names...,)
end

@pure function merge_types(names::Tuple{Vararg{Symbol}}, a::Type{<:NamedTuple}, b::Type{<:NamedTuple})
    @nospecialize names a b
    bn = _nt_names(b)
    return Tuple{Any[ fieldtype(sym_in(names[n], bn) ? b : a, names[n]) for n in 1:length(names) ]...}
end

=#



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

#=
function firstin(x::NamedTuple{N,T}) where {N,T}
    name = first(N)
    value = first(x)
    return NamedTuple{(name,)}((value,),)
end

function firstrest(x::NamedTuple{N,T}) where {N,T}
    isempty(x) && return x
    name = first(N)
    value = first(x)
    firstnt = NamedTuple{(name,)}((value,),)
    names = Base.diff_names(fieldnames(x),(name,))
    isempty(names) && return firstnt
    values = getfield.(Ref(x), names)
    restnt = NamedTuple{names}(values)
    return firstnt, restnt
end
=#

"""
    split(namedtuple, symbol(s)|Tuple)

Generate two namedtuples, the first with only the fields in the second arg, the
second with all but the fields in the second arg, such that
`merge(split(nt, ks)...) == nt` when `ks` contains the first fields of `nt`.
"""
split(nt::NamedTuple, ks::Symbol) = split(nt, (ks,))
split(nt::NamedTuple, ks) = select(nt, ks), delete(nt, ks)

#=  interconvert: NamedTuple <--> Dict =#

uniontype(nt::NamedTuple) = Union{typeof.(values(nt))...,}

"""
    gather_(x::Iterable)

Collect the elements of x into a Tuple, in their iterated order.
"""
@inline gather_(x::T) where {T} = (collect(x)...,)

if VERSION > v"1.5.9"
 	namedtuple(d::T) where {T<:AbstractDict{Symbol,V}} where {V} =
		NamedTuple(d)
else
	namedtuple(d::T) where {T<:AbstractDict{Symbol,V}} where {V} =
	    NamedTuple{gather_(keys(d)), NTuple{length(d), V}}(gather_(values(d)))
end

namedtuple(d::T) where {T<:AbstractDict{S,V}} where {S<:AbstractString, V} =
    NamedTuple{Symbol.(gather_(keys(d))), NTuple{length(d), V}}(gather_(values(d)))
namedtuple(d::T) where {T<:AbstractDict{Symbol,Any}} =
    NamedTuple{gather_(keys(d)), Tuple{typeof.(values(d))...}}(gather_(values(d)))
namedtuple(d::T) where {T<:AbstractDict{S,Any}} where {S<:AbstractString} =
    NamedTuple{Symbol.(gather_(keys(d))), Tuple{typeof.(values(d))...}}(gather_(values(d)))

# use: dict = convert(Dict, nt)
#=
   for Dict{Symbol,Any}:
   Base.convert(::Type{Dict}, x::NT) where {N, NT<:NamedTuple{N}} =
       Dict([sym=>val for (sym,val) in zip(fieldnames(x), fieldvalues(x))])
=#
Base.convert(::Type{D}, x::NT) where {D<:AbstractDict, N, NT<:NamedTuple{N}} =
    D{Symbol, uniontype(x)}([sym=>val for (sym,val) in zip(fieldnames(x), fieldvalues(x))])

dictionary(nt::NamedTuple) = convert(Dict, nt) # deprecated

# from PR by pdeffebach (Vector of Pairs becomes NamedTuple)
function namedtuple(v::Vector{<:Pair{<:Symbol}})
    N = length(v)
    NamedTuple{ntuple(i -> v[i][1], N)}(ntuple(i -> v[i][2], N))
end
# with names as strings
function namedtuple(v::Vector{<:Pair{String}})
    N = length(v)
    NamedTuple{ntuple(i -> Symbol(v[i][1]), N)}(ntuple(i -> v[i][2], N))
end
# NamedTuple becomes a Vector of Pairs
Base.convert(::Type{Vector{Pair}}, nt::NamedTuple) =  map(kv->Pair(first(kv), last(kv)), zip(keys(nt), values(nt)))

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

end # module NamedTupleTools
