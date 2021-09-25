# NamedTuples: A Users Guide

- [NamedTuples: A Users Guide](#namedtuples-a-users-guide)
  - [Creating NamedTuples](#creating-namedtuples)
  - [Retrieving a field value](#retrieving-a-field-value)
    - [retrieving multiple values](#retrieving-multiple-values)

## Creating NamedTuples
```
empty_nt  = (;)
one_item  = (; one = 1)
one_where = (; one = 1, where = "here")
where_one = (; where = "here", one = 1)
```

## Retrieving a field value
```
julia> nt = (one = 1, two = 2, three = 3)
(ten = 10, twenty = 20, thirty = 3)

julia> nt.ten, nt.twenty, nt.thirty
(10, 20, 30)

julia> nt[:ten], nt[:twenty], nt[:thirty]
(10, 20, 30)

julia> nt[1], nt[3]
(10, 30)

julia> getfield(nt, 1), getfield(nt, 3)
(10, 30)
```

### retrieving multiple values
```
julia> nt = (one = 1, two = 2, three = 3)
(ten = 10, twenty = 20, thirty = 3)

julia> getfield.(Ref(nt), (2,3))
(20, 30)

julia> getfield.(Ref(nt), (:ten,:thirty))
(10, 30)
```

