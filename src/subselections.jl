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

@inline function selectnames(nt::NamedTuple{N,T}, names::Tuple{Vararg{Symbol}}) where {N,T}
    ntnames = keys(nt)
    return filter(!isnothing, map(sym->occurs_in(sym, ntnames), names))
end

function select(nt::NamedTuple{N,T}, names::Tuple{Vararg{Symbol}}) where {N,T}
    names = selectnames(nt, names)
    return NamedTuple{names}(nt)
end
    
@inline select(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T} = select(nt, names)

function omit(nt::NamedTuple{N,T}, names::Tuple{Vararg{Symbol}}) where {N,T}
    names = Tuple( setdiff(N, names) )
    NamedTuple{names}(nt)
end

function omit(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T}
    names = Tuple( setdiff(N, names) )
    NamedTuple{names}(nt)
end

omit(nt::NamedTuple{N,T}, names::Tuple{}) where {N,T} = nt


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
