#=
   Many of these NamedTuple methods sound just like methods in Base.
   None of these NamedTuple methods is spelled like methods in Base.
   An underscore ensures there be no type piracy and no method privateering.
   
   Thank you
   Takafumi Arakaki @tkf, for convincing me to organize away prior piracy.
   Jameson Nash @vtjnash, for introducing "privateering" to my lexicon.
=#

#=
   The homonym functions in Base work with `::Type{<:NamedTuple}` only (by design).
   These methods work with both `::Type{<:NamedTuple}` and `indicant::NamedTuple`.
   Dispatch through indicants (realizations, concretions) is much more performant.
   That helps us provide desiderata in an accessible, unobtrusive, welcome manner.
=#

const NTT = NamedTupleTools

export field_count, 
       field_range, field_indices,
       field_names, field_name, field_types, field_type, 
       field_values, field_value,
       has_key, has_value,
       destructure, restructure

# these functions are not exported
# fields_types, fields_type

"""
    field_count(nt | NT)

tallys the named fields
""" field_count

field_count(@nospecialize nt::NamedTuple{N,T}) where {N,T} = length(N)
field_count(@nospecialize nt::Type{NamedTuple{N,T}}) where {N,T} = length(N)

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

field_names(@nospecialize nt::NamedTuple{N,T}) where {N,T} = N
field_names(@nospecialize nt::Type{NamedTuple{N,T}}) where {N,T} = N
field_name(@nospecialize nt::NamedTuple{N,T}, idx::Integer) where {N,T} = N[idx]
field_name(@nospecialize nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = N[idx]

fields_types(@nospecialize nt::NamedTuple{N,T}) where {N,T} = Tuple{T.parameters...}
fields_types(@nospecialize nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple{T.parameters...}
fields_type(@nospecialize nt::NamedTuple{N,T}, idx::Integer) where {N,T} = Tuple{T.parameters[idx]}
fields_type(@nospecialize nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = Tuple{T.parameters[idx]}

field_types(@nospecialize nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_types(@nospecialize nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)
field_type(@nospecialize nt::NamedTuple{N,T}, idx::Integer) where {N,T} = tuple(T.parameters[idx])
field_type(@nospecialize nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = tuple(T.parameters[idx])

"""
    field_range(nt | NT)

provides a range for iterating over all fields
""" field_range

"""
    field_indices(nt | NT)

provides the indices for all fields as a sorted tuple
""" field_indices

field_range(@nospecialize nt::NamedTuple{N,T}) where {N,T} = 1:field_count(nt)
field_range(@nospecialize nt::Type{NamedTuple{N,T}}) where {N,T} =  1:field_count(nt)
field_indices(@nospecialize nt::NamedTuple{N,T}) where {N,T}= ntuple(i->i, field_count(nt))
field_indices(@nospecialize nt::Type{NamedTuple{N,T}}) where {N,T} = ntuple(i->i, field_count(nt))

"""
    field_values(nt)

the same as `values(nt)`, provided for symmetry
""" field_values

"""
    field_value(nt, position)

provides the value of the field at the position given
""" field_value

field_values(@nospecialize nt::NamedTuple) = values(nt)
field_value(@nospecialize nt::NamedTuple, idx::Integer) = values(nt)[idx]

"""
    has_key(nt | NT, Symbol)::Bool

faster version of `haskey` for NamedTuples
""" has_key

has_key(@nospecialize nt::NamedTuple{N,T}, key::Symbol) where {N,T} = key in N
has_key(@nospecialize NT::Type{NamedTuple{N,T}}, key::Symbol) where {N,T} = key in N

"""
    has_value(nt, value)::Bool

does `value` exist in nt?
""" has_value

has_value(@nospecialize nt::NamedTuple{N,T}, value) where {N,T} = value in values(nt)

"""
   destructure(nt; typetuple::Bool=false)

- with `typetuple = false` [default]
yields ((fieldnames), (fieldtypes), (fieldvalues))
- with `typetuple = true`
yields ((fieldnames), Tuple{fieldtypes}, (fieldvalues))
""" destructure

function destructure(@nospecialize nt::NamedTuple; typetuple::Bool=false)
    if typetuple
       (field_names(nt), fields_types(nt), field_values(nt))
    else
       (field_names(nt), field_types(nt), field_values(nt))
    end
end

"""
   restructure((fieldnames), (fieldtypes), (fieldvalues))
   restructure((fieldnames), Tuple{fieldtypes}, (fieldvalues))

yields the corresponding NamedTuple
""" restructure

restructure(@nospecialize names::Tuple, @nospecialize types::Tuple, @nospecialize values::Tuple) =
   NamedTuple{names, Tuple{types...}}(values)

restructure(@nospecialize names::Tuple, @nospecialize types::Type{Tuple}, values::Tuple) =
   NamedTuple{names, types}(values)

