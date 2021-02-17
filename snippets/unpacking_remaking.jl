using Dates

nt = (event = "JuliaCon", date = Date("2021-07-28"))

event, date = nt

event == nt.event && date == nt.date

remake_nt = (; event, date)

remake_nt == nt
