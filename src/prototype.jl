"""
    prototype( (names...) | names...)
    prototype( (names) | [names], (types) | [types] )
    - names, types may be given as a tuple or a vector

    prototype(NT | NTT | NTP)

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

# constructor from <empty>
prototype() = NamedTuple{(), Tuple{}}

# constructor from NamedTuple and Type{NamedTuple}
function prototype(ntt::Type{NamedTuple})
    @nospecialize ntt
    ntt
end
function prototype(nt::NamedTuple)
    @nospecialize nt
    typeof(nt)
end

# constructor from Symbols
function prototype(names::NTuple{N,Symbol}) where {N}
    @nospecialize names
    NamedTuple{names, T} where {T<:Tuple}
end
function prototype(names::Vararg{Symbol})
    @nospecialize names
    prototype(names)
end
function prototype(names::AbstractVector{Symbol})
    @nospecialize names
    prototype(Tuple(names))
end

# constructor from 1 name and 1 type
function prototype(name::Symbol, type::Type)
    @nospecialize name, type
    NamedTuple{(name,), Tuple{type}}
end
function prototype(name::Symbol, type::Tuple{<:Type})
    @nospecialize name, type
    NamedTuple{(name,), Tuple{type...}}
end

# prototype as constructor from N names and N types
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
