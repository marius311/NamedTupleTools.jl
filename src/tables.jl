using Tables, DataFrames

# Tables.namedtupleiterator
# t's very easy to turn the dataframe into a named tuple via Tables.columntable

randresult = rand(NamedTuple,6,8,3,permutevals=true,permutesyms=true)

ntstack = []
for r in randresult
  push!(ntstack, r)
end

#=
   There are two common ways that systems store data tables.
   Some systems use their own, less common approaches.

   (a) "column major order", where one column follows another
        - adjacent columns are closer than adjacent rows
        - for easiest column by column access to data
        - Julia, R, MATLAB, and FORTRAN store data accross columns

   (b) "row major order", where one row follows another
        - adjacent rows are closer than adjacent columns
        - for easiest row by row access to data
        - C++, C, SAS, and Pascal store data accross rows

   (c) system specific organizations
        - Scala, Python, and Java use their own approaches
=#

#= 
    Most of Julia's table packages support working with 
    data organized as a column-major table by default.
    A few well-regarded, and widely used packages allow you
    to "re-orient" the data into a table organized for
    row-major storage and retreival.  In March 2021,
    this approach is limited to data tables that have
    no more than 100 rows and no more than 100  columns
    (a table with size==(150, 50) does not qualify).
=#
