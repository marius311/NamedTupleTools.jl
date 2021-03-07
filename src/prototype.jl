prototype(nt::NamedTuple{N,T}) where {N,T} = NamedTuple{N}
prototype(NT::Type{NamedTuple{N,T}}) where {N,T} = NamedTuple{N}
