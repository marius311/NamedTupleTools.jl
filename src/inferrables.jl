#=
       tuple operations from within Base

julia> atuple = Tuple{:a, :b, :c, :d};
julia> nelems = Base._counttuple(atuple)
4

Tuple{Nothing, Int64, Missing}

julia> tuptyp = Base.tuple_type_cons(Float64, tuptyp)
Tuple{Float64, Nothing, Int64, Missing}

julia> Base.tuple_type_head(tuptyp)
Float64

julia> Base.tuple_type_tail(tuptyp)
Tuple{Nothing, Int64, Missing}

function tuple_type_tail(T::Type)
    @_pure_meta # TODO: this method is wrong (and not @pure)
    if isa(T, UnionAll)
        return UnionAll(T.var, tuple_type_tail(T.body))
    elseif isa(T, Union)
        return Union{tuple_type_tail(T.a), tuple_type_tail(T.b)}
    else
        T.name === Tuple.name || throw(MethodError(tuple_type_tail, (T,)))
        if isvatuple(T) && length(T.parameters) == 1
            va = T.parameters[1]
            (isa(va, DataType) && isa(va.parameters[2], Int)) || return T
            return Tuple{Vararg{va.parameters[1], va.parameters[2]-1}}
        end
        return Tuple{argtail(T.parameters...)...}
    end
end


# deprecations
tuple_type_head(T::Type) = fieldtype(T, 1)
tuple_type_cons(::Type, ::Type{Union{}}) = Union{}
function tuple_type_cons(::Type{S}, ::Type{T}) where T<:Tuple where S
    @_pure_meta
    Tuple{S, T.parameters...}
end
# convenience function for extracting N from a Tuple (if defined)
# else return `nothing` for anything else given (such as Vararg or other non-sized Union)
_counttuple(::Type{<:NTuple{N,Any}}) where {N} = N
_counttuple(::Type) = nothing



=#

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
                
                
 const Tup = Union{Tuple, NamedTuple}
const EmptyTup = Union{Tuple{}, NamedTuple{(), Tuple{}}}

                
                # StructArrays
@generated function staticschema(::Type{T}) where {T}
    name_tuple = Expr(:tuple, [QuoteNode(f) for f in fieldnames(T)]...)
    type_tuple = Expr(:curly, :Tuple, [Expr(:call, :fieldtype, :T, i) for i in 1:fieldcount(T)]...)
    Expr(:curly, :NamedTuple, name_tuple, type_tuple)
end

staticschema(::Type{T}) where {T<:Tup} = T

createinstance(::Type{T}, args...) where {T} = T(args...)
createinstance(::Type{T}, args...) where {T<:Union{Tuple, NamedTuple}} = T(args)
                
eltypes(::Type{T}) where {T} = map_params(eltype, T)

map_params(f, ::Type{Tuple{}}) = Tuple{}
function map_params(f, ::Type{T}) where {T<:Tuple}
    tuple_type_cons(f(tuple_type_head(T)), map_params(f, tuple_type_tail(T)))
end
map_params(f, ::Type{NamedTuple{names, types}}) where {names, types} =
    NamedTuple{names, map_params(f, types)}

_map_params(f, ::Type{Tuple{}}) = ()
function _map_params(f, ::Type{T}) where {T<:Tuple}
    (f(tuple_type_head(T)), _map_params(f, tuple_type_tail(T))...)
end
_map_params(f, ::Type{NamedTuple{names, types}}) where {names, types} =
    NamedTuple{names}(_map_params(f, types))

buildfromschema(initializer, ::Type{T}) where {T} = buildfromschema(initializer, T, staticschema(T))

function buildfromschema(initializer, ::Type{T}, ::Type{NT}) where {T, NT<:Tup}
    nt = _map_params(initializer, NT)                


# Tim and Mason
                    
Keys(::NamedTuple{K}) where {K} = Tuple{K...}

function copyto_type_recursive!(target::Wrapper{T, F}, 
                                source::Wrapper{T, F}) where {T, F}
    copyto_type_recursive!(target, source, Keys(F))
    target
end

@inline function copyto_type_recursive!(target::Wrapper{T, F}, 
                                        source::Wrapper{T, F}, 
                                        ::Type{Tup}) where {T, F, Tup <: Tuple}
    Tup === Tuple{} && return nothing
    property = Base.tuple_type_head(Tup)
    setproperty!(target, property, getproperty(source, property))
    copyto_type_recursive!(target, source, Base.tuple_type_tail(Tup))
end
                    
