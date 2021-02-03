#=
    Field-based discernment for NamedTuples and structs

    field-oriented operations that apply to types with fields
      op(::Type{T}) ⟣  field_count(T), field_names(T), field_types(T), field_tupletype(T)

    field-focused operations that apply to instances of types with fields
      op(x::T)      ⟣  field_count(x), field_names(x), field_types(x), field_tupletype(x)
      op(x::T)      ⟣  field_values(x)
    
    Most programming languages provide functions designed for the processing of values.
    Fewer are designed with methods for the processing of types. Julia does both well.
    Our field-based discernment functions are reliable and performant.
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
field_types(x::LittleDict) = (typeof.(x.vals)...,)

"""
    field_tupletype

obtains as a Tuple type, the types of the fields
- works with NamedTuple, struct types
- works with NamedTuple, struct, LittleDict instances
""" field_tupletype

field_tupletype(::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletype(x::DataType)   = Tuple{fieldtypes(x)...}
field_tupletype(x::T) where T  = Tuple{fieldtypes(T)...}
field_tupletype(x::LittleDict) = Tuple{fieldtypes(T)...}

"""
    field_values

obtains the values of the fields in a NamedTuple, LittleDict, struct
- works with NamedTuple, struct, LittleDict instances
""" field_values

field_values(x::NamedTuple) = values(x)
field_values(x::T) where T = getfield.((x,), field_names(x))
field_values(x::LittleDict) = Tuple(x.vals)
