## NamedTupleTools _(version 2)_

NamedTupleTools provides easy access to and manipulation of NamedTuples ( __NT__ ) and NamedTuple Types ( __NTT__ ).

Every `NamedTuple` is a realization (instance) of a `NamedTupleType`. While an __NTT__ is as an __NT__ factory.

- This is a NamedTuple: ```(firstname = "Jennifer", lastname = "Kindly", birthdate = Date("1994-06-15"))```
- The associated NamedTupleType: ```NamedTuple{(firstname, lastname, birthdate), Tuple{String, String, Date}}``` 
- using the NamedTupleType to construct the NamedTuple:

```
julia> using Dates

julia> ntt_names      = (:firstname, :lastname, :birthdate)
(:firstname, :lastname, :birthdate)

julia> ntt_types      = (String, String, Date)
(String, String, Date)

julia> nt_values      = ("Jennifer", "Kindly", Date("1994-06-15"))
("Jennifer", "Kindly", Date("1994-06-15"))

julia> ntt = NamedTuple{ntt_names, Tuple{ntt_types...}}
NamedTuple{(:firstname, :lastname, :birthdate), Tuple{String, String, Date}}

julia> JenniferKindly  = ntt( values )
(firstname = "Jennifer", lastname = "Kindly", birthdate = Date("1994-06-15"))

julia> ntt == typeof(JenniferKindly)
true
```

- using the same __NTT__ to construct a different NamedTuple
```
julia> using Dates
julia> ntt_names      = (:firstname, :lastname, :birthdate);
julia> ntt_types      = (String, String, Date);
julia> nt_values      = ("Wanda", "Closepal", Date("1948-03-23"));
julia> ntt = NamedTuple{ntt_names, Tuple{ntt_types...}};
julia> WandaClosepal  = ntt( nt_values )
(firstname = "Wanda", lastname = "Closepal", birthdate = Date("1948-03-23"))

julia> ntt == typeof(WandaClosepal)
true
```

### prototype(_)

`prototype` is an abstraction realizing constructor that yields a NamedTuple Type

- `prototype` constructs NamedTuple Types from field names (symbols) or field names and field types.
- `prototype` converts a NamedTuple into a NamedTuple Type (in its simplest form, like _typeof(\_)_).

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

----

### canonical, isbijection ( __↔__ )

It is helpful to have a field order independant notion of equivalence for NTTs and NTs.

We want to know when two NamedTupleTypes have the same field names, regardless of their order, and matching field names associate with matching field types.
For NamedTuples, we want to know when they match as NamedTupleTypes and matching field names associate with matching field values.
This sameness holds where they are identical as given and where they become identical under a permutation of the field order for one of them.

A canonical form `canonical` for NTTs and for NTs is introduced that sorts fields over their names.
Where two canonical forms are identical, their source forms are a bijection.
The multidispatched predicate `isbijection(ntt1, ntt2), isbijection(nt1, nt2)` provides this information.  
There is an infix symbol for it, __↔__.  "↔" is entered in the REPL as \:leftrightarrow:<tab>

```
nt1 = (a = 1, b = 2)
nt2 = (b = 2, a = 1)
canonical(nt1) == nt1
canonical(nt2) == nt1
isbijection(nt1, nt2) === true

ntt1 = typeof(nt1)
ntt2 = typeof(nt2)
isbijection(ntt1, ntt2) === true

nt3 = (b = 2, a = 3)
nt2 ↔ nt3 === false

ntt3 = typeof(nt3)
ntt2 ↔ ntt3 === true
```

----



- field_{name, type, value}
    - all fields
    - field indicated by index or by name
    - fields selected by indices or by names


### support
- 
- getindicies
