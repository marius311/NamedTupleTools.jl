unrolled_indexof(sym::Symbol, tup::NTuple{N,Symbol}) where N =
    unrolled_indexof(Val(N), sym, tup)

function unrolled_indexof(::Val{1}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ( 
    sym === tup[1] && return 1)
    return 0
end

function unrolled_indexof(::Val{2}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2)
    return 0
end

function unrolled_indexof(::Val{3}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) || 
    sym === tup[3] && return 3)
    return 0
end

function unrolled_indexof(::Val{4}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) || 
    sym === tup[3] && return 3) || 
    sym === tup[4] && return 4)
    return 0
end

function unrolled_indexof(::Val{5}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((( 
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) || 
    sym === tup[3] && return 3) || 
    sym === tup[4] && return 4) || 
    sym === tup[5] && return 5)
    return 0
end

function unrolled_indexof(::Val{6}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    (((((( 
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) || 
    sym === tup[3] && return 3) || 
    sym === tup[4] && return 4) || 
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6)
    return 0
end

function unrolled_indexof(::Val{7}, sym::Symbol, tup::NTuple{N,Symbol}) where N
    ((((((( 
    sym === tup[1] && return 1) ||
    sym === tup[2] && return 2) || 
    sym === tup[3] && return 3) || 
    sym === tup[4] && return 4) || 
    sym === tup[5] && return 5) ||
    sym === tup[6] && return 6) ||
    sym === tup[7] && return 7) ||
    return 0
end

#=
from Mason Protter

@generated function myfind_gen(s::Symbol, tup::NTuple{N, Symbol}) where {N}
    ex = :(s === tup[1] && return 1)
    foreach(2:N) do i
        ex = :($ex || (s === tup[$i] && return $i))
    end
    quote
        $ex
        nothing
    end
end
=#