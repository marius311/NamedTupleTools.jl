#=
    types and realized values
    for use with testing only

                    | Type       | value
        ------------|------------|------------
        NamedTuple  | TestNT     | test_nt
        struct      | TestStruct | test_struct   
=#

test_nt = (a=1, two='2', datatype=NamedTuple)
TestNT  = typeof(test_nt)

struct TestStruct
    a::Int
    two::Char
    datatype::DataType
end
test_struct = TestStruct(1, '2', TestStruct)

