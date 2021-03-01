select(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T} = 
    NamedTuple{names}(nt)

function omit(nt::NamedTuple{N,T}, names::Vararg{Symbol}) where {N,T}
    names_to_keep = Tuple( setdiff(N, names) )
    NamedTuple{names_to_keep}(nt)
end
