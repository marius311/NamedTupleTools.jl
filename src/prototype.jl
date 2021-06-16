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

# prototype as constructor from NamedTuple
function prototype(nt::NamedTuple{N,T}) where {N,T}
    @nospecialize nt
    NamedTuple{N,T}
end

const WithTypes = Val{true}()
const WithoutTypes = Val{false}()

function prototype(nt::NamedTuple{N,T}, ::Val{true}) where {N,T}
    @nospecialize nt
    NamedTuple{N,T}
end    
function prototype(nt::NamedTuple{N,T}, ::Val{false}) where {N,T}
    @nospecialize nt
    NamedTuple{N}
end

function prototype(ntt::Type{NamedTuple{N,T}}, ::Val{true}) where {N,T}
    @nospecialize ntt
    NamedTuple{N,T}
end    
function prototype(ntt::Type{NamedTuple{N,T}}, ::Val{false}) where {N,T}
    @nospecialize ntt
    NamedTuple{N}
end


# prototype as a constructor from <empty>
prototype() = NamedTuple{(), Tuple{}}

# idempotency
prototype(x::Type{<:NamedTuple}) = x

# prototype as a constructor from 1+ names
function prototype(names::NTuple{N,Symbol}) where {N}
    @nospecialize names
    NamedTuple{names, Tuple{T}} where {T}
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
    NamedTuple{(name,), Tuple{type...}}
end
function prototype(name::Tuple{Symbol}, type::Type)
    @nospecialize name, type
    NamedTuple{name, Tuple{type}}
end    
function prototype(name::Tuple{Symbol}, type::Tuple{<:Type})
    @nospecialize name, type
    NamedTuple{name, Tuple{type...}}
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

                                            
    
