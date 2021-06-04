module NamedTupleTools

export # familiar field operations, expanded applicability      (avoids piracy)
       field_count, field_names,     # all  NamedTupleTypes, all NamedTuples
       field_types,                  # some NamedTupleTypes, all NamedTuples
       field_values,                 # none NamedTupleTypes, all NamedTuples
       # data structure interconversions, args follow `convert` (avoids piracy)
       restructure,  Struct,         # restructure(::Type{Target}, x::Source)
#=
       abstract type Struct end

       restructure(::Type{Struct}, x::NamedTuple) 
       restructure(::Type{NamedTuple}, x) = restructure_(Val(isstructtype(x)), NamedTuple, x)
       restructure_(::Val{true}, ::Type{NamedTuple}, x)
       restructure_(::Val{false}, ::Type{NamedTuple}, x) = throw
=#
       from, # from(::Tuple, x::Tuple) = x; from(::DataType, x::NamedTuple)    restructure(::NamedTuple, x::DataType)
       astuple, asnamedtuple, asdict, asstruct
       namedtuple_from,
       tuple_from, littledict_from, struct_from, table_from
       tupled, nametupled, structured, tabled, littledicted,
       # editing: include, exclude,
       reposition_fields, reposition_field,
       remove_from,
       prepend_fields,  prepend_field,
       postpend_fields, postpend_field,


namedtuple

include("support.jl")
include("field_ops.jl")



end  # NamedTupleTools
