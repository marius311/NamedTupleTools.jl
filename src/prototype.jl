prototype(nt::NamedTuple{N,T}) where {N,T} = NamedTuple{N}
prototype(NT::Type{NamedTuple{N,T}}) where {N,T} = NamedTuple{N}

prototype(nt::NamedTuple{N,T}, types::NTuple{N1,Type}) where {N,T,N1} =
    NamedTuple{N,Tuple{types...}}


"""
    isprototype( nt | NT )

Predicate that identifies NamedTuple prototypes.
"""
isprototype(::Type{T}) where {T<:NamedTuple} = eltype(T) === Any
isprototype(nt::T) where {T<:NamedTuple} = false
isprototype(::Type{UnionAll}) = false
isprototype(::NamedTuple{(), Tuple{}}) = true
