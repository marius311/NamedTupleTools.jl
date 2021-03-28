@generated function index_of(s::Symbol, tup::NTuple{N, Symbol}) where {N}
    @nospecialize d, tup
    ex = :(s === tup[1] && return 1)
        foreach(2:N) do i
            ex = :($ex || (s === tup[$i] && return $i))
        end
    quote
        $ex
        0
    end
end

# foreach sym in syms, iff sym in symbols getindex(symbols, sym)
function indices_of(syms::NTuple{N1,Symbol}, symbols::NTuple{N2, Symbol}) where {N1,N2}
   filter(!iszero, map(s->index_of(s, symbols), syms))
end

indices_of(syms::NTuple{N, Symbol}, nt::NamedTuple{Names,Types}) where {N,Names,Types} = indices_of(syms, N)


# @propagate_inbounds getindex(a::FieldArray, i::Int) = getfield(a, i)

function find_index_of(sym::Symbol, symbols::NTuple{N, Symbol}) where N
   for (idx, symbol) in enumerate(symbols)
      sym === symbol && return idx
   end
   return 0
end

# foreach sym in syms, iff sym in symbols getindex(symbols, sym)
function find_indices_of(syms::NTuple{N1,Symbol}, symbols::NTuple{N2, Symbol}) where {N1,N2}
   filter(!iszero, map(s->find_index_of(s, symbols), syms))
end

find_indices_of(syms::NTuple{N,Symbol}, nt::NamedTuple{N,T}) where {N,T} = find_indices_of(syms, N)

#=
   forall xs | 0  <= length(xs) <= 16 the fastest hand unrolled functions are used
   forall xs | 17 <= length(xs) <= 32 the very fast generated functions are used
   forall xs | 33 <= length(xs)       
=#

function indexof(s::Symbol, tup::NTuple{N, Symbol}) where {N}
    if N < 17
        index_of(Val(N), s, tup)
    else
        index_of(s, tup)
    end
end

# generated function

@generated function index_of(s::Symbol, tup::NTuple{N, Symbol}) where {N}
    ex = :(s === tup[1] && return 1)
        foreach(2:N) do i
            ex = :($ex || (s === tup[$i] && return $i))
        end
    quote
        $ex
        0
    end
end

@generated function index_of(s::Symbol, tup1::NTuple{N1, Symbol}, tup2::NTuple{N2, Symbol}) where {N1, N2}
    ex = :(s === tup1[1] && return 1)
       foreach(2:N1) do i
           ex = :($ex || (s === tup1[$i] && return $i))
       end
       foreach(1:N2) do i
           ex = :($ex || (s === tup2[$i] && return $i+N1))
       end
    quote
       $ex
       0
    end
end


# hand unrolled functions

"""
    index_of(Val(N), x::Symbol, xs::NTuple{N,Symbol}) where N

nothing, if x does not occur in xs, otherwise
idx, where idx is the first (smallest) index where xs[idx] == x

for tuples of 16 or fewer elements, positionof is hand unrolled
""" index_of

function index_of(::Val{0}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    return 0
end

function index_of(::Val{1}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (
    sym === tup[1] && return 1)
    return 0
end

function index_of(::Val{2}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2)
    return 0
end

function index_of(::Val{3}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3)
    return 0
end

function index_of(::Val{4}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4)
    return 0
end

function index_of(::Val{5}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5)
    return 0
end

function index_of(::Val{6}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) ||
    sym === tup[3] && return 3) ||
    sym === tup[4] && return 4) ||
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6)
    return 0
end

function index_of(::Val{7}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{8}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{9}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{10}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{11}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{12}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{13}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{14}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{15}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

function index_of(::Val{16}, sym::Symbol, tup::NTuple{N,Symbol}) where N
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

