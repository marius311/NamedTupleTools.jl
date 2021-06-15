using NamedTupleTools
using OrderedCollections: OrderedSet, OrderedDict, LittleDict, freeze
using Test

#=
    types and realized values
    only to be used for tests
=#
include("testvalues.jl")

include("field_ops.jl")
include("prototype.jl")
