#=
   testing the field operations

   op(x::T)      ⟣  fieldvalues(x)
   op(::Type{T}) ⟣  fieldcount(T), fieldnames(T), fieldtypes(T)
=#

@testset "field ops (NamedTuple)" begin
    T = TestNT
    t = test_nt

    @test field_count(T)  == 3
    @test field_names(T)  == (:a, :two, :datatype)
    @test field_types(T)  == (Int, Char, UnionAll)
    @test field_values(t) == (1, '2', NamedTuple)
end

@testset "field ops (struct)" begin
    T = TestStruct
    t = test_struct

    @test field_count(T)  == 3
    @test field_names(T)  == (:a, :two, :datatype)
    @test field_types(T)  == (Int, Char, DataType)
    @test field_values(t) == (1, '2', TestStruct)
end

