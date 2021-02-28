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

"""
    field_names(nt | NT)

provides the field's names as Symbols in a tuple
""" field_names

"""
    field_types(nt | NT)

provides the fields' types as a tuple
""" field_types

"""
    fields_type(nt | NT)

provides the type for the fields as Tuple{ types... }
""" fields_type

"""
    field_range(nt | NT)

provides a range for iterating over all fields
""" field_range

"""
    field_indices(nt | NT)

provides the indices for all fields as a sorted tuple
""" field_indices

field_count(nt::NamedTuple{N,T}) where {N,T} = length(N)
field_count(nt::Type{NamedTuple{N,T}}) where {N,T} = length(N)
field_names(nt::NamedTuple{N,T}) where {N,T} = N
field_names(nt::Type{NamedTuple{N,T}}) where {N,T} = N
fields_type(nt::NamedTuple{N,T}) where {N,T} = Tuple{T.parameters...}
fields_type(nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple{T.parameters...} # 8x
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_types(nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters) # 8x
field_range(nt::NamedTuple{N,T}) where {N,T} = 1:field_count(nt)
field_range(nt::Type{NamedTuple{N,T}}) where {N,T} =  1:field_count(nt)
field_indices(nt::NamedTuple{N,T}) where {N,T}= ntuple(i->i, field_count(nt))
field_indices(nt::Type{NamedTuple{N,T}}) where {N,T} = ntuple(i->i, field_count(nt))

"""
    field_values(nt)

the same as `values(nt)`, provided for symmetry
""" field_values

field_values(nt::NamedTuple) = values(nt)

