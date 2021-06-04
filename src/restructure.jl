#=
    `restructure` is intended to be a generic method for interconverting data structures (without type piracy).
    - args follow `convert`:  restructure(::Type{Target}, x::Source)

    This file collects conversions that facilitate working with NamedTuples.
=#

function restructure(::Type{NamedTuple}, x::T) where {T<:OrderedDict}

# support for Structs

# struct Type -> NamedTuple Type
restructure(::Type{NamedTuple}, @nospecialize x::Type{T}) where {T} = 
    restructure_(Val(isstructtype(x)), NamedTuple, x)
restructure_(::Val{false}, ::Type{NamedTuple}, @nospecialize x::Type{T}) where {T} =
    throw(ErrorException("Restructuring to a NamedTuple Type is not supported for $(T)."))
function restructure_(::Val{true}, ::Type{NamedTuple}, x::Type{T}) where {T} =
    namedfields = field_names(x)
    tupletypedfields = field_tupletypes(x)
    return NamedTuple{namedfields, tupletypedfields}
end

# struct realization -> NamedTuple realization
restructure(::Type{NamedTuple}, @nospecialize x::T) where {T} =
    restructure_(Val(isstructtype(T)), NamedTuple, x)
restructure_(::Val{false}, ::Type{NamedTuple}, @nospecialize x::T) where {T} =
    throw(ErrorException("Restructuring to a NamedTuple is not supported for $(typeof(x))."))
function restructure_(::Val{true}, ::Type{NamedTuple}, x:::T) where {T} =
    namedfields = field_names(x)
    tupletypedfields = field_tupletypes(x)
    return NamedTuple{namedfields, tupletypedfields}(values(x))
end

# struct realization -> NamedTupleType
# use `restructure(NamedTuple, typeof(struct_realization))`
    
#=

       restructure(::Type{Struct}, x::NamedTuple) 
       restructure(::Type{NamedTuple}, @nospecialize x::T) where {T} = restructure_(Val(isstructtype(T)), NamedTuple, x)
       restructure_(::Val{true}, ::Type{NamedTuple}, x)
       restructure_(::Val{false}, ::Type{NamedTuple}, x) = throw
=#
    
#=
    support for specific restructurings
=#
    
# support for LittleDicts, extended to other OrderedCollections
isfrozen(@nospecialize x::LittleDict{K,V, <:Tuple, <:Tuple}) where {K,V} = true
isfrozen(@nospecialize x::LittleDict{K,V, <:Vector, <:Vector) where {K,V} = false
isfrozen(@nospecialize x::AbstractDict) = false
isfrozen(@nospecialize x::OrderedSet)  = true
# OrderedCollections exports `frozen = freeze(::LittleDict)`
unfreeze(@nospecialize x::LittleDict{K,V, <:Tuple, <:Tuple) where {K,V} =
    LittleDict(keys(x), values(x))
