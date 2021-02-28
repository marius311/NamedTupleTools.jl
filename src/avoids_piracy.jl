#=
   These are often faster than the corresponding functions in Base

   Unlike their corresponding functions in Base, these work well with types and with instances.
   The versions that expect instances are much faster than those that expect NamedTuple types.
   This is a substantive benefit when working with NamedTuple internals.
=#

"""
    field_count(nt | NT)

tallys the named fields
""" field_count

field_count(nt::NamedTuple{N,T}) where {N,T} = length(N)
field_count(nt::Type{NamedTuple{N,T}}) where {N,T} = length(N)

"""
    field_names(nt | NT)

provides the field's names as Symbols in a tuple
""" field_names

"""
    field_name(nt | NT, position)

provides the name of the field at the position given
""" field_name

"""
    field_types(nt | NT)

provides the fields' types as a tuple
""" field_types

"""
    field_type(nt | NT, position)

provides the type of the field at the position given
""" field_type

"""
    fields_types(nt | NT)

provides the type for the fields as Tuple{ types... }
""" fields_types

"""
    fields_type(nt | NT, position)

provides the type for the field at the position given as Tuple{ type }
""" fields_type

field_names(nt::NamedTuple{N,T}) where {N,T} = N
field_names(nt::Type{NamedTuple{N,T}}) where {N,T} = N
field_name(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = N[idx]
field_name(nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = N[idx]

fields_types(nt::NamedTuple{N,T}) where {N,T} = Tuple{T.parameters...}
fields_types(nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple{T.parameters...}
fields_type(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = Tuple{T.parameters[idx]}
fields_type(nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = Tuple{T.parameters[idx]}

field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_types(nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)
field_type(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = tuple(T.parameters[idx])
field_type(nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = tuple(T.parameters[idx])

"""
    field_range(nt | NT)

provides a range for iterating over all fields
""" field_range

"""
    field_indices(nt | NT)

provides the indices for all fields as a sorted tuple
""" field_indices

field_range(nt::NamedTuple{N,T}) where {N,T} = 1:field_count(nt)
field_range(nt::Type{NamedTuple{N,T}}) where {N,T} =  1:field_count(nt)
field_indices(nt::NamedTuple{N,T}) where {N,T}= ntuple(i->i, field_count(nt))
field_indices(nt::Type{NamedTuple{N,T}}) where {N,T} = ntuple(i->i, field_count(nt))

"""
    field_values(nt)

the same as `values(nt)`, provided for symmetry
""" field_values

"""
    field_value(nt, position)

provides the value of the field at the position given
""" field_value

field_values(nt::NamedTuple) = values(nt)
field_value(nt::NamedTuple, idx::Integer) = values(nt)[idx]

