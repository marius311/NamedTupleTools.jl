select(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T} = 
    NamedTuple{names}(nt)

omit(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T} =
           NamedTuple{Tuple(setdiff(N, names))}(nt)
