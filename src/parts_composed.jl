# ====================================================================

# nttype(_) form a NamedTupleType

nttype() = (;)
nttype(x) = NamedTuple{nt_names(x), T} where {T<:Tuple}
nttype(xs::Vararg{Symbol}) = NamedTuple{xs, T} where {T<:Tuple}
nttype(x, y) = NamedTuple{nt_names(x), nt_types(y)}

nttype(; names) = nttype(names)
nttype(; names, types) = nttype(names, types)

# nt(_) form a NamedTuple

nt(x, y) = NamedTuple{nt_names(x)}(nt_values(y))
nt(x, y, z::Vararg{Any}) = NamedTuple{nt_names(x), nt_types(y)}(z)
nt(x, y, z) = NamedTuple{nt_names(x), nt_types(y)}(nt_values(z))

nt(; names, values) = ntt(names, values)
nt(; names, types, values) = ntt(names, types, values)

nt(x::Type{<:NamedTuple}, y) = (x)(y)
nt(; nttype, values) = nt(nttype, values)

# ====================================================================
# support routines for the constructive functions above
# conversions to args for NamedTupleTypes and NamedTuples

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
