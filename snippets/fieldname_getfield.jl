nt = (event = "JuliaCon", date = Date("2021-07-28"))
# (event = "JuliaCon", date = Date("2021-07-28"))

fieldname(typeof(nt), 1), getfield(nt, fieldname(typeof(nt), 1))
# (:event, "JuliaCon")

fieldname(typeof(nt), 2), getfield(nt, fieldname(typeof(nt), 2))
# (:date, Date("2021-07-28"))


nt_names = fieldnames(typeof(nt))
# (:event, :date)

nt_types = typeof.(Tuple(nt))
# (String, Date)

nt_tupledtypes = Tuple{ nt_types... }
# Tuple{String, Date}

NT = NamedTuple{ names, tupledtypes }
# NamedTuple{(:event, :date), Tuple{String, Date}}

nt_remade = NT( Tuple(nt) )
# (event = "JuliaCon", date = Date("2021-07-28"))

nt_remade == nt
# true
