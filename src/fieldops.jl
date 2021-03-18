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
works with instances of thes Types
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





# https://discourse.julialang.org/t/is-this-a-valid-pure-function/17577/2
Base.@pure typeparams(t::Type) = Tuple{t.parameters...}

# https://discourse.julialang.org/t/is-this-pure/8050/5
"""
    which_key(NTuple{N,Symbol}, key::Symbol)

evaluates to a tuple of Bool, true everywhere the key is found
"""
which_key(tuple::Tuple{Vararg{Symbol}}, key::Symbol) =
    _which_key(key, tuple...)
_which_key(key::Symbol) = ()
Base.@pure _which_key(key::Symbol, first::Symbol, tail...) =
    (first === key, _which_key(key, tail...)...)

#=
julia> language = "Interpretive Dance"; programming = "Julia";

julia> (; language, programming )
(language = "Interpretive Dance", programming = "Julia")
=#

# fieldindex

# from Base.namedtuples.jl
#=
    Base.diff_names(x::NTuple{N1,Symbol}, y::NTuple{N2,Symbol}) where {N1,N2}
      - names_in_x_and_not_in_y = diff_names(x, y)
    Base.merge_names(x::NTuple{N1,Symbol}, y::NTuple{N2,Symbol}) where {N1,N2}
       - names_in_x_and_names_y_uniquely

_nt_names(::NamedTuple{names}) where {names} = names
_nt_names(::Type{T}) where {names,T<:NamedTuple{names}} = names
julia> Base._nt_names(nt)
(:a, :b)

_nt_types(x::NamedTuple{names,Tuple{types}}) where {names,types} = types
_nt_types(x::NamedTuple{names,tupletypes}) where {names,tupletypes} = tupletypes
nt_types(x::NamedTuple{names,tupletypes}) where {names,tupletypes} = Tuple(tupletypes.parameters)

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


function named_fields(x::NamedTuple{N,T}, positions::Vector{Int}) where {I,N,T}
   syms = N[positions]
   typs = Tuple{T.parameters[positions]...} # Tuple{T.parameters[[positions]]...}
   vals = map(i->getindex(x,i) , positions)
 return (syms, typs, vals);  #    return NamedTuple{sym, typ}(val)
end

# named_fields(nt1, [1,2])
#((:a, :b), Tuple{Int64, String}, Any[1, "two"])


# low level support functions

function indexof(item::T, seq::NTuple{N, T}) where {N,T}
    if N < 33 
        indexof_recur(item, seq)
    else
        indexof_iter(item, seq)
    end    
end

function indexof_recur(item::T, seq::NTuple{N, T}, idx=1) where {N,T}
    item === first(seq) ? idx : indexof_recur(item, Base.tail(seq), idx+1)
end
indexof_recur(item::T, seq::Tuple{}, idx=1) where {T} = 0

@inline function indexof_iter(item::T, seq::NTuple{N, T}) where {N,T}
    equalsx = Base.Fix2(===, item)
    idx = 1
    for x in seq
        equalsx(x) && break
        idx = idx + 1
    end
    return idx > N ? 0 : idx
end

function indexof(item::T, seq::Vector{T}) where {T}
    equalsx = Base.Fix2(===, item)
    idx = 1
    for x in seq
        equalsx(x) && break
        idx = idx + 1
    end
    return ifelse(idx > length(seq), 0, idx)
end
