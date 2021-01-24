#=
    Field based nondestructive ops for NamedTuples and struts

      op(x::T)      ⟣  fieldvalues(x)
      op(::Type{T}) ⟣  fieldcount(T), fieldnames(T), fieldtypes(T)

    Our field-oriented discernment functions are reliable and performant.
    
    Most programming languages provide functions designed for the processing of values.
    Fewer are designed with methods for the processing of types. Julia does both well.

    Three of these methods are field-oriented operations that apply to types with fields.
    The fourth method is field-focused, as it is applies to values with these same types.
    
    `fieldcount(_)`, `fieldnames(_)`, and `fieldtypes(_)` accept type-valued variables.
    `fieldvalues(_)` applies to variables with assigned values rather than their types.


    

=#

Base.@pure get_parameters(::Type{T}) where {T} = (T).parameters

Base.@pure Base.fieldnames(::Type{NamedTuple{N,T}}) where {N,T} = (N)
Base.fieldcount(::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
Base.fieldtypes(::Type{NamedTuple{N,T}}) where {N,T} =
    Tuple(get_parameters(T))

fieldvalues(nt::NamedTuple{N,T}) where {N,T} = Tuple(nt)

fieldvalues(x::T) where {T} = isstructtype(T) &&
    getfield.((x,), fieldnames(T))

