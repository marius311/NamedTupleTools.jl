"""
     NamedTupleTools

This module provides some useful NamedTuple tooling.

@ref(tuplenames), @ref(fieldnames), @ref(keys), @ref(values), @ref(remove)
"""
module NamedTupleTools

export tuplenames, isprototype

import Base: fieldnames, keys, values, delete!, merge

# accept comma delimited values
Base.NamedTuple{T}(xs...) where {T} = NamedTuple{T}(xs)

"""
    tuplenames(  name1, name2, ..  )
    tuplenames( (name1, name2, ..) )
    tuplenames(  namedtuple )

Generate a NamedTuple prototype by specifying or obtaining the fieldnames.
The prototype is applied to fieldvalues, giving a completed NamedTuple.
"""
tuplenames(names::NTuple{N,Symbol}) where {N} = NamedTuple{names}
tuplenames(names::Vararg{Symbol}) = NamedTuple{names}
tuplenames(nt::T) where {T<:NamedTuple} = tuplenames(fieldnames(nt))

"""
    fieldnames( ntprototype )
    fieldnames( namedtuple  )

Retrieve the names as a tuple of symbols.
"""
fieldnames(::Type{T}) where {T<:NamedTuple} = Base._nt_names(T)
fieldnames(nt::T) where {T<:NamedTuple} = Base._nt_names(T)

"""
    keys( ntprototype )
    keys( namedtuple  )

Retrieve the names as a tuple of symbols.
"""
keys(::Type{T}) where {T<:NamedTuple} = Base._nt_names(T)
# keys(namedtuple) already defined

"""
    values( namedtuple )

Retrieve the values as a tuple.
"""
values(::Type{T}) where {T<:NamedTuple} = ()
# values(nt::NamedTuple) is already defined

"""
    isprototype( ntprototype )
    isprototype( namedtuple  )

Predicate that identifies NamedTuple prototypes.
"""
isprototype(::Type{T}) where {T<:NamedTuple} = true
isprototype(nt::T) where {T<:NamedTuple} = false

"""
   delete!(namedtuple, symbol(s)|Tuple)
   delete!(ntprototype, symbol(s)|Tuple)
   
Generate a namedtuple [ntprototype] from the first arg omitting fields present in the second arg.
"""
delete!(a::NamedTuple, b::Symbol) = Base.structdiff(a, tuplenames(b))
delete!(a::NamedTuple, b::NTuple{N,Symbol}) where {N} = Base.structdiff(a, tuplenames(b))
delete!(a::NamedTuple, bs::Vararg{Symbol}) = Base.structdiff(a, tuplenames(bs))

delete!(::Type{T}, b::Symbol) where {S,T<:NamedTuple{S}} = tuplenames((Base.setdiff(S,(b,))...,))
delete!(::Type{T}, b::NTuple{N,Symbol}) where {S,N,T<:NamedTuple{S}} = tuplenames((Base.setdiff(S,b)...,))
delete!(::Type{T}, bs::Vararg{Symbol}) where {S,N,T<:NamedTuple{S}} = tuplenames((Base.setdiff(S,bs)...,))

merge(::Type{T1}, ::Type{T2}) where {N1,N2,T1<:NamedTuple{N1},T2<:NamedTuple{N2}} =
    tuplenames((unique((N1..., N2...,))...,))
# merge(nt1::T1, nt2::T2) where {T1<:NamedTuple, T2<:NamedTuple} is already defined

end # module NamedTupleTools
