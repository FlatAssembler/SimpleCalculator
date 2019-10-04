debug=0 ;Stavite nulu ako zelite program bez debug-outputa.
        ;Stavite jedinicu ako zelite program sa svim debug-outputom.
        ;Ako stavite ista drugo, a ne promjenite "if debug=x" naredbe,
        ;dobit cete program koji ispisuje samo rezultat
        ;(binarni IEEE 754 zapis unesenog broja.)
        ;Program se moze prevesti Flat Assembler-om.
format MZ

push cs
pop ds
finit
jmp start

globalneVarijable:
        if debug=0
                unesiteBrojStr db 'Unesite broj u dekadskom sustavu (moze i decimalni).',10,24h
                zaokruzitiStr db 'Prilikom pretvorbe u binarni sustav, broj je zaokruzen na:',10,24h
                ieeeStr db 'Broj u IEEE 754 standardu glasi:',10,24h
        end if
        konstanta100 dw 100
        broj dd ?
        ispis db 32 DUP('0'),10,'$'
        pomocniString1 db 32 DUP('$')
        pomocniString2 db 16 DUP('$')
        if debug=1
                pomocniString3 db 16 DUP('$')
        end if
        string dw ?
        DEL_KEY=8h
        RETURN_KEY=0Dh

if debug=1
        ispisiBroj:
                jmp l243
                        brojac243 dd 0
                        index1 dw ?
                        index2 dw ?
                        tmp243 dd ?
                        debugIspis25 db 'DEBUG: Pozvana funkcija "ispisiBroj".',10,24h
                        debugIspis26 db 'DEBUG: Broj je negativan.',10,24h
                        debugIspis27 db 'DEBUG: Broj je pozitivan.',10,24h
                        debugString28 db 'DEBUG: Broj s desna na lijevo iznosi:',10,24h
                        debugIspis29 db 'DEBUG: Algoritam obrtanja zavrsio, ispisujemo string s brojem.',10,24h
                        debugIspis30 db 'DEBUG: Izlazimo iz funkcije "ispisiBroj".',10,24h
                        debugString59 db 'DEBUG: Prije sljedece iteracije algoritma obrtanja, string s brojem je:',10,24h
                l243:
                mov [string],debugIspis25
                call ispisiString
                mov bx,pomocniString3
                cmp [broj],0
                jl l244
                        mov [string],debugIspis27
                        call ispisiString
                        mov byte [bx],'+'
                        jmp l245
                l244:
                        mov [string],debugIspis26
                        call ispisiString
                        mov byte [bx],'-'
                        jmp l245
                l245:
                mov [index1],bx
                inc [index1]
                mov eax,[broj]
                cmp eax,0
                jg l248
                        neg eax
                l248:
                mov [tmp243],eax
                l246:
                        inc bx
                        mov [brojac243],0
                        l247:
                                cmp [tmp243],10
                                jl l249
                                sub [tmp243],10
                                inc [brojac243]
                                jmp l247
                        l249:
                        mov eax,[tmp243]
                        add al,'0'
                        mov [bx],al
                        mov eax,[brojac243]
                        mov [tmp243],eax
                        cmp [tmp243],0
                        jg l246
                mov [index2],bx
                inc bx
                mov byte [bx],10
                inc bx
                mov byte [bx],'$'
                mov [string],debugString28
                call ispisiString
                mov [string],pomocniString3
                call ispisiString
                mov bx,[index2]
                sub bx,pomocniString3+1
                mov cx,1
                l250:
                        cmp bx,2
                        jl l251
                        sub bx,2
                        inc cx
                        jmp l250
                l251:
                        push cx
                                mov [string],debugString59
                                call ispisiString
                                mov [string],pomocniString3
                                call ispisiString
                        pop cx
                        mov bx,[index1]
                        mov al,[bx]
                        mov bx,[index2]
                        mov dl,[bx]
                        xchg al,dl
                        mov [bx],dl
                        mov bx,[index1]
                        mov [bx],al
                        inc [index1]
                        dec [index2]
                loop l251
                mov [string],debugIspis29
                call ispisiString
                mov [string],pomocniString3
                call ispisiString
                mov [string],debugIspis30
                call ispisiString
                retn
end if

ispisiString:
        mov dx,[string]
        mov ah,9
        int 21h
        retn

odrediBrojZnamenki:
        jmp l40
                brojac1 dw 0
                cijeliBroj dd ?
                tmp10 dd ?
        l40:
        mov [brojac1],0
        fst [tmp10]
        fld [tmp10]
        if debug=1
                jmp l1125
                        debugString60 db 'DEBUG: Pozvana funkcija "odrediBrojZnamenki"',10,24h
                        debugString61 db 'DEBUG: Broj na vrhu stoga (zaokruzen na cijelo) je:',10,24h
                l1125:
                mov [string],debugString60
                call ispisiString
                mov [string],debugString61
                call ispisiString
                fist [broj]
                call ispisiBroj
        end if
        l41:
                fimul [konstanta100]
                fist [cijeliBroj]
                fidiv [konstanta100]
                cmp [cijeliBroj],10*100
                jl l42
                inc [brojac1]
                mov [cijeliBroj],10
                fidiv [cijeliBroj]
                jmp l41
        l42:
        fstp [tmp10]
        fild [brojac1]
        if debug=1
                jmp l1126
                        debugString62 db 'DEBUG: Izlazimo iz funkcije "odrediBrojZnamenki"',10
                                      db 'Na stog stavljamo broj (jednak broju znamenki minus jedan):',10,24h
                l1126:
                mov [string],debugString62
                call ispisiString
                movsx eax,[brojac1]
                mov [broj],eax
                call ispisiBroj
        end if
        retn

ispisiDecimalniBroj:
        jmp l30
                decimalni dd ?
                cijeli dd ?
                brojac dd 0
                brojZnamenki dw ?
                tmp16 dw ?
        l30:
        if debug=1
                jmp l1250
                        debugString35 db 'DEBUG: Pozvana funkcija "ispisiDecimalniBroj."',10,24h
                l1250:
                mov [string],debugString35
                call ispisiString
        end if
        fimul [konstanta100]
        fist [cijeli]
        fidiv [konstanta100]
        cmp [cijeli],0
        jl l35
                if debug=1
                        mov [string],debugIspis27
                        call ispisiString
                end if
                mov [pomocniString2],'+'
                jmp l36
        l35:
                if debug=1
                        mov [string],debugIspis26
                        call ispisiString
                end if
                mov [pomocniString2],'-'
                jmp l36
        l36:
        fst [decimalni]
        fld [decimalni]
        fabs
        call odrediBrojZnamenki
        fistp [brojZnamenki]
        if debug=1
                jmp l1251
                        debugString36 db 'DEBUG: Njegov cjelobrojni dio ima znamenki:',10,24h
                l1251:
                mov [string],debugString36
                call ispisiString
                movsx eax,[brojZnamenki]
                mov [broj],eax
                inc [broj]
                call ispisiBroj
        end if
        fist [cijeli]
        if debug=1
                jmp l1252
                        debugString37 db 'DEBUG: Njegova apsolutna vrijednost zaokruzena na cijeli broj je:',10,24h
                l1252:
                mov [string],debugString37
                call ispisiString
                mov eax,[cijeli]
                mov [broj],eax
                call ispisiBroj
        end if
        fisub [cijeli]
        jmp l551
        popraviZaokruzivanje:
                if debug=1
                        jmp l1254
                                debugString39 db 'DEBUG: Pozvan blok "popraviZaokruzivanje."',10,24h
                        l1254:
                        mov [string],debugString39
                        call ispisiString
                end if
                fimul [konstanta100]
                fist [tmp16]
                fidiv [konstanta100]
                cmp [tmp16],0
                jg l550
                        if debug=1
                                jmp l1253
                                        debugString38 db  'DEBUG: Prvi broj na stogu je negativan.',10
                                                      db  'To znaci da je naredba "fist" zaokruzila na vise.',10
                                                      db  'Ispravimo to.',10,24h
                                l1253:
                                mov [string],debugString38
                                call ispisiString
                        end if
                        fiadd [cijeli]
                        dec [cijeli]
                        fisub [cijeli]
                l550:
                if debug=1
                        jmp l1255
                                debugString40 db 'DEBUG: Izlazimo iz bloka "ispraviZaokruzivanje."',10,24h
                        l1255:
                        mov [string],debugString40
                        call ispisiString
                end if
                retn
        l551:
        call popraviZaokruzivanje
        fst [decimalni]
        mov bx,pomocniString2+1
        add bx,[brojZnamenki]
        if debug=1
                jmp l1257
                        debugString41 db 'DEBUG: Zapoceto razdvajajnje cjelobrojnih znamenki.',10,24h
                l1257:
                mov [string],debugString41
                call ispisiString
        end if
        l31:
                mov [brojac],0
                l33:
                        cmp [cijeli],10
                        jl l34
                        sub [cijeli],10
                        inc [brojac]
                        jmp l33
                l34:
                if debug=1
                        jmp l1256
                                debugString42 db 'DEBUG: Sljedeca cjelobrojna znamenka je:',10,24h  
                        l1256:
                        push bx
                        mov [string],debugString42
                        call ispisiString
                        mov eax,[cijeli]
                        mov [broj],eax
                        call ispisiBroj
                        pop bx
                end if
                mov eax,[cijeli]
                mov [bx],al
                add byte [bx],'0'
                mov eax,[brojac]
                mov [cijeli],eax
                dec bx
                cmp bx,pomocniString2
                jz l32
                jmp l31
        l32:
        add bx,[brojZnamenki]
        add bx,2
        mov byte [bx],'.'
        if debug=1
                jmp l1259
                        debugString44 db 'DEBUG: Zapoceto razdvajanje decimalnih znamenki.',10,24h
                l1259:
                mov [string],debugString44
                call ispisiString
        end if
        inc bx
        l37:
                mov [cijeli],10
                fimul [cijeli]
                fist [cijeli]
                fisub [cijeli]
                call popraviZaokruzivanje
                mov eax,[cijeli]
                if debug=1
                        jmp l1258
                                debugString43 db 'DEBUG: Sljedeca decimalna znamenka je:',10,24h
                        l1258:
                        push bx
                        mov [string],debugString43
                        call ispisiString
                        mov eax,[cijeli]
                        mov [broj],eax
                        call ispisiBroj
                        pop bx
                end if
                mov eax,[cijeli]
                cmp al,9
                jng l321
                        if debug=1
                                jmp l1260
                                        debugString45 db 'DEBUG: Sljedeca znamenka je veca od devet!? Postavimo je na 9 i nastavimo.',10,24h
                                l1260:
                                mov [string],debugString45
                                call ispisiString
                        end if
                        mov al,9
                l321:
                mov [bx],al
                add byte [bx],'0'
                cmp bx,pomocniString2+14
                je l256
                inc bx
                jmp l37
        l256:
        mov byte [bx],10
        if debug=1
                jmp l1261
                        debugString46 db 'DEBUG: String s brojem je popunjen, ispisimo ga.',10,24h
                l1261:
                mov [string],debugString46
                call ispisiString
        end if
        mov [string],pomocniString2
        call ispisiString
        fstp [decimalni]
        if debug=1
                jmp l1262
                        debugString47 db 'DEBUG: Izlazimo iz funkcije "ispisiDecimalniBroj."',10,24h
                l1262:
                mov [string],debugString47
                call ispisiString
        end if
        retn

unesiString:
        mov bx,[string]
        if debug=1
                jmp l1263
                        debugString48 db 'DEBUG: Pozvana funkcija "unesiString."',10,24h
                l1263:
                mov [string],debugString48
                call ispisiString
        end if
        l3:
                if debug=1
                        mov edx,0
                end if
                mov ah,1
                int 21h
                mov dl,al
                if debug=1
                        jmp l5418
                                debugString49 db 'DEBUG: Unesen znak s ASCII kodom:',10,24h
                        l5418:
                        push dx
                        push bx
                        movzx eax,dl
                        mov [broj],eax
                        mov [string],debugString49
                        call ispisiString
                        call ispisiBroj
                        pop bx
                        pop dx
                end if
                cmp dl,DEL_KEY
                jne l4
                        if debug=1
                                jmp l1265
                                        debugString50 db 'DEBUG: To je tipka backspace, vratimo pokazivac bajt unazad.',10,24h
                                l1265:
                                mov [string],debugString50
                                call ispisiString
                        end if
                        dec bx
                        jmp l3
                l4:
                cmp dl,RETURN_KEY
                jnz l5
                        if debug=1
                                jmp l1266
                                        debugString51 db 'DEBUG: To je tipka enter, izlazimo iz funkcije "unesiString."',10,24h
                                l1266:
                                mov [string],debugString51
                                call ispisiString
                        end if
                        mov byte [bx],'$'
                        retn
                l5:
                mov [bx],dl
                inc bx
                jmp l3
        if debug=1
                jmp l1267
                        debugString52 db 'DEBUG: Izasli smo iz petje ulaza s tipkovnice?! Izadimo iz funkcije.',10,24h
                l1267:
                mov [string],debugString52
                call ispisiString
        end if
        retn

unesiDecimalniBroj:
        jmp l10
                decimale db 0
                predznak db 0
                potencija dd 0
                tmp dw ?
        l10:
        if debug=1
                jmp l1268
                        debugString53 db 'DEBUG: Pozvana funkcija "unesiDecmalniBroj"',10,24h
                l1268:
                mov [string],debugString53
                call ispisiString
        end if
        fld1
        fst [potencija]
        fldz
        mov [string],pomocniString1
        call unesiString
        if debug=1
                jmp l1234
                        debugString10 db 'DEBUG: Funkcija "unesiString" pozvana iz "unesiDecimalniBroj" je vratila:',10,24h
                        debugString11 db 10,24h
                l1234:
                mov [string],debugString10
                call ispisiString
                mov [string],pomocniString1
                call ispisiString
                mov [string],debugString11
                call ispisiString
        end if
        mov bx,pomocniString1
        l6:
                cmp byte [bx],'-'
                je l8
                cmp byte [bx],','
                je l9
                cmp byte [bx],'.'
                je l9
                cmp byte [bx],'0'
                jge l11
                if debug=1
                        jmp l302
                                debugString14 db 'DEBUG: Pokazivac referencira neprepoznat znak!?',10,24h
                        l302:
                        mov [string],debugString14
                        call ispisiString
                end if
                jmp l7
                l8:
                        if debug=1
                                jmp l300
                                        debugString12 db 'DEBUG: Promjenjen predznak.',10,24h
                                l300:
                                mov [string],debugString12
                                call ispisiString
                        end if
                        not byte [predznak]
                        jmp l7
                l9:
                        if debug=1
                                jmp l301
                                        debugString13 db 'DEBUG: Zapocet unos decimala.',10,24h
                                l301:
                                mov [string],debugString13
                                call ispisiString
                        end if
                        not byte [decimale]
                        jmp l7
                l11:
                        cmp byte [bx],'9'
                        if debug=1
                                jle l303
                                        mov [string],debugString14
                                        call ispisiString
                                l303:
                        end if
                        jg l7
                        sub [decimale],0
                        jne l13
                                if debug=1
                                        jmp l325
                                                debugString20 db 'DEBUG: Pokazivac referencira dekadsku znamenku.',10,24h
                                        l325:
                                        mov [string],debugString20
                                        call ispisiString
                                end if
                                mov [tmp],10
                                fimul [tmp]
                                mov ah,0
                                mov al,[bx]
                                mov [tmp],ax
                                fild [tmp]
                                mov [tmp],'0'
                                fisub [tmp]
                                sub [predznak],0
                                jne l20
                                        if debug=1
                                                jmp l326
                                                        debugString21 db 'DEBUG: Predznak je pozitivan, dodajemo je prvom broju na stogu.',10,24h
                                                l326:
                                                mov [string],debugString21
                                                call ispisiString
                                        end if
                                        faddp st1,st0
                                        jmp l21
                                l20:
                                        if debug=1
                                                jmp l327
                                                        debugString22 db 'DEBUG: Predznak je negativan, oduzimamo je od prvog broja na stogu.',10,24h
                                                l327:
                                                mov [string],debugString22
                                                call ispisiString
                                        end if
                                        fsubp st1,st0
                                        jmp l21
                                l21:
                                jmp l7
                        l13:
                                if debug=1
                                        jmp l328
                                                debugString23 db 'DEBUG: Pokazivac referencira decimalu.',10,24h
                                        l328:
                                        mov [string],debugString23
                                        call ispisiString
                                end if
                                fld [potencija]
                                mov ah,0
                                mov al,[bx]
                                mov [tmp],ax
                                fild [tmp]
                                mov ax,'0'
                                mov [tmp],ax
                                fisub [tmp]
                                fmulp st1,st0
                                sub [predznak],0
                                jne l22
                                        if debug=1
                                                mov [string],debugString21
                                                call ispisiString
                                        end if
                                        faddp st1,st0
                                        jmp l23
                                l22:
                                        if debug=1
                                                mov [string],debugString22
                                                call ispisiString
                                        end if
                                        fsubp st1,st0
                                        jmp l23
                                l23:
                                jmp l7
                l7:
                sub [decimale],0
                jz l12
                        fld [potencija]
                        mov ax,10
                        mov [tmp],ax
                        fidiv [tmp]
                        fstp [potencija]
                l12:
                inc bx
                if debug=1
                        jmp l512
                                debugString1 db 'DEBUG: Pokazivac pokazuje na index:',10,24h
                                debugString2 db 'DEBUG: Prvi broj na stogu je:',10,24h
                                debugString7 db 'DEBUG: Lokalna varijabla "potencija" ima vrijednost:',10,24h
                                debugString9 db 'DEBUG: ______________________',10,24h
                        l512:
                        push bx
                        mov [string],debugString1
                        call ispisiString
                        mov [string],bx
                        fild [string]
                        mov [string],pomocniString1
                        fisub [string]
                        fist [broj]
                        call ispisiBroj
                        fistp [string]
                        mov [string],debugString2
                        call ispisiString
                        call ispisiDecimalniBroj
                        fld [potencija]
                        mov [string],debugString7
                        call ispisiString
                        call ispisiDecimalniBroj
                        fistp [string]
                        mov [string],debugString9
                        call ispisiString
                        pop bx
                end if
                cmp byte [bx],'$'
                jnz l6
        if debug=1
                jmp l1269
                        debugIspis54 db 'DEBUG: Dosli smo do kraja unesenog stringa s brojem.',10
                                     db 'Napustamo funkciju "unesiDecimalniBroj"',10,24h
                l1269:
                mov [string],debugIspis54
                call ispisiString
        end if
        retn

start:
        if debug=1
                jmp l500
                        debugString3 db 'DEBUG: Vrijednost broja pi je:',10,24h
                        debugString4 db 'DEBUG: Drugi korjen od 2 iznosi:',10,24h
                        debugString5 db 'DEBUG: Vrijednost od fi*1000 iznosi:',10,24h
                        debugString6 db 'DEBUG: Njegova negativna vrijednost je:',10,24h
                        debugString24 db 'DEBUG: Pozvana funkcija "start." Testirajmo "ispisiBroj."',10,24h
                        debugString31 db 'DEBUG: Pokusajmo ispisati broj 1024.',10,24h
                        debugString32 db 'DEBUG: Pokusajmo ispisati broj -512.',10,24h
                        debugString33 db 'DEBUG: Testiramo funkciju "ispisiDecimalniBroj."',10,24h
                l500:
                mov [string],debugString24
                call ispisiString
                mov [string],debugString31
                call ispisiString
                mov [broj],1024
                call ispisiBroj
                mov [string],debugString32
                call ispisiString
                mov [broj],-512
                call ispisiBroj
                mov [string],debugString33
                call ispisiString
                mov [string],debugString3
                call ispisiString
                fldpi
                call ispisiDecimalniBroj
                mov [broj],2
                fild [broj]
                fsqrt
                mov [string],debugString4
                call ispisiString
                call ispisiDecimalniBroj
                mov [broj],5
                fild [broj]
                fsqrt
                mov [broj],1
                fiadd [broj]
                mov [broj],2
                fidiv [broj]
                mov [broj],1000
                fimul [broj]
                mov [string],debugString5
                call ispisiString
                call ispisiDecimalniBroj
                mov [broj],-1
                fimul [broj]
                mov [string],debugString6
                call ispisiString
                call ispisiDecimalniBroj
                mov [string],debugString9
                call ispisiString
                repeat 4
                        fistp [string]
                end repeat
        end if
        if debug=0
                mov [string],unesiteBrojStr
                call ispisiString
        end if
        call unesiDecimalniBroj
        if debug=1
                jmp l2048
                        debugString8 db 'DEBUG: Funkcija "unesiDecimalniBroj" je vratila:',10,24h
                        debugString55 db 'DEBUG: IEEE 754 zapis tog broja je vracen kao broj u dekadskom sustavu,',10
                                      db 'ali je vjerojatno prevelik za ispisivanje.',10,24h
                        debugString56 db 'DEBUG: Pocnimo ga pretvarati u binarni.',10,24h
                l2048:
                mov [string],debugString8
                call ispisiString
                call ispisiDecimalniBroj
                mov [string],debugString55
                call ispisiString
                mov [string],debugString56
                call ispisiString
        else if debug=0
                mov [string],zaokruzitiStr
                call ispisiString
                call ispisiDecimalniBroj
                mov [string],ieeeStr
                call ispisiString
        end if
        fst [broj]
        mov bx,ispis+31
        l1:
                shr [broj],1
                jnc l2
                        mov byte [bx],'1'
                l2:
                dec bx
                cmp bx,ispis
                jge l1
        if debug=1
                jmp l1270
                        debugIspis57 db 'DEBUG: Algoritam pretvaranja zavrsio. Ispisimo string sa rezultatom.',10,24h
                l1270:
                mov [string],debugIspis57
                call ispisiString
        end if
        mov ah,9h
        mov dx,ispis
        int 21h
izlaz:
        if debug=1
                jmp l1271
                        debugIspis58 db 'DEBUG: Kraj programa.',10,24h
                l1271:
                mov [string],debugIspis58
                call ispisiString
        end if
        mov ax,4C00h
        int 21h
