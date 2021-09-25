# NamedTuples: A Users Guide

- [NamedTuples: A Users Guide](#namedtuples-a-users-guide)
  - [Creating NamedTuples](#creating-namedtuples)
    - [deconstructing NamedTuples](#deconstructing-namedtuples)
  - [Retrieving values](#retrieving-values)
    - [retrieving a field value](#retrieving-a-field-value)
    - [retrieving multiple values](#retrieving-multiple-values)
  - [Querying](#querying)
    - [NamedTuples](#namedtuples)
    - [NamedTuple Types](#namedtuple-types)

## Creating NamedTuples
```
empty_nt  = (;)
one_item  = (; one = 1)
one_where = (; one = 1, where = "here")
where_one = (; where = "here", one = 1)
```
### deconstructing NamedTuples
```
julia> nt = (; flavor = "vanilla", food = "ice cream")
(food = "ice cream", flavor = "vanilla")

julia> food, flavor = nt; (food, flavor)
("ice cream", "vanilla")
```

## Retrieving values
### retrieving a field value
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

## Querying

### NamedTuples
```
julia> nt = (; food = "ice cream", flavor = "vanilla")
(food = "ice cream", flavor = "vanilla")

julia> length(nt)
2

julia> values(nt)
("ice cream", "vanilla")

julia> keys(nt)
(:food, :flavor)
```
### NamedTuple Types
```
julia> nt = (; food = "ice cream", flavor = "vanilla")
(food = "ice cream", flavor = "vanilla")

julia> NT = typeof(nt)
NamedTuple{(:food, :flavor), Tuple{String, String}}

julia> fieldcount(NT)
2

julia> fieldnames(NT)
(:food, :flavor)

julia> fieldtypes(NT)
(String, String)
```
