"""
    prototype(::Type{NamedTuple{N}})
    prototype(::Type{NamedTuple{N,T}}; types::Bool=false)
    prototype(::NamedTuple{N,T}; types::Bool=false)

generate a prototypic NamedTuple `schema` from the given arg[s]

|      | kind                 | construct                 |
|:-----|:---------------------|:--------------------------|
| NTP  | NamedTuple Prototype | NamedTuple{N}             |
| NTT  | NamedTuple Type      | NamedTuple{N,T}           |
| NT   | NamedTuple           | NamedTuple{N,T}(<values>) |

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
