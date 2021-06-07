
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
end

@testset "field_names( NTT+NT )" begin
  @test field_names(ntt0) == field_names(nt0) == ()
  @test field_names(ntt1) == field_names(nt1) == (:a,)
  @test field_names(ntt2) == field_names(nt2) == (:a, :b)
  @test field_names(ntt3) == field_names(nt3) == (:a, :b, :c)

  @test field_names(ntt2, 2) == field_names(nt2, 2)  == :b
  @test field_names(ntt2, (2,)) == field_names(nt2, (2,)) == (:b,)
  @test field_names(ntt3, (1, 3)) == (:a, :c)
end

@testset "field_types( NTT+NT )" begin
  @test field_types(ntt0) == field_types(nt0) == ()
  @test field_types(ntt1) == field_types(nt1) == (Int64,)
  @test field_types(ntt2) == field_types(nt2) == (Int64, Char)
  @test field_types(ntt3) == field_types(nt3) == (Int64, Char, String)

  @test field_types(ntt2, 2) == field_types(nt2, 2) == Char
  @test field_types(ntt2, (2,)) == field_types(nt2, (2,)) == (Char,)
  @test field_types(ntt3, (1, 3)) == (Int64, String)
  @test field_types(ntt2, (:b,)) == field_types(nt2, (:b,)) == (Char,)
  @test field_types(ntt3, (:a, :c)) == (Int64, String)
end

@testset "field_tupletypes( NTT+NT )" begin
  @test field_tupletypes(ntt0) == field_tupletypes(nt0) == Tuple{}
  @test field_tupletypes(ntt1) == field_tupletypes(nt1) == Tuple{Int64}
  @test field_tupletypes(ntt2) == field_tupletypes(nt2) == Tuple{Int64, Char}
  @test field_tupletypes(ntt3) == field_tupletypes(nt3) == Tuple{Int64, Char, String}

  @test field_tupletypes(ntt2, 2) == field_tupletypes(nt2, 2) == Tuple{Char}
  @test field_tupletypes(ntt2, (2,)) == field_tupletypes(nt2, (2,)) == Tuple{Char}
  @test field_tupletypes(ntt3, (1, 3)) == Tuple{Int64, String}

  @test field_tupletypes(ntt2, :b) == field_types(nt2, :b) == Tuple{Char}
  @test field_tupletypes(ntt2, (:b,)) == field_types(nt2, (:b,)) == Tuple{Char}
  @test field_tupletypes(ntt3, (:a, :c)) == Tuple{Int64, String}
end

@testset "field_values( NT )" begin
  @test field_values(nt0) == ()
  @test field_values(nt1) == (1,)
  @test field_values(nt2) == (1, '2')
  @test field_values(nt3) == (1, '2', "three")

  @test field_values(ntt2, 2) == field_values(nt2, (2,)) == ('2',)
  @test field_values(ntt3, (1, 3)) == (1, "three")
  @test field_values(ntt2, :b) == field_values(nt2, (:b,)) == ('2',)
  @test field_values(ntt3, (:a, :c)) == (1, "three")
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
    OT      ≝  OrderedDict instance
    OTT     ≝  OrderedDict type == typeof(OT)
    OTT+OT  ≝  works with both an OTT arg and an OT arg
=#

@testset "field_count( TTT+TT )" begin
  @test field_count(Empty_Tuple) == field_count(empty_tuple) == 0
  @test field_count(Test_Tuple) == field_count(test_tuple) == 3
end
@testset "field_count( STT+ST )" begin
  @test field_count(Test_Singleton) == field_count(test_singleton) == 0
  @test field_count(Test_Struct) == field_count(test_struct) == 3
end
@testset "field_count( LT+OT )" begin
  @test field_count(test_ldict) == 3
  @test field_count(test_odict) == 3
end
@testset "field_count( LTT )" begin
  @test field_count(Test_LDict) == 3
end

@testset "field_names( STT+ST )" begin
  @test field_names(Test_Singleton) == field_names(test_singleton) == ()
  @test field_names(Test_Struct) == field_names(test_struct) == (:a, :b, :c)
end
@testset "field_names( LT+OT )" begin
  @test field_names(test_ldict) == (:a, :b, :c)
  @test field_names(test_odict) == (:a, :b, :c)
end
@testset "field_names( LTT )" begin
  @test field_names(Test_LDict) == (:a, :b, :c)
end

@testset "field_types( TTT+TT )" begin
  @test field_types(Empty_Tuple) == field_types(empty_tuple) == ()
  @test field_types(Test_Tuple) == field_types(test_tuple) == (Int64, Char, String)

  @test field_types(Test_Tuple, 2) == field_types(test_tuple, (2,)) == (Char,)
  @test field_types(Test_Tuple, (1, 3)) == (Int64, String)
  @test field_types(Test_Tuple, :b) == field_types(test_tuple, (:b,)) == (Char,)
  @test field_types(Test_Tuple, (:a, :c)) == (Int64, String)
end
@testset "field_types( STT+ST )" begin
  @test field_types(Test_Singleton) == field_types(test_singleton) == ()
  @test field_types(Test_Struct) == field_types(test_struct) == (Int64, Char, String)

  @test field_types(Test_Struct, 2) == field_types(test_tuple, (2,)) == (Char,)
  @test field_types(Test_Struct, (1, 3)) == (Int64, String)
  @test field_types(Test_Struct, :b) == field_types(test_tuple, (:b,)) == (Char,)
  @test field_types(Test_Struct, (:a, :c)) == (Int64, String)
end
@testset "field_types( LT+OT )" begin
  @test field_types(test_ldict) == (Int64, Char, String)
  @test field_types(test_odict) == (Int64, Char, String)

  @test field_types(test_ldict, 2) == field_types(test_ldict, (2,)) == (Char,)
  @test field_types(test_ldict, (1, 3)) == (Int64, String)
  @test field_types(test_ldict, :b) == field_types(test_ldict, (:b,)) == (Char,)
  @test field_types(test_ldict, (:a, :c)) == (Int64, String)

  @test field_types(test_odict, 2) == field_types(test_odict, (2,)) == (Char,)
  @test field_types(test_odict, (1, 3)) == (Int64, String)
  @test field_types(test_odict, :b) == field_types(test_odict, (:b,)) == (Char,)
  @test field_types(test_odict, (:a, :c)) == (Int64, String)
end
@testset "field_types( LTT+OTT )" begin
  @test field_types(Test_LDict) == (Int64, Char, String)

  @test field_types(Test_LDict, 2) == field_types(Test_LDict, (2,)) == (Char,)
  @test field_types(Test_LDict, (1, 3)) == (Int64, String)
  @test field_types(Test_LDict, :b) == field_types(Test_LDict, (:b,)) == (Char,)
  @test field_types(Test_LDict, (:a, :c)) == (Int64, String)
end

@testset "field_typestuple( TTT+TT )" begin
  @test field_typestuple(Empty_Tuple) == field_typestuple(empty_tuple) == Tuple{}
  @test field_typestuple(Test_Tuple) == field_typestuple(test_tuple) == Tuple{Int64, Char, String}

  @test field_typestuple(Test_Tuple, 2) == field_typestuple(test_tuple, (2,)) == Tuple{Char}
  @test field_typestuple(Test_Tuple, (1, 3)) == Tuple{Int64, String}
  @test field_typestuple(Test_Tuple, :b) == field_typestuple(test_tuple, (:b,)) == Tuple{Char}
  @test field_typestuple(Test_Tuple, (:a, :c)) == Tuple{Int64, String}
end
@testset "field_typestuple( STT+ST )" begin
  @test field_typestuple(Test_Singleton) == field_typestuple(test_singleton) == ()
  @test field_typestuple(Test_Struct) == field_typestuple(test_struct) == Tuple{Int64, Char, String}

  @test field_typestuple(Test_Struct, 2) == field_typestuple(test_tuple, (2,)) == Tuple{Char}
  @test field_typestuple(Test_Struct, (1, 3)) == Tuple{Int64, String}
  @test field_typestuple(Test_Struct, :b) == field_typestuple(test_tuple, (:b,)) == Tuple{Char}
  @test field_typestuple(Test_Struct, (:a, :c)) == Tuple{Int64, String}
end
@testset "field_typestuple( LT+OT )" begin
  @test field_typestuple(test_ldict) == Tuple{Int64, Char, String}
  @test field_typestuple(test_odict) == Tuple{Int64, Char, String}

  @test field_typestuple(test_ldict, 2) == field_typestuple(test_ldict, (2,)) == Tuple{Char}
  @test field_typestuple(test_ldict, (1, 3)) == Tuple{Int64, String}
  @test field_typestuple(test_ldict, :b) == field_typestuple(test_ldict, (:b,)) == Tuple{Char}
  @test field_typestuple(test_ldict, (:a, :c)) == Tuple{Int64, String}

  @test field_typestuple(test_odict, 2) == field_typestuple(test_odict, (2,)) == Tuple{Char}
  @test field_typestuple(test_odict, (1, 3)) == Tuple{Int64, String}
  @test field_typestuple(test_odict, :b) == field_typestuple(test_odict, (:b,)) == Tuple{Char}
  @test field_typestuple(test_odict, (:a, :c)) == Tuple{Int64, String}
end
@testset "field_typestuple( LTT+OTT )" begin
  @test field_typestuple(Test_LDict) == Tuple{Int64, Char, String}

  @test field_typestuple(Test_LDict, 2) == field_typestuple(Test_LDict, (2,)) == Tuple{Char}
  @test field_typestuple(Test_LDict, (1, 3)) == Tuple{Int64, String}
  @test field_typestuple(Test_LDict, :b) == field_typestuple(Test_LDict, (:b,)) == Tuple{Char}
  @test field_typestuple(Test_LDict, (:a, :c)) == Tuple{Int64, String}
end


@testset "field_values( TTT+TT )" begin
  @test field_values(Empty_Tuple) == field_values(empty_tuple) == ()
  @test field_values(Test_Tuple) == field_values(test_tuple) == (1, '2', "three")

  @test field_values(Test_Tuple, 2) == field_values(test_tuple, (2,)) == ('2',)
  @test field_values(Test_Tuple, (1, 3)) == (1, "three")
  @test field_values(Test_Tuple, :b) == field_values(test_tuple, (:b,)) == ('2',)
  @test field_values(Test_Tuple, (:a, :c)) == (1, "three")
end
@testset "field_values( STT+ST )" begin
  @test field_values(Test_Singleton) == field_values(test_singleton) == ()
  @test field_values(Test_Struct) == field_values(test_struct) == (1, '2', "three")

  @test field_values(Test_Struct, 2) == field_values(test_tuple, (2,)) == ('2',)
  @test field_values(Test_Struct, (1, 3)) == (1, "three")
  @test field_values(Test_Struct, :b) == field_values(test_tuple, (:b,)) == ('2',)
  @test field_values(Test_Struct, (:a, :c)) == (1, "three")
end
@testset "field_values( LT+OT )" begin
  @test field_values(test_ldict) == (1, '2', "three")
  @test field_values(test_odict) == (1, '2', "three")

  @test field_values(test_ldict, 2) == field_values(test_ldict, (2,)) == ('2',)
  @test field_values(test_ldict, (1, 3)) == (1, "three")
  @test field_values(test_ldict, :b) == field_values(test_ldict, (:b,)) == ('2',)
  @test field_values(test_ldict, (:a, :c)) == (1, "three")

  @test field_values(test_odict, 2) == field_values(test_odict, (2,)) == ('2',)
  @test field_values(test_odict, (1, 3)) == (1, "three")
  @test field_values(test_odict, :b) == field_values(test_odict, (:b,)) == ('2',)
  @test field_values(test_odict, (:a, :c)) == (1, "three")
end
@testset "field_values( LTT+OTT )" begin
  @test field_values(Test_LDict) == (1, '2', "three")

  @test field_values(Test_LDict, 2) == field_values(Test_LDict, (2,)) == ('2',)
  @test field_values(Test_LDict, (1, 3)) == (1, "three")
  @test field_values(Test_LDict, :b) == field_values(Test_LDict, (:b,)) == ('2',)
  @test field_values(Test_LDict, (:a, :c)) == (1, "three")
end

