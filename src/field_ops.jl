#=
    The first 3/4 of this file supports NamedTuple Types and NamedTuple realizations
    The rest of this file supports Tuples, structs, LittleDicts and their realizations
=#

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

# obtain the Value[s] that are assigned to fields
field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)
# (field, index) selected field_item
field_values(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(nt, idx)
# (field, indices) multiselected field_items
field_values(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getfield.(Ref(nt), idxs)

# obtain the Type[s] that must be instantiated as fields
field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(ntt.parameters[2].parameters)
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
# (field, index) selected field_item
field_types(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = (T.parameters)[idx]
field_types(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = (T.parameters)[idx]
# (field, indices) multiselected field_items
field_types(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)
field_types(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)

# obtain Tuple{ Type[s] } that must be instantiated as fields
field_typestuple(ntt::Type{NamedTuple{N,T}}) where {N,T} = T
field_typestuple(nt::NamedTuple{N,T}) where {N,T} = T
# (field, index) selected field_item
field_typestuple(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = Tuple{ (T.parameters)[idx] }
field_typestuple(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = Tuple{ (T.parameters)[idx] }
# (field, indices) multiselected field_items
field_typestuple(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = Tuple{ getindex.(Ref(T.parameters), idxs)... }
field_typestuple(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = Tuple{ getindex.(Ref(T.parameters), idxs)... }

#=
   field_ops support for
      (a) Tuple types and their realizations
      (a) struct types and thier realizations
      (b) LittleDict types and their realizations
=#

# tuples
field_count(x::Type{Tuple}) = length(x)
field_count(x::Tuple) = length(x)
# structs
field_count(x::Type{T}) where {T} = fieldcount(x)
field_count(x::T) where {T} = fieldcount(T)
# dicts
field_count(x::AbstractDict) = length(x)

# tuples
field_names(x::Type{Tuple}) = ()
field_names(x::Tuple) = ()
# structs
field_names(x::Type{T}) where {T} = fieldnames(T)
field_names(x::T) where {T} = fieldnames(T)
# dicts
field_names(x::AbstractDict) = keys(x)

# tuples
field_values(x::Tuple) = x
# structs
field_values(x::T) where {T} = getfield.(Ref(x), fieldnames(T))
# dicts
field_values(x::AbstractDict) = values(x)

# tuples
field_types(x::Type{Tuple}) = x
field_types(x::Tuple) = typeof.(x)
# structs
field_types(x::Type{T}) where {T} = fieldnames(T)
field_types(x::T) where {T} = fieldnames(T)
# dicts
field_types(x::AbstractDict) = Tuple(typeof.(values(x)))  # ONLY USE WITH VERY SMALL DICTIONARIES

# tuples
field_typestuple(x::Type{Tuple}) = x
field_typestuple(x::Tuple) = typeof(x)
# structs
field_typestuple(x::Type{T}) where {T} = fieldnames(T)
field_typestuple(x::T) where {T} = fieldnames(T)
# dicts
field_typestuple(x::AbstractDict) = Tuple{typeof.(values(x))...}  # ONLY USE WITH VERY SMALL DICTIONARIES
