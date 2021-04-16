@generated function occurs_in(s::Symbol, tup::NTuple{N, Symbol}) where {N}
    ex = :(s === tup[1] && return s)
       foreach(2:N) do i
           ex = :($ex || (s === tup[$i] && return s))
       end
    quote
       $ex
       nothing
    end
end

@inline function selectnames(nt::NamedTuple{N,T}, keepnames::Tuple{Vararg{Symbol}}) where {N,T}
    ntnames = keys(nt)
    return filter(!isnothing, map(sym->occurs_in(sym, ntnames), keepnames))
end

function select(nt::NamedTuple{N,T}, keepnames::Tuple{Vararg{Symbol}}) where {N,T}
    usenames = selectnames(nt, keepnames)
    return NamedTuple{usenames}(nt)
end
    
@inline select(nt::NamedTuple{N,T}, keepnames::Vararg{Symbol}) where {N,T} = select(nt, keepnames)

@inline not_occurs_in(needles, hay) = filter(straw -> !(straw in needles), hay)

function omit(nt::NamedTuple{N,T}, omitnames::Tuple{Vararg{Symbol}}) where {N,T}
    keepnames = not_occurs_in(omitnames, N)
    NamedTuple{keepnames}(nt)
end

omit(nt::NamedTuple{N,T}, omitnames::Tuple{}) where {N,T} = nt

#=
julia> needles,hay
((:a, :x, :d), (:a, :b, :d))

julia> hay[[foldl(.&,map(.!,[needle .== hay for needle in needles]))...]]
(:b,)


julia> needles, hay
((:a, :x, :d), (:a, :b, :d))

julia> hay[[1,2,3][[ ((1,2,3) .∉ ((1,3),))... ]]]
(:b,)

> @btime hay[[foldl(.&,map(.!,[needle .== $hayr[] for needle in $needlesr[]]))...]]
  252.033 ns (6 allocations: 496 bytes)
(:b,)

julia> map(s->any(s in hay), needles)
(true, false, true)

julia> map(s->!any(s in hay), needles)
(false, true, false)
=#

#=
function omit(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T}
    names = Tuple( setdiff(N, names) )
    NamedTuple{names}(nt)
end
=#

#=
"""
   delete(namedtuple, symbol(s)|Tuple)
   delete(ntprototype, symbol(s)|Tuple)

Generate a namedtuple [ntprototype] from the first arg omitting fields present in the second arg.
see: [`merge`](@ref)
"""
delete(a::NamedTuple, b::Symbol) = Base.structdiff(a, namedtuple(b))
delete(a::NamedTuple, b::NTuple{N,Symbol}) where {N} = Base.structdiff(a, namedtuple(b))
delete(a::NamedTuple, bs::Vararg{Symbol}) = Base.structdiff(a, namedtuple(bs))

delete(::Type{T}, b::Symbol) where {S,T<:NamedTuple{S}} = namedtuple((Base.setdiff(S,(b,))...,))
delete(::Type{T}, b::NTuple{N,Symbol}) where {S,N,T<:NamedTuple{S}} = namedtuple((Base.setdiff(S,b)...,))
delete(::Type{T}, bs::Vararg{Symbol}) where {S,N,T<:NamedTuple{S}} = namedtuple((Base.setdiff(S,bs)...,))
=#

#=
"""
    parameters(x)

obtain the parameters attached to x as a SimpleVector
obtain the kth parameter, reaching in is allowed
"""
Base.@pure parameters(x)      = x.parameters
Base.@pure parameters(x, i)   = x.parameters[i].parameters

Base.@pure parameter(x, i)    = x.parameters[i]
Base.@pure parameter(x, i, j) = x.parameters[i].parameters[j]

getindicies(x, idxs::NTuple{N,Integer}) where N = getindex.(tuple(x), idxs)

"""
    enTuple(x)

wrap the type `Tuple` about x[s] obtaining Tuple{x}, Tuple{xs...}
"""
enTuple(x) = Tuple{x}
enTuple(x::Tuple) = Tuple{x...}
enTuple(x::Vararg{Type}) = Tuple{x...}

"""
    unTuple(x)

dual to
"""

"""
    untuple( Tuple{_} )

Retrieve the types that are internal to the `Type{Tuple{_}}` as a `(tuple,)`.
"""
Base.@pure untuple(::Type{T}) where {T<:Tuple} = (T.parameters...,)
Base.@pure untuple(::Type{T}) where {T<:Tuple{Vararg{Any}}} = T.parameters

"""
    retuple( (_) )

Generate a `Type{Tuple{_}}` with the given internal types as a `Tuple{_}`.
"""
Base.@pure retuple(x::Tuple) = Tuple{x...,}
=#
