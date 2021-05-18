using NamedTupleTools
using OrderedCollections: OrderedDict, LittleDict
using Test

#=
    types and realized values
    for use with testing only

                    | Type       | value
        ------------|------------|------------
        NamedTuple  | TestNT     | test_nt
        struct      | TestStruct | test_struct
=#
include("testvalues.jl")

include("field_ops.jl")
