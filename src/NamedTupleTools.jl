module NamedTupleTools

export # familiar field operations (piracy avoiding)
       field_count, 
       field_names,  field_name,
       field_types,  field_type,
       field_values, field_value,
       # data structure interconversions
       namedtuple_from,
       tuple_from, dict_from, struct_from,
       # editing: include, exclude,
       reposition_fields, reposition_field,
       remove_from,
       prepend_fields,  prepend_field,
       postpend_fields, postpend_field,


namedtuple

include("field_ops.jl")



end  # NamedTupleTools
