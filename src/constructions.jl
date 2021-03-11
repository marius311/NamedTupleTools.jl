#= to_nt is from Mason Protter

@generated function to_nt(x::T) where T
    if isstructtype(T)
      Expr(:tuple, :(T = $T), [:($n = to_nt(getfield(x, $(QuoteNode(n))))) for n in fieldnames(T)]...)
    else
      :(x)
    end
end
=#

# dispatches(x::Type{Tuple{}}) dispatches(Tuple{}}
# dispatches(x::Type{Tuple{T}}) where T dispatches(Tuple{Int})
# dispatches(x::Type{NTuple{N,T}}) where {N,T} dispatches(Tuple{Int,..,Int}) 
# dispatches(x::NTuple{N,Type}) where N dispatches((Int, String, ..))
#
#   dispatch(::Type{T}) where {T<:Tuple} = dispatch_helper(T.parameters...,)
#   dispatch_helper(x::Vararg{Type}) = x # or something else (a transform of x)
#
#

#=
    make <this> <named> [from] <that>
=#

@generated function make(::Type{NamedTuple}, astruct::DataType)
    NT = NamedTuple{fieldnames(obj), Tuple{fieldtypes(obj)...}}
    return :($NT(tuple($((:(getfield(obj, $i)) for i in 1:fieldcount(obj))...))))
 end



make(::Type{DataType}, structname::Symbol, NT::Type{NamedTuple{N,T}}) where {N,T} =
    makestruct(structname, N, Tuple(T.parameters))
    
# Expr part from Fredrik Ekre
structexpr(structname, names, types) =
    "Expr(:struct,
        false,
        Expr(:curly,
             :$structname
        ),
        Expr(:block,
             map((x,y) -> Expr(:(::), x, y), $names, $types)...
        )
    )"

makestruct(structname, names, types) = 
    (eval(eval(Meta.parse(structexpr(structname, names, types)))); return eval(structname))


#=
answered Mar 27 '20 at 10:00
François Févotte

Creation

       # regular syntax
julia> nt = (a=1, b=2.)
(a = 1, b = 2.0)

       # empty named tuple (useful as a seed that will later grow)
julia> (;) # or NamedTuple() 
NamedTuple()

       # only one entry => either use `;` or don't forget the comma
julia> (; a = 1), (b = 2,)
(a = 1,), (b = 2,)


Growth and "modification"

It is possible to merge two named tuples to create a new one:

julia> merge(nt, (c=3, d=4.))
(a = 1, b = 2.0, c = 3, d = 4.0)

...or to re-use an existing NamedTuple by splatting it in the creation of a new one:

julia> (; nt..., c=3, d=4.)
(a = 1, b = 2.0, c = 3, d = 4.0)

When the same field name appears multiple times, the last occurrence is kept. This allows for a form of "copy with modification":

julia> nt
(a = 1, b = 2.0)

julia> merge(nt, (b=3,))
(a = 1, b = 3)

julia> (; nt..., b=3)
(a = 1, b = 3)


Dynamic manipulations

Using field=>value pairs in the various techniques presented above allows for more dynamic manipulations:

julia> field = :c;

julia> merge(nt, [field=>1])
(a = 1, b = 2.0, c = 1)

julia> (; nt..., field=>1)
(a = 1, b = 2.0, c = 1)

The same technique can be used to build NamedTuples from existing dynamic data structures

julia> dic = Dict(:a=>1, :b=>2);
julia> (; dic...)
(a = 1, b = 2)

julia> arr = [:a=>1, :b=>2];
julia> (; arr...)
(a = 1, b = 2)


Iteration

Iterating on a NamedTuple iterates on its values:

julia> for val in nt
           println(val)
       end
1
2.0

Like all key->value structures, the keys function can be used to iterate over the fields:

julia> for field in keys(nt)
           val = nt[field]
           println("$field => $val")
       end
a => 1
b => 2.0

=#

#=
julia> ntkw = (a = [1,2], b = [:x, :y, :z], c = 2)
(a = [1, 2], b = [:x, :y, :z], c = 2)

julia> NTkw = typeof(ntkw)
NamedTuple{(:a, :b, :c),Tuple{Array{Int64,1},Array{Symbol,1},Int64}}

julia> fieldnames(NTkw), Tuple(ntkw)
((:a, :b, :c), ([1, 2], [:x, :y, :z], 2))

julia> map((n,v)->Pair(n,v),fieldnames(NTkw),Tuple(ntkw))
(:a => [1, 2], :b => [:x, :y, :z], :c => 2)

julia> fieldnames(NTkw), Tuple(ntkw)
((:a, :b, :c), ([1, 2], [:x, :y, :z], 2))

julia> NamedTuple{fieldnames(NTkw)}(Tuple(ntkw))
(a = [1, 2], b = [:x, :y, :z], c = 2)
=#
