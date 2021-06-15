using NamedTupleTools
using OrderedCollections: OrdereeSet, OrderedDict, LittleDict, freeze
using Test

#=
    types and realized values
    only to be used for tests
=#
include("testvalues.jl")

include("prototype.jl")
include("field_ops.jl")
include("select_omit.jl")

