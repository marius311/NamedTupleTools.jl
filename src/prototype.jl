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

prototype(x::NamedTuple{N,T}; types::Bool=false) where {N,T} =
    ifelse(types, NamedTuple{N,T}, NamedTuple{N})

prototype(x::Type{NamedTuple{N,T}}; types::Bool=false) where {N,T} =
    ifelse(types, x, NamedTuple{N})

prototype(x::Type{NamedTuple{N}}) where {N} = x

prototype(x::NamedTuple{N,T}, types::NTuple{N,Type}) where {N,T} =
    NamedTuple{N, Tuple{types...}}

prototype(x::Type{NamedTuple{N,T}}, types::NTuple{N,Type}) where {N,T} =
    NamedTuple{N, Tuple{types...}}
