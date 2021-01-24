#=
    field ops for NamedTuples and struts

    op(x::T)      ⟣  fieldvalues(x)
    op(::Type{T}) ⟣  fieldcount(T), fieldnames(T), fieldtypes(T)
=#

Base.@pure get_parameters(::Type{T}) where {T} = (T).parameters

Base.@pure Base.fieldnames(::Type{NamedTuple{N,T}}) where {N,T} = (N)
Base.fieldcount(::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
Base.fieldtypes(::Type{NamedTuple{N,T}}) where {N,T} =
    Tuple(get_parameters(T))

fieldvalues(nt::NamedTuple{N,T}) where {N,T} = Tuple(nt)

fieldvalues(x::T) where {T} = isstructtype(T) &&
    map(field->getfield(x, field), fieldnames(T))

fieldvalues(x::T) where {T} = isstructtype(T) &&
    getfield.((x,), fieldnames(T))

