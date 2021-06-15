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
#=

# prototype as a constructor from <empty>
prototype() = NamedTuple{(), Tuple{}}

# idempotency
prototype(@nospecialize x::Type{<:NamedTuple}) = x

# prototype as a constructor from 1+ names
prototype(@nospecialize names::NTuple{N,Symbol}) where {N} = NamedTuple{names, T} where {T<:Tuple}
prototype(@nospecialize names::Vararg{Symbol,N}) where {N} = prototype(names)
prototype(@nospecialize names::AbstractVector{Symbol}) = prototype(Tuple(names))

# prototype as constructor from 1 name and 1 type
prototype(name::Symbol, type::Type) = NamedTuple{(name,), Tuple{type}}
prototype(name::Symbol, type::Tuple{<:Type}) = NamedTuple{(name,), Tuple{first(type)}}
prototype(name::Tuple{Symbol}, type::Type) = NamedTuple{name, Tuple{type}}
prototype(name::Tuple{Symbol}, type::Tuple{<:Type}) = NamedTuple{name, Tuple{first(type)}}
    
# prototype as constructor from 2+ names and types
prototype(names::NTuple{N,Symbol}, types::NTuple{N,Type}) where {N} = NamedTuple{names, Tuple{types...}}
prototype(names::AbstractVector{Symbol}, types::AbstractVector{<:Type}) = prototype(Tuple(names), Tuple(types))
prototype(names::NTuple{N,Symbol}, types::AbstractVector{<:Type}) where {N} = prototype(names, Tuple(types))
prototype(names::AbstractVector{Symbol}, types::NTuple{N,Type}) where {N} = prototype(Tuple(names), types)
=#

@testset "prototype()" begin
  @test prototype() == NamedTuple{(), Tuple{}}
end

@testset "prototype idempotentcy" begin
  @test prototype(Test1_NTP) == Test1_NTP
  @test prototype(Test1_NTT) == Test1_NTT
  @test prototype(Test_NTP) == Test_NTP
  @test prototype(Test_NTT) == Test_NTT
end

@testset "prototype from 1 name" begin
  @test prototype(Test1_field_name[1]) == NamedTuple{Test1_field_name, Tuple{T}} where {T}
  @test prototype(Test1_field_name) == NamedTuple{Test1_field_name, Tuple{T}} where {T}
  @test prototype([Test1_field_name[1]]) == NamedTuple{Test1_field_name, Tuple{T}} where {T}
end

@testset "prototype from 2+ name" begin
  @test prototype(Test_field_names...) == NamedTuple{Test_field_names, Tuple{T}} where {T}
  @test prototype(Test_field_names) == NamedTuple{Test_field_names, Tuple{T}} where {T}
  @test prototype([Test_field_names...]) == NamedTuple{Test_field_names, Tuple{T}} where {T}
end

@testset "prototype from 1 name and type" begin
  @test prototype(Test1_field_name[1], Test1_field_type[1]) == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype(Test1_field_name, Test1_field_type[1]) == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype([Test1_field_name[1]], Test1_field_type[1])  == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype(Test1_field_name[1], Test1_field_type) == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype(Test1_field_name, Test1_field_type) == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype([Test1_field_name[1]], Test1_field_type)  == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype(Test1_field_name[1], [Test1_field_type[1]]) == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype(Test1_field_name, [Test1_field_type[1]]) == NamedTuple{Test1_field_name, Test1_field_tupletype}
  @test prototype([Test1_field_name[1]], [Test1_field_type[1]])  == NamedTuple{Test1_field_name, Test1_field_tupletype}
end

@testset "prototype from 3 names and types" begin
  @test prototype(Test_field_names, Test_field_types) == NamedTuple{Test_field_names, Test_field_tupletypes}
  @test prototype(Test_field_names, [Test_field_types...]) == NamedTuple{Test_field_names, Test_field_tupletypes}
  @test prototype([Test_field_names...], Test_field_types)  == NamedTuple{Test_field_names, Test_field_tupletypes}
  @test prototype([Test_field_names...], [Test_field_types...])  == NamedTuple{Test_field_names, Test_field_tupletypes}
end

#=
# test prototype construction from wholes

@testset "prototype(_)" begin
  @test prototype(Test_NTP) == Test_NTP
  @test prototype(Test_NTT) == Test_NTT
  @test prototype(Test_NT)  == Test_NTT
  @test prototype(test_nt)  == Test_NTP
end

@testset "prototype(_; types=false)" begin
  @test prototype(Test_NTT; types=false) == Test_NTP
  @test prototype(Test_NT; types=false)  == Test_NTP
  @test prototype(test_nt; types=false)  == Test_NTP
end

@testset "prototype(_; types=true)" begin
  @test prototype(Test_NTT; types=true) == Test_NTT
  @test prototype(Test_NT; types=true)  == Test_NTT
  @test prototype(test_nt; types=true)  == Test_NTT
end

# test prototype construction from <empty>
  @test prototype(Test1_field_name[1], Test1_field_type) == NamedTuple{Test1_field_name, Test1_field_tupletype}}
  @test prototype(Test1_field_name, Test1_field_type) == NamedTuple{Test1_field_name, Test1_field_tupletype}}
  @test prototype([Test1_field_name[1]], Test1_field_type)  == NamedTuple{Test1_field_name, Test1_field_tupletype}}
  @test prototype(Test1_field_name[1], Test1_field_type) == NamedTuple{Test1_field_name, Test1_field_tupletype}}
  @test prototype(Test1_field_name, Test1_field_type) == NamedTuple{Test1_field_name, Test1_field_tupletype}}
  @test prototype([Test1_field_name[1]], Test1_field_type)  == NamedTuple{Test1_field_name, Test1_field_tupletype}}
@test prototype() == NamedTuple{(), Tuple{}}

# test prototype construction from parts with symbols

@testset "prototypes from symbols" begin
  @test prototype(:a) == NamedTuple{(:a,)}
  @test prototype(:a, :b) == NamedTuple{(:a, :b)}
  @test prototype((:a,)) == NamedTuple{(:a,)}
  @test prototype((:a, :b)) == NamedTuple{(:a, :b)}
  @test prototype([:a, :b]) == NamedTuple{(:a, :b)}
end

@testset "prototypes from symbols and types" begin
  @test prototype(:a, Int64) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype((:a,), (Int64,)) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype([:a], [Int64]) == NamedTuple{(:a,), Tuple{Int64}}

    
  @test prototype((:a, :b), (Int64, String)) == NamedTuple{(:a, :b), Tuple{Int64, String}}
  @test prototype([:a, :b], [Int64, String]) == NamedTuple{(:a, :b), Tuple{Int64, String}}
end

@testset "prototypes from symbols and types, mixed" begin
  @test prototype(:a, (Int64,)) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype((:a,), Int64) == NamedTuple{(:a,), Tuple{Int64}}

  @test prototype([:a, :b], (Int64, String)) == NamedTuple{(:a, :b), Tuple{Int64, String}}

  @test prototype((:a,), [Int64,]) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype((:a, :b), [Int64, String]) == NamedTuple{(:a, :b), Tuple{Int64, String}}
end

# test prototype construction from parts with strings

@testset "prototypes from strings" begin
  @test prototype("a") == NamedTuple{(:a,)}
  @test prototype("a", "b") == NamedTuple{(:a, :b)}
  @test prototype(("a",)) == NamedTuple{(:a,)}
  @test prototype(("a", "b")) == NamedTuple{(:a, :b)}
  @test prototype(["a", "b"]) == NamedTuple{(:a, :b)}
end

# test prototype construction from parts with strings and types

@testset "prototypes from strings and types" begin
  @test prototype("a", Int64) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype("a", (Int64,)) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype(("a",), Int64) == NamedTuple{(:a,), Tuple{Int64}}

  @test prototype(("a",), (Int64,)) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype(("a", "b"), (Int64, String)) == NamedTuple{(:a, :b), Tuple{Int64, String}}
  @test prototype(["a", "b"], (Int64, String)) == NamedTuple{(:a, :b), Tuple{Int64, String}}

  @test prototype(("a",), [Int64,]) == NamedTuple{(:a,), Tuple{Int64}}
  @test prototype(("a", "b"), [Int64, String]) == NamedTuple{(:a, :b), Tuple{Int64, String}}
  @test prototype(["a", "b"], [Int64, String]) == NamedTuple{(:a, :b), Tuple{Int64, String}}
end

=#
