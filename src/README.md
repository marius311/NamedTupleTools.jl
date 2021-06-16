## NamedTupleTools _(version 2)_

### prototype(_)

- `prototype` constructs NamedTuple Types from field names (symbols) or field names and field types.
- `prototype` converts a NamedTuple into a NamedTuple Type (in its simplest form, like _typeof(_)_).

----

### field operations

Our field operations are named similarly to Julia's, we interpose an underscore
to avoid type piracy and eschew function privateering. 

These functions work with NamedTuples, structs, LittleDicts, OrderedSets.

- field_count
- field_names
- field_types
- field_values


These functions work with the corresponding types, typeof(_). 

- field_count
- field_names
- field_types




- field_{name, type, value}
    - all fields
    - field indicated by index or by name
    - fields selected by indices or by names


### support
- 
- getindicies
