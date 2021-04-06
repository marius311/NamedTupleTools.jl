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

ntt(name::Symbol, type::DataType) = NamedTuple{(name,), Tuple{type}}
ntt(name::Symbol, type::Tuple{DataType}) = NamedTuple{(name,), Tuple{type[1]}}
ntt(name::Tuple{Symbol}, type::DataType) = NamedTuple{name, Tuple{type}}      
ntt(name::Tuple{Symbol}, type::Tuple{DataType}) = ntt(name, Tuple{type[1]})
                                       
ntt(name::Symbol, type::Vector{<:DataType}) = NamedTuple{(name,), Tuple{type[1]}}
ntt(names::NTuple{N,Symbol}, types::Vector{<:DataType}) where {N} = NamedTuple{names, Tuple{types[1:N]...}}     
ntt(names::Vector{Symbol}, types::NTuple{N, <:DataType}) where {N} = NamedTuple{Tuple(names[1:N]), Tuple{types...}}
ntt(names::Vector{Symbol}, types::Vector{<:DataType}) = let N=min(length(names), length(types))
    NamedTuple{Tuple(names[1:N], Tuple{types[1:N]...}}
end
              

