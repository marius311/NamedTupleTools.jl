#=
    Field based nondestructive ops for NamedTuples and struts

      op(x::T)      ⟣  fieldvalues(x)
      op(::Type{T}) ⟣  fieldcount(T), fieldnames(T), fieldtypes(T)

    Our field-oriented discernment functions are reliable and performant.
    
    Most programming languages provide functions designed for the processing of values.
    Fewer are designed with methods for the processing of types. Julia does both well.

    Three of these methods are field-oriented operations that apply to types with fields.
    The fourth method is field-focused, as it is applies to values with these same types.
    
    `fieldcount(_)`, `fieldnames(_)`, and `fieldtypes(_)` accept type-valued variables.
    `fieldvalues(_)` applies to variables with assigned values rather than their types
=#

#=
   renaming avoids typed-method piracy
   Base: fieldcount, fieldnames, fieldtypes work with types only
   these work with types and instances both
   and are helpful with NamedTuples, structs, LittleDicts
=#

"""
    field_count

tally the number of fields in a NamedTuple, LittleDict, struct
- works with NamedTuple, struct types
- works with NamedTuple, struct, LittleDict instances
""" field_count

field_count(::Type{T}) where {T<:NamedTuple} = fieldcount(T)
field_count(x::DataType)  = fieldcount(x)
field_count(x::T) where T = fieldcount(T)
field_count(x::LittleDict) = length(x.keys)

"""
    field_names

obtains the names of the fields in a NamedTuple, struct, LittleDict
- works with NamedTuple, struct types
- works with NamedTuple, struct, LittleDict instances
""" field_names

Base.@pure field_names(::Type{NamedTuple{N,T}}) where {N,T} = (N)
field_names(x::DataType)  = fieldnames(x)
field_names(x::T) where T = fieldnames(T)
field_names(x::LittleDict) = (x.keys...,)

"""
    field_types

obtains the types of the fields in a NamedTuple, LittleDict, struct
- works with NamedTuple, struct types
- works with NamedTuple, struct, LittleDict instances
""" field_types

field_types(::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)
field_types(x::DataType)  = fieldtypes(x)
field_types(x::T) where T = fieldtypes(T)
field_types(x::LittleDict) = (typeof.(x.vals).parameters...,)

"""
    field_values

obtains the values of the fields in a NamedTuple, LittleDict, struct
- works with NamedTuple, struct, LittleDict instances
""" field_values

field_values(x::NamedTuple) = values(x)
field_values(x::T) where T = getfield.((x,), field_names(x))
field_values(x::LittleDict) = Tuple(x.vals)
