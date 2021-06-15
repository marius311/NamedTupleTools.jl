"""
    prototype( (names...) | names...)
    prototype( (names...), (types...) )

    prototype(NT | NTT; types=false)
    prototype(NT | NTT | NTP [, NTuple{nfields, Type} ])

Construct prototypic NamedTuple `schema`.

NamedTuple prototypes are valid constructors.

Prototypes that specify a type for each field expect
a type-matched tuple of values. Prototypes that omit
speicifying types work with any length-matched tuple of values.

|      | kind                 | construct                 |
|:-----|:---------------------|:--------------------------|
| NT   | NamedTuple           | NamedTuple{N,T}(<values>) |
| NTT  | NamedTuple Type      | NamedTuple{N,T}           |
| NTP  | NamedTuple Prototype | NamedTuple{N}             |
""" prototype



# prototype as a constructor from <empty>
prototype() = NamedTuple{(), Tuple{}}

# idempotency
prototype(x::Type{<:NamedTuple}) = x

# prototype as a constructor from 1+ names
function prototype(names::NTuple{N,Symbol}) where {N}
    @nospecialize names
    NamedTuple{names, T} where {T<:Tuple}
end    
function prototype(names::Vararg{Symbol,N}) where {N}
    @nospecialize names
    prototype(names)
end    
function prototype(names::AbstractVector{Symbol})
    @nospecialize names
    prototype(Tuple(names))
end    


# prototype as constructor from 1 name and 1 type
function prototype(name::Symbol, type::Type)
    @nospecialize name, type
    NamedTuple{(name,), Tuple{type}}
end
function prototype(name::Symbol, type::Tuple{<:Type})
    @nospecialize name, type
    NamedTuple{(name,), Tuple{type}}
end
function prototype(name::Tuple{Symbol}, type::Type)
    @nospecialize name, type
    NamedTuple{name, Tuple{type}}
end    
function prototype(name::Tuple{Symbol}, type::Tuple{<:Type})
    @nospecialize name, type
    NamedTuple{name, Tuple{type}}
end

# prototype as constructor from 2+ names and types
function prototype(names::NTuple{N,Symbol}, types::NTuple{N,Type}) where {N}
    @nospecialize names, types
    NamedTuple{names, Tuple{types...}}
end
function prototype(names::AbstractVector{Symbol}, types::AbstractVector{<:Type})
    @nospecialize names, types
    prototype(Tuple(names), Tuple(types))
end
function prototype(names::NTuple{N,Symbol}, types::AbstractVector{<:Type}) where {N}
    @nospecialize names, types
    prototype(names, Tuple(types))
end
function prototype(names::AbstractVector{Symbol}, types::NTuple{N,Type}) where {N}
    @nospecialize names, types
    prototype(Tuple(names), types)
end

#=
# prototype as a constructor from <empty>
prototype() = NamedTuple{(), Tuple{}}

# idempotency
prototype(x::Type{<:NamedTuple}) = x

# prototype as a constructor from 1+ names
@nospecialize prototype(names::NTuple{N,Symbol}) where {N} = NamedTuple{names, T} where {T<:Tuple}
@nospecialize prototype(names::Vararg{Symbol,N}) where {N} = prototype(names)
@nospecialize prototype(names::AbstractVector{Symbol}) = prototype(Tuple(names))

# prototype as constructor from 1 name and 1 type
@nospecialize prototype(name::Symbol, type::Type) = NamedTuple{(name,), Tuple{type}}
@nospecialize prototype(name::Symbol, type::Tuple{<:Type}) = NamedTuple{(name,), Tuple{first(type)}}
@nospecialize prototype(name::Tuple{Symbol}, type::Type) = NamedTuple{name, Tuple{type}}
@nospecialize prototype(name::Tuple{Symbol}, type::Tuple{<:Type}) = NamedTuple{name, Tuple{first(type)}}
    
# prototype as constructor from 2+ names and types
@nospecialize prototype(names::NTuple{N,Symbol}, types::NTuple{N,Type}) where {N} = NamedTuple{names, Tuple{types...}}
@nospecialize prototype(names::AbstractVector{Symbol}, types::AbstractVector{<:Type}) = prototype(Tuple(names), Tuple(types))
@nospecialize prototype(names::NTuple{N,Symbol}, types::AbstractVector{<:Type}) where {N} = prototype(names, Tuple(types))
@nospecialize prototype(names::AbstractVector{Symbol}, types::NTuple{N,Type}) where {N} = prototype(Tuple(names), types)
=$
#=
# prototype as a constructor from name and type
prototype(name::Symbol, type::Type) = NamedTuple{(name,), Tuple{type}}
prototype(name::Symbol, type::NTuple{1,Type}}) = NamedTuple{(name,), Tuple{type}}

        #=prototype(name::Symbol, type::Type{NTuple{1,T}}) where T = NamedTuple{(name,), Tuple{T}}
prototype(name::NTuple{1,Symbol}, type::Type) = NamedTuple{name, Tuple{type}}
prototype(name::NTuple{1,Symbol}, type::Type{NTuple{1,T}}) where T = NamedTuple{name, Tuple{T}}

# prototype as a constructor from names and types


# ⨖ construct prototypes from Tuples


# prototype as a constructor from names and types
prototype(names::Symbol, types::Type) = NamedTuple{(names,), Tuple{types}}
prototype(names::Symbol, types::Tuple) = NamedTuple{(names,), Tuple{types[1]}}
prototype(names::Tuple{Symbol}, types::Type) = NamedTuple{names, Tuple{types}}
prototype(names::Tuple{Symbol}, types::Type{T}) where {T<:Tuple} = NamedTuple{(names,), Tuple{types[1]}}

prototype(names::NTuple{N,Symbol}, types::Type{<:Tuple}) where {N} =
    NamedTuple{names, types}
prototype(names::NTuple{N,Symbol}, types::NTuple{N,DataType}) where {N} =
    prototype(names, Tuple{types...})

# allow vectors
prototype(names::AbstractVector{Symbol})  =
    protot=$ype(Tuple(names))
prototype(names::AbstractVector{Symbol}, types::AbstractVector{DataType})  =
    prototype(Tuple(names), Tuple(types))
prototype(names::AbstractVector{Symbol}, types::NTuple{N,DataType}) where {N}  =
    prototype(Tuple(names), types)
prototype(names::NTuple{N,Symbol}, types::AbstractVector{DataType}) where {N} =
    prototype(names, Tuple(types))

# allow names given as Strings
prototype(names::Vararg{<:AbstractString,N}) where {N} =
    prototype(Symbol.(names))
prototype(names::NTuple{N,<:AbstractString}) where {N} =
    prototype(Symbol.(names))
prototype(names::NTuple{N,<:AbstractString}, types::Type{<:Tuple}) where {N} =
    prototype(Symbol.(names), types)
prototype(names::NTuple{N,<:AbstractString}, types::NTuple{N,DataType}) where {N} =
    prototype(Symbol.(names), types)

prototype(names::AbstractVector{<:AbstractString})  =
    prototype(Symbol.(names))
prototype(names::AbstractVector{<:AbstractString}, types::AbstractVector{DataType})  =
    prototype(Symbol.(names), types)
prototype(names::AbstractVector{<:AbstractString}, types::NTuple{N,DataType}) where {N}  =
    prototype(Symbol.(names), types)
prototype(names::NTuple{N,<:AbstractString}, types::AbstractVector{DataType}) where {N} =
    prototype(Symbol.(names), types)
=#
#=
   prototypes from NamedTuples
=#

# prototype as a constructor from wholes
#=
prototype(x::NamedTuple{N,T}; types::Bool=false) where {N,T} =
    ifelse(types, NamedTuple{N,T}, NamedTuple{N})

prototype(x::Type{NamedTuple{N,T}}; types::Bool=false) where {N,T} =
    ifelse(types, x, NamedTuple{N})

prototype(x::Type{NamedTuple{N}}) where {N} = x

prototype(x::NamedTuple{N,T}, types::NTuple{N,DataType}) where {N,T} =
    NamedTuple{N, Tuple{types...}}

prototype(x::Type{NamedTuple{N,T}}, types::NTuple{N,DataType}) where {N,T} =
    NamedTuple{N, Tuple{types...}}
=#
# `prototype` as a constructor from parts with symbols

# prototype(x::Symbol) = NamedTuple{(x,)}
#=
prototype(x::NTuple{N,Symbol}) where {N} = NamedTuple{x}
prototype(x::Vararg{Symbol}) = NamedTuple{x}
prototype(x::AbstractVector{Symbol}) = prototype(Tuple(x))

prototype(x::String) = prototype(Symbol(x))
prototype(x::NTuple{N,String}) where {N} = prototype(Symbol.(x))
prototype(x::Vararg{String}) = prototype(Symbol.(x))
prototype(x::AbstractVector{String}) = prototype(Tuple(x))

prototype(x::Symbol, y::DataType) = NamedTuple{(x,), Tuple{y}}
prototype(x::Symbol, y::Tuple{DataType}) = NamedTuple{(x,), Tuple{y[1]}}
prototype(x::Tuple{Symbol}, y::DataType) = NamedTuple{x, Tuple{y}}
prototype(x::Tuple{Symbol}, y::Tuple{DataType}) = NamedTuple{x, Tuple{y[1]}}

prototype(x::Pair{Symbol,DataType}) = prototype(first(x), last(x))
prototype(x::Tuple{Symbol,DataType}) = prototype(first(x), last(x))

prototype(x::NTuple{N,Symbol}, y::NTuple{N,DataType}) where {N} = NamedTuple{x, Tuple{y...}}
prototype(x::AbstractVector{Symbol}, y::AbstractVector{DataType}) = NamedTuple{Tuple(x), Tuple{y...}}

prototype(x::NTuple{N,Symbol}) where {N} = NamedTuple{x}
prototype(x::Vararg{Symbol}) = NamedTuple{x}
prototype(x::AbstractVector{Symbol}) = prototype(Tuple(x))

# `prototype` as a constructor from parts with strings

prototype(x::String) = prototype(Symbol(x))
prototype(x::NTuple{N,String}) where {N} = prototype(Symbol.(x))
prototype(x::Vararg{String}) = prototype(Symbol.(x))
prototype(x::AbstractVector{String}) = prototype(Tuple(x))

prototype(x::String, y::Type) = prototype(Symbol(x), y)
prototype(x::Pair{String,Type}) = prototype(first(x), last(x))
prototype(x::Tuple{String,Type}) = prototype(first(x), last(x))

prototype(x::NTuple{N,String}, y::NTuple{N,DataType}) where {N} = prototype(Symbol.(x), y)
prototype(x::NTuple{N,String}, y::NTuple{N,DataType}) where {N} = prototype(Symbol.(x), y)
prototype(x::NTuple{N,String}, y::AbstractVector{DataType}) where {N} = prototype(Symbol.(x), y)

prototype(x::AbstractVector{String}, y::AbstractVector{DataType}) = prototype(Tuple(x), NamedTuple{Tuple(x), Tuple{y...}}
prototype(x::AbstractVector{String}, y::NTuple{N, DataType}) where {N} = NamedTuple{Tuple(x), Tuple{y...}}

prototype(x::AbstractVector{Symbol}, y::AbstractVector{DataType}) = NamedTuple{Tuple(x), Tuple{y...)}

prototype(x::AbstractVector{String}, y::NTuple{N,DataType}) where {N} = NamedTuple{Symbol.(x), Tuple{y...}}
prototype(x::NTuple{N,String}, y::AbstractVector{DataType}) where {N} = NamedTuple{Symbol.(x), Tuple{y...}}

=#
