@testset "select" begin
  nt = test_nt
  names = field_names(nt)
  firstofnames = names[1]
  restofnames = Tuple(names[2:end])
  
  @test select(nt, ()) == (;)
  @test select(nt, :one) == (; one = nt.one)
  @test select(nt, :one, :two)  == (; one = nt.one, two = nt.two)
  
  @test select(nt, field_names(nt)...) == nt
  @test select(nt, reverse(field_names(nt))...)  == (; three = nt.three, two = nt.two, one = nt.one)
end

@testset "omit" begin
  nt = test_nt
  names = field_names(nt)
  firstofnames = names[1]
  restofnames = Tuple(names[2:end])
  
  @test omit(nt, ()) == nt
  @test omit(nt, :one) == (; two = nt.two, three = nt.three)
  @test omit(nt, :one, :two)  == (; three = nt.three)
  
  @test omit(nt, field_names(nt)...) == (;)
  @test omit(nt, reverse(field_names(nt))...)  == (;)
end
