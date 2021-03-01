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
result = []
@bytes_and_nanos(result, fieldtypes,NT, field_types, nt)
result[]
# (base = (bytes = 144, nanos = 525.13), ntt = (bytes = 0, nanos = 10.0))
