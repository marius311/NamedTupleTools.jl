#=
    `restructure` is intended to be a generic method for interconverting data structures (without type piracy).
    - args follow `convert`:  restructure(::Type{Target}, x::Source)

    This file collects conversions that facilitate working with NamedTuples.
=#

function restructure(::Type{NamedTuple}, x::T) where {T<:OrderedDict}
    
#=

       restructure(::Type{Struct}, x::NamedTuple) 
       restructure(::Type{NamedTuple}, x) = restructure_(Val(isstructtype(x)), NamedTuple, x)
       restructure_(::Val{true}, ::Type{NamedTuple}, x)
       restructure_(::Val{false}, ::Type{NamedTuple}, x) = throw
=#
    
#=
    support for specific restructurings
=#
    
# support for OrderedCollections, including LittleDicts
isfrozen(@nospecialize x::LittleDict{K,V, <:Tuple, <:Tuple}) where {K,V} = true
isfrozen(@nospecialize x::LittleDict{K,V, <:Vector, <:Vector) where {K,V} = false
isfrozen(@nospecialize x::AbstractDict) = false
isfrozen(@nospecialize x::OrderedSet)  = true

# support for LittleDicts
unfreeze(@nospecialize x::LittleDict{K,V, <:Tuple, <:Tuple) where {K,V} =
    LittleDict(keys(x), values(x))
