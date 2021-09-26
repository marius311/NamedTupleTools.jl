module NamedTupleTools

export namedtuple,                      # harmonious multifaceted tooling
    prototype, WithTypes, WithoutTypes, # forming NamedTuple Types
    # support a canonical internal ordering for NamedTuples and their types
    #    lexicographic over field names `sort(nt::NamedTuple)`
    #    lexicographic over field names `sort(ntt::Type{NamedTuple})`
    canonical,
    #    isbijection(nt1, nt2) <--> sort(nt1) == sort
    isbijection, ↔,
    # largest fieldcounts supporting each of 3 levels of additional performance
    FastestFieldsMax, FasterFieldsMax,  FastFieldsMax,
    # familiar field operations, expanded applicability      (avoids piracy)
    field_count, field_names,          # all  NamedTupleTypes, all NamedTuples
    field_types, field_tupletypes,     # some NamedTupleTypes, all NamedTuples
    field_values,                      # none NamedTupleTypes, all NamedTuples
    restructure,                       # restructure(::Type{Target}, x::Source)
    # incorporate fields not already present by name
    prepend, postpend,                 # add as first [last] field
    # remove field[s] by name, by index
    delete,
    # reposition a field within target type
    reposition,
    # substitute one field for another within target type
    substitute # substitute(TargetType, old_field_names, new_fields)


# Julia could define Struct
try
    abstract type Struct end
catch
    nothing
end


using OrderedCollections: OrderedSet, LittleDict, OrderedDict, freeze

const FastestFieldsMax = 16
const FasterFieldsMax  = 32
const FastFieldsMax    = 64

# dispatch on NamedTuple Types using dispatchable const `Val{T}() where T<:Type`
const ValNT = Val{NamedTuple}
const NTT = ValNT()

include("support.jl")

include("field_ops.jl")
include("prototype.jl")


include("select_omit.jl")



end  # NamedTupleTools
