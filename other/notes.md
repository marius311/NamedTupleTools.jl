".. but the compiler basically gives up once you hit named tuples with 500 fields, 
 so anyone who is doing this with NamedTuples is going to have bigger problems"

          Tuples 10 fields is in coddle space, with that Named Tuples with 10 or fewer fields carry some of the same benefit 
    Named Tuples 16 fields, NTT provides swaddling
    Named Tuples, 24 fields, rest easy .. 
    
    tuple_splat::Int = 32, # base/compiler/types.jl
    after 32 I'd prefer
    
    this_is_easy = (:a = 1, .., :x = 24)
    so_is_this   = (:A = 1, ..., :X = 24)
    abracadabra  = (initial_nt = this_is_easy, final_nt = so_is_this)  
    [special support]
    
       
