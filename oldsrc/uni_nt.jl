"""
    named_field

obtains a NamedTuple constituent from within a NamedTuple
- by position or by name
""" named_field

function named_field(x::NamedTuple{N,T}, position::Integer) where {N,T}
    sym = (N[position],)
    typ = Tuple{T.parameters[position]}
    val = x[position]
    return NamedTuple{sym, typ}(val)
end

function named_field(x::NamedTuple{N,T}, name::Symbol) where {N,T}
    sym = (name,)
    typ = Tuple{T.parameters[position]}
    val = getfield(x, name)
    return NamedTuple{sym, typ}(val)
end

function named_fields(x::NamedTuple{N,T}, positions::Vector{Int}) where {I,N,T}
   syms = N[positions]
   typs = Tuple{T.parameters[positions]...} # Tuple{T.parameters[[positions]]...}
   vals = map(i->getindex(x,i) , positions)
 return (syms, typs, vals);  #    return NamedTuple{sym, typ}(val)
end


