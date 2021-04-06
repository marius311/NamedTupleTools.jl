
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
