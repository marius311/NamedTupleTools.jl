"""
   select(namedtuple, symbol(s)|Tuple)
   select(ntprototype, symbol(s)|Tuple)

Generate a namedtuple [ntprototype] from the first arg, 
including only fields present in the second arg.
see: [`merge`](@ref)
"""

function select(nt::NamedTuple, sym::Symbol)
    @nospecialize nt sym
    getfield(nt, sym)
end

function select(nt::NamedTuple, syms::NTuple{N,Symbol}) where {N}
    @nospecialize nt syms
    ntuple(i->getfield(nt, syms[i]), N)
end

select(nt::NamedTuple, k::NamedTuple) = select(nt, keys(k))
select(nt::NamedTuple, ks) = namedtuple(ks)(((nt[k] for k in ks)...,))

function deselect(nt::NamedTuple, syms::NTuple{N, Symbol}) where {N}
    @nospecialize nt syms
    symbols = tuplediff(keys(nt), syms)
    select(nt, symbols)
end

function deselect(nt::NamedTuple, sym::Symbol)
    @nospecialize nt sym
    deselect(nt, (sym,))
end

function deselect(nt::NamedTuple, without::NamedTuple)
    @nospecialize nt without
    deselect(nt, keys(without))
end

#=
map(s->in(s,allsyms) && s, syms)

julia> syms = (:b, :d)
(:b, :d)

julia> filter(t->typeof(t) === Symbol, map(s->!in(s,syms) && s, allsyms))
(:a, :c)

filter(s->!in(s,syms), allsyms)

# from Jakob Nybo Nissen
_setdiff(t1::Tuple, t2::Tuple) = filter(∉(t2), t1)
# from Jakob Nybo Nissen
function tuplediff(a::SymTuple, b::SymTuple)
    ntuple(length(a) - length(b)) do i
        n = 0
        for (j, ia) in pairs(a)
            n += ia ∉ b
            n == i && return ia
        end
    end
end

function tuplediff(a::SymTuple, b::SymTuple)
    ntuple(length(a) - length(b)) do i
        n = 0
        for (j, ia) in pairs(a)
            n += ia ∉ b
            n == i && return ia
        end
        error()
    end
end

=#