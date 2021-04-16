field_count(ntt::Type{NamedTuple{N}}) where {N} = nfields(N)
field_names(ntt::Type{NamedTuple{N}}) where {N} = N

field_count(ntt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_names(ntt::Type{NamedTuple{N,T}}) where {N,T} = N
field_tupletypes(ntt::Type{NamedTuple{N,T}}) where {N,T} = T
field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(T.parameters)

field_count(nt::NamedTuple{N,T}) where {N,T} = nfields(N)
field_names(nt::NamedTuple{N,T}) where {N,T} = N
field_tupletypes(nt::NamedTuple{N,T}) where {N,T} = T
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)

