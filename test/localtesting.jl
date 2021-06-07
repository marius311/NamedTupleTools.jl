using OrderedCollections
using OrderedCollections:LittleDict, OrderedDict, OrderedSet, freeze
using Test

const RepoPath = joinpath("C:\\","Users","jas","Documents","GitHub","NamedTupleTools","NamedTupleTools.jl")
const SrcPath = joinpath(RepoPath,"src")
const TestPath = joinpath(RepoPath,"test")

testfile(x) = joinpath(TestPath, string(x,".jl"))
srcfile(x) = joinpath(SrcPath, string(x,".jl"))

macro fromsrc(fname)
  quote begin
    local fil = srcfile($fname)
    include( fil )
  end; end
end

macro fromtest(fname)
    quote begin
      local fil = testfile($fname)
      include( fil )
    end; end
end

# gather names to ignore
oldnames = names(Main);

# bring in source files
@fromsrc("field_ops")
@fromsrc("select_omit")
@fromsrc("prototype")

#=

#    introduces and exports
field_count,
field_names, field_types, field_tupletypes,
field_values,

select, omit,

prototype, namedtuple

#   defines assits for internal logic of filtering
findindex, occurs_in, not_occurs_in

=#

# run testsets
@fromtest("testvalues")
@fromtest("field_ops")
@fromtest("select_omit")
@fromtest("prototype")
@fromtest("namedtuple")

# proceed

