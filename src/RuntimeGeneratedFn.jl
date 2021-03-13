using Dates
using RuntimeGeneratedFunctions

RuntimeGeneratedFunctions.init(@__MODULE__)

# using GeneralizedGenerated

the_event = "JuliaCon"
the_year  = Year(2021)

nt = (event = the_event, year = the_year)
NT = typeof(nt);

struct StructNT
  event::String
  year::Year
end

structnt = StructNT(the_event, the_year)






module RGFPrecompTest2
    using RuntimeGeneratedFunctions
    RuntimeGeneratedFunctions.init(@__MODULE__)

    y_in_RGFPrecompTest2 = 2

    # Simulates a helper function which generates an RGF, but caches it in a
    # different module.
    function generate_rgf(cache_module)
        context_module = @__MODULE__
        RuntimeGeneratedFunction(cache_module, @__MODULE__, :((x)->y_in_RGFPrecompTest2+x))
    end
end








nt1 = (a = 1, b = "two", d=4.0)
NT1 = typeof(nt1);
nt2 = (a = 100, c = 200, d=400)
NT2 = typeof(nt2);

