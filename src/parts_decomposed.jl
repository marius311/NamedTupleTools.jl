# field summary
field_count(ntt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(nt::NamedTuple{N,T}) where {N,T} = nfields(N)

# field selected field_items

# obtain the Symbol[s] that name fields
field_names(ntt::Type{NamedTuple{N,T}}) where {N,T} = ntt.parameters[1]
field_names(nt::NamedTuple{N,T}) where {N,T} = N
# (field, index) selected field_item
field_names(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = getfield(N, idx)
field_names(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(N, idx)
# (field, indices) multiselected field_items
field_names(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(N), idxs)
field_names(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(N), idxs)

# obtain the Type[s] that must be instantiated as fields
field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = ntt.parameters[2]
field_types(nt::NamedTuple{N,T}) where {N,T} = T
# (field, index) selected field_item
field_types(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = (T.parameters)[idx]
field_types(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = (T.parameters)[idx]
# (field, indices) multiselected field_items
field_types(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)
field_types(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)

# obtain the Value[s] that are assigned to fields
field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)
# (field, index) selected field_item
field_values(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(nt, idx)
# (field, indices) multiselected field_items
field_values(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getfield.(Ref(nt), idxs)
