#=
   testing the field operations

   op(x::T)      ⟣  fieldvalues(x)
   op(::Type{T}) ⟣  fieldcount(T), fieldnames(T), fieldtypes(T)
=#

@testset "field ops (NamedTuple)" begin
    T = TestNT
    t = test_nt

    @test fieldcount(T)  == 3
    @test fieldnames(T)  == (:a, :two, :datatype)
    @test fieldtypes(T)  == (Int, Char, DataType)
    @test fieldvalues(t) == (1, '2', NamedTuple)
end

@testset "field ops (struct)" begin
    T = TestStruct
    t = test_struct

    @test fieldcount(T)  == 3
    @test fieldnames(T)  == (:a, :two, :datatype)
    @test fieldtypes(T)  == (Int, Char, DataType)
    @test fieldvalues(t) == (1, '2', TestStruct)
end

