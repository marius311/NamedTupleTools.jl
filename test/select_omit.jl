@testset "select" begin
  nt = test_nt
  nt_names = field_names(nt)
  
  @test select(nt, ()) == (;)
  @test select(nt, :one) == (; one = nt.one)
  @test select(nt, :one, :two)  == (; one = nt.one, two = nt.two)
  
  @test select(nt, nt_names...) == nt
  @test select(nt, reverse(nt_names)...)  == (; three = nt.three, two = nt.two, one = nt.one)
end

@testset "omit" begin
  nt = test_nt
  nt_names = field_names(nt)
  
  @test omit(nt, ()) == nt
  @test omit(nt, :one) == (; two = nt.two, three = nt.three)
  @test omit(nt, :one, :two)  == (; three = nt.three)
  
  @test omit(nt, nt_names...) == (;)
  @test omit(nt, reverse(nt_names)...)  == (;)
end
