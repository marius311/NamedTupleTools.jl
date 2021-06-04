module NamedTupleTools

export # familiar field operations, expanded applicability      (avoids piracy)
       field_count, field_names,     # all  NamedTupleTypes, all NamedTuples
       field_types,                  # some NamedTupleTypes, all NamedTuples
       field_values,                 # none NamedTupleTypes, all NamedTuples
       # data structure interconversions, args follow `convert` (avoids piracy)
       restructure,                  # restructure(::Type{Target}, x::Source)
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
include("restructure.jl")


end  # NamedTupleTools
