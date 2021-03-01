using BenchmarkTools
const BTparam = BenchmarkTools.DEFAULT_PARAMETERS
BTparam.samples = 50_000
BTparam.time_tolerance = 1/16

BT.samples=10_000; BT.time_tolerance=1/25;
rnd(x) = round(x*100) / 100


macro bytes_and_nanos(result, basefn, basearg, nttfn, nttarg)
  quote begin;
   local bytes4base = @ballocated $basefn($basearg)
   local nanos4base = (@belapsed $basefn(arg) setup=(arg=$basearg;)) * 1.0e9
   local bytes4ntt  = @ballocated $nttfn($nttarg)
   local nanos4ntt  = (@belapsed $nttfn(arg) setup=(arg=$nttarg;)) * 1.0e9
   bench    = (base=(bytes=bytes4base, nanos=rnd(nanos4base)),
                      ntt =(bytes=bytes4ntt , nanos=rnd(nanos4ntt )) )
    push!($result, bench);
    end; 
 end; end

# using Dates; nt = (event= "JuliaCon", year=Year(2021)); NT = typeof(nt);
results = Dict(:field_names => [], :field_types => [], :field_values => [])

@bytes_and_nanos(results[:field_names], fieldnames,NT, field_names, nt)
@bytes_and_nanos(results[:field_types], fieldtypes,NT, field_types, nt)
@bytes_and_nanos(results[:field_values], values, nt, field_values, nt)

results[:field_names]
results[:field_types]
results[:field_values]
