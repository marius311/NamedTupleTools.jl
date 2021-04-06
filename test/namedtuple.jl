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

