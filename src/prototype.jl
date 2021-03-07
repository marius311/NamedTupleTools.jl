prototype(nt::NamedTuple{N,T}) where {N,T} = NamedTuple{N}
prototype(NT::Type{NamedTuple{N,T}}) where {N,T} = NamedTuple{N}

prototype(nt::NamedTuple{N,T}, types::NTuple{N1,Type}) where {N,T,N1} =
    NamedTuple{N,Tuple{types...}}
