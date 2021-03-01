#=
    types and realized values
    for use with testing only

    Julia type     local type     value
    ----------     --------------------------
    NamedTuple     TestNT         test_nt
    struct         TestStruct     test_struct   
=#

test_nt = (one = 1, two = '2', three = "three")
Test_NT = typeof(test_nt)

struct Test_Struct
    one::Int
    two::Char
    three::String
end
test_struct = Test_Struct(1, '2', "three")

test_ldict = LittleDict((:a, :two, :datatype), (1, '2', "three"))
Test_LDict  = typeof(test_ldict)

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

# ('a', 'b', .. 'z')
chr_az = Tuple(map(x->Char(x), collect(Int('a'):Int('z'))));
# ('A'..'Z','a'..'z')
chr_Az = Tuple(map(x->Char(x), (collect(Int('A'):Int('Z'))...,collect(Int('a'):Int('z'))...,) ));
# ("a", "b", .. "z")
str_az = Tuple(map(string, chr_az)); 
str_Az = Tuple(map(string, chr_Az)); 

# (:a, :b, .. :z)
sym_az = Tuple(map(Symbol, chr_az));
sym_Az = Tuple(map(Symbol, chr_Az));

nt_az = NamedTuple{sym_az}(chr_az);
nt_Az = NamedTuple{sym_Az}(chr_Az);

# (:a0, :b0, .. :z0)
# ... 182 symbols
# (:a6, :b6, .. :z6)
sym_a0 = Symbol.(chr_az, 0)
sym_a1 = Symbol.(chr_az, 1)
sym_a2 = Symbol.(chr_az, 2)
sym_a3 = Symbol.(chr_az, 3)
sym_a4 = Symbol.(chr_az, 4)
sym_a5 = Symbol.(chr_az, 5)
sym_a6 = Symbol.(chr_az, 6)

sym_a0a6 = (sym_a1...,sym_a2...,sym_a3...,sym_a4...,sym_a5...,sym_a6...,)

# (a1=1, ..z1=26,, a2=27 .. z6=156)
nt_182 = NamedTuple{(sym_a0a6)}(1:length(sym_a0a6))

