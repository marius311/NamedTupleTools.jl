
"""
    field_count(x|T)

count the fields specified with 'T' or present in 'x::T'
works with these Types and their instances
- NamedTuples, DataTypes (structs), Tuples, LittleDicts
""" field_count

field_count(NT::Type{NamedTuple{N}}) where {N} = nfields(N)
field_count(NT::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(nt::NamedTuple{N,T}) where {N,T} = nfields(N)
field_count(x::T) where {T<:DataType} = fieldcount(x)
field_count(x::T) where {T} = field_count(T)
field_count(x::Type{T}) where {T<:LittleDict} = length(x.parameters[3].parameters)
field_count(x::LittleDict) = length(keys(x))

"""
    field_names(::T|T)

obtain the names of fields specified with 'T' or present in 'x::T'
works with these Types and their instances
- NamedTuples, DataTypes (structs), LittleDict (instances only)
""" field_names

field_names(NT::Type{NamedTuple{N}}) where {N} = N
field_names(NT::Type{NamedTuple{N,T}}) where {N,T} = N
field_names(nt::NamedTuple{N,T}) where {N,T} = N
field_names(x::T) where {T<:DataType} = fieldnames(x)
field_names(x::T) where {T} = field_names(T)
field_names(x::LittleDict) = keys(x)

"""
    field_tupletypes(::T|T)

obtain as a Tuple{_}, the types of fields specified with 'T' or present in 'x::T'
works with these Types and their instances
- NamedTuples, DataTypes (structs), LittleDict
""" field_tupletypes

field_tupletypes(NT::Type{NamedTuple{N}}) where {N} = NTuple{length(N), Any}
field_tupletypes(NT::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletypes(nt::NamedTuple{N,T}) where {N,T} = T
field_tupletypes(x::T) where {T<:DataType} = Tuple{fieldtypes(x)...}
field_tupletypes(x::T) where {T} = field_types(T)
field_tupletypes(x::Type{T}) where {T<:LittleDict} = x.parameters[4]
field_tupletypes(x::LittleDict) = field_tupletypes(typeof(x))

"""
    field_types(::T|T)

obtain the types of fields specified with 'T' or present in 'x::T'
works with these Types and their instances
- NamedTuples, DataTypes (structs), LittleDict
""" field_types

field_types(NT::Type{NamedTuple{N}}) where {N} = ntuple(i->Any, Val(length(N)))
field_types(NT::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_types(x::T) where {T<:DataType} = fieldtypes(x)
field_types(x::T) where {T} = field_types(T)
field_types(x::Type{T}) where {T<:LittleDict} = Tuple(x.parameters[4])
field_types(x::LittleDict) = field_tupletypes(typeof(x))

"""
    field_values(::T)

obtain the values of fields present in 'x::T'
works with these Type instances
- NamedTuples, DataTypes (structs), LittleDict
""" field_values

field_values(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_values(x::T) where {T} = Tuple(map(i->getfield(x, i), 1:field_count(x)))
field_values(x::LittleDict) = Tuple(values(x))




field_tupletypes(ntt::Type{NamedTuple{N,T}}) where {N,T} = T
field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)

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
