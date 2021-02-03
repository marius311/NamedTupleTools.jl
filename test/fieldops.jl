#=
   testing the field operations

   T a NamedTuple or a struct
   op(::Type{T}) ⟣  field_count(T), field_names(T), field_types(T), field_tupletype(T)
   op(x::T)      ⟣  field_count(x), field_names(x), field_types(x), field_tupletype(T)
   op(x::T)      ⟣  field_values(x)

   T a LittleDict
   op(x::T)      ⟣  field_count(x), field_names(x), field_types(x), field_tupletype(T)
   op(x::T)      ⟣  field_values(x)
=#

@testset "field ops (NamedTuple())" begin
    T = NamedTuple{(), Tuple{}}
    t = NamedTuple()

    @test field_count(T)  == 0
    @test field_names(T)  == ()
    @test field_types(T)  == ()
    @test field_tupletype(T)  == Tuple{}

    @test field_count(t)  == 0
    @test field_names(t)  == ()
    @test field_types(t)  == ()
    @test field_values(t) == ()
    @test field_tupletype(t)  == Tuple{}
end

@testset "field ops (NamedTuple)" begin
    T = TestNT
    t = test_nt

    @test field_count(T)  == 3
    @test field_names(T)  == (:a, :two, :datatype)
    @test field_types(T)  == (Int, Char, UnionAll)
    @test field_tupletype(T)  == Tuple{Int, Char, UnionAll}

    @test field_count(t)  == 3
    @test field_names(t)  == (:a, :two, :datatype)
    @test field_types(t)  == (Int, Char, UnionAll)
    @test field_tupletype(t)  == Tuple{Int, Char, UnionAll}
    @test field_values(t) == (1, '2', NamedTuple)
end

@testset "field ops (struct)" begin
    T = TestStruct
    t = test_struct

    @test field_count(T)  == 3
    @test field_names(T)  == (:a, :two, :datatype)
    @test field_types(T)  == (Int, Char, DataType)
    @test field_tupletype(T)  == Tuple{Int, Char, DataType}

    @test field_count(t)  == 3
    @test field_names(t)  == (:a, :two, :datatype)
    @test field_types(t)  == (Int, Char, DataType)
    @test field_tupletype(t)  == Tuple{Int, Char, DataType}
    @test field_values(t) == (1, '2', TestStruct)
end

@testset "field ops (LittleDict)" begin
    T = TestLDict
    t = test_ldict

    @test field_types(T)  == (Int, Char, UnionAll)
    @test field_tupletype(T)  == Tuple{Int, Char, UnionAll}
   
    @test field_count(t)  == 3
    @test field_names(t)  == (:a, :two, :datatype)
    @test field_types(t)  == (Int, Char, UnionAll)
    @test field_tupletype(t)  == Tuple{Int, Char, UnionAll}
    @test field_values(t) == (1, '2', LittleDict)
end

