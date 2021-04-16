field_count(ntt::Type{NamedTuple{N}}) where {N} = nfields(N)
field_names(ntt::Type{NamedTuple{N}}) where {N} = N

field_count(ntt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_names(ntt::Type{NamedTuple{N,T}}) where {N,T} = N
field_tupletypes(ntt::Type{NamedTuple{N,T}}) where {N,T} = T
field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)

field_count(nt::NamedTuple{N,T}) where {N,T} = nfields(N)
field_names(nt::NamedTuple{N,T}) where {N,T} = N
field_tupletypes(nt::NamedTuple{N,T}) where {N,T} = T
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)

field_names(ntt::Type{NamedTuple{N}}, idx::Integer) where {N} = N[idx]
field_names(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = N[idx]
field_types(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = T.parameters[idx]

field_names(nt::NamedTuple{N}, idx::Integer) where {N} = N[idx]
field_names(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = N[idx]
field_types(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = T.parameters[idx]
field_values(nt::NamedTuple{N}, idx::Integer) where {N} = values(nt)[idx]

field_names(ntt::Type{NamedTuple{N}}, idxs::Vararg{<:Integer}) where {N} = map(i->field_names(ntt,i), idxs)
field_names(ntt::Type{NamedTuple{N,T}}, idxs::Vararg{<:Integer}) where {N,T} = map(i->field_names(ntt,i), idxs)
field_types(ntt::Type{NamedTuple{N,T}}, idxs::Vararg{<:Integer}) where {N,T} = map(i->field_types(ntt,i), idxs)

field_names(nt::NamedTuple{N}, idxs::Vararg{<:Integer}) where {N} = map(i->field_names(nt,i), idxs)
field_names(nt::NamedTuple{N,T}, idxs::Vararg{<:Integer}) where {N,T} = map(i->field_names(nt,i), idxs)
field_types(nt::NamedTuple{N,T}, idxs::Vararg{<:Integer}) where {N,T} = map(i->field_types(nt,i), idxs)
field_values(nt::NamedTuple{N}, idxs::Vararg{<:Integer}) where {N} = map(i->field_values(ntt,i), idxs)
