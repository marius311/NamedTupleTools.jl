#=
export field_count, 
       field_range, field_indices,
       field_names, field_name, field_types, field_type, 
       field_values, field_value,
       destructure, restructure
=#

@testset "field_<method>(::Type{<:NamedTuple})" begin
   NT = Test_NT
   @test field_count(NT)   == fieldcount(NT)
   @test field_range(NT)   == 1:field_count(NT)
   @test field_indices(NT) == Tuple(field_range(NT))
   @test field_names(NT)   == fieldnames(NT)
   @test field_types(NT)   == fieldtypes(NT)
   @test fields_types(NT)  == Tuple{fieldtypes(NT)...}
end

@testset "field_<method>(indicant::NamedTuple)" begin
   NT = Test_NT
   nt = test_nt
   @test field_count(nt)   == fieldcount(NT)
   @test field_range(nt)   == 1:field_count(NT)
   @test field_indices(nt) == Tuple(field_range(NT))
   @test field_names(nt)   == fieldnames(NT)
   @test field_types(nt)   == fieldtypes(NT)
   @test fields_types(nt)  == Tuple{fieldtypes(NT)...}
   @test field_values(nt)  == values(nt)
end
