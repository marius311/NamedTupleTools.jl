const Symbols = Union{Vararg{Symbol}, Tuple{Vararg{Symbol}}}

# symbols select positions to be admitted

"""
    admit_key(NTuple{N,Symbol}, key::Symbol)

evaluates to a tuple of Bool, true everywhere the key is found
"""
admit_key(tuple::Tuple{Vararg{Symbol}}, key::Symbol) =
    _admit_key(key, tuple...)

Base.@pure _admit_key(key::Symbol) = ()

Base.@pure _admit_key(key::Symbol, first::Symbol, tail...) =
    [first === key, _admit_key(key, tail...)...]

"""
    admit_keys(NTuple{N,Symbol}, keys::Vararg{Symbol})

evaluates to a tuple of Bool, true everywhere any of the keys is found
"""
admit_keys(tuple::Tuple{Vararg{Symbol}}, keys::Symbols) =
    map(|, (admit_key(tuple, k) for k in keys)...)

# symbols select positions to be omitted

"""
    omit_key(NTuple{N,Symbol}, key::Symbol)

evaluates to a tuple of Bool, false everywhere the key is found
"""
omit_key(tuple::Tuple{Vararg{Symbol}}, key::Symbol) =
    _omit_key(key, tuple...)

Base.@pure _omit_key(key::Symbol) = ()

Base.@pure _omit_key(key::Symbol, first::Symbol, tail...) =
    [first !== key, _omit_key(key, tail...)...]

"""
    omit_keys(NTuple{N,Symbol}, keys::Vararg{Symbol})

evaluates to a tuple of Bool, false everywhere any of the keys is found
"""
omit_keys(tuple::Tuple{Vararg{Symbol}}, keys::Symbols) =
    map(&, (omit_key(tuple, k) for k in keys)...)

# keys select positions to be admitted

admit_indices(NT::Type{NamedTuple{N,T}}, keys::Symbols) where {N,T} =
    (1:field_count(N))[admit_keys(N, keys)]

admit_indices(nt::NamedTuple{N,T}, keys::Symbols) where {N,T} =
    (1:field_count(N))[admit_keys(N, keys)]

admit_indices(x::Type{T}, keys::Symbols) where T =
    (1:field_count(T))[admit_keys(field_names(x), keys)]

admit_indices(x::T, keys::Symbols) where T =
    (1:field_count(T))[admit_keys(field_names(x), keys)]

# keys select positions to be omitted

omit_indices(NT::Type{NamedTuple{N,T}}, keys::Symbols) where {N,T} =
    (1:field_count(N))[omit_keys(N, keys)]

omit_indices(nt::NamedTuple{N,T}, keys::Symbols) where {N,T} =
    (1:field_count(N))[omit_keys(N, keys)]

omit_indices(x::Type{T}, keys::Symbols) where T =
    (1:field_count(T))[omit_keys(field_names(x), keys)]

omit_indices(x::T, keys::Symbols) where T =
    (1:field_count(T))[omit_keys(field_names(x), keys)]
