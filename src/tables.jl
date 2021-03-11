using Tables, DataFrames

# Tables.namedtupleiterator
# t's very easy to turn the dataframe into a named tuple via Tables.columntable

randresult = rand(NamedTuple,6,8,3,permutevals=true,permutesyms=true)

ntstack = []
for r in randresult
  push!(ntstack, r)
end

#=
   There are two common ways to store tabulated information.
   (a) "column major order", where one column follows another
        - adjacent columns are closer than adjacent rows
   (b) "row major order", where one row follows another
        - adjacent rows are closer than adjacent columns
   Julia follows 

meet where one ends and the next begins)

are contigous
   row-major (faster when accessed as a sequence of rows)
# which data storage orientation is easier for your pkg's clients?
# which data storage orientation is more intuitive, and which is more performant? 

orientation, column dominant or row dominantis easier for your users table organization is easier for your users
# which table r is more performant for your user
table_of_rows    = Tables.rowtable(ntstack)
table_of_columns = Tables.columntable(tableofrows)


