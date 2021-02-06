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

madeby(x) = x[:madeby]
Stradivari(x) = (==)("Stradivari", madeby(x))
filter(Stradivari, all_strings)
((instrument = "violin", madeby = "Stradivari"), (instrument = "viola", madeby = "Stradivari"))

=#


intaz = (collect(Int('a'):Int('z')));
symaz = map(Symbol, intaz); 
chraz = map(x->Char(x), intaz);

int26 = collect(1:26); 
str26 = map(string, int26); 
sym26 = map(Symbol, int26);

int512 = collect(1:512);
sym512 = map(Symbol, int512);
str512 = map(string, int512);

straz = map(string, intaz); 

ntaz = NamedTuple{(symaz...,)}(chraz)

int_512 = collect(1:512);

sym_az = map(Symbol, int_az);
sym_26 = map(Symbol, int_26);

nt_az = NamedTuple{(sym_az)}(int_z)

