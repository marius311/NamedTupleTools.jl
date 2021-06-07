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

@fromtest("testvalues")
@fromsrc("field_ops")
@fromsrc("prototype")
@fromsrc("select_omit")

@fromtest("field_ops")
@fromtest("select_omit")

@fromtest("prototype")
