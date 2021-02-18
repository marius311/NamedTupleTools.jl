
#=
   Glossary of Short Forms and Affixes
   
          NamedT      NamedTuple                NT
          
          NamedTT     NamedTuple Type           NTT
          
          NTNames     NamedTuple Names          (    Symbols... )
          NTTypes     NamedTuple Types          (      Types... )
          NTTYPES     NamedTuple Types Tuple    Tuple{ Types... }
          
          field_name[s]     fieldnames from realized NT
          field_typetuple   Tuple{ fieldtypes... } from realized NT
          field_type[s]     fieldtypes from realized NT
          field_value[s]    fieldvalues from realized NT
          
          NamedTP     NamedTuple Prototype      NTP
          NamedTS     NamedTuple Schema         NTS
          
          NamedTI     NamedTuple Instance       NTI
          NamedTR     NamedTuple Realization    NTR
          
          
   NamedTuple Type      (NTT)
   NamedTuple Prototype (NTP)
   NamedTuple Schema    (NTS)
   NamedTuple Instance  (NTI)
   
   The empty NamedTuples are a type and a instance 
   there is a structured NamedTuple type that is empty, it is a singleton
   there is a concrete   NamedTuple type that is empty, it is a singleton
   there is a realized   NamedTuple instance that is empty, it is a singleton
=#

const EmptyNTT = NamedTuple{(), Tuple{}}

const EmptyNamedTuple = (;)
const EmptyNamedTuple  = EmptyNamedTupleT( () )

