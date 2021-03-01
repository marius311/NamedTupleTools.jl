select(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T} = 
    NamedTuple{names}(nt)

select(nt::NamedTuple{N,T}, names::Tuple{}) where {N,T} = (;)

function omit(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T}
    names = Tuple( setdiff(N, names) )
    NamedTuple{names}(nt)
end

omit(nt::NamedTuple{N,T}, names::Tuple{}) where {N,T} = nt

