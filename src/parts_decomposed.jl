# field selected field_items

field_count(ntt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(nt::NamedTuple{N,T}) where {N,T} = nfields(N)

field_names(ntt::Type{NamedTuple{N,T}}) where {N,T} = ntt.parameters[1]
field_names(nt::NamedTuple{N,T}) where {N,T} = N

field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = ntt.parameters[2]
field_types(nt::NamedTuple{N,T}) where {N,T} = T

field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)

# (field, index) selected field_item

field_name(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = getfield(N, idx)
field_name(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(N, idx)

field_type(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = (T.parameters)[idx]
field_type(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = (T.parameters)[idx]

field_value(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(nt, idx)

# (field, indices) multiselected field_items

field_name(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(N), idxs)
field_name(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(N), idxs)

field_type(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)
field_type(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)

field_value(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getfield.(Ref(nt), idxs)
