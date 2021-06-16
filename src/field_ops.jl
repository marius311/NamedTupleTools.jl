#=
    The first 3/4 of this file supports NamedTuple Types and NamedTuple realizations
    The rest of this file supports Tuples, structs, LittleDicts and their realizations
=#

# map field name (a Symbol) to field index(an Int)
findindex(x::Symbol, syms::NTuple{N2,Symbol}) where {N1,N2} =
    findfirst(isequal(x), syms)
findindex(xs::NTuple{N1,Symbol}, syms::NTuple{N2,Symbol}) where {N1,N2} =
    findfirst.(isequal.(xs), Ref(syms))

# field tally
field_count(ntt::Type{NamedTuple{N,T}}) where {N,T} = nfields(N)
field_count(nt::NamedTuple{N,T}) where {N,T} = nfields(N)

# field selected field_items

# obtain the Symbol[s] that name fields
field_names(ntt::Type{NamedTuple{N,T}}) where {N,T} = ntt.parameters[1]
field_names(nt::NamedTuple{N,T}) where {N,T} = N
# (field, index) selected field_item
field_names(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = getfield(N, idx)
field_names(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(N, idx)
# (field, indices) multiselected field_items
field_names(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(N), idxs)
field_names(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(N), idxs)

# obtain the Value[s] that are assigned to fields
field_values(nt::NamedTuple{N,T}) where {N,T} = values(nt)
# (field, index) selected field_item
field_values(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = getfield(nt, idx)
# (field, indices) multiselected field_items
field_values(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getfield.(Ref(nt), idxs)
# (field, symbol) selected field_item
# field_values(ntt::Type{NamedTuple{N,T}}, idx::Symbol) where {N,T} = field_values(ntt, findindex(idx, N))
# field_values(nt::NamedTuple{N,T}, idx::Symbol) where {N,T} = field_values(nt, findindex(idx, N))
# (field, symbols) multiselected field_items
field_values(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Symbol}) where {N,T,L} = field_values(ntt, findindex(idxs, N))
field_values(nt::NamedTuple{N,T}, idxs::NTuple{L,Symbol}) where {N,T,L} = field_values(nt, findindex(idxs, N))

# obtain the Type[s] that must be instantiated as fields
field_types(ntt::Type{NamedTuple{N,T}}) where {N,T} = Tuple(ntt.parameters[2].parameters)
field_types(nt::NamedTuple{N,T}) where {N,T} = Tuple(T.parameters)
# (field, index) selected field_item
field_types(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = (T.parameters)[idx]
field_types(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = (T.parameters)[idx]
# (field, indices) multiselected field_items
field_types(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)
field_types(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = getindex.(Ref(T.parameters), idxs)
# (field, symbol) selected field_item
# field_types(ntt::Type{NamedTuple{N,T}}, idx::Symbol) where {N,T} = field_types(ntt, findindex(idx, N))
# field_types(nt::NamedTuple{N,T}, idx::Symbol) where {N,T} = field_types(nt, findindex(idx, N))
# (field, symbols) multiselected field_items
field_types(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Symbol}) where {N,T,L} = field_types(ntt, findindex(idxs, N))
field_types(nt::NamedTuple{N,T}, idxs::NTuple{L,Symbol}) where {N,T,L} = field_types(nt, findindex(idxs, N))

# obtain Tuple{ Type[s] } that must be instantiated as fields
field_tupletypes(ntt::Type{NamedTuple{N,T}}) where {N,T} = T
field_tupletypes(nt::NamedTuple{N,T}) where {N,T} = T
# (field, index) selected field_item
field_tupletypes(ntt::Type{NamedTuple{N,T}}, idx::Integer) where {N,T} = Tuple{ (T.parameters)[idx] }
field_tupletypes(nt::NamedTuple{N,T}, idx::Integer) where {N,T} = Tuple{ (T.parameters)[idx] }
# (field, indices) multiselected field_items
field_tupletypes(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Integer}) where {N,T,L} = Tuple{ getindex.(Ref(T.parameters), idxs)... }
field_tupletypes(nt::NamedTuple{N,T}, idxs::NTuple{L,Integer}) where {N,T,L} = Tuple{ getindex.(Ref(T.parameters), idxs)... }
# (field, symbol) selected field_item
# field_tupletypes(ntt::Type{NamedTuple{N,T}}, idx::Symbol) where {N,T} = field_tupletypes(ntt, findindex(idx, N))
# field_tupletypes(nt::NamedTuple{N,T}, idx::Symbol) where {N,T} = field_tupletypes(nt, findindex(idx, N))
# (field, symbols) multiselected field_items
field_tupletypes(ntt::Type{NamedTuple{N,T}}, idxs::NTuple{L,Symbol}) where {N,T,L} = field_tupletypes(ntt, findindex(idxs, N))
field_tupletypes(nt::NamedTuple{N,T}, idxs::NTuple{L,Symbol}) where {N,T,L} = field_tupletypes(nt, findindex(idxs, N))

#=
   field_ops support for
      (a) Tuple types and their realizations
      (b) struct types and thier realizations
      (c) LittleDict types and their realizations
      (d) OrderedDict realizations (intended for use with small dictionaries)
      (e) OrderedSet realizations
=#

const OrdDict = Union{LittleDict, OrderedDict}

isfrozen(x::LittleDict) = true
isfrozen(x::LittleDict{Symbol, Any, Vector{Symbol}, Vector{Any}}) = false
isfrozen(x::OrderedDict) = false

isfrozen(x::Type{<:LittleDict}) = true
isfrozen(x::Type{LittleDict{Symbol, Any, Vector{Symbol}, Vector{Any}}}) = false
isfrozen(x::Type{<:OrderedDict}) = false

# tuples
field_count(x::Type{<:Tuple}) = length(x.parameters)
field_count(x::Tuple) = length(x)
# structs
field_count(x::Type{T}) where {T} = fieldcount(x)
field_count(x::T) where {T} = fieldcount(T)
# ordered dicts
field_count(x::Type{<:LittleDict})  = isfrozen(x) ? length(x.parameters[3].parameters) : missing
field_count(x::OrdDict) = length(x)
# ordered sets
field_count(@nospecialize x::OrderedSet{T}) where {T} = length(x)

# tuples
field_names(x::Type{Tuple}) = ()
field_names(x::Tuple) = ()
# structs
field_names(x::Type{T}) where {T} = fieldnames(T)
field_names(x::T) where {T} = fieldnames(T)
# ordered dicts
field_names(x::OrdDict) = Tuple(keys(x))
# ordered sets
field_names(@nospecialize x::OrderedSet{T}) where {T} = Tuple(Symbol.(keys(x)))

# tuples
field_values(x::Tuple) = x
# structs
field_values(x::T) where {T} = getfield.(Ref(x), fieldnames(T))
# ordered dicts
field_values(x::OrdDict) = values(x)
# ordered sets
field_values(@nospecialize x::OrderedSet{T}) where {T} = Tuple(x.dict.keys)

# tuples
field_types(x::Type{Tuple}) = x
field_types(x::Tuple) = typeof.(x)
# structs
field_types(x::Type{T}) where {T} = fieldtypes(T)
field_types(x::T) where {T} = fieldtypes(T)
# ordered dicts -- ONLY USE WITH VERY SMALL DICTIONARIES
field_types(x::OrdDict) = Tuple(typeof.(values(x)))
# ordered sets
field_types(@nospecialize x::OrderedSet{T}) where {T} = Tuple(x.dict.keys)
field_types(x::OrderedSet{T}) where {T} = Tuple(fill(T, length(x)))

# tuples
field_tupletypes(x::Type{Tuple}) = x
field_tupletypes(x::Tuple) = typeof(x)
# structs
field_tupletypes(x::Type{T}) where {T} =
    isstructtype(T) ? field_types(x) : throw(ErrorException("Expected a struct realization, got $(x)."))
# ordered dicts -- ONLY USE WITH VERY SMALL DICTIONARIES
field_tupletypes(x::Union{LittleDict,OrderedDict}) = Tuple{typeof.(values(x))...}
# ordered sets
field_tupletypes(x::OrderedSet{T}) where {T} = NTuple{length(x), T}

