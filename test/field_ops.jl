#=
    The first 3/4 of this file tests NamedTuple Types and NamedTuple realizations
    The rest of this file tests Tuples, structs, LittleDicts and their realizations
=#

#=
    NT   ≝  NamedTuple
    NTT  ≝  NamedTuple Type  == typeof(NT)
    NTT+NT  ≝ works with both an NTT arg and an NT arg
=#

@testset "field_count( NTT+NT )" begin
  @test field_count(ntt0) == field_count(nt0) == 0
  @test field_count(ntt1) == field_count(nt1) == 1
  @test field_count(ntt2) == field_count(nt2) == 2
  @test field_count(ntt3) == field_count(nt3) == 3
  @test field_count(ntt4) == field_count(nt4) == 4
end

@testset "field_names( NTT+NT )" begin
  @test field_names(ntt0) == field_names(nt0) == ()
  @test field_names(ntt1) == field_names(nt1) == (:a,)
  @test field_names(ntt2) == field_names(nt2) == (:a, :b)
  @test field_names(ntt3) == field_names(nt3) == (:a, :b, :c)
  @test field_names(ntt4) == field_names(nt4) == (:a, :b, :c, :d)
end

@testset "field_types( NTT+NT )" begin
  @test field_types(ntt0) == field_types(nt0) == ()
  @test field_types(ntt1) == field_types(nt1) == (Int64,)
  @test field_types(ntt2) == field_types(nt2) == (Int64, Char)
  @test field_types(ntt3) == field_types(nt3) == (Int64, Char, String)
  @test field_types(ntt4) == field_types(nt4) == (Int64, Char, String, Rational{Int64})
end

@testset "field_typestuple( NTT+NT )" begin
  @test field_typestuple(ntt0) == field_types(nt0) == Tuple{}
  @test field_typestuple(ntt1) == field_types(nt1) == Tuple{Int64}
  @test field_typestuple(ntt2) == field_types(nt2) == Tuple{Int64, Char}
  @test field_typestuple(ntt3) == field_types(nt3) == Tuple{Int64, Char, String}
  @test field_typestuple(ntt4) == field_types(nt4) == Tuple{Int64, Char, String, Rational{Int64}}
end

@testset "field_values( NT )" begin
  @test field_values(nt0) == ()
  @test field_values(nt1) == (1,)
  @test field_values(nt2) == (1, '2')
  @test field_values(nt3) == (1, '2', "three")
  @test field_values(nt4) == (1, '2', "three", 4//1)
end

#=
    TT      ≝  Tuple instance
    TTT     ≝  Tuple type == typeof(TT)
    TTT+TT  ≝  works with both an TTT arg and an TT arg

    ST      ≝  struct instance
    STT     ≝  struct type == typeof(ST)
    STT+ST  ≝  works with both an STT arg and an ST arg

    LT      ≝  LittleDict instance
    LTT     ≝  LittleDict type == typeof(LT)
    LTT+LT  ≝  works with both an LTT arg and an LT arg
=#

@testset "field_count( TTT+TT )" begin
  @test field_count(Empty_Tuple) == field_count(empty_tuple) == 0
  @test field_count(Test_Tuple) == field_count(test_tuple) == 3
end
@testset "field_count( STT+ST )" begin
  @test field_count(Test_Singleton) == field_count(test_singleton) == 0
  @test field_count(Test_Struct) == field_count(test_struct) == 3
end
@testset "field_count( LTT+LT )" begin
  @test field_count(Test_LDict) == field_count(test_ldict) == 3
  @test field_count(Test_ODict) == field_count(test_odict) == 3
end
