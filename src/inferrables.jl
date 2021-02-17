#=
KristofferC
https://github.com/JuliaLang/julia/issues/29100
=#
@generated function field_names(t::Type{T}) where {T}
    return :($(Expr(:tuple, [QuoteNode(f) for f in fieldnames(T)]...)))
end

@generated function field_types(t::Type{T}) where {T}
    return :($(Expr(:tuple, [QuoteNode(f) for f in fieldtypes(T)]...)))
end

Base.@pure function _fieldnames(@nospecialize t) 
     if t.name === NamedTuple_typename 
         if t.parameters[1] isa Tuple 
             return t.parameters[1] 
         else 
             throw(ArgumentError("type does not have definite field names")) 
         end 
     end 
     isdefined(t, :names) ? t.names : t.name.names 
 end
 
 Base.@pure function _fieldtypes(@nospecialize t) 
     if t.name === NamedTuple_typename 
         if t.parameters[2] isa Tuple 
             return t.parameters[2].parameters 
         else 
             throw(ArgumentError("type does not have definite field types")) 
         end 
     end 
     isdefined(t, :types) ? t.types : t.name.types 
 end
