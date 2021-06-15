@testset "bijection" begin
  @test bijection( (a=1,), (a=1,) )
  @test bijection( (a=1, b=2), (a=1, b=2) )
  @test bijection( (a=1, b=2), (b=2, a=1) )
  
  @test bijection( (a=1, b=0x02, c='3', d=4.0), (b=0x02, d=4.0, c='3', a=1) )
  @test !bijection( (a=1, b=0x02, c='3', d=4.0), (b=0x02, d=4.0f0, c='3', a=1) )
end

@testset "↔" begin
  @test (a=1,)  ↔ (a=1,)
  @test (a=1, b=2)  ↔ (a=1, b=2)
  @test (a=1, b=2)  ↔ (b=2, a=1)
  
  @test (a=1, b=0x02, c='3', d=4.0)  ↔ (b=0x02, d=4.0, c='3', a=1)
  @test !( (a=1, b=0x02, c='3', d=4.0)  ↔ (b=0x02, d=4.0f0, c='3', a=1) )
end

  
