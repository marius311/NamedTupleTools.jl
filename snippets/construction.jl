
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


# create an empty NamedTuple
(;)
# create an empty NamedTuple type
typeof( (;) )

# create a NamedTuple with a single valued field
# 𝗏𝖺𝗋 

fld𝗉𝗈𝗌₁  = 1               # field's ordinal position
fld𝗇𝖺𝗆₁  = :letter         # field's name
tupnam₁  = ( :letter, )    # tuple of field's name
fldtyp₁  = Char            # field's type
tuptyp₁  = Tuple{Char}     # tuple type of field's type
fld𝗏𝖺𝗅₁  = 'x'             # field's value

fld𝗉𝗈𝗌₂  = 2               # field's ordinal position
fld𝗇𝖺𝗆₂  = :ver            # field's name
fldtyp₂  = VersionNumber   # field's type
fld𝗏𝖺𝗅₂  = v"1.7"          # field's value

xlower == (letter = 'x')
semver == (ver = v"2.1")

 (letter = 'x')
 (ver = v"2"  )

 :( $fldnam₁ = $fldval₁ )
 :( $fldnam₂ = $fldval₂ )

 NamedTuple{      ( fldnam₁ ,) }( fldval₁ )
 NamedTuple{ tuple( fldnam₂  ) }( fldval₂ )
 NamedTuple{ tupn₂  ) }( fldval₂ )

 NamedTuple{      ( fldnam₁ ,) }( fldval₁ )
 NamedTuple{ tuple( fldnam₂  ) }( fldval₂ )

