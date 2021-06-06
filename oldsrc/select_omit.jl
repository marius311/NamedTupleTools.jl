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

omit(nt::NamedTuple{N,T}, omitnames::Vararg{Symbol}) where {N,T} = omit(nt, omitnames)
    
