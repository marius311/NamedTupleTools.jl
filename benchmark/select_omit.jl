# Benchmarking `select(nt|NT, names)` and `omit(nt|NT, names)`

using BenchmarkTools; 
const BTparam = BenchmarkTools.DEFAULT_PARAMETERS; 
BTparam.samples = 50_000; BTparam.time_tolerance = 1/64;

include("../test/testvalues.jl")
