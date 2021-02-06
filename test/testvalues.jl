#=
    types and realized values
    for use with testing only

    Julia type     local type     value
    ----------     --------------------------
    NamedTuple     TestNT         test_nt
    struct         TestStruct     test_struct   
=#

test_nt = (a=1, two='2', datatype=NamedTuple)
TestNT  = typeof(test_nt)

struct TestStruct
    a::Int
    two::Char
    datatype::DataType
end
test_struct = TestStruct(1, '2', TestStruct)

test_ldict = LittleDict((:a, :two, :datatype), (1, '2', LittleDict))
TestLDict  = typeof(test_ldict)

violin_s = (instrument = "violin", madeby = "Stradivari")
viola_s  = (instrument = "viola" , madeby = "Stradivari")
violin_g = (instrument = "violin", madeby = "Guarneri")
all_strings = (violin_s, violin_g, viola_s)
#=
filter(x->x[:madeby] == "Stradivari", all_strings)
((instrument = "violin", madeby = "Stradivari"), (instrument = "viola", madeby = "Stradivari"))
sym_ch = map(Symbol,chr_az,chr_az);

madeby(x) = x[:madeby]
Stradivari(x) = (==)("Stradivari", madeby(x))
filter(Stradivari, all_strings)
((instrument = "violin", madeby = "Stradivari"), (instrument = "viola", madeby = "Stradivari"))

=#

sym_ch = map(Symbol,chr_az,chr_az);

int_az = (collect(Int('a'):Int('z')));
chr_az = map(x->Char(x), int_az);
sym_az = map(Symbol, chr_az); 
str_az = map(string, int_az); 

int_26  = collect(1:26); 
str_26  = map(string, int26); 
sym_26  = map(Symbol, int26);str_az = map(string, int_az); 

int_512 = collect(1:512);
str_512 = map(string, int_512);

nt_az = NamedTuple{(sym_az)}(chr_az)

