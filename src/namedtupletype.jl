#=
   making life with ::Type{NamedTuple} a smidge less smudged
=#

"""
    ntt() ↣ typeof((;))
    ntt(name) ↣ NamedTuple{(name,)}
    ntt(names...) 
    ntt(name, type) ↣ NamedTuple{(name,), Tuple{type}}
    ntt(names, types) ↣ NamedTuple{(names...,), Tuple{types...}}
""" ntt

ntt() = NamedTuple{(),Tuple{}}

ntt(name::Symbol) = NamedTuple{(name,)}
ntt(name::AbstractString) = ntt(Symbol(name))

ntt(name::Tuple{Symbol}) = ntt(name[1])
ntt(name::Tuple{<:AbstractString}) = ntt(Symbol.(name))

ntt(names::NTuple{N, Symbol}) where N = NamedTuple{names}
ntt(names::NTuple{N, <:AbstractString}) where N = ntt(Symbol.(names))

ntt(names::Vararg{Symbol}) = NamedTuple{names}
ntt(names::Vararg{<:AbstractString}) = ntt(Symbol.(names))

ntt(names::Vector{Symbol}) = ntt(Tuple(names))
ntt(names::Vector{<:AbstractString}) = ntt(Symbol.(names))
