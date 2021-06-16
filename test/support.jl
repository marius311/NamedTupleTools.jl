@testset "isbijection" begin
  @test isbijection( (a=1,), (a=1,) )
  @test isbijection( (a=1, b=2), (a=1, b=2) )
  @test isbijection( (a=1, b=2), (b=2, a=1) )
  
  @test isbijection( (a=1, b=0x02, c='3', d=4.0), (b=0x02, d=4.0, c='3', a=1) )
  @test !isbijection( (a=1, b=0x02, c='3', d=4.0), (b=0x02, d=4.0f0, c='3', a=1) )
end

@testset "↔" begin
  @test (a=1,) ↔ (a=1,)
  @test (a=1, b=2) ↔ (a=1, b=2)
  @test (a=1, b=2) ↔ (b=2, a=1)
  
  @test (a=1, b=0x02, c='3', d=4.0) ↔ (b=0x02, d=4.0, c='3', a=1)
  @test !( (a=1, b=0x02, c='3', d=4.0) ↔ (b=0x02, d=4.0f0, c='3', a=1) )
end

@testset "canonical(NT)" begin
  @test canonical( (a=1,) ) == (a = 1, )
  @test canonical( (a=1, b=2) ) == (a = 1, b = 2)
  @test canonical( (b=2, a=1) ) == (a = 1, b = 2)
end

@testset "canonical(NTT)" begin
  @test canonical( NamedTuple{(:a,)} ) == NamedTuple{(:a,)}
  @test canonical( NamedTuple{(:a, :b)} ) == NamedTuple{(:a, :b)}
  @test canonical( NamedTuple{(:b, :a)} ) == NamedTuple{(:a, :b)}
  @test canonical( NamedTuple{(:a, :b), Tuple{Char, String}} ) == NamedTuple{(:a, :b), Tuple{Char, String}}
  @test canonical( NamedTuple{(:b, :a), Tuple{String, Char}} ) == NamedTuple{(:a, :b), Tuple{Char, String}}
end  
