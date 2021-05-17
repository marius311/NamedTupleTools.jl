getindices(x, idx::Integer) = getindex(x, idx)
getindices(x, idxs::NTuple{L,T}) where {L, T<:Integer} = Tuple(map(i->getindex(x, i), idxs))
