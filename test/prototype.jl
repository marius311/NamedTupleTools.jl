#=
    prototype(NT | NTT; types=false)
    prototype(NT | NTT | NTP [, NTuple{nfields, Type} ])

Construct prototypic NamedTuple `schema`.

NamedTuple prototypes are valid constructors.

Prototypes that specify a type for each field expect
a type-matched tuple of values. Prototypes that omit
speicifying types work with any length-matched tuple of values.

|      | kind                 | construct                 |
|:-----|:---------------------|:--------------------------|
| NT   | NamedTuple           | NamedTuple{N,T}(<values>) |
| NTT  | NamedTuple Type      | NamedTuple{N,T}           |
| NTP  | NamedTuple Prototype | NamedTuple{N}             |

=#

@testset "prototype(NTP)" begin
  @test prototype(Test_NTP) == Test_NTP
  @test prototype(Test_NTT) == Test_NTT
  @test prototype(Test_NT)  == Test_NT
  @test prototype(test_nt)  == Test_NTT
  @test prototype(test_NTT; types=false) == Test_NTP
  @test prototype(test_nt; types=false)  == Test_NTP
  @test prototype(test_NTP; types=false) == Test_NTP
end

  
