@testset "select and omit" begin
  nt = test_nt
  @test select(nt, ()) == ()
  @test select(nt, :event) == (; event = nt.event)
  @test select(nt, :year)  == (; year = nt.year)
  
  @test select(nt, fieldnames(nt)) == nt
  @test select(nt, :year, :event)  == (; year = nt.year, event = nt.event)
end
