# field_items

field_count(ntt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(nt::NamedTuple{N,T}) where {N,T} = nfields(N)

field_names(ntt::Type{NamedTuple{N,T}}) where {N,T} = ntt.parameters[1]
field_names(nt::NamedTuple{N,T}) where {N,T} = N

field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = ntt.parameters[2]
field_types(nt::NamedTuple{N,T}) where {N,T} = T

field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)

# field_item indexed

field_name(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = getfield(N, idx)
field_name(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(N, idx)

field_type(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = getfield(T, idx)
field_type(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = (T.parameters)[idx]

field_value(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(nt, idx)

#=
    Field-based discernment for NamedTuples and structs
    field-oriented operations that apply to types with fields
      op(::Type{T}) ⟣  field_count(T), field_names(T), field_types(T), field_tupletype(T)
    field-focused operations that apply to instances of types with fields
      op(x::T)      ⟣  field_count(x), field_name[s](x), field_type[s](x), field_tupletype(x)
      op(x::T)      ⟣  field_index(T, x), field_value[s](x), named_field[s](x, n[s])
    Base: fieldcount, fieldname[s], fieldtype[s] work with types only
    
    here: field_count, field_name[s], field_type[s] 
         works with types and works with their instances
   
     they have been designed to support NamedTuples and structs
     and, where meaninful (mostly instances), LittleDicts
    Most programming languages provide functions designed for the processing of values.
    Fewer are designed with methods for the processing of types. Julia does both well.
    Our field-based discernment functions are reliable and performant.
=#

#=
   Many of these NamedTuple methods sound just like methods in Base.
   None of these NamedTuple methods is spelled like methods in Base.
   An underscore ensures there be no type piracy and no method privateering.
   
   Thank you
   Takafumi Arakaki @tkf, for convincing me to organize away prior piracy.
   Jameson Nash @vtjnash, for introducing "privateering" to my lexicon.
=#

Base.@pure params(t::Type) = t.parameters
Base.@pure tupleparams(t::Type) = Tuple{params(t)...}

"""
    field_count(x|T)

count the fields specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs), Tuples
""" field_count

field_count(NT::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(nt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(x::Type{T}) where {T} = fieldcount(x)
field_count(x::T) where {T} = fieldcount(T)

"""
    field_names(::T|T)

obtain the names of fields specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs)
""" field_names

field_names(NT::Type{NamedTuple{N,T}}) where {N,T} = N
@generated field_names(nt::Type{NamedTuple{N,T}}) where {N,T} = N
field_names(x::Type{T}) where {T} = fieldnames(x)
field_names(x::T) where {T} = fieldnames(T)

"""
    field_name(::T|T, ith)

obtain the name of the ith field specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs)
""" field_name

field_name(NT::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = N[idx]
field_name(nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = N[idx]
field_name(x::Type{T}, idx::Integer) where {T} = fieldnames(x)[idx]
field_name(x::T, idx::Integer) where {T} = fieldnames(T)[idx]

"""
    field_tupletypes(::T|T)

obtain, wrapped with Tuple{_}, types of fields specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs), Tuples
""" field_tupletypes

field_tupletypes(NT::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletypes(nt::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletypes(x::Type{T}) where {T} = Tuple{fieldtypes(T)...}
field_tupletypes(x::T) where {T} = Tuple{fieldtypes(T)...}

"""
    field_types(::T|T)

obtain the types of fields specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs), Tuples
""" field_types

field_types(nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(params(T))
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(params(T))
field_types(x::Type{T}) where {T} = fieldtypes(x)
field_types(x::T) where {T} = fieldtypes(T)

"""
    field_type(::T|T, ith)

obtain the name of the ith field specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs)
""" field_type

field_type(nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = params(T)[idx]
field_type(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = params(T)[idx]
field_type(x::Type{T}, idx::Integer) where {T} = fieldtypes(x)[idx]
field_type(x::T, idx::Integer) where {T} = fieldtypes(T)[idx]

field_type(nt::Type{NamedTuple{N,T}}, name::Symbol) where {N,T} = params(T)[indexof(name,N)]
field_type(nt::NamedTuple{N,T}, name::Symbol) where {N,T} = params(T)[indexof(name,N)]
field_type(x::Type{T}, name::Symbol) where {T} = fieldtypes(x)[indexof(name, fieldnames(T))]
field_type(x::T, name::Symbol) where {T} = fieldtypes(T)[indexof(name, fieldnames(T))]

"""
    field_indicies(::T|T)

obtain the indices of fields specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs), Tuples
""" field_indicies

field_indicies(NT::Type{NamedTuple{N,T}}) where {N,T} = ntuple(i->i, nfields(N))
field_indicies(nt::Type{NamedTuple{N,T}}) where {N,T} = ntuple(i->i, nfields(N))
field_indicies(x::Type{T}) where {T} = ntuple(i->i, fieldcount(T))
field_indicies(x::T) where {T} = ntuple(i->i, fieldcount(T))

"""
    field_index(::T|T, name)

obtain the index of the named field specified with 'T' or present in 'x::T'

works with these Types and their instances
- NamedTuples, DataTypes (structs)
""" field_type

field_index(nt::Type{NamedTuple{N,T}}, name::Symbol) where {N,T} = indexof(name, N)
field_index(nt::NamedTuple{N,T}, name::Symbol) where {N,T} = indexof(name, N)
field_index(x::Type{T}, name::Symbol) where {T} = indexof(name, field_names(T))
field_index(x::T, name::Symbol) where {T} = indexof(name, field_names(T))

"""
    field_values(::T)

obtain the values of fields present in 'x::T'

works with instances of these Types
- NamedTuples, DataTypes (structs), Tuples
""" field_values

field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)
field_values(x::T) where {T} = Tuple(getfield.((x,), 1:fieldcount(T)))

"""
    field_value(::T, ith)

obtain the name of the ith field present in 'x::T'

works with instances of these Types
- NamedTuples, DataTypes (structs)
""" field_value

field_value(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(nt, idx)
field_value(x::T, idx::Integer) where {T} = getfield(x, idx)
field_value(nt::NamedTuple{N,T}, name::Symbol) where {N,T} = getfield(nt, name)
field_value(x::T, name::Symbol) where {T} = getfield(x, name)

