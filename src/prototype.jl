"""
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

# prototype as a constructor from wholes

prototype(x::NamedTuple{N,T}; types::Bool=false) where {N,T} =
    ifelse(types, NamedTuple{N,T}, NamedTuple{N})

prototype(x::Type{NamedTuple{N,T}}; types::Bool=false) where {N,T} =
    ifelse(types, x, NamedTuple{N})

prototype(x::Type{NamedTuple{N}}) where {N} = x

prototype(x::NamedTuple{N,T}, types::NTuple{N,DataType}) where {N,T} =
    NamedTuple{N, Tuple{types...}}

prototype(x::Type{NamedTuple{N,T}}, types::NTuple{N,DataType}) where {N,T} =
    NamedTuple{N, Tuple{types...}}

# `prototype` as a constructor from parts with symbols

prototype(x::Symbol) = NamedTuple{(x,)}
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
prototype(x::AbstractVector{Symbol}, y::AbstractVector{DataType}) = prototype(Tuple(x), Tuple(y))

prototype(x::NTuple{N,Symbol}) where {N} = NamedTuple{x}
prototype(x::Vararg{Symbol}) = NamedTuple{x}
prototype(x::AbstractVector{Symbol}) = prototype(Tuple(x))

prototype(x::AbstractVector{Symbol}, y::NTuple{N,DataType}) where {N} = prototype(Tuple(x), y)
prototype(x::NTuple{N,Symbol}, y::AbstractVector{DataType}) where {N} = prototype(x, Tuple(y))

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

prototype(x::AbstractVector{String}, y::AbstractVector{DataType}) = NamedTuple{Tuple(x), Tuple{y...}}
prototype(x::AbstractVector{String}, y::NTuple{N, DataType}) where {N} = NamedTuple{Tuple(x), Tuple{y...}}

prototype(x::AbstractVector{Symbol}, y::AbstractVector{DataType}) = prototype(Tuple(x), Tuple(y))

prototype(x::AbstractVector{String}, y::NTuple{N,DataType}) where {N} = prototype(Tuple(x), y)
prototype(x::NTuple{N,String}, y::AbstractVector{DataType}) where {N} = prototype(x, Tuple(y))
