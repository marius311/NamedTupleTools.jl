Base.convert(::Type{Pair}, x::NamedTuple{N,Tuple{T}}) where {N,T} = Pair(N[1], x[1])
Base.convert(NamedTuple, x::Pair{Symbol,T}) where {T} = NamedTuple{(first(x),)}(last(x))
Base.convert(NamedTuple, x::Tuple{Vararg{<:Pair{Symbol,Any}}}) 