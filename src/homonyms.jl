#=
   Many of these NamedTuple methods sound just like methods in Base.
   None of these NamedTuple methods is spelled like methods in Base.
   An underscore ensures there be no type piracy and no method privateering.
   
   Thank you
   Takafumi Arakaki @tkf, for convincing me to organize away prior piracy.
   Jameson Nash @vtjnash, for introducing "privateering" to my lexicon.
=#

"""
    field_count
""" field_count

field_count(NT::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(nt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(x::Type{T}) where {T} = fieldcount(x)
field_count(x::T) where {T} = fieldcount(T)

"""
    field_names
""" field_names

field_names(NT::Type{NamedTuple{N,T}}) where {N,T} = N
field_names(nt::Type{NamedTuple{N,T}}) where {N,T} = N
field_names(x::Type{T}) where {T} = fieldnames(x)
field_names(x::T) where {T} = fieldnames(T)

"""
    field_name
""" field_name

field_name(NT::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = N[idx]
field_name(nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = N[idx]
field_name(x::Type{T}, idx::Integer) where {T} = fieldnames(x)[idx]
field_name(x::T, idx::Integer) where {T} = fieldnames(T)[idx]

"""
    field_tupletypes
""" field_tupletypes

field_tupletypes(NT::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletypes(nt::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletypes(x::Type{T}) where {T} = Tuple{fieldtypes(T)...}
field_tupletypes(x::T) where {T} = Tuple{fieldtypes(T)...}

"""
    field_types
""" field_types

field_types(nt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_types(x::Type{T}) where {T} = fieldtypes(x)
field_types(x::T) where {T} = fieldtypes(T)

"""
    field_type
""" field_type

field_type(nt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = T.parameters[idx]
field_type(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = T.parameters[idx]
field_type(x::Type{T}, idx::Integer) where {T} = fieldtypes(x)[idx]
field_type(x::T, idx::Integer) where {T} = fieldtypes(T)[idx]

field_type(nt::Type{NamedTuple{N,T}}, name::Symbol) where {N,T} = T.parameters[indexof(name,N)]
field_type(nt::NamedTuple{N,T}, name::Symbol) where {N,T} = T.parameters[indexof(name,N)]
field_type(x::Type{T}, name::Symbol) where {T} = fieldtypes(x)[indexof(name, fieldnames(T))]
field_type(x::T, name::Symbol) where {T} = fieldtypes(T)[indexof(name, fieldnames(T))]

"""
    field_indicies
""" field_indicies

field_indicies(NT::Type{NamedTuple{N,T}}) where {N,T} = ntuple(i->i, nfields(N))
field_indicies(nt::Type{NamedTuple{N,T}}) where {N,T} = ntuple(i->i, nfields(N))
field_indicies(x::Type{T}) where {T} = ntuple(i->i, fieldcount(T))
field_indicies(x::T) where {T} = ntuple(i->i, fieldcount(T))

"""
    field_values
""" field_values

field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)
field_values(x::T) where {T} = Tuple(getfield.((x,), 1:fieldcount(T)))

"""
    field_value
""" field_value

field_value(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(nt, idx)
field_value(x::T, idx::Integer) where {T} = getfield(x, idx)
field_value(nt::NamedTuple{N,T}, name::Symbol) where {N,T} = getfield(nt, name)
field_value(x::T, name::Symbol) where {T} = getfield(x, name)

#=
    parameter retrieval
=#

#   parameters(nt|NT)

parameters(nt::Type{NamedTuple{}}) = nothing
parameters(nt::NamedTuple{}) = nothing

parameters(nt::Type{NamedTuple{N}}) where {N} = N
parameters(nt::NamedTuple{N}) where {N} = N

parameters(nt::Type{NamedTuple{N,T}}) where {N,T} = N
parameters(nt::NamedTuple{N,T}) where {N,T} = N

# an indexical is a dedicated and devote d service 
#   brought available to for use in this environment and timme of wealth accumulation
parameters(nt::Type{NamedTuple{N,T}}) where {N,T} = (N, T.parameters)
parameters(nt::NamedTuple{N,T}) where {N,T} = (N, T.parameters)

parameters(::Type{T}) where {T} = T.parameters
parameter(::Type{T}, idx) where {T} = getindex(parameters(T), idx)

parameters(x::T) where {T} = parameters(T)
parameter(x::T, idx) where {T} = getindex(parameters(T), idx)


parameters(::Type{T}) where {T} = T.parameters
parameters(::T) where {T} = T.parameters
getparameter(::Type{T}, idx) where {T} = parameters(T)[idx]
getparameters(::Type{T}, idxs) where {T} = parameters(T)[idxs]

# field_<aspect>(::Type{NamedTuple})

#=
 @generated function myfind_gen(s::Symbol, tup::NTuple{N, Symbol}) where {N}
                  ex = :(s === tup[1] && return 1)
                  foreach(2:N) do i
                      ex = :($ex || (s === tup[$i] && return $i))
                  end
                  quote
                      $ex
                      nothing
                  end
              end

@generated fieldnames_fast(x) = Expr(:tuple, (:(fieldnames(x))...))

=#

function field_count(nt::Type{NamedTuple{N,T}}) where {N,T}
    @nospecialize nt
    return nfields(N)
end

function field_names(nt::Type{NamedTuple{N,T}}) where {N,T}
    @nospecialize nt
    return N
end

function field_tupletypes(nt::Type{NamedTuple{N,T}}) where {N,T}
    @nospecialize nt
    return T
end

function field_types(nt::Type{NamedTuple{N,T}}) where {N,T}
    @nospecialize nt
    return T.parameters
end

function field_indices(nt::Type{NamedTuple{N,T}}) where {N,T}
    @nospecialize nt
    ntuple(i->i, field_count(nt))
end

function field_range(nt::Type{NamedTuple{N,T}}) where {N,T}
    @nospecialize nt
    1:field_count(nt)
end

# field_<aspect>(::NamedTuple)

function field_count(nt::NamedTuple{N,T}) where {N,T}
    @nospecialize nt
    return nfields(nt)
end

function field_names(nt::NamedTuple{N,T}) where {N,T}
    @nospecialize nt
    return Base._nt_names(nt)
end

function field_tupletypes(nt::NamedTuple{N,T}) where {N,T}
    @nospecialize nt
    return T
end

function field_types(nt::Type{NamedTuple{N,T}}) where {N,T}
    @nospecialize nt
    return T.parameters
end

function field_indices(nt::NamedTuple{N,T}) where {N,T}
    @nospecialize nt
    ntuple(i->i, field_count(nt))
end

function field_range(nt::NamedTuple{N,T}) where {N,T}
    @nospecialize nt
    1:field_count(nt)
end

function field_values(nt::NamedTuple{N,T}) where {N,T}
    @nospecialize nt
    return values(nt)
end



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

 Expr(:tuple,
      :(T = $T),
      [:($n =
              to_nt(getfield(x, $(QuoteNode(n)))))
              for n in fieldnames(T)
      ]...
     )



@generated function to_nt(x::T) where T
  if isstructtype(T)
    Expr(:tuple, :(T = $T),
         [:($n =
            to_nt( getfield(x, $(QuoteNode(n)))))
                   for n in fieldnames(T)]...)
  else
    :(x)
  end
end

ulia> a = QuoteNode(:a)
:(:a)
julia> :((b=2, $(a.value)=1))
:((b = 2, a = 1))




ay("Boxing Day", 2021)

julia> struct Holiday
         event::String
         year::Int64
       end

julia> boxing_day = Holiday("Boxing Day", 2021)
Holiday("Boxing Day", 2021)

julia> function tont(x::T) where T
       ( # Expr(:tuple, :(T = T),
         [ getfield(x, n) for n in fieldnames(T)]
       ) ;  end
tont (generic function with 1 method)

julia> tont(boxing_day)
2-element Vector{Any}:
     "Boxing Day"
 2021


@generated function untuple2(@nospecialize ::Type{T}) where {T<:Tuple}
           if all(t isa Type for t in T.parameters)
               return Tuple(T.parameters)
           else
               error("Non-type values are not allowed!")
           end
       end


In every successful project I have seen, the priorities are
(a) know what you are going to do before the doing
(b) first explain your intent to another .. there is no second step until they understand
(c) get it right (drawing pictures and writing tests helps)
(d) however easy it is to use, make it easier to use
(e) profiling and benchmarking should direct efforts to speed up the software
(f) all the work only gets you a demo until there is writing that lets others use it well
(g) get here (this is step seven) (edited)





julia> function tont(x::T) where T
       ( # Expr(:tuple, :(T = T),
         [ (n, getfield(x, n)) for n in fieldnames(T)]
       ) ;  end
tont (generic function with 1 method)

2-element Vector{Tuple{Symbol, Any}}:
 (:event, "Boxing Day")
 (:year, 2021)



julia> function tont(x::T) where T
                Expr(:tuple, :(T = T),
                [ (n, getfield(x, n)) for n in fieldnames(T)])
               ;  end
tont (generic function with 1 method)

julia> tont(boxing_day)
:((T = T, Tuple{Symbol, Any}[(:event, "Boxing Day"), (:year, 2021)]))

# ==================================================================


holiday_nt = (event = "Boxing Day", year = 2021)
Holiday_nt = typeof(holiday_nt)

struct Holiday_st
	event::String
	year::Int64
end

holiday_st = Holiday("Boxing Day", 2021)

field_count(@nospecialize nt::NamedTuple{N,T}) where {N,T} = nfields(N)

field_count(@nospecialize ::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)

field_names(@nospecialize nt::NamedTuple{N,T}) where {N,T} = N

field_names(@nospecialize ::Type{NamedTuple{N,T}}) where {N,T} = N

field_typestuple(@nospecialize nt::NamedTuple{N,T}) where {N,T} = T

field_typestuple(@nospecialize ::Type{NamedTuple{N,T}}) where {N,T} = T

field_types(@nospecialize nt::NamedTuple{N,T}) where {N,T} =
    Tuple{T.parameters[2].parameters}

field_types(@nospecialize ::Type{NamedTuple{N,T}}) where {N,T} =
    Tuple{T.parameters[2].parameters}

field_values(@nospecialize nt::NamedTuple{N,T}) where {N,T} =
    values(nt)

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

