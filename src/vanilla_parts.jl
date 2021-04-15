# conversions to vanilla args for NamedTupleTypes and NamedTuples

# nt_names(_) ↦ names::NTuple{N, Symbol}

nt_names() = ()
nt_names(x::NTuple{N,Symbol}) where {N} = x
nt_names(x::Vararg{Symbol}) = x
nt_names(x::Vector{Symbol}) = Tuple(x)

nt_names(x::NTuple{N,<:AbstractString}) where {N} = nt_names(Symbol.(x))
nt_names(x::Vararg{<:AbstractString}) = nt_names(Symbol.(x))
nt_names(x::Vector{<:AbstractString}) = nt_names(Symbol.(x))

# nt_types(_) ↦ types::Tuple{NTuple{N, <:DataType}...}

nt_types() = Tuple{}
nt_types(x::Type{<:Tuple}) = x
nt_types(x::NTuple{N,<:DataType}) where {N} = Tuple{x...}
nt_types(x::Vararg{<:DataType}) = Tuple{x...}
nt_types(x::Vector{DataType}) = nt_types(Tuple(x))

# nt_values(_) ↦ values::NTuple{N, Any}

nt_values() = ()
nt_values(x::T) where {T} = (x,)
nt_values(x::NTuple{N,Any}) where {N} = x
nt_values(x::Vararg{Any}) = x
nt_values(x::Vector{Any}) = Tuple(x)


# ====================================================================

ntt() = (;)
ntt(x) = NamedTuple{nt_names(x), T} where {T}
ntt(xs::Vararg{Symbol}) = NamedTuple{xs, T} where {T}
ntt(x, y) = NamedTuple{nt_names(x), nt_types(y)}

nt(x, y) = NamedTuple{nt_names(x)}(nt_values(y))
nt(x, y, z::Vararg{Any}) = NamedTuple{nt_names(x), nt_types(y)}(z)
nt(x, y, z) = NamedTuple{nt_names(x), nt_types(y)}(nt_values(z))

# ====================================================================
