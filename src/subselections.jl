select(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T} = 
    NamedTuple{names}(nt)

function omit(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T}
    names = Tuple( setdiff(N, names) )
    NamedTuple{namea}(nt)
end
