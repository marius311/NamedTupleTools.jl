"""
    indexof(Val(N), x::Symbol, xs::NTuple{N,Symbol}) where N

nothing, if x does not occur in xs, otherwise
idx, where idx is the first (smallest) index where xs[idx] == x

for tuples of 16 or fewer elements, positionof is hand unrolled
""" indexof

function indexof(::Val{1}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (
    sym === tup[1] && return 1)
    return 0
end

function indexof(::Val{2}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2)
    return 0
end

function indexof(::Val{3}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3)
    return 0
end

function indexof(::Val{4}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4)
    return 0
end

function indexof(::Val{5}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5)
    return 0
end

function indexof(::Val{6}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6)
    return 0
end

function indexof(::Val{7}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{8}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{9}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{10}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{11}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{12}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{13}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{14}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{15}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function indexof(::Val{16}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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
    zero(Int)

