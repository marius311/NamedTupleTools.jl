#=
    Field-based discernment for NamedTuples and structs

    field-oriented operations that apply to types with fields
      op(::Type{T}) ⟣  field_count(T), field_names(T), field_types(T), field_tupletype(T)

    field-focused operations that apply to instances of types with fields
      op(x::T)      ⟣  field_count(x), field_names(x), field_types(x), field_tupletype(x)
      op(x::T)      ⟣  field_values(x), field_value(x), named_field(x, n)

    Most programming languages provide functions designed for the processing of values.
    Fewer are designed with methods for the processing of types. Julia does both well.
    Our field-based discernment functions are reliable and performant.
=#

using OrderedCollections: LittleDict

#=
   renaming avoids typed-method piracy
   Base: fieldcount, fieldnames, fieldtypes work with types only
   these work with types and instances both
   and are helpful with NamedTuples, structs, LittleDicts
=#

"""
    field_count

tally the number of fields in a NamedTuple, struct (keys in a LittleDict)
- works with NamedTuple, struct types
- works with NamedTuple, struct, LittleDict instances
""" field_count

field_count(::Type{T}) where {T<:NamedTuple} = fieldcount(T)
field_count(x::DataType)  = fieldcount(x)
field_count(x::T) where T = fieldcount(T)
field_count(x::LittleDict) = length(x.keys)

"""
    field_names

obtains the names of the fields in a NamedTuple, struct (the keys in a LittleDict)
- works with NamedTuple, struct types
- works with NamedTuple, struct, LittleDict instances
""" field_names

Base.@pure field_names(::Type{NamedTuple{N,T}}) where {N,T} = (N)
field_names(x::DataType)  = fieldnames(x)
field_names(x::T) where T = fieldnames(T)
field_names(x::LittleDict) = (x.keys...,)

"""
    field_types

obtains the types of the fields in a NamedTuple, LittleDict, struct (of the values in a LittleDict)
- works with NamedTuple, struct types and LittleDicts using tuples
- works with NamedTuple, struct, LittleDict instances
""" field_types

field_types(::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)
field_types(x::DataType)  = fieldtypes(x)
field_types(x::T) where T = fieldtypes(T)
field_types(x::Type{<:LittleDict}) = (x.parameters[4].parameters...,)
field_types(x::LittleDict) = (typeof.(x.vals)...,)

"""
    field_tupletype

obtains as a Tuple type, the types of the fields in a NamedTuple, struct (of the values in a LittleDict)
- works with NamedTuple, struct type and LittleDicts using tuples
- works with NamedTuple, struct, LittleDict instances
""" field_tupletype

field_tupletype(::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletype(x::DataType)   = Tuple{field_types(x)...}
field_tupletype(x::T) where T  = Tuple{field_types(T)...}
field_tupletype(x::Type{<:LittleDict}) = x.parameters[4]
field_tupletype(x::LittleDict) = typeof(x.vals)

"""
    field_values

obtains the values of the fields in a NamedTuple, struct (of the keys in a LittleDict)
""" field_values

field_values(x::NamedTuple) = values(x)
field_values(x::T) where T = getfield.((x,), field_names(x))
field_values(x::LittleDict) = Tuple(x.vals)

"""
    field_value

obtains the value of a field in a NamedTuple, struct (of a key in a LittleDict)
""" field_value

field_value(x::NamedTuple, field::Symbol) = getfield(x, field)
field_value(x::T, field::Symbol) where T  = getfield(x, field)
field_value(x::LittleDict, field::Symbol) = x[field]

"""
    named_field

obtains a NamedTuple constituent from within a NamedTuple
- by position or by name
""" named_field

function named_field(x::NamedTuple{N,T}, position::Integer) where {N,T}
    sym = (N[position],)
    typ = Tuple{T.parameters[position]}
    val = x[position]
    return NamedTuple{sym, typ}(val)
end

function named_field(x::NamedTuple{N,T}, name::Symbol) where {N,T}
    sym = (name,)
    typ = Tuple{T.parameters[position]}
    val = getfield(x, name)
    return NamedTuple{sym, typ}(val)
end

# low level support functions

function indexof(item::T, seq::NTuple{N, T}) where {N,T}
    if N < 33 
        indexof_recur(item, seq)
    else
        indexof_iter(N, item, seq)
    end    
end

function indexof_recur(item::T, seq::NTuple{N, T}, idx=1) where {N,T}
    item === first(seq) ? idx : indexof_recur(item, Base.tail(seq), idx+1)
end
indexof_recur(item::T, seq::Tuple{}, idx=1) where {T} = 0

@inline function indexof_iter(N, item::T, seq::NTuple{N, T}) where {N,T}
    equalsx = Base.Fix2(===, item)
    idx = 1
    for x in seq
        equalsx(x) && break
        idx = idx + 1
    end
    return idx > N ? 0 : idx
end

@inline function indexof(item::T, seq::Vector{T}) where {T}
    equalsx = Base.Fix2(===, item)
    idx = 1
    for x in seq
        equalsx(x) && break
        idx = idx + 1
    end
    return idx > length(seq) ? 0 : idx
end
