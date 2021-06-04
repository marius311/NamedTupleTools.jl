module NamedTupleTools

export # familiar field operations, expanded applicability      (avoids piracy)
       field_count, field_names,     # all  NamedTupleTypes, all NamedTuples
       field_types,                  # some NamedTupleTypes, all NamedTuples
       field_values,                 # none NamedTupleTypes, all NamedTuples
       # data structure interconversions, args follow `convert` (avoids piracy)
       restructure,                  # restructure(::Type{Target}, x::Source)
#=

       restructure(::Type{Struct}, x::NamedTuple) 
       restructure(::Type{NamedTuple}, x) = restructure_(Val(isstructtype(x)), NamedTuple, x)
       restructure_(::Val{true}, ::Type{NamedTuple}, x)
       restructure_(::Val{false}, ::Type{NamedTuple}, x) = throw
=#
       # editing: include, exclude,
       reposition_fields, reposition_field,
       remove_from,
       prepend_fields,  prepend_field,
       postpend_fields, postpend_field,


namedtuple

# Julia could define Struct
if !isdefined(Base, :Struct)
    abstract type Struct end
else
    import Struct
end
export Struct

include("support.jl")
include("field_ops.jl")



end  # NamedTupleTools
