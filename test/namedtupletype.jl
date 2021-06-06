ntt(x::Symbol) = NamedTuple{(x,)}
ntt(x::NTuple{N,Symbol}) where {N} = NamedTuple{x}
ntt(x::Vararg{Symbol}) = NamedTuple{x}
ntt(x::AbstractVector{Symbol}) = ntt(Tuple(x))

ntt(x::String) = ntt(Symbol(x))
ntt(x::NTuple{N,String}) where {N} = ntt(Symbol.(x))
ntt(x::Vararg{String}) = ntt(Symbol.(x))
ntt(x::AbstractVector{String}) = ntt(Tuple(x))

ntt(x::Symbol, y::Type) = NamedTuple{(x,), Tuple{y}}
ntt(x::Pair{Symbol,Type}) = ntt(first(x), last(x))
ntt(x::Tuple{Symbol,Type}) = ntt(first(x), last(x))

ntt(x::NTuple{N,Symbol}, y::NTuple{N,Type}) = NamedTuple{x, Tuple{y...})
    
ntt(x::NTuple{N,Symbol}) where {N} = NamedTuple{x}
ntt(x::Vararg{Symbol}) = NamedTuple{x}
ntt(x::AbstractVector{Symbol}) = ntt(Tuple(x))

ntt(x::String) = ntt(Symbol(x))
ntt(x::NTuple{N,String}) where {N} = ntt(Symbol.(x))
ntt(x::Vararg{String}) = ntt(Symbol.(x))
ntt(x::AbstractVector{String}) = ntt(Tuple(x))

ntt(x::String, y::Type) = ntt(Symbol(x), y)
ntt(x::Pair{String,Type}) = ntt(first(x), last(x))
ntt(x::Tuple{String,Type}) = ntt(first(x), last(x))

ntt(x::NTuple{N,String}, y::NTuple{N,Type}) = ntt{Symbol.(x), y)
          

@test ntt() == NamedTuple{(), Tuple{}}
@test ntt(:a) == NamedTuple{(:a,)}
@test ntt("a") == NamedTuple{(:a,)}
@test ntt(:a, :b) == NamedTuple{(:a, :b)}
@test ntt("a", "b") == NamedTuple{(:a, :b)}
@test ntt((:a,)) == NamedTuple{(:a,)}
@test ntt(("a",)) == NamedTuple{(:a,)}
@test ntt((:a, :b)) == NamedTuple{(:a, :b)}
@test ntt(("a", "b")) == NamedTuple{(:a, :b)}
@test ntt([:a, :b]) == NamedTuple{(:a, :b)}
@test ntt(["a", "b"]) == NamedTuple{(:a, :b)}

@test ntt(:a, Int) == NamedTuple{(:a,), Tuple{Int}}
@test ntt("a", Int) == NamedTuple{(:a,), Tuple{Int}}
@test ntt(:a, (Int,)) == NamedTuple{(:a,), Tuple{Int}}
@test ntt("a", (Int,)) == NamedTuple{(:a,), Tuple{Int}}
@test ntt((:a,), Int) == NamedTuple{(:a,), Tuple{Int}}
@test ntt(("a",), Int) == NamedTuple{(:a,), Tuple{Int}}

@test ntt((:a,), (Int,)) == NamedTuple{(:a,), Tuple{Int}}
@test ntt(("a",), (Int,)) == NamedTuple{(:a,), Tuple{Int}}
@test ntt((:a, :b), (Int, String)) == NamedTuple{(:a, :b), Tuple{Int, String}}
@test ntt(("a", "b"), (Int, String)) == NamedTuple{(:a, :b), Tuple{Int, String}}
@test ntt([:a, :b], (Int, String)) == NamedTuple{(:a, :b), Tuple{Int, String}}
@test ntt(["a", "b"], (Int, String)) == NamedTuple{(:a, :b), Tuple{Int, String}}

@test ntt((:a,), [Int,]) == NamedTuple{(:a,), Tuple{Int}}
@test ntt(("a",), [Int,]) == NamedTuple{(:a,), Tuple{Int}}
@test ntt((:a, :b), [Int, String]) == NamedTuple{(:a, :b), Tuple{Int, String}}
@test ntt(("a", "b"), [Int, String]) == NamedTuple{(:a, :b), Tuple{Int, String}}
@test ntt([:a, :b], [Int, String]) == NamedTuple{(:a, :b), Tuple{Int, String}}
@test ntt(["a", "b"], [Int, String]) == NamedTuple{(:a, :b), Tuple{Int, String}}

#=
@test nt() == NamedTuple{(), Tuple{}}()
@test nt(:a) == NamedTuple{(:a,)}
@test nt("a") == NamedTuple{(:a,)}
@test nt(:a, :b) == NamedTuple{(:a, :b)}
@test nt("a", "b") == NamedTuple{(:a, :b)}

@test nt((:a,)) == NamedTuple{(:a,)}
@test nt(("a",)) == NamedTuple{(:a,), Tuple{String}}("a")
@test nt((:a, :b)) == NamedTuple{(:a, :b)}
@test nt(("a", "b")) == NamedTuple{(:a, :b), Tuple{String, String}}("a", "b")
@test nt([:a, :b]) == NamedTuple{(:a, :b)}
@test nt(["a", "b"]) == NamedTuple{(:a, :b), Tuple{String, String}}("a", "b")

@test nt(:a, x::T) where {T} == NamedTuple{(:a,), Tuple{T}}(z)
@test nt("a", x::T) where {T} == NamedTuple{(:a,), Tuple{T}}(z)
=#
