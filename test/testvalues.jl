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

# ('a', 'b', .. 'z')
chr_az = Tuple(map(x->Char(x), collect(Int('a'):Int('z'))));
# ("a", "b", .. "z")
str_az = Tuple(map(string, chr_az)); 

# (:a, :b, .. :z)
sym_az = Tuple(map(Symbol, chr_az));
# (:a0, :b0, .. :z0)
sym_a0 = Symbol.(chr_az, 0)
# (:a1, :b1, .. :z1)
sym_a1 = Symbol.(chr_az, 1)
# (:a2, :b2, .. :z2)
sym_a2 = Symbol.(chr_az, 2)

# :aa :bb .. :zz
sym_cc = (map(Symbol, chr_az, chr_az)...,);
# :a1 :b2 .. :z26
sym_ch = (map(Symbol, chr_az, (1:26))...,);

# :a, :b, .. :z, :a1, :b2, .. :z26, :aa, :bb .. :zz,
ab12zz = (sym_az..., sym_ch..., sym_cc)

# :a1 .. :z512
sym_13312 = (Symbol(a,i) for a in 'a':'z' for i in 1:512)

# (a='a', b='b', .. z='z')
nt_az = NamedTuple{(sym_az)}(chr_az)

