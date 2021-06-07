#=
    types and realized values
    for use with testing only

    Julia type     local type     value
    ----------     --------------------------
    NamedTuple     TestNT         test_nt
    struct         TestStruct     test_struct
=#

using OrderedCollections: LittleDict, freeze

# special case types and their realizations for testing

empty_tuple = ();
Empty_Tuple = typeof(empty_tuple);

struct Test_Singleton end;
const test_singleton = Test_Singleton();

# types and their realizations for testing

#=
    Test_<Type> and test_<type> = Test_<Type>( _ )

    test field names that are conventional Symbols
         field values that are of different concrete types

    fields - names: `(:one, :two, :three)`, values: `(1, '2', "three")`
=#

const Test_field_count = 3;
const Test_field_names = (:one, :two, :three);
const Test_field_types = (Int, Char, String);
const Test_field_tupletypes = Tuple{Int, Char, String};

const test_field_count = Test_field_count;
const test_field_names = Test_field_names;
const test_field_types = Test_field_types;
const test_field_tupletypes = Test_field_tupletypes;
const test_field_values = (1, '2', "three");

test_tuple = test_field_values;
Test_Tuple = typeof(test_tuple)

Test_NT = NamedTuple{Test_field_names, Test_field_tupletypes};
test_nt = Test_NT(test_field_values);

Test_NTT = NamedTuple{Test_field_names, Test_field_tupletypes};
Test_NTP = NamedTuple{Test_field_names};

struct Test_Struct
    one::Int
    two::Char
    three::String
end;
test_struct = Test_Struct(test_field_values...);

test_ldict = LittleDict(test_field_names, test_field_values);
Test_LDict = typeof(test_ldict);
test_odict = LittleDict(Dict(test_ldict)) # unfrozen
Test_ODict = typeof(test_odict)

#=
    TestASet_<Type> and testaset_<type> = TestASet_<Type>( _ )

    test field names that are Int indexed (Symbol(::Int) named)
         field values that are of the same concrete type (here, Char)

    fields - names: `Symbol.((1, 2, 3))`, values: `('b', 'a', 'c')`
=#


const TestASet_field_count = 3;
const TestASet_field_names = Symbol.((1,2,3));
const TestASet_field_types = (Char, Char, Char);
const TestASet_field_tupletypes = Tuple{Char, Char, Char};

const testaset_field_count = TestASet_field_count;
const testaset_field_names = TestASet_field_names;
const testaset_field_types = TestASet_field_types;
const testaset_field_tupletypes = TestASet_field_tupletypes;
const testaset_field_values = ('b', 'a', 'c');

TestASet_NamedTuple = NamedTuple{TestASet_field_names, TestASet_field_tupletypes};
testaset_namedtuple = TestASet_NamedTuple(testaset_field_values);

struct TestASet_Struct
    var"1"::Char
    var"2"::Char
    var"3"::Char
end;
testaset_struct = TestASet_Struct(testaset_field_values...);

testaset_ldict_frozen = LittleDict(testaset_field_names, testaset_field_values);
TestASet_LDict_frozen = typeof(testaset_ldict_frozen);
testaset_ldict_unfrozen = LittleDict(testaset_ldict_frozen);
TestASet_LDict_unfrozen = typeof(testaset_ldict_unfrozen);

testaset_oset  =  OrderedSet{Char}(['b','a','c'])
TestASet_OAset  = typeof(testaset_oset)

# end types and their realizations for testing

violin_s = (instrument = "violin", madeby = "Stradivari");
viola_s  = (instrument = "viola" , madeby = "Stradivari");
violin_g = (instrument = "violin", madeby = "Guarneri");
all_strings = (violin_s, violin_g, viola_s);
#=
filter(x->x[:madeby] == "Stradivari", all_strings)
((instrument = "violin", madeby = "Stradivari"), (instrument = "viola", madeby = "Stradivari"))
sym_ch = map(Symbol,chr_az,chr_az);

madeby(x) = x[:madeby]
Stradivari(x) = (==)("Stradivari", madeby(x))
filter(Stradivari, all_strings)
((instrument = "violin", madeby = "Stradivari"), (instrument = "viola", madeby = "Stradivari"))

=#

nt0 = (;); ntt0 = typeof(nt0);
nt1 = (; a=1); ntt1 = typeof(nt1);
nt2 = (a=1, b='2'); ntt2 = typeof(nt2);
nt3 = (a=1, b='2', c="three"); ntt3 = typeof(nt3);

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

nt_8  = NamedTuple{sym_az[1:8]}(chr_az[1:8])
NT_8  = typeof(nt_8)
nt_16  = NamedTuple{sym_az[1:16]}(chr_az[1:16])
NT_16  = typeof(nt_16)
nt_26 = NamedTuple{sym_az}(chr_az);
NT_26 = typeof(nt_26);
nt_32 = NamedTuple{sym_Az[1:32]}(chr_Az[1:32]);
NT_32 = typeof(nt_32);
nt_52 = NamedTuple{sym_Az}(str_Az);
NT_52 = typeof(nt_52);

# (:a0, :b0, .. :z0)
# ... 182 symbols
# (:a6, :b6, .. :z6)
sym_a0 = Symbol.(chr_az, 0);
sym_a1 = Symbol.(chr_az, 1);
sym_a2 = Symbol.(chr_az, 2);
sym_a3 = Symbol.(chr_az, 3);
sym_a4 = Symbol.(chr_az, 4);
sym_a5 = Symbol.(chr_az, 5);
sym_a6 = Symbol.(chr_az, 6);

sym_a0a3 = (sym_a1...,sym_a2...,sym_a3...,);
sym_a0a6 = (sym_a1...,sym_a2...,sym_a3...,sym_a4...,sym_a5...,sym_a6...,);

# (a1=1, ..z1=26,, a2=27 .. z6=156)
nt_78 = NamedTuple{sym_a0a3}(1:length(sym_a0a3));
NT_78 = typeof(nt_78);
nt_182 = NamedTuple{sym_a0a6}(1:length(sym_a0a6));
NT_182 = typeof(nt_182);
