@testset "field_count" begin
  @test field_count(ntt0) == field_count(nt0) == 0
  @test field_count(ntt1) == field_count(nt1) == 1
  @test field_count(ntt2) == field_count(nt2) == 2
  @test field_count(ntt3) == field_count(nt3) == 3
  @test field_count(ntt4) == field_count(nt4) == 4
end

@testset "field_names" begin
  @test field_names(ntt0) == field_names(nt0) == ()
  @test field_names(ntt1) == field_names(nt1) == (:a,)
  @test field_names(ntt2) == field_names(nt2) == (:a, :b)
  @test field_names(ntt3) == field_names(nt3) == (:a, :b, :c)
  @test field_names(ntt4) == field_names(nt4) == (:a, :b, :c, :d)
end

@testset "field_types" begin
  @test field_types(ntt0) == field_types(nt0) == ()
  @test field_types(ntt1) == field_types(nt1) == (Int64,)
  @test field_types(ntt2) == field_types(nt2) == (Int64, Char)
  @test field_types(ntt3) == field_types(nt3) == (Int64, Char, String)
  @test field_types(ntt4) == field_types(nt4) == (Int64, Char, String, Rational{Int64})
end

@testset "field_typestuple" begin
  @test field_typestuple(ntt0) == field_types(nt0) == Tuple{}
  @test field_typestuple(ntt1) == field_types(nt1) == Tuple{Int64}
  @test field_typestuple(ntt2) == field_types(nt2) == Tuple{Int64, Char}
  @test field_typestuple(ntt3) == field_types(nt3) == Tuple{Int64, Char, String}
  @test field_typestuple(ntt4) == field_types(nt4) == Tuple{Int64, Char, String, Rational{Int64}}
end

@testset "field_values" begin
  @test field_values(nt0) == ()
  @test field_values(nt1) == (1,)
  @test field_values(nt2) == (1, '2')
  @test field_values(nt3) == (1, '2', "three")
  @test field_values(nt4) == (1, '2', "three", 4//1)
end
