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

# Tim
You could try doing the recursion in the type domain, 
    Tuple{:a, :b, :c} using Base.tuple_type_head and Base.tuple_type_tail.
        
There is also a trick to get this using tuple_type_head and tuple_type_tail
   from Base. I’m not sure how recommended it is, 
   but it allows to do inferrable recursive definitions with tuple types. 
       I’m removing MyType for simplicity.

from_vec(::Type{Tuple{}}, x) = ()
                
function from_vec(::Type{T}, x) where {T<:Tuple}
    S = Base.tuple_type_head(T)
    T1 = Base.tuple_type_tail(T)
    return (f(S, x), from_vec(T1, x)...)
end

# Then, for example,

julia> f(S, x) = S(x)

julia> from_vec(Tuple{Int, Float64}, 1)
(1, 1.0)        
