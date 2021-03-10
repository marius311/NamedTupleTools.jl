using Tables, DataFrames

# Tables.namedtupleiterator
# t's very easy to turn the dataframe into a named tuple via Tables.columntable

randresult = rand(NamedTuple,6,8,3,permutevals=true,permutesyms=true)

ntstack = []
for r in randresult
  push!(ntstack, r)
end

# in this order
tableofrows = Tables.rowtable(ntstack)
tableofcols = Tables.columntable(tableofrows)

