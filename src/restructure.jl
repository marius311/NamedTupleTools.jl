#=
    `restructure` is intended to be a generic method for interconverting data structures (without type piracy).
    - args follow `convert`:  restructure(::Type{Target}, x::Source)

    This file collects conversions that facilitate working with NamedTuples.
=#

#=
    OrderedSets of N elements have implicit field names given as `Tuple(Symbol.(1:N))`
    These constants must be defined before they appear in other source code.
=#

const SymbolicIndices = Symbol.(Tuple(1:FastFieldsMax))

#=
    specific restructurings
=#

#> support for struct types and struct realizations

# struct Type -> NamedTuple Type
restructure(::Type{NamedTuple}, @nospecialize x::Type{T}) where {T} =
    restructure_(Val(isstructtype(x)), NamedTuple, x)
restructure_(::Val{false}, ::Type{NamedTuple}, @nospecialize x::Type{T}) where {T} =
    throw(ErrorException("Restructuring to a NamedTuple Type is not supported for $(T)."))
function restructure_(::Val{true}, ::Type{NamedTuple}, x::Type{T}) where {T}
    namedfields = field_names(x)
    tupletypedfields = field_tupletypes(x)
    return NamedTuple{namedfields, tupletypedfields}
end

# struct realization -> NamedTupleType
# use `restructure(NamedTuple, typeof(struct_realization))`
function restructure(::ValNT, @nospecialize x::LittleDict)
    namedfields = field_names(x)
    tupletypedfields = field_tupletypes(x)
    return NamedTuple{namedfields, tupletypedfields}
end

# struct realization -> NamedTuple realization
restructure(::Type{NamedTuple}, @nospecialize x::T) where {T} =
    restructure_(Val(isstructtype(T)), NamedTuple, x)
restructure_(::Val{false}, ::Type{NamedTuple}, @nospecialize x::T) where {T} =
    throw(ErrorException("Restructuring to a NamedTuple is not supported for $(typeof(x))."))
function restructure_(::Val{true}, ::Type{NamedTuple}, x::T) where {T}
    valuedfields = field_values(x)
    return restructure(NTT, x)(valuedfields)
end

# NamedTuple realization -> struct realiztion
# from baggepinnen discource How do I best convert a nested named tuple..
function nt2struct(nt::NamedTuple{names, types}, ::Type{T}) where {names, types, T}
    fs = ntuple(i->getfield(nt, names[i]), fieldcount(T))
    T(fs...)
end

#> support for LittleDicts, OrderedDicts

for T in (:LittleDict, :OrderedDict)
  @eval begin
    # realization -> NamedTuple Type
    function restructure(::ValNT, @nospecialize x::$T)
        namedfields = field_names(x)
        tupletypedfields = field_tupletypes(x)
        return NamedTuple{namedfields, tupletypedfields}
    end
    # realization -> NamedTuple realization
    function restructure(::Type{NamedTuple}, @nospecialize x::$T)
        valuedfields = field_values(x)
        return restructure(NTT, x)(valuedfields)
    end
  end
end

#> support for Orderedsets

# OrderedSet realization -> NamedTuple Type
function restructure(::ValNT, @nospecialize x::OrderedSet{T}) where {T}
    namedfields = field_names(x)
    tupletypedfields = field_tupletypes(x)
    return NamedTuple{namedfields, tupletypedfields}
end

# OrderedSet realization -> NamedTuple realization
function restructure(::Type{NamedTuple}, @nospecialize x::OrderedSet{T}) where {T}
    valuedfields = field_values(x)
    return restructure(NTT, x)(valuedfields)
end
