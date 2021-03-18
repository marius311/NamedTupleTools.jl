#=

faster and less memory to map over a vector of NamedTuples

julia> tst[1:4]
((ab = 6, bc = 2, c = 3, de = 4, ef = 8, fg = 5, g = 1, hij = 7), 
 (ab = 2, bcd = 5, cd = 6, d = 7, e = 4, f = 8, ghi = 3, hi = 1), 
 (ab = 8, b = 7, cd = 1, de = 2, ef = 6, f = 3, gh = 4, h = 5),
 (abc = 6, bc = 2, cde = 7, def = 5, ef = 4, fg = 8, gh = 3, hi = 1))

julia> tst2[1:4]
4-element Vector{NamedTuple{names, NTuple{8, Int64}} where names}:
 (ab = 6, bc = 2, c = 3, de = 4, ef = 8, fg = 5, g = 1, hij = 7)
 (ab = 2, bcd = 5, cd = 6, d = 7, e = 4, f = 8, ghi = 3, hi = 1)
 (ab = 8, b = 7, cd = 1, de = 2, ef = 6, f = 3, gh = 4, h = 5)
 (abc = 6, bc = 2, cde = 7, def = 5, ef = 4, fg = 8, gh = 3, hi = 1)



julia> @btime map(field_count,$tst2);
  5.800 μs (1 allocation: 336 bytes)

julia> @btime field_count.($tst2);
  5.917 μs (1 allocation: 336 bytes)

julia> @btime field_count.($tst);
  11.200 μs (64 allocations: 68.50 KiB)

=#
