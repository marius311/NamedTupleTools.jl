#=
Base.convert(::Type{Pair}, x::NamedTuple{N,Tuple{T}}) where {N,T} = Pair(N[1], x[1])
Base.convert(NamedTuple, x::Pair{Symbol,T}) where {T} = NamedTuple{(first(x),)}(last(x))
Base.convert(NamedTuple, x::Tuple{Vararg{<:Pair{Symbol,Any}}})
=#
namedtuple(name::Symbol, value::T) where {T} = NamedTuple{(name,), Tuple{T}}(value)
namedtuple(names::NTuple{N,Symbol}, values::Tuple) where N = NamedTuple{names}(values)

namedtuple(name::AbstractString, value::T) where {T} = namedtuple(Symbol(name), value)
namedtuple(names::NTuple{N,AbstractString}, values::Tuple) where N = namedtuple(Symbol.(names), values)

namedtuple(names::AbstractVector{Symbol}, values::AbstractVector) = namedtuple(Tuple(names), Tuple(values))
namedtuple(names::AbstractVector{Symbol}, values::Tuple) = namedtuple(Tuple(names), values)
namedtuple(names::NTuple{N,Symbol}, values::AbstractVector) where N = namedtuple(names, Tuple(values))

namedtuple(names::AbstractVector{AbstractString}, values::AbstractVector) = namedtuple(Tuple(names), Tuple(values))
namedtuple(names::AbstractVector{AbstractStringSymbol}, values::Tuple) = namedtuple(Tuple(names), values)
namedtuple(names::NTuple{N,AbstractString}, values::AbstractVector) where N = namedtuple(names, Tuple(values))

namedtuple(names::NTuple{N,Symbol}, types::NTuple{N,Type}) where N = NamedTuple{names, Tuple{types...}}

namedtuple(name::Symbol, type::Type{T}, value::T) where {T} = NamedTuple{(name,), Tuple{T}}(value)

