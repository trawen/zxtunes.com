
Global Dim koi2num.w(32), Dim buf.w(128,2), Dim table_2s.w(128), lenght, *src_mem, space.f, rus.f, bad.f
Global Dim tbcd(128,2), *dst_mem, pos_from, pos_to

*src_mem = AllocateMemory(12800000)
*dst_mem = AllocateMemory(12800000)

Procedure alt2num (a)
  If a >= $E0: a - $30: EndIf
  ProcedureReturn (a & 31)
EndProcedure
  
Procedure.l work_2s (c1, c2, check, nm_buf)
  
  i = (c1<<2)+(c2>>3)
  mask = $80 >> (c2&7) 
  
  If check=1:
    
    If buf(i,nm_buf) & mask = 0: ProcedureReturn 0: EndIf
       buf(i,nm_buf) & ~mask
  EndIf    
       
  If table_2s(i) & mask <> 0: ProcedureReturn 1: EndIf
        
  ProcedureReturn 2
EndProcedure
 
Procedure.l def_code (n)
  
  bad_1=0
  bad_2=0
  bad_3=0
  all_1=0
  all_2=0
  all_3=0
  
  c1.c = 0
  c2.c = 0
  
  
  For i=0 To 127
    buf(i,0)=$FF 
    buf(i,1)=$FF
  Next i
  
  m_pos = 0
  
  Repeat
    
    c1 = c2
    c2 = PeekC(*src_mem + m_pos)
    m_pos + 1
    
    If m_pos = lenght: Break: EndIf
   
    
    If ((c1>=$80 And c1<$B0) Or (c1>=$E0 And c1<$F0)) And ((c2>=$80 And c2<$B0) Or (c2>=$E0 And c2<$F0))
      
      Select work_2s(alt2num(c1),alt2num(c2),1,0)
        Case 2: bad_1+1
        Case 1: all_1+1
      EndSelect  
      
    EndIf 
    
    If c1 >= $C0 And c2 >= $C0:
      
      Select work_2s(c1&31,c2&31,1,1)
        Case 0: Continue 
        Case 2: bad_2+1
      EndSelect
       
      Select work_2s(koi2num(c1&31),koi2num(c2&31),0,0)
        Case 2: bad_3+1
        Case 1: all_3+1
      EndSelect
      
    EndIf   
  Until all_1>n And all_3>n
  
  If bad_1 <= (all_1>>5): bad_1=0: EndIf
  If bad_2 <= (all_3>>5): bad_2=0: EndIf
  If bad_3 <= (all_3>>5): bad_3=0: EndIf
  
  a = ((255-bad_1)<<8) + all_1
  b = ((255-bad_2)<<8) + all_3
  c = ((255-bad_3)<<8) + all_3
  
  If a>=b And a>=c: ProcedureReturn 0: EndIf
  
  If b>=c: ProcedureReturn 1
  Else:    ProcedureReturn 2
  EndIf
  
  
EndProcedure
  
Procedure good_file()
 
  space = 0
  bad =0
  rus = 0
  pos = 0
  While pos<lenght
   
    a = PeekC(*src_mem+pos) 
    If a=32: space + 1: EndIf
    If a<>10 And a<>13 And a<32 And a<>7 And a<>9: bad + 1: EndIf
    If a>127: rus + 1: EndIf
  
    pos + 1
  Wend   
  
  space = space / (lenght/100)
  rus = rus / (lenght/100)
  bad = bad / (lenght/100)
  
EndProcedure

Procedure.l to_utf(type)
  
  Debug type
 
  pos = 0
  For n=0 To lenght-1
    
    s.c = PeekC(*src_mem + n)
  
    If s>127: 
     
      u.l = tbcd( s-128 , type )
      
      If u < $FFF
        a.c = u & %111111
        a = a | %10000000
        
        bb.l = u & %111111000000
        b.c = bb >> 6
        b = b | %11000000
        
        PokeC(*dst_mem + pos + 0, b)
        PokeC(*dst_mem + pos + 1, a)
        pos + 2
        
      Else
        
        a.c = u & %111111
        a = a | %10000000
        
        bb.l = u & %111111000000
        b.c = bb >> 6
        b = b | %10000000
        
        cc.l = u &111111000000000000
        c.c = cc >> 12
        c = c | %11100000
        
        PokeC(*dst_mem + pos + 0, c)
        PokeC(*dst_mem + pos + 1, b)
        PokeC(*dst_mem + pos + 2, a)
        pos + 3
        
      EndIf
      
    Else
      
      PokeC(*dst_mem + pos, s)
      pos + 1
      
    EndIf
    
   
  Next n
  ProcedureReturn pos
EndProcedure

Procedure InsertColor()
  
  pos_from + 1
  ink = Val(PeekS(*src_mem + pos_from, 1))
  pos_from + 1
  pap = Val(PeekS(*src_mem + pos_from, 1))
  pos_from + 1
  brg = Val(PeekS(*src_mem + pos_from, 1))
  
  color = (ink & %00000111) | ((brg & %1) << 3)
  
  s$ = "</span><span class='RGB" + Str(color) + "'>"
  PokeS(*dst_mem + pos_to, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ColorThis() 
  pos_from = 0
  pos_to = 0
  
  s$ = "<span>"
  PokeS(*dst_mem + pos_to, s$)
  pos_to + Len(s$)
  
  
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = 27:
      InsertColor()
    Else
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
EndProcedure

Procedure WelcomePress()
  
  pos_from = 0
  pos_to = 0
  
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $10:
      pos_from + 1
    ElseIf s = $1F
      pos_from + 3
    ElseIf s = $13 Or s = $0 Or s = $1E
      
    Else
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
EndProcedure
 
Procedure ZXF()
  
  pos_from = 0
  pos_to = 0
  last_color = %1100
  main_color = %1100
  
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "'&amp;") 
      pos_to + 5
    
    ElseIf s = $10 Or s =$11
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = (color & %00000111) | ((color & %01000000) >> 3)
       
      If s = $11: color=main_color: pos_from -1: EndIf
      
      s$ = "</span><span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
      last_color = color
      
    ElseIf s = $0D And last_color <> main_color
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
      color = main_color
      
      s$ = "</span><span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
      last_color = color
    ElseIf s = $11
      
      last_color = 0
      
    ElseIf s = $1F
      
      pos_from + 3
      
    ElseIf s = $01 Or s = $1E Or s = $7C Or s = $00 Or s = $11
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure DJVU()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = (color & %00000111) | ((color & %01000000) >> 3)
       
      If flag: s$ + "</span>": EndIf
      
      flag = 1
      s$ = "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $0F  
      pos_from + 4
      
    ElseIf s < $0D
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  Debug Len(s$)
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure FLTM()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    s2 = PeekC(*src_mem + pos_from + 1)
    
    If s = $0D And s2 > $C0
      
      pos_from + 1
      color = PeekC(*src_mem + pos_from)
      color = (color & %00000111) | 8;((color & %01000000) >> 3)
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $0D And s2 <> $0A
      pos_from + 1
    ElseIf s < $0D Or s = $1A
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  Debug Len(s$)
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure SPC15()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = (color & %00000111) | $8
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s < $0D
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ADV15()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $FE: s = $0D: EndIf
    
    
    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = (color & %00000111) | $8
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s < $0D
      
    ElseIf s = $7F
      
      s$ = "(C)"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $11 Or s=$13 Or s=$1A
      pos_from + 1
      
    ElseIf s = $0D Or s>= $20
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ADV6()
  
  pos_from = 4
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $FE: s = $0D: EndIf
    
    
    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = (color & %00000111) | $8
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s < $0D
      
    ElseIf s = $7F
      
      s$ = "(C)"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $11 Or s=$13 Or s=$1A
      pos_from + 1
      
    ElseIf s = $0D Or s>= $20
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure OPTRON()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
     
    If s = $0F
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = (color & 7) | ((color & %01000000) >> 3)
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      pos_from + 1
      
    ElseIf s=$11
      
      pos_from + 1
      s = PeekC(*src_mem + pos_from)
      Debug s
      If s And s<33: pos_from + (s*8)+s+1: EndIf
       
    ElseIf s=$0E Or s=$01 
      
      pos_from + 1
    ElseIf s <> $0D And s<$20
      
    Else
       
       PokeC(*dst_mem + pos_to, s)
       pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure VIRTWORLD()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $7B
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & 7
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s=$7D 
      
      pos_from + 1
      
    ElseIf s < $0D  

    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ZXREVU()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $11  
      pos_from + 1
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure POLES()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    

    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %11000111
      
      If color > 7: color = color & %111: color | %1000: EndIf
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $19 Or s = $01
      pos_from + 1
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ASPECT()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  
  last = 0
  
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "'&amp;") 
      pos_to + 5
    
    ElseIf s < $8
      
      If s<>last
        
        last = s
        color = s & %111
        
        color | %1000
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
      EndIf
      
    ElseIf s = $0B 
      pos_from + 3
      
    ElseIf s = $09   
      
      PokeS(*dst_mem + pos_to, "   ")
      pos_to + 3
      
    ElseIf s <> $0D And s<$20 And s<>$09
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure DOD()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  last = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    
    If s = $10
      pos_from + 1
       
      color = PeekC(*src_mem + pos_from)
      
      If color<>last
        
        last = color
        
        color = color & %11000111
        
        If color > 7: color = color & %111: color | %1000: EndIf
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
      EndIf
      
    ElseIf s = $18 
      pos_from + 3
    ElseIf s = 0
      PokeC(*dst_mem + pos_to, $0D)
      pos_to + 1
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure Z80()
  
  pos_from = 0
  pos_to = 0

  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s=$0D Or s>=$20
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    ElseIf s=$1A Or s=$19 ; #5 & #6
      
      PokeC(*dst_mem + pos_to, 32)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght

  
EndProcedure

Procedure ZXPOWER()
  

    
    pos_from = 0
    pos_to = 0
    flag = 1
    
    cl$ = "<span class='RGB13'>"
    PokeS(*dst_mem, cl$)
    pos_to = Len(cl$)
    
    Repeat 
      
      s = PeekC(*src_mem + pos_from)
      
      
      
      If s = $01 Or s = $02;#1 - s = $02 Or s = $03
        
        If s = $01
          
          pos_from + 1
          color = PeekC(*src_mem + pos_from)
          
        Else
        
          color = 5 
          
        EndIf
        
        color = color & %00000111 | %1000
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
      ; ElseIf s = $19 Or s = $01
        ; pos_from + 1
        
      ElseIf s <> $0D And s<$20 
        
      Else
        
        PokeC(*dst_mem + pos_to, s)
        pos_to + 1
        
      EndIf
      
      pos_from + 1
      
    Until pos_from > lenght
    
    s$ = "</span>"
    PokeS(*dst_mem + pos_to -1, s$)
    pos_to + Len(s$)
  
EndProcedure
  
Procedure ZXNEWS()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  last = 4
  
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
     
    If s = $F4
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      If color = Asc("0"): color = 12 : Else: color = color & %00000111 | 8 : EndIf

      last = color
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $0D And last <> 12
      
      s$ = Chr($0D)
      If flag: s$ + "</span>": EndIf
      
      flag = 1
      s$ + "<span class='RGB12'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
      last = 12
      
    ElseIf (s <> $0D And s<$20) Or s = $F5  
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ZXNEWS43()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  last = 4
  
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      If color = Asc("0"): color = 12 : Else: color = color & %00000111 | 8 : EndIf
      
      last = color
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $0D And last <> 12
      
      s$ = Chr($0D)
      If flag: s$ + "</span>": EndIf
      
      flag = 1
      s$ + "<span class='RGB12'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
      last = 12
      
    ElseIf (s <> $0D And s<$20)  
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure BODY()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s > $0 And s<$7
       
      color = s & %00000111
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
     
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure THINK()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure SCENERGY()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    If s = $17
      
      pos_from + 1
      
      Repeat
      
        s = PeekC(*src_mem + pos_from)
        If s = $15 Or s = $16 Or pos_from > lenght: Break: EndIf
        ;If s = $00: Break 2: EndIf
      
        pos_from + 2
        
      ForEver  
      
    ElseIf s = $19 Or s = $18 
      
      pos_from + 1
      n = PeekC(*src_mem + pos_from)
      
      If s = $18: 
        
        pos_from + 1
        s = PeekC(*src_mem + pos_from)
        
      Else  
        
        s = $20
        
      EndIf
      

      
      For a=1 To n
        
        PokeC(*dst_mem + pos_to, s)
        pos_to + 1
        
      Next a
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  

  
EndProcedure

Procedure JOINT()
    
    pos_from = 0
    pos_to = 0
    flag = 0
    
    last = 4
    
    s$ = "<span class='RGB12>"
    PokeS(*dst_mem + pos_to, s$)
    pos_to + Len(s$)
    
    
    Repeat 
      
      s = PeekC(*src_mem + pos_from)
      
      If s = Asc("<"):
        
        PokeS(*dst_mem + pos_to, "&#60;") 
        pos_to + 5
        
      ElseIf s = Asc(">"):
        
        PokeS(*dst_mem + pos_to, "&#62;") 
        pos_to + 5
        
      ElseIf s = Asc("&"):
        
        PokeS(*dst_mem + pos_to, "'&amp;") 
        pos_to + 5
        
      ElseIf s > 0 And s < $8
        
        PokeC(*dst_mem + pos_to, $0D)
        pos_to + 1
        
        If s<>last
          
          last = s
          color = s & %111
          
          color | %1000
          
          If flag: s$ = "</span>": Else: s$ = "": EndIf
          
          flag = 1
          s$ + "<span class='RGB" + Str(color) + "'>"
          PokeS(*dst_mem + pos_to, s$)
          pos_to + Len(s$)
          
        EndIf
        
      ElseIf s<$20
        
      Else
        
        PokeC(*dst_mem + pos_to, s)
        pos_to + 1
        
      EndIf
      
      pos_from + 1
      
    Until pos_from > lenght
    
    s$ = "</span>"
    PokeS(*dst_mem + pos_to-1, s$)
    pos_to + Len(s$)
  
EndProcedure
  
Procedure STANDART()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
    
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $11 Or s = $19  
      pos_from + 1
    
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ZXF4()
  
  pos_from = 0;$801F
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "'&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ; ElseIf s = $1F
      ; pos_from + 1 
      ; ln = PeekC(*src_mem + pos_from)
      ; pos_from + (ln * 9)
      ; 
      ; For aa=1 To ln
        ; PokeS(*dst_mem + pos_to, " ")
        ; pos_to + 1
      ; Next aa
      
    ElseIf s = $0D
      pos_from + 1  
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
      If PeekC(*src_mem + pos_from) = $AF: pos_from + 3:
      ElseIf PeekC(*src_mem + pos_from) <> $10: pos_from + 1: EndIf
      
      
      ; Repeat
        ; PokeC(*dst_mem + pos_to, s)
        ; pos_to + 1
        ; 
        ; s = PeekC(*src_mem + pos_from)
        ; 
        ; If 
          ; 
        ; ForEver  
        ; 
        ; $AF: pos_from + 3:
        ; ElseIf PeekC(*src_mem + pos_from) <> $10: pos_from + 1: EndIf
      
      
    ElseIf s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ZXF6()
  
  ;CopyMemory(*src_mem+$14000, *src_mem+$BF20, 16384)
  
  theend = 0
  pos_from = $801F
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "'&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)

      
    ElseIf s = $11
       
      color = %00000100 | %1000
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $0
      
      ;$24 $28 $2A $2B
      
      s1 = PeekC(*src_mem + pos_from + 1)
      s2 = PeekC(*src_mem + pos_from + 2)
      
      If s1 = $10 Or s1 = $0: add = 0
      ElseIf s2 = $10 Or s2 = $1D Or s2 > $2B Or s2 = $20 : add = 1
      Else: add = 2   
      EndIf
      
      
      PokeC(*dst_mem + pos_to, $0D)
      pos_to + 1
      pos_from + add
      
    ElseIf  s = $16
      
      PokeS(*dst_mem + pos_to, "music by ")
      pos_to + 9   
      
    ElseIf  s = $17
      
      PokeS(*dst_mem + pos_to, "(C)")
      pos_to + 3    
      
    ElseIf  s = $12
      
      PokeS(*dst_mem + pos_to, "- ")
      pos_to + 2  
      
    ElseIf  s = $1C
      
      PokeS(*dst_mem + pos_to, ", ")
      pos_to + 2   
      
    ElseIf  s = $1B
      
      PokeS(*dst_mem + pos_to, ". ")
      pos_to + 2  
      
    ElseIf  s = $1D
      
      PokeS(*dst_mem + pos_to, "  ")
      pos_to + 2
      
    ElseIf  s = $1E
      
      PokeS(*dst_mem + pos_to, "   ")
      pos_to + 3
      
    ElseIf s = $1F
      
      pos_from + 1 
      ln = PeekC(*src_mem + pos_from)
      pos_from + (ln * 9)
      
      For aa=1 To ln
        PokeS(*dst_mem + pos_to, " ")
        pos_to + 1
      Next aa  
      
    ElseIf s = $05
      
      pos_from + 1 
      ln = PeekC(*src_mem + pos_from)
      pos_from + 1 
      s = PeekC(*src_mem + pos_from)
      
      For aa=1 To ln
        PokeC(*dst_mem + pos_to, s)
        pos_to + 1
      Next aa  
      
    ElseIf s = $13
      
      pos_from + 1 
      s = PeekC(*src_mem + pos_from)
      
      For aa=1 To 3
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
    Next aa    
    
  ElseIf s = $1A
    
    pos_from + 1 
    s = PeekC(*src_mem + pos_from)
    
    For aa=1 To 4
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
    Next aa    
      
  ElseIf s < $20 

    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght Or theend = 1
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure DONNEWS()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $60;"'"
      pos_from + 1
      
      z$ =  PeekS(*src_mem + pos_from, 1)
      
      If z$="c" Or z$ = "C" 
      
        If z$ = "C": bt = %1000: Else: bt = 0: EndIf
        
        pos_from + 1
        
        c = Val(PeekS(*src_mem + pos_from, 2)) 

        color = c & %00000111 | bt
      
        If flag: s$ = "</span>": Else: s$ = "": EndIf
      
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
        pos_from + 1
      
      ElseIf z$ = "s" Or z$ = "S"
    
        pos_from + 2
        
      ElseIf z$ = "f" Or z$ = "F"
        
        pos_from + 1
        
      ElseIf z$ = "z"
        
        ;pos_from + 1
        
      EndIf  
      
    ElseIf s = $07  
      
      PokeC(*dst_mem + pos_to, $0D)
      pos_to + 1
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure GENZ()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "'&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $0
      
      Break
      
    ElseIf s = $11  
      pos_from + 1
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  ; s$ = "</span>"
  ; PokeS(*dst_mem + pos_to -1, s$)
  ; pos_to + Len(s$)
  
EndProcedure

Procedure INFERNO()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "'&amp;") 
      pos_to + 5
      
    ElseIf s < $7
      
      If PeekC(*src_mem + pos_from) = 0 And PeekC(*src_mem + pos_from+1) = 0 And PeekC(*src_mem + pos_from+2) = 0
        Break
      EndIf
      
      color = PeekC(*src_mem + pos_from) + 1
      color = color & %00000111
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $7
      
      PokeC(*dst_mem + pos_to, $0D)
      pos_to + 1
      
    ElseIf s = $B
       
      pos_from + 2
      s = PeekC(*src_mem + pos_from)
      
      pos_from + (s*9)
      
    ElseIf s = $C
      
      Break
      
    ElseIf s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to, s$)
  pos_to + Len(s$) + 1
  
EndProcedure

Procedure SPECTROFON()
  
  ;CopyMemory(*src_mem+$14000, *src_mem+$BF20, 16384)
  
  theend = 0
  pos_from = $0000;$801F
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = Asc(".") And PeekC(*src_mem + pos_from + 1) = Asc("i")
      
      pos_from + 2
       
       color = PeekC(*src_mem + pos_from)
       color = color & %00000111 | %1000
       
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
   
    
    ElseIf s = Asc(".") And (PeekC(*src_mem + pos_from + 1) = Asc("s") Or PeekC(*src_mem + pos_from + 1) = Asc("c") Or PeekC(*src_mem + pos_from + 1) = Asc("o")  Or PeekC(*src_mem + pos_from + 1) = Asc("m")  Or PeekC(*src_mem + pos_from + 1) = Asc("p"))
      
      pos_from + 2
       
    ElseIf s = Asc(".") And PeekC(*src_mem + pos_from + 1) = Asc("S")  
      
      pos_from + 4
      
    ElseIf PeekS(*src_mem + pos_from, 4) = ".kad"  
      
      pos_from + 3
      
    ElseIf PeekS(*src_mem + pos_from, 4) = ".kab"  
      
      pos_from + 3  
      
    ElseIf s = $18
      
      PokeS(*dst_mem + pos_to, "  ")
      pos_to + 2
      
    ElseIf s = $19
      
      PokeS(*dst_mem + pos_to, "   ")  
      pos_to + 3
      
      
    ElseIf s < $20 And s <> $0D
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght Or theend = 1
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure SPECTROFON20()
  
  ;CopyMemory(*src_mem+$14000, *src_mem+$BF20, 16384)
  
  theend = 0
  pos_from = 0;$6000;$801F
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      
      pos_from + 1 
      
      color = PeekC(*src_mem + pos_from) | bright
      color = color & %00000111
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)

      
    ElseIf s = $15 And PeekC(*src_mem + pos_from +1) = Asc("B")
      
      pos_from + 2
      bright = PeekC(*src_mem + pos_from) & 1
         
    ElseIf s = $12
      
      PokeS(*dst_mem + pos_to, "  ")
      pos_to + 2
      
    ElseIf s = $13
       
       PokeS(*dst_mem + pos_to, "   ")  
       pos_to + 3
      
    ElseIf s = $19
      
      PokeS(*dst_mem + pos_to, "   ")  
      pos_from + 1   
      
      
    ElseIf s < $20 And s <> $0D
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght; Or pos_from > $1BA20; Or theend = 1
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure DEJAVU5()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    z = PeekC(*src_mem + pos_from + 1)
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "'&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      last_color = color
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s = $04
      pos_from + 3
      
    ElseIf s = $0D And last_color <> 12 And z = $0D
      
      color = 12
      last_color = color
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ = Chr(13) + Chr(13) + s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)  
       
    ElseIf s = $0D And last_color <> 12 And z <> $0D
        
      color = 12
      last_color = color
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
       
      flag = 1
      s$ + Chr(13) + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght Or s = $03
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure VOYAGER()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    z = PeekC(*src_mem + pos_from + 1)
    
    If s = Asc("<"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
       
    ElseIf s = $10
      pos_from + 1
       
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If color <> last_color
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
        last_color = color
        
        
        If last = $0D And PeekC(*src_mem + pos_from+1) = $0D
          
          PokeC(*dst_mem + pos_to, $0D )
          pos_to + 1
          
        EndIf
        
      EndIf
      
    ElseIf s = $09  
       pos_from + 1
       last = s 
      
    ElseIf s <> $0D And s<$20 
       
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      last = s
      
    EndIf
    
    pos_from + 1
    
  Until pos_from >= lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure IZH()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
    ; ElseIf s = $11  
      ; pos_from + 1
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure insanity4()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $0
      
      PokeC(*dst_mem + pos_to, $0D): pos_to + 1:
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    flag + 1
    
   ; If flag = 64:  flag = 0 : EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  ; s$ = "</span>"
  ; PokeS(*dst_mem + pos_to -1, s$)
  ; pos_to + Len(s$)
  
EndProcedure

Procedure insanity6()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      pos_from + 1
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      pos_from + 1
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      pos_from + 1
      
    ElseIf s = $0
      
      PokeC(*dst_mem + pos_to, $0D)
      pos_to + 1:
      flag = 0
      pos_from + 1
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      pos_from + 1
      
    EndIf
    
    flag + 1
    
    If flag = 49:  PokeC(*dst_mem + pos_to, $0D): pos_to + 1: flag = 1 : EndIf
    
    
    
  Until pos_from > lenght
  
  ; s$ = "</span>"
  ; PokeS(*dst_mem + pos_to -1, s$)
  ; pos_to + Len(s$)
  
EndProcedure

Procedure insanity5()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    
    
    If s = Asc("<"):
      
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $10 Or s = $0F
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If flag: s$ = "</span>": Else: s$ = "": EndIf
      
      flag = 1
      s$ + "<span class='RGB" + Str(color) + "'>"
      PokeS(*dst_mem + pos_to, s$)
      pos_to + Len(s$)
      
      If s = $0F: pos_from + 1: EndIf
      
    ElseIf s = $11  
      pos_from + 1
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure STANDART2()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    z = PeekC(*src_mem + pos_from + 1)
    
    If s = Asc("<"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If color <> last_color
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
        last_color = color
        
        
        If last = $0D And PeekC(*src_mem + pos_from+1) = $0D
          
          PokeC(*dst_mem + pos_to, $0D )
          pos_to + 1
          
        EndIf
        
      EndIf
      
    ElseIf s = $11
      pos_from + 1
      last = s 
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      last = s
      
    EndIf
    
    pos_from + 1
    
  Until pos_from >= lenght
  
 ; s$ = "</span>"
 ; PokeS(*dst_mem + pos_to -1, s$)
 ; pos_to + Len(s$)
  
EndProcedure

Procedure revival()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    z = PeekC(*src_mem + pos_from + 1)
    
    If s = Asc("<"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $F3 Or s = $0D
      
      If s = $0D
      
        PokeC(*dst_mem + pos_to, $0D)
        pos_to + 1
        
      EndIf
      
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | ((color %01000000) >> 3)
      
      If color <> last_color
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
        last_color = color
        
        
        If last = $0D And PeekC(*src_mem + pos_from+1) = $0D
          
          PokeC(*dst_mem + pos_to, $0D )
          pos_to + 1
          
        EndIf
        
      EndIf
      
    ElseIf s = $11
      pos_from + 1
      last = s 
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      last = s
      
    EndIf
    
    pos_from + 1
    
  Until pos_from >= lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ADV()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    z = PeekC(*src_mem + pos_from + 1)
    
    If s = Asc("<"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $FA
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If color <> last_color
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
        last_color = color
        
        
        If last = $FF And PeekC(*src_mem + pos_from+1) = $FF
          
          PokeC(*dst_mem + pos_to, $0D )
          pos_to + 1
          
        EndIf
        
      EndIf
      
    ElseIf s = $11
      pos_from + 1
      last = s 
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      last = s
      
    EndIf
    
    pos_from + 1
    
  Until pos_from >= lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure ADV8()
  
  pos_from = 4
  pos_to = 0
  flag = 0
  bright = 8
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    z = PeekC(*src_mem + pos_from + 1)
    
    If s = Asc("<"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $7F
      
      last = s
      PokeS(*dst_mem + pos_to, "(C)") 
      pos_to + 3
      
    ElseIf s = $FF Or s = $FA Or s = $F8
      
      If s = $FF
        
        PokeC(*dst_mem + pos_to, $0D)
        pos_to + 1
        last = $FF
         
      EndIf
      
      pos_from + 1
      
      If s=$F8
        
        bright = (PeekC(*src_mem + pos_from) & 1) << 3
        color = last_color & %111
        
      Else
      
        color = PeekC(*src_mem + pos_from)
      
      EndIf
      
      color = (color & %00000111) | bright
      
      If color <> last_color
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
        last_color = color
        
        
        If last = $FF And PeekC(*src_mem + pos_from+1) = $FF
          
          PokeC(*dst_mem + pos_to, $0D )
          pos_to + 1
          
        EndIf
        
      EndIf
      
    ElseIf s >= $F2 And s <> $F8; Or s = $F8 Or s = $FD
       
      pos_from + 1
      last = s 
      
    ElseIf s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      last = s
      
    EndIf
    
    pos_from + 1
    
  Until pos_from >= lenght
  
  s$ = "</span>"
  PokeS(*dst_mem + pos_to -1, s$)
  pos_to + Len(s$)
  
EndProcedure

Procedure SCREAM3()
  
  pos_from = 0
  pos_to = 0
  flag = 0
  Repeat 
    
    s = PeekC(*src_mem + pos_from)
    z = PeekC(*src_mem + pos_from + 1)
    
    If s = Asc("<"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#60;") 
      pos_to + 5
      
    ElseIf s = Asc(">"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&#62;") 
      pos_to + 5
      
    ElseIf s = Asc("&"):
      
      last = s
      PokeS(*dst_mem + pos_to, "&amp;") 
      pos_to + 5
      
    ElseIf s = $10
      pos_from + 1
      
      color = PeekC(*src_mem + pos_from)
      color = color & %00000111 | %1000
      
      If color <> last_color
        
        If flag: s$ = "</span>": Else: s$ = "": EndIf
        
        flag = 1
        s$ + "<span class='RGB" + Str(color) + "'>"
        PokeS(*dst_mem + pos_to, s$)
        pos_to + Len(s$)
        
        last_color = color
        
        
        If last = $0D And PeekC(*src_mem + pos_from+1) = $0D
          
          PokeC(*dst_mem + pos_to, $0D )
          pos_to + 1
          
        EndIf
        
      EndIf
      
    ElseIf s < $0D
      
      PokeC(*dst_mem + pos_to, 32)
      pos_to + 1
      last = s 
      
    ElseIf s <> $0D And s<$20 
      
    Else
      
      PokeC(*dst_mem + pos_to, s)
      pos_to + 1
      last = s
      
    EndIf
    
    pos_from + 1
    
  Until pos_from > lenght
  
  
EndProcedure


Procedure.s decode(name$)  

  lenght = FileSize(name$)
  
  If lenght And ReadFile(5, name$)
    
    ReadData(5, *src_mem, lenght)
    CloseFile(5)
    
    ;ColorThis()
    ;WelcomePress()
    ;FLTM()
    ;SPC15()
    ;ADV6()
    ;OPTRON()
    ;VIRTWORLD()
    ;ZXREVU()
    ;Z80()
    ;POLES()
    ;ASPECT()
    ;DOD()
    ;ZXPOWER()
    ;ZXNEWS43()
    ;BODY()
    ;THINK()
    ;SCENERGY()
    ;JOINT()
    ;STANDART2()
    ;ZXF6() 
    ;DONNEWS()
    ;GENZ()
    ;INFERNO()
    ;SPECTROFON20()
    ;DEJAVU5()
    ;VOYAGER()
    ;IZH()
    insanity6()
    ;revival()
    ;ADV8()
    ;SCREAM3()
    
    CopyMemory(*dst_mem, *src_mem, pos_to-1);//

    lenght = pos_to -1;//
     
    lenght = to_utf(0);def_code(255));//
    CreateFile(55, "utf8\" + name$ + ".html")
    WriteData(55, *dst_mem, lenght)
       
    CloseFile(55)
    
  EndIf
  
EndProcedure  



Restore table2
For a=0 To 31
  Read.w koi2num(a)  
Next a

Restore table1
For a=0 To 128
  Read.w table_2s(a)  
Next a

n = 0
ReadFile(0, "dos.txt")  
While Eof(0) = 0          
  tbcd(n,0) = Val("$"+ReadString(0))     
  n + 1
Wend
CloseFile(0)              

n = 0
ReadFile(0, "win.txt")  
While Eof(0) = 0          
  tbcd(n,1) = Val("$"+ReadString(0))    
  n + 1
Wend
CloseFile(0)

n = 0
ReadFile(0, "koi.txt")  
While Eof(0) = 0          
  tbcd(n,2) = Val("$"+ReadString(0))
  n + 1
Wend
CloseFile(0)


OpenConsole()

nm = 1
SetCurrentDirectory("_/genz55")

CreateDirectory("utf8")


; 
; Directory$ = GetCurrentDirectory()
; 
If ExamineDirectory(0, Directory$, "*.*")  
  While NextDirectoryEntry(0)
    If DirectoryEntryType(0) = #PB_DirectoryEntry_File
      Debug DirectoryEntryName(0)
      decode(DirectoryEntryName(0))
      
      PrintN(Str(nm))
      nm + 1
      
    EndIf
  Wend
  FinishDirectory(0)
EndIf



End 




DataSection
  
  table1:
  Data.w $FF,$FF,$FF,$C7,$FE,$BE,$F7,$FB
  Data.w $FD,$BF,$F7,$F9,$FC,$BE,$F1,$80,$FF,$FF,$F7,$BB,$FF,$FF,$FF
  Data.w $CF,$DE,$BF,$D1,$08,$FF,$BF,$F1,$BF,$FF,$FF,$FF,$C7,$1D,$3F
  Data.w $7F,$81,$A7,$B6,$F2,$82,$FF,$FF,$75,$DB,$FC,$BF,$D7,$9D,$FF
  Data.w $AE,$FB,$DF,$FF,$FF,$FF,$C7,$84,$B7,$F3,$9F,$FF,$FF,$FF,$DB
  Data.w $FF,$BF,$FF,$FF,$FD,$BF,$FF,$FF,$FF,$FF,$E7,$C7,$84,$9E,$F0
  Data.w $12,$BC,$BF,$F0,$84,$A4,$BA,$10,$10,$A4,$BE,$B8,$88,$AC,$BF
  Data.w $F7,$0A,$84,$86,$90,$08,$04,$00,$00,$03,$7F,$FD,$F7,$C1,$7D
  Data.w $AE,$6F,$CB,$15,$3D,$FC,$00,$7F,$7D,$E7,$C2,$7F,$FD,$F7,$C3
  
  table2:
  Data.w 30,0,1,22,4,5,20,3,21,8,9,10,11,12,13,14,15,31,16,17,18,19,6,2,28,27,7,24,29,25,23,26 
; jaPBe Version=3.9.11.815
; FoldLines=0007000A000C001A001C006000620076007800AF00B100C000C200DB00DD00F6
; FoldLines=00F80145014701720174019F01A101C801CA01FD01FF02320234026602680293
; FoldLines=029502BF02C102EF02F10337033903720374038E039003CC03CE04050407043E
; FoldLines=044004650467048E049004CF04D1051705190554055605AF05B10656065806AD
; FoldLines=06AF06ED06EF0739073B0792079407E507E7083A083C0889088B08C508C708F7
; FoldLines=08F909300932096E097009BD09BF0A140A160A630A650ACD0ACF0B1B
; Build=0
; Language=0x0000 Language Neutral
; FirstLine=186
; CursorPosition=2944
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF