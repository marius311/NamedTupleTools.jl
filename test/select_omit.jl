@testset "select" begin
  nt = test_nt
  nt_names = field_names(nt)
  
  @test select(nt, ()) == (;)

  @test select(nt, (:one,)) == (; one = nt.one)
  @test select(nt, (:one, :two,))  == (; one = nt.one, two = nt.two)
  @test select(nt, nt_names) == nt
  @test select(nt, reverse(nt_names))  == (; three = nt.three, two = nt.two, one = nt.one)

  @test select(nt, :one) == (; one = nt.one)
  @test select(nt, :one, :two)  == (; one = nt.one, two = nt.two)
  @test select(nt, nt_names...) == nt
  @test select(nt, reverse(nt_names)...)  == (; three = nt.three, two = nt.two, one = nt.one)
end

@testset "omit" begin
  nt = test_nt
  nt_names = field_names(nt)
  
  @test omit(nt, ()) == nt
  
  @test omit(nt, (:one,)) == (; two = nt.two, three = nt.three)
  @test omit(nt, (:two,)) == (; one = nt.one, three = nt.three)
  @test omit(nt, (:three,)) == (; one = nt.one, two = nt.two)
  @test omit(nt, (:one, :one)) == (; two = nt.two, three = nt.three)
  @test omit(nt, (:two, :two, :two)) == (; one = nt.one, three = nt.three)

  @test omit(nt, (:one, :two,))  == (; three = nt.three)
  @test omit(nt, (:two, :one,))  == (; three = nt.three)
  @test omit(nt, (:one, :three,))  == (; two = nt.two)
  @test omit(nt, (:three, :one,))  == (; two = nt.two)
  @test omit(nt, (:two, :three,))  == (; one = nt.one)
  @test omit(nt, (:three, :two,))  == (; one = nt.one)
    
  @test omit(nt, (:one, :two, :three,))  == (;)
  @test omit(nt, (:one, :three, :two,))  == (;)
  @test omit(nt, (:two, :three, :one,))  == (;)
  @test omit(nt, (:three, :two, :one))  == (;)
    
  @test omit(nt, :one) == (; two = nt.two, three = nt.three)
  @test omit(nt, :one, :two)  == (; three = nt.three)
  
  @test omit(nt, nt_names...) == (;)
  @test omit(nt, reverse(nt_names)...)  == (;)
end
