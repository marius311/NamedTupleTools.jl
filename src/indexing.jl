#=
https://discourse.julialang.org/t/splatting-tuples-into-a-named-tuple-implicitly-converts-them-to-pairs/44351/4

julia> args = [(:a, 1), (:b, 2)];

julia> ofargs = (; args...)
(a = 1, b = 2)

----

= 1, b = 2)

julia> args
2-element Vector{Tuple{Symbol, Int64}}:
 (:a, 1)
 (:b, 2)

julia> println(args)
[(:a, 1), (:b, 2)]

julia> args
2-element Vector{Tuple{Symbol, Int64}}:
 (:a, 1)
 (:b, 2)

julia> ofargs = (; args...)
(a = 1, b = 2)

julia> typeof(ans)
NamedTuple{(:a, :b), Tuple{Int64, Int64}}

=#
struct NamedPair 


getpair(ntt::Type{<:NamedTuple}, idx::Integer) =
    Pair(fieldnames(ntt)[idx], fieldtypes(ntt)[idx])

getpair(nt::NamedTuple{N,T}, idx::Integer) where {N,T} =
    Pair(N[idx], T.parameters[idx])

getpair(nt::NamedTuple{N,T}, idx::Integer) where {N,T} =
    Pair(N[idx], ntt[idx])

min_is1(nt) = max(nfields(nt), nfields(nt) - 1)

#=
firstindex(nt::NamedTuple) = 1
lastindex(nt::NamedTuple) = nfields(nt)
=#
second_index(nt::NamedTuple) = 2 
third_index(nt::NamedTuple)  = 3
fourth_index(nt::NamedTuple) = 4
fourth_indexlast(nt::tolast(
thirdlast_index_last(nt::NamedTuple) = max(0, nfields(nt) - 1)
second_lastindex(nt::NamedTuple) = max(0, nfields(nt) - 1)

dnoces

penultimateindex(nt::NamedTuple) = nfields(nt) - 1



#=
# thanks to Mason Protter

function indexof(item::T, seq::NTuple{N, T}) where {N,T}
    if N < 33 
        indexof_recur(item, seq)
    else
        indexof_iter(item, seq)
    end    
end

function indexof_recur(item::T, seq::NTuple{N, T}, idx=1) where {N,T}
    item === first(seq) ? idx : indexof_recur(item, Base.tail(seq), idx+1)
end
indexof_recur(item::T, seq::Tuple{}, idx=1) where {T} = 0

@inline function indexof_iter(item::T, seq::NTuple{N, T}) where {N,T}
    equalsx = Base.Fix2(===, item)
    idx = 1
    for x in seq
        equalsx(x) && break
        idx = idx + 1
    end
    return idx > N ? 0 : idx
end


#=
    `indexof_unroll(sym, tuple)` is the most performant `indexof`.
    tuples of 1:12 symbols are supported

# index_gen from Mason Protter

@generated function indexof_gen(s::Symbol, tup::NTuple{N, Symbol}) where {N}
    ex = :(s === tup[1] && return 1)
    foreach(2:N) do i
        ex = :($ex || (s === tup[$i] && return $i))
    end
    quote
        $ex
        nothing
    end
end

function indexof_unroll(sym::Symbol, tup::NTuple{N,Symbol}) where N
    indexof_unroll(Val(N), sym, tup)
end

function index_of_unrolled(sym, tup::NTuple{N,Symbol}) where N
    x12, r12 = divrem(N,12)
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    !iszero(x12-1) && result = indexof_unroll(Val(12), sym, tup[13:N])
    !iszero(result) && return result    
    return indexof_unroll(Val(r12),sym, tup[N-x12*12+1:end]) + 12
end
=#

function indexof_unroll(::Val{1}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (
    sym === tup[1] && return 1)
    return 0
end

function indexof_unroll(::Val{2}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2)
    return 0
end

function indexof_unroll(::Val{3}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3)
    return 0
end

function indexof_unroll(::Val{4}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4)
    return 0
end

function indexof_unroll(::Val{5}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5)
    return 0
end

function indexof_unroll(::Val{6}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6)
    return 0
end

function indexof_unroll(::Val{7}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6) ||
    sym === tup[7] && return 7)
    return 0
end

function indexof_unroll(::Val{8}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6) ||
    sym === tup[7] && return 7) ||
    sym === tup[8] && return 8)
    return 0
end

function indexof_unroll(::Val{9}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6) ||
    sym === tup[7] && return 7) ||
    sym === tup[8] && return 8) ||
    sym === tup[9] && return 9)
    return 0
end

function indexof_unroll(::Val{10}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((((((
    sym === tup[1]  && return  1) ||
    sym === tup[2]  && return  2) ||
    sym === tup[3]  && return  3) ||
    sym === tup[4]  && return  4) ||
    sym === tup[5]  && return  5) ||
    sym === tup[6]  && return  6) ||
    sym === tup[7]  && return  7) ||
    sym === tup[8]  && return  8) ||
    sym === tup[9]  && return  9) ||
    sym === tup[10] && return 10)
    return 0
end

function indexof_unroll(::Val{11}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((((((((
    sym === tup[1]  && return  1) ||
    sym === tup[2]  && return  2) ||
    sym === tup[3]  && return  3) ||
    sym === tup[4]  && return  4) ||
    sym === tup[5]  && return  5) ||
    sym === tup[6]  && return  6) ||
    sym === tup[7]  && return  7) ||
    sym === tup[8]  && return  8) ||
    sym === tup[9]  && return  9) ||
    sym === tup[10] && return 10) ||
    sym === tup[11] && return 11)
    return 0
end

function indexof_unroll(::Val{12}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((((((((
    sym === tup[1]  && return  1) ||
    sym === tup[2]  && return  2) ||
    sym === tup[3]  && return  3) ||
    sym === tup[4]  && return  4) ||
    sym === tup[5]  && return  5) ||
    sym === tup[6]  && return  6) ||
    sym === tup[7]  && return  7) ||
    sym === tup[8]  && return  8) ||
    sym === tup[9]  && return  9) ||
    sym === tup[10] && return 10) ||
    sym === tup[11] && return 11) ||
    sym === tup[12] && return 12)
    return 0
end

function indexof_unroll(::Val{13}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((((((((((
    sym === tup[1]  && return  1) ||
    sym === tup[2]  && return  2) ||
    sym === tup[3]  && return  3) ||
    sym === tup[4]  && return  4) ||
    sym === tup[5]  && return  5) ||
    sym === tup[6]  && return  6) ||
    sym === tup[7]  && return  7) ||
    sym === tup[8]  && return  8) ||
    sym === tup[9]  && return  9) ||
    sym === tup[10] && return 10) ||
    sym === tup[11] && return 11) ||
    sym === tup[12] && return 12) ||
    sym === tup[13] && return 13)
    return 0
end

function indexof_unroll(::Val{14}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((((((((((
    sym === tup[1]  && return  1) ||
    sym === tup[2]  && return  2) ||
    sym === tup[3]  && return  3) ||
    sym === tup[4]  && return  4) ||
    sym === tup[5]  && return  5) ||
    sym === tup[6]  && return  6) ||
    sym === tup[7]  && return  7) ||
    sym === tup[8]  && return  8) ||
    sym === tup[9]  && return  9) ||
    sym === tup[10] && return 10) ||
    sym === tup[11] && return 11) ||
    sym === tup[12] && return 12) ||
    sym === tup[13] && return 13) ||
    sym === tup[14] && return 14)
    return 0
end

function indexof_unroll(::Val{15}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((((((((((((
    sym === tup[1]  && return  1) ||
    sym === tup[2]  && return  2) ||
    sym === tup[3]  && return  3) ||
    sym === tup[4]  && return  4) ||
    sym === tup[5]  && return  5) ||
    sym === tup[6]  && return  6) ||
    sym === tup[7]  && return  7) ||
    sym === tup[8]  && return  8) ||
    sym === tup[9]  && return  9) ||
    sym === tup[10] && return 10) ||
    sym === tup[11] && return 11) ||
    sym === tup[12] && return 12) ||
    sym === tup[13] && return 13) ||
    sym === tup[14] && return 14) ||
    sym === tup[15] && return 15)
    return 0
end

function indexof_unroll(::Val{16}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((((((((((((
    sym === tup[1]  && return  1) ||
    sym === tup[2]  && return  2) ||
    sym === tup[3]  && return  3) ||
    sym === tup[4]  && return  4) ||
    sym === tup[5]  && return  5) ||
    sym === tup[6]  && return  6) ||
    sym === tup[7]  && return  7) ||
    sym === tup[8]  && return  8) ||
    sym === tup[9]  && return  9) ||
    sym === tup[10] && return 10) ||
    sym === tup[11] && return 11) ||
    sym === tup[12] && return 12) ||
    sym === tup[13] && return 13) ||
    sym === tup[14] && return 14) ||
    sym === tup[15] && return 15) ||
    sym === tup[16] && return 16)
    return 0
end

#=
    support for tuples of length 17..32
      handle the intial 16 using above
      if notfound, the trailing 33-N remain
        handle the trailing 1..16 using above on the tail
=#

function indexof_unroll_17to32(sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(16), sym, tup)
    !iszero(result) && return result
    taillen = N-16
    range = 17:N
    result = indexof_unroll(Val(taillen), sym, tup[range])
    return !iszero(result) ? 16 + result : 0
end

function indexof_unroll_33to64(sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll_17to32(sym, tup[1:32])
    !iszero(result) && return result
    taillen = N-32
    range = 33:N
    result = indexof_unroll_17to32(sym, tup[range])
    return !iszero(result) ? 32 + result : 0
end

function indexof_unroll(::Val{17}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(16), sym, tup)
    !iszero(result) && return result
    result = indexof_unroll(Val(1), sym, tup[17:17])
    return !iszero(result) ? 16 + result : result)
end

function indexof_unroll(::Val{18}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(6), sym, tup[13:18])
end

function indexof_unroll(::Val{19}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(7), sym, tup[13:19])
end

function indexof_unroll(::Val{20}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(8), sym, tup[13:20])
end

function indexof_unroll(::Val{21}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(9), sym, tup[13:21])
end

function indexof_unroll(::Val{22}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(10), sym, tup[13:22])
end

function indexof_unroll(::Val{23}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(11), sym, tup[13:23])
end

function indexof_unroll(::Val{24}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(12), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(12), sym, tup[13:24])
end

function indexof_unroll_25to36(sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll(Val(24), sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(N-24), sym, tup[25:N])
end

function indexof_unroll_37to48(sym::Symbol, tup::NTuple{N,Symbol}) where N
    result = indexof_unroll_25to36(sym, tup)
    !iszero(result) && return result
    return 12 + indexof_unroll(Val(N-36), sym, tup[37:N])
end

=#
