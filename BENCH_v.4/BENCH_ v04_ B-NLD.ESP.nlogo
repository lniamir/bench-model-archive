;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                       ;
;;;                        BENCH Model                                ;;;
;;;                    Version:B-NLD.ESP 03                           ;;;
;;;                     IIASA-RITE Project                            ;;;
;;;;;;                                                              ;;;;;
;;;         Author: Leila Niamir <leila.niamir@gmail.com>             ;;;
;;;                     IIASA, Laxenburg-Austria                      ;;;
;;;;;                                                              ;;;;;;
;;;                          30 Jan 2023                              ;;;
;                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; #####################################################################################
; ####################### variables and extensions ####################################
; #####################################################################################

extensions [gis csv]
;breed [turtles household]

globals[
  district  cities year
  cge-es-ssp2-h  cge-es-ssp2-con  primes-es-ref-prices  cge-nl-ssp2-h  cge-nl-ssp2-con  primes-nl-ref-prices
  rn  ge  ow  en  ed  sa  ec  dsi  dag  ty n prov
  greyuser  brownuser  greenuser  elec.grey.p  elec.brown.p  elec.green.p  gas.grey.p  gas.green.p
  k  aware.total pn1.total pn2.total pn3.total  sn1.total sn2.total sn3.total
  noaction a1 a2 a3  a4 a5 a6  a7 a8 a9 a.total  a1.com a2.com a3.com a4.com a5.com a6.com a7.com a8.com a9.com
  g1.a1 g1.a2 g1.a3 g1.a4 g1.a5 g1.a6 g1.a7 g1.a8 g1.a9  g2.a1 g2.a2 g2.a3 g2.a4 g2.a5 g2.a6 g2.a7 g2.a8 g2.a9  g3.a1 g3.a2 g3.a3 g3.a4 g3.a5 g3.a6 g3.a7 g3.a8 g3.a9
  g4.a1 g4.a2 g4.a3 g4.a4 g4.a5 g4.a6 g4.a7 g4.a8 g4.a9  g5.a1 g5.a2 g5.a3 g5.a4 g5.a5 g5.a6 g5.a7 g5.a8 g5.a9  g6.a1 g6.a2 g6.a3 g6.a4 g6.a5 g6.a6 g6.a7 g6.a8 g6.a9
  g7.a1 g7.a2 g7.a3 g7.a4 g7.a5 g7.a6 g7.a7 g7.a8 g7.a9  g8.a1 g8.a2 g8.a3 g8.a4 g8.a5 g8.a6 g8.a7 g8.a8 g8.a9  g9.a1 g9.a2 g9.a3 g9.a4 g9.a5 g9.a6 g9.a7 g9.a8 g9.a9
  g10.a1 g10.a2 g10.a3 g10.a4 g10.a5 g10.a6 g10.a7 g10.a8 g10.a9  g11.a1 g11.a2 g11.a3 g11.a4 g11.a5 g11.a6 g11.a7 g11.a8 g11.a9  g12.a1 g12.a2 g12.a3 g12.a4 g12.a5 g12.a6 g12.a7 g12.a8 g12.a9
  group1.a1 group1.a2 group1.a3 group2.a1 group2.a2 group2.a3 group3.a1 group3.a2 group3.a3 group4.a1 group4.a2 group4.a3 group5.a1 group5.a2 group5.a3
  t1.a1 t1.a2 t1.a3 t2.a1 t2.a2 t2.a3
  dwage1.a1 dwage2.a1 dwage3.a1
  dwage1R.a1 dwage3R.a1 dwage5R.a1
  elab1.a1 elab1.a2 elab1.a3 elab2.a1 elab2.a2 elab2.a3 elab3.a1 elab3.a2 elab3.a3 elab4.a1 elab4.a2 elab4.a3 elab5.a1 elab5.a2 elab5.a3
  prob1  prob2  prob3  prob4  prob5  prob6 prob7  prob8  prob9
  save.elec  save.elec.com  save.gas  save.gas.com  invs  invs.com
  save.elec.g1 save.elec.g2 save.elec.g3 save.elec.g4 save.elec.g5 save.elec.g6 save.elec.g7 save.elec.g8 save.elec.g9 save.elec.g10 save.elec.g11 save.elec.g12
  save.gas.g1 save.gas.g2 save.gas.g3 save.gas.g4 save.gas.g5 save.gas.g6 save.gas.g7 save.gas.g8 save.gas.g9 save.gas.g10 save.gas.g11 save.gas.g12
  elec.total  gas.total elec.all gas.all
  elec.g1 elec.g2 elec.g3 elec.g4 elec.g5 elec.g6 elec.g7 elec.g8 elec.g9 elec.g10 elec.g11 elec.g12
  elec.t1.a1 elec.t1.a2 elec.t1.a3 elec.t2.a1 elec.t2.a2 elec.t2.a3 elec.t1 elec.t2
  gas.t1.a1 gas.t1.a2 gas.t1.a3 gas.t2.a1 gas.t2.a2 gas.t2.a3 gas.t1 gas.t2
  gas.g1 gas.g2 gas.g3 gas.g4 gas.g5 gas.g6 gas.g7 gas.g8 gas.g9 gas.g10 gas.g11 gas.g12
  invs.a1.g1  invs.a2.g1  invs.a3.g1  invs.a1.g2  invs.a2.g2  invs.a3.g2   invs.a1.g3  invs.a2.g3  invs.a3.g3   invs.a1.g4  invs.a2.g4  invs.a3.g4   invs.a1.g5  invs.a2.g5  invs.a3.g5   invs.a1.g6  invs.a2.g6  invs.a3.g6
  invs.a1.g7  invs.a2.g7  invs.a3.g7  invs.a1.g8  invs.a2.g8  invs.a3.g8   invs.a1.g9  invs.a2.g9  invs.a3.g9   invs.a1.g10  invs.a2.g10  invs.a3.g10  invs.a1.g11  invs.a2.g11  invs.a3.g11  invs.a1.g12  invs.a2.g12  invs.a3.g12
  invs1.com  invs2.com  invs3.com
  number.g1 number.g2 number.g3 number.g4 number.g5 number.g6 number.g7 number.g8 number.g9 number.g10 number.g11 number.g12   ;edu+age
  number.group1 number.group2 number.group3 number.group4 number.group5   ;income
  number.t1 number.t2
  number.elab1 number.elab2 number.elab3 number.elab4 number.elab5
  number.dwage1 number.dwage2 number.dwage3
  number.dwage1R  number.dwage3R  number.dwage5R
  n.hh.eff n.hh.pro
  number.households
]

turtles-own[
  h.id  h.group h.sta sdgroup
  income  gen  edu  ecom  age
  dw.st  dw.elab  dw.type  dw.age  dw.size
  elec  gas
  aware  know  cee.aw  ed.aw  guilt
  m1  m2  m3  m1.st  m2.st  m3.st  pn1  pn2  pn3  sn1  sn2  sn3
  pbcI1  pbcI2  pbcI3  pbcC1  pbcC2  pbcC3 pbcS1  pbcS2  pbcS3  ene.pat1  ene.pat2  ene.pat3  ene.prov
  cI1.st  cI2.st  cI3.st  cC1.st  cC2.st  cC3.st  cS1.st  cS2.st  cS3.st
  U1  act1  U2  act2  U3  act3  U4  act4  U5  act5  U6  act6  U7  act7  U8  act8  U9  act9
  erI1  erI2  erI3  erC1  erC2  erC3  erS1  erS2  erS3
  save.a1  save.a2  save.a3  save.a4   save.a5  save.a6
  act1.year  act2.year  act3.year  invest1  invest2  invest3
  invs.a1  invs.a2  invs.a3  invs.a4  invs.a5  invs.a6  invs.a7  invs.a8  invs.a9
  ngb.k  ngb.k.mean  ngb.ca  ngb.ca.mean  ngb.ed  ngb.ea.mean ngb.pn1  ngb.pn2  ngb.pn3  ngb.sn1  ngb.sn2  ngb.sn3 ngb.pbcI1  ngb.pbcI2  ngb.pbcI3  ngb.pbcC1  ngb.pbcC2  ngb.pbcC3  ngb.pbcS1  ngb.pbcS2  ngb.pbcS3
  renov
]

; #####################################################################################
; ############################# loading data ##########################################
; #####################################################################################

to load-data

  if case-study = "ES"[
    if Scenario = "Ref.SSP2"[
      ifelse (file-exists? "cge-es-ssp2-h.csv")[               ;; income growth
        file-open "cge-es-ssp2-h.csv"
        set cge-es-ssp2-h csv:from-file "cge-es-ssp2-h.csv"
        file-close][
        user-message "Sorry, there is no <cge-es-ssp2-h> file in the directory" ]
    ]]

  if case-study = "NL"[
    if Scenario = "Ref.SSP2"[
      ifelse (file-exists? "cge-nl-ssp2-h.csv")[               ;; income growths
        file-open "cge-nl-ssp2-h.csv"
        set cge-nl-ssp2-h csv:from-file "cge-nl-ssp2-h.csv"
        file-close][
        user-message "Sorry, there is no <cge-nl-ssp2-h> file in the directory" ]
    ]]

end

; #####################################################################################
; ################################### setup ###########################################
; #####################################################################################

To setup
  clear-all
  clear-drawing
  ct
  file-close-all

  if generate-seed? [set Seed-for-random new-seed]
  random-seed Seed-for-random

  createfiles
  load-data
  set year 2016

  set aware.total 0
  set pn1.total 0 set pn2.total 0 set pn3.total 0  set sn1.total 0 set sn2.total 0 set sn3.total 0
  set a.total 0 set prob1 0  set prob2 0  set prob3 0  set prob4 0  set prob5 0  set prob6 0  set prob7 0  set prob8 0  set prob9 0
  set save.elec 0  set save.elec.com 0  set save.gas 0  set save.gas.com 0  set invs 0  set invs.com 0

  set t1.a1 0 set t1.a2 0  set t1.a3 0
  set t2.a1 0 set t2.a2 0  set t2.a3 0
  set dwage1.a1 0  set dwage2.a1 0  set dwage3.a1 0
  set dwage1R.a1 0 set dwage3R.a1 0 set dwage5R.a1 0


  set elec.t1.a1 0 set elec.t1.a2 0 set elec.t1.a3 0
  set elec.t2.a1 0 set elec.t2.a2 0 set elec.t2.a3 0
  set elec.t1 0 set elec.t2 0
  set gas.t1.a1 0 set gas.t1.a2 0 set gas.t1.a3 0
  set gas.t2.a1 0 set gas.t2.a2 0 set gas.t2.a3 0
  set gas.t1 0 set gas.t2 0
  set n.hh.eff 0 set n.hh.pro 0

 if case-study = "ES" [
    if Data = "Empirical-survey"[
      create-turtles 793 [ setxy random-xcor random-ycor  set shape "house"  set color grey]

      ask turtles[
        set h.id who
        set h.sta ""
        set sdgroup 0
        set aware 0 set guilt "Null" set k 0
        set m1.st "Null" set m2.st "Null" set m3.st "Null" set m1 0 set m2 0 set m3 0
        set cI1.st "Null" set cI2.st "Null" set cI3.st "Null"
        set cC1.st "Null" set cC2.st "Null" set cC3.st "Null"
        set cS1.st "Null" set cS2.st "Null" set cS3.st "Null"
        set U1 0 set U2 0 set U3 0
        set act1 "Null"  set act2 "Null"  set act3 "Null"
        set act1.year 0  set act2.year 0  set act3.year 0
        set save.a1 0  set save.a2 0  set save.a3 0  set save.a4 0  set save.a5 0  set save.a6 0
        set invest1 False set invest2 False  set invest3 False
        set invs.a1 0  set invs.a2 0  set invs.a3 0  set invs.a4 0  set invs.a5 0  set invs.a6 0  set invs.a7 0  set invs.a8 0 set invs.a9 0

        set elec randomNumber 1000 5000 100
        set rn random-float 100                  ;; to assign incomes

        if (rn < 11.4 ) [                        ;; 11.4% --> income group 1
          set h.group 1
          set income randomNumber 800 10000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 3 7 0.05          set cee.aw randomNumber 3 7 0.05         set ed.aw randomNumber 2.4 7 0.05
          set pn1 randomNumber 2.87 7 0.05        set pn2 randomNumber 2.87 7 0.05         set pn3 randomNumber 2.87 7 0.05
          set sn1  randomNumber 1 7 0.05          set sn2  randomNumber 1 7 0.05           set sn3  randomNumber 1 7 0.05
          set pbcI1 randomNumber 1 7 0.05         set pbcI2 randomNumber 1 7 0.05          set pbcI3 randomNumber 1 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 1 2.5 0.05    set ene.pat2 randomNumber 1 2.5 0.05     set ene.pat3 randomNumber 1 2.5 0.05

          set erI1 randomNumber -0.03 0.01 0.01   set erI2 randomNumber -0.01 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.05 0.01  set erC2 randomNumber -0.05 -0.03 0.01   set erC3 randomNumber -0.05 -0.03 0.01
          set erS1 randomNumber -0.01 0.00 0.01   set erS2 -0.01                           set erS3 randomNumber -0.02 -0.01 0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 71) [set gen 1]
          if (ge >= 71) and (ge <= 100) [set gen 2]
          set sa random 100                      ;; to assign age
          if (sa < 6 ) [set age 1]
          if (sa >= 6 ) and (sa < 64 ) [set age 2]
          if (sa >= 64 ) and (sa < 95 ) [set age 3]
          if (sa >= 95 ) and (sa <= 100 ) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 73 ) [set ecom 1]
          if (ec >= 73 ) and (ec < 96) [set ecom 2]
          if (ec >= 96 ) and (ec <= 100) [set ecom 3]
          set ed random 100                      ;; to assign education level
          if (ed < 36) [set edu 1]
          if (ed >= 36) and (ed < 58) [set edu 2]
          if (ed >= 58) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 37) [set dw.st 1]             ;; 37% owner
          if (ow >= 37) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 83 ) [set dw.type 1]
          if (ty >= 83 ) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 22 ) [set dw.age 1]
          if (dag >= 22 ) and (dag < 69) [set dw.age 2]
          if (dag >= 69) and (dag <= 100 ) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 71 ) [set dw.size 1]
          if (dsi >= 71 ) and (dsi < 93) [set dw.size 2]
          if (dsi >= 93) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 21) [set dw.elab 1]                           ;; 21% --> A
          if (en >= 21) and (en < 63.1) [set dw.elab 2]          ;; 42.1% --> B
          if (en >= 63.1) and (en < 78.9) [set dw.elab 3]        ;; 15.8% --> C
          if (en >= 78.9) and (en < 94.7) [set dw.elab 4]        ;; 15.8% --> D
          if (en >= 94.7) and (en <= 100) [set dw.elab 5]        ;; 5.3% --> E
          set prov random-float 100              ;; to assign energy provider
          if (prov < 3.49) [set ene.prov 2]                      ;; 3.49% --> brown
          if (prov >= 3.49) and (prov <= 100) [set ene.prov 1]   ;; rest  --> grey
        ]

        if (rn >= 11.4) and (rn < 58.2) [         ;; 46.8% -->  income group 2
          set h.group 2
          set income randomNumber 10000 30000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 1 7 0.05          set cee.aw randomNumber 2 7 0.05         set ed.aw randomNumber 1 7 0.05
          set pn1 randomNumber 2.25 7 0.05        set pn2 randomNumber 2.25 7 0.05         set pn3 randomNumber 2.25 7 0.05
          set sn1  randomNumber 1 7 0.05          set sn2  randomNumber 1 7 0.05           set sn3  randomNumber 1 7 0.05
          set pbcI1 randomNumber 1 7 0.05         set pbcI2 randomNumber 1 7 0.05          set pbcI3 randomNumber 1 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 1 2.5 0.05    set ene.pat2 randomNumber 1 2.5 0.05     set ene.pat3 randomNumber 1 2.5 0.05

          set erI1 randomNumber -0.03 -0.01 0.01  set erI2 randomNumber -0.01 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.03 0.01  set erC2 randomNumber -0.05 -0.03 0.01   set erC3 randomNumber -0.05 -0.03 0.01
          set erS1 randomNumber -0.01 0.00 0.01   set erS2 -0.01                           set erS3 randomNumber -0.02 -0.01 0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 63) [set gen 1]
          if (ge >= 63) and (ge <= 100) [set gen 2]
          set sa random 100                      ;; to assign age
          if (sa < 3) [set age 1]
          if (sa >= 3) and (sa < 48) [set age 2]
          if (sa >= 48) and (sa < 93) [set age 3]
          if (sa >= 93) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 24) [set ecom 1]
          if (ec >= 24) and (ec < 75) [set ecom 2]
          if (ec >= 75) and (ec <= 100) [set ecom 3]
          set ed random 100                    ;; to assign education level
          if (ed < 19) [set edu 1]
          if (ed >= 19) and (ed < 46) [set edu 2]
          if (ed >= 46) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 78) [set dw.st 1]             ;; 37% owner
          if (ow >= 78) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 81) [set dw.type 1]
          if (ty >= 81) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 30) [set dw.age 1]
          if (dag >= 30) and (dag < 76) [set dw.age 2]
          if (dag >= 76) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 72) [set dw.size 1]
          if (dsi >= 72) and (dsi < 91) [set dw.size 2]
          if (dsi >= 91) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 32.3) [set dw.elab 1]
          if (en >= 32.3) and (en < 64.6) [set dw.elab 2]
          if (en >= 64.6) and (en < 83.1) [set dw.elab 3]
          if (en >= 83.1) and (en < 90.8) [set dw.elab 4]
          if (en >= 90.8) and (en < 97) [set dw.elab 5]
          if (en >= 97) and (en < 100) [set dw.elab 6]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 4.25) [set ene.prov 2]
          if (prov >= 4.25) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn >= 58.2) and (rn < 86) [            ;; 27.8% --> income group 3
          set h.group 3
          set income randomNumber 30001 50000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 1 7 0.05          set cee.aw randomNumber 1 7 0.05         set ed.aw randomNumber 1 7 0.05
          set pn1 randomNumber 2 7 0.05           set pn2 randomNumber 2 7 0.05            set pn3 randomNumber 2 7 0.05
          set sn1  randomNumber 1 7 0.05          set sn2  randomNumber 1 7 0.05           set sn3  randomNumber 1 7 0.05
          set pbcI1 randomNumber 2.2 7 0.05       set pbcI2 randomNumber 2.2 7 0.05        set pbcI3 randomNumber 2.2 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 1 3 0.05      set ene.pat2 randomNumber 1 3 0.05       set ene.pat3 randomNumber 1 3 0.05

          set erI1 randomNumber -0.03 -0.01 0.01  set erI2 randomNumber -0.01 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.03 0.01  set erC2 randomNumber -0.05 -0.02 0.01   set erC3 -0.01
          set erS1 randomNumber -0.302 -0.01 0.01 set erS2 randomNumber -0.02 -0.01 0.01   set erS3 randomNumber -0.02 -0.01 0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 46) [set gen 1]
          if (ge >= 46) and (ge <= 100) [set gen 2]
          set sa random 100                      ;; to assign age
          if (sa < 2) [set age 1]
          if (sa >= 2) and (sa < 46) [set age 2]
          if (sa >= 46) and (sa < 91) [set age 3]
          if (sa >= 91) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 28) [set ecom 1]
          if (ec >= 28) and (ec < 75) [set ecom 2]
          if (ec >= 75) and (ec <= 100) [set ecom 3]
          set ed random 100                      ;; to assign education level
          if (ed < 10) [set edu 1]
          if (ed >= 10) and (ed < 31) [set edu 2]
          if (ed >= 31) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 85) [set dw.st 1]
          if (ow >= 85) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 76) [set dw.type 1]
          if (ty >= 76) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 29) [set dw.age 1]
          if (dag >= 29) and (dag < 78) [set dw.age 2]
          if (dag >= 78) and (dag <= 100 ) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 58) [set dw.size 1]
          if (dsi >= 58) and (dsi < 86) [set dw.size 2]
          if (dsi >= 86) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 32) [set dw.elab 1]
          if (en >= 32) and (en < 57.5) [set dw.elab 2]
          if (en >= 57.5) and (en < 76.6) [set dw.elab 3]
          if (en >= 76.6) and (en < 83) [set dw.elab 4]
          if (en >= 83) and (en < 93.6) [set dw.elab 5]
          if (en >= 93.6) and (en <= 100) [set dw.elab 6]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 5.71) [set ene.prov 2]
          if (prov >= 5.71) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn >= 86) and (rn < 94.7) [            ;; 8.7% -->  income group 4
          set h.group 4
          set income randomNumber 50001 70000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 3.66 6.33 0.05    set cee.aw randomNumber 2.92 7 0.05      set ed.aw randomNumber 2.33 7 0.05
          set pn1 randomNumber 2 7 0.05           set pn2 randomNumber 2 7 0.05            set pn3 randomNumber 2 7 0.05
          set sn1  randomNumber 1 7 0.05          set sn2  randomNumber 1 7 0.05           set sn3  randomNumber 1 7 0.05
          set pbcI1 randomNumber 2.6 7 0.05       set pbcI2 randomNumber 2.6 7 0.05        set pbcI3 randomNumber 2.6 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 1 2 0.05      set ene.pat2 randomNumber 1 2 0.05       set ene.pat3 randomNumber 1 2 0.05

          set erI1 randomNumber -0.03 -0.02 0.01  set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.03 0.01  set erC2 randomNumber -0.06 -0.02 0.01   set erC3 randomNumber -0.05 -0.02 0.01
          set erS1 -0.01                          set erS2 -0.01                           set erS3 randomNumber -0.02 -0.01 0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 50) [set gen 1]
          if (ge >= 50) and (ge <= 100) [set gen 2]
          set sa random 100                      ;; to assign age
          if (sa < 2) [set age 1]
          if (sa >= 2) and (sa < 47) [set age 2]
          if (sa >= 47) and (sa < 92) [set age 3]
          if (sa >= 92) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 8) [set ecom 1]
          if (ec >= 8) and (ec <= 49) [set ecom 2]
          if (ec >= 49) and (ec <= 100) [set ecom 3]
          set ed random 100                     ;; to assign education level
          if (ed < 5) [set edu 1]
          if (ed >= 5) and (ed < 18) [set edu 2]
          if (ed >= 18) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 94) [set dw.st 1]
          if (ow >= 94) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 65) [set dw.type 1]
          if (ty >= 65) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 33) [set dw.age 1]
          if (dag >= 33) and (dag < 80) [set dw.age 2]
          if (dag >= 80) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 59) [set dw.size 1]
          if (dsi >= 59) and (dsi < 76) [set dw.size 2]
          if (dsi >= 76) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 31.3) [set dw.elab 1]
          if (en >= 31.3) and (en < 56.3) [set dw.elab 2]
          if (en >= 56.3) and (en < 68.8) [set dw.elab 3]
          if (en >= 68.8) and (en < 87.5) [set dw.elab 4]
          if (en >= 87.5) and (en <= 100) [set dw.elab 5]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 3.03) [set ene.prov 2]
          if (prov >= 3.03) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn >= 94.7) and (rn < 97.8) [        ;; 3.1% --> income group 5
          set h.group 5
          set income randomNumber 70001 90000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 3.83 7 0.05       set cee.aw randomNumber 3.28 7 0.05      set ed.aw randomNumber 2.8 7 0.05
          set pn1 randomNumber 2.5 7 0.05         set pn2 randomNumber 2.5 7 0.05          set pn3 randomNumber 2.5 7 0.05
          set sn1  randomNumber 1 7 0.05          set sn2  randomNumber 1 7 0.05           set sn3  randomNumber 1 7 0.05
          set pbcI1 randomNumber 1.6 6.8 0.05     set pbcI2 randomNumber 1.6 6.8 0.05      set pbcI3 randomNumber 1.6 6.8 0.05
          set pbcC1 randomNumber 1.5 7 0.05       set pbcC2 randomNumber 1.5 7 0.05        set pbcC3 randomNumber 1.5 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 1 2 0.05      set ene.pat2 randomNumber 1 2 0.05       set ene.pat3 randomNumber 1 2 0.05

          set erI1 randomNumber -0.03 0.01 0.01   set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.03 0.01  set erC2 randomNumber -0.06 -0.02 0.01   set erC3 randomNumber -0.05 -0.03 0.01
          set erS1 -0.01                          set erS2 -0.01                           set erS3 randomNumber -0.02 -0.01 0.01

          set ge random 100                ;; to assign gender
          if (ge < 39) [set gen 1]
          if (ge >= 39) and (ge <= 100) [set gen 2]
          set sa random 100                ;; to assign age
          if (sa < 52) [set age 2]
          if (sa >= 52) and (sa < 96) [set age 3]
          if (sa >= 96) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 7) [set ecom 1]
          if (ec >= 7) and (ec <= 84) [set ecom 2]
          if (ec >= 84) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 10) [set edu 2]
          if (ed >= 10) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 96) [set dw.st 1]
          if (ow >= 96) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 74) [set dw.type 1]
          if (ty >= 74) and (ty <= 100 ) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 35) [set dw.age 1]
          if (dag >= 35) and (dag < 87) [set dw.age 2]
          if (dag >= 87) and (dag <= 100 ) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 57) [set dw.size 1]
          if (dsi >= 57) and (dsi < 83) [set dw.size 2]
          if (dsi >= 83) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 33.3) [set dw.elab 2]
          if (en >= 33.3) and (en <= 100) [set dw.elab 3]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 13.4) [set ene.prov 2]
          if (prov >= 13.4) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn >=  97.8) and (rn < 98.7) [       ;; 0.9% --> income group 6
          set h.group 5
          set income randomNumber 90001 110000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 3.83 7 0.05       set cee.aw randomNumber 3.5 6.5 0.05   set ed.aw randomNumber 3.2 7 0.05
          set pn1 randomNumber 2.25 6.75 0.05     set pn2 randomNumber 2.25 6.75 0.05    set pn3 randomNumber 2.25 6.75 0.05
          set sn1 randomNumber 1 6 0.05           set sn2  randomNumber 1 6 0.05         set sn3  randomNumber 1 6 0.05
          set pbcI1 randomNumber 1 5.6 0.05       set pbcI2 randomNumber 1 5.6 0.05      set pbcI3 randomNumber 1 5.6 0.05
          set pbcC1 randomNumber 1 5.6 0.05       set pbcC2 randomNumber 1 5.6 0.05      set pbcC3 randomNumber 1 5.6 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05        set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 1 1.75 0.05   set ene.pat2 randomNumber 1 1.75 0.05  set ene.pat3 randomNumber 1 1.75 0.05

          set erI1 randomNumber -0.03 0.01 0.01   set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.03 0.01  set erC2 randomNumber -0.06 -0.02 0.01   set erC3 randomNumber -0.05 -0.03 0.01
          set erS1 -0.01                          set erS2 -0.01                           set erS3 randomNumber -0.02 -0.01 0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 57) [set gen 1]
          if (ge >= 57) and (ge <= 100) [set gen 2]
          set sa random 100                      ;; to assign age
          if (sa < 28) [set age 2]
          if (sa >= 28) and (sa <= 100) [set age 3]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 25) [set ecom 1]
          if (ec >= 25) and (ec <= 50) [set ecom 2]
          if (ec >= 50) and (ec <= 100) [set ecom 3]
          set edu 3

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 86) [set dw.st 1]
          if (ow >= 86) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 86) [set dw.type 1]
          if (ty >= 86) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 71) [set dw.age 2]
          if (dag >= 71) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 14) [set dw.size 1]
          if (dsi >= 14) and (dsi < 71) [set dw.size 2]
          if (dsi >= 71) and (dsi <= 100) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 66.7) [set dw.elab 2]
          if (en >= 66.7) and (en < 100) [set dw.elab 6]
          set ene.prov 1
        ]

        if (rn >= 98.7) and (rn <= 100) [           ;; 1.3% -->  income group 7
          set h.group 5
          set income randomNumber 110001 150000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 4 6.33 0.05       set cee.aw randomNumber 4.57 6.28 0.05   set ed.aw randomNumber 3.5 6.33 0.05
          set pn1 randomNumber 4.42 7 0.05        set pn2 randomNumber 4.42 7 0.05         set pn3 randomNumber 4.42 7 0.05
          set sn1  randomNumber 3.33 6.2 0.05     set sn2  randomNumber 3.33 6.2 0.05      set sn3  randomNumber 3.33 6.2 0.05
          set pbcI1 randomNumber 3.6 7 0.05       set pbcI2 randomNumber 3.6 7 0.05        set pbcI3 randomNumber 3.6 7 0.05
          set pbcC1 randomNumber 1 6.5 0.05       set pbcC2 randomNumber 1 6.5 0.05        set pbcC3 randomNumber 1 6.5 0.05
          set pbcS1 randomNumber 3 6 0.05         set pbcS2 randomNumber 3 6 0.05          set pbcS3 randomNumber 3 6 0.05
          set ene.pat1 randomNumber 1 3 0.05      set ene.pat2 randomNumber 1 3 0.05       set ene.pat3 randomNumber 1 3 0.05

          set erI1 randomNumber -0.03 0.01 0.01   set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.03 0.01  set erC2 randomNumber -0.06 -0.02 0.01   set erC3 randomNumber -0.05 -0.03 0.01
          set erS1 -0.01                          set erS2 -0.01                           set erS3 randomNumber -0.02 -0.01 0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 40) [set gen 1]
          if (ge >= 40) and (ge <= 100) [set gen 2]
          set sa random 100                      ;; to assign age
          if (sa < 20) [set age 2]
          if (sa >= 20) and (sa < 70) [set age 3]
          if (sa >= 70) and (sa < 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 17) [set ecom 1]
          if (ec >= 17) and (ec <= 100) [set ecom 3]
          set ed random 100                      ;; to assign education level
          if (ed < 20) [set edu 2]
          if (ed >= 20) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 80) [set dw.st 1]
          if (ow >= 80) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 50) [set dw.type 1]
          if (ty >= 50) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 30) [set dw.age 1]
          if (dag >= 30) and (dag < 80) [set dw.age 2]
          if (dag >= 80) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 30) [set dw.size 1]
          if (dsi >= 30) and (dsi < 80) [set dw.size 2]
          if (dsi >= 80) and (dsi <= 100) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 50) [set dw.elab 2]
          if (en >= 50) and (en <= 100) [set dw.elab 6]
          set ene.prov 1
        ]
      ]
    ]
  ]

  if case-study = "NL" [
    if Data = "Empirical-survey"[
      create-turtles 759 [ setxy random-xcor random-ycor  set shape "house"  set color grey]  ; 1/10000
      ask turtles[
        set h.id who
        set h.sta ""
        set sdgroup 0
        set aware 0 set guilt "Null" set k 0
        set m1.st "Null" set m2.st "Null" set m3.st "Null" set m1 0 set m2 0 set m3 0
        set cI1.st "Null" set cI2.st "Null" set cI3.st "Null"
        set cC1.st "Null" set cC2.st "Null" set cC3.st "Null"
        set cS1.st "Null" set cS2.st "Null" set cS3.st "Null"
        set U1 0 set U2 0 set U3 0
        set act1 "Null"  set act2 "Null"  set act3 "Null"
        set act1.year 0  set act2.year 0  set act3.year 0
        set save.a1 0  set save.a2 0  set save.a3 0  set save.a4 0  set save.a5 0  set save.a6 0
        set invest1 False set invest2 False  set invest3 False
        set invs.a1 0  set invs.a2 0  set invs.a3 0  set invs.a4 0  set invs.a5 0  set invs.a6 0  set invs.a7 0  set invs.a8 0 set invs.a9 0
        set renov False

        set elec randomNumber 1000 5000 100
        set rn random-float 100                  ;; to assign incomes

        if (rn < 5.5 ) [                         ;; 5.5% --> income group 1
          set h.group 1
          set income randomNumber 800 10000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 1 7 0.05          set cee.aw randomNumber 1.2 6.8 0.05     set ed.aw randomNumber 1 7 0.05
          set pn1 randomNumber 1 6.5 0.05         set pn2 randomNumber 1 6.5 0.05          set pn3 randomNumber 1 6.5 0.05
          set sn1  randomNumber 1 6.5 0.05        set sn2  randomNumber 1 6.5 0.05         set sn3  randomNumber 1 6.5 0.05
          set pbcI1 randomNumber 1 7 0.05         set pbcI2 randomNumber 1 7 0.05          set pbcI3 randomNumber 1 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 0.25 2.22 0.05   set ene.pat2 randomNumber 0.25 2.22 0.05     set ene.pat3 randomNumber 0.25 2.22 0.05

          set erI1 randomNumber -0.03 -0.01 0.01   set erI2 randomNumber -0.02 -0.01 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.04 -0.03 0.01   set erC2 randomNumber -0.06 -0.03 0.01    set erC3 randomNumber -0.04 -0.02 0.01
          set erS1 randomNumber -0.01 0.00 0.01    set erS2 randomNumber -0.02 -0.01 0.01    set erS3  -0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 66.7) [set gen 1]
          if (ge >= 66.7) and (ge <= 100) [set gen 2]
          set sa random-float 100                ;; to assign age
          if (sa < 1.8 ) [set age 1]
          if (sa >= 1.8 ) and (sa < 35.1 ) [set age 2]
          if (sa >= 35.1 ) and (sa < 78.9 ) [set age 3]
          if (sa >= 78.9 ) and (sa <= 100 ) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 43.9 ) [set ecom 1]
          if (ec >= 43.9 ) and (ec < 64.9) [set ecom 2]
          if (ec >= 64.9 ) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 57.9) [set edu 1]
          if (ed >= 57.9) and (ed < 82.5) [set edu 2]
          if (ed >= 82.5) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 49) [set dw.st 1]             ;; owner
          if (ow >= 49) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 28.1 ) [set dw.type 1]
          if (ty >= 28.1 ) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 14 ) [set dw.age 1]
          if (dag >= 14 ) and (dag < 63.2) [set dw.age 2]
          if (dag >= 63.2) and (dag <= 100 ) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 47.1 ) [set dw.size 1]
          if (dsi >= 47.1 ) and (dsi < 80.7) [set dw.size 2]
          if (dsi >= 80.7) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 25) [set dw.elab 1]                           ;; A
          if (en >= 25) and (en < 34.4) [set dw.elab 2]          ;; B
          if (en >= 34.4) and (en < 40.6) [set dw.elab 3]        ;; C
          if (en >= 40.6) and (en < 43.7) [set dw.elab 4]        ;; D
          if (en >= 43.7) and (en <= 100) [set dw.elab 5]        ;; E
          set prov random-float 100              ;; to assign energy provider
          if (prov < 24.57) [set ene.prov 2]                     ;;  brown
          if (prov >= 24.57) and (prov <= 100) [set ene.prov 1]   ;; grey
        ]

        if (rn >= 5.5) and (rn <= 40.19) [       ;; 34.69% -->  income group 2
          set h.group 2
          set income randomNumber 10000 30000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 1 7 0.05          set cee.aw randomNumber 1 6.8 0.05       set ed.aw randomNumber 1.3 7 0.05
          set pn1 randomNumber 2 7 0.05           set pn2 randomNumber 2 7 0.05            set pn3 randomNumber 2 7 0.05
          set sn1  randomNumber 1 7 0.05          set sn2  randomNumber 1 7 0.05           set sn3  randomNumber 1 7 0.05
          set pbcI1 randomNumber 1.4 7 0.05       set pbcI2 randomNumber 1.4 7 0.05        set pbcI3 randomNumber 1.4 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 0.25 1.7 0.05    set ene.pat2 randomNumber 0.25 1.7 0.05     set ene.pat3 randomNumber 0.25 1.7 0.05

          set erI1 randomNumber -0.03 -0.01 0.01  set erI2 randomNumber -0.02 -0.01 0.01   set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.05 -0.02 0.01  set erC2 randomNumber -0.06 -0.03 0.01   set erC3 randomNumber -0.04 -0.01 0.01
          set erS1 randomNumber -0.01 0.00 0.01   set erS2 randomNumber -0.02 -0.01 0.01   set erS3 -0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 54.6) [set gen 1]
          if (ge >= 54.6) and (ge <= 100) [set gen 2]
          set sa random-float 100                ;; to assign age
          if (sa < 18.4) [set age 2]
          if (sa >= 18.4) and (sa < 57.4) [set age 3]
          if (sa >= 57.4) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 18.9) [set ecom 1]
          if (ec >= 18.9) and (ec < 41.5) [set ecom 2]
          if (ec >= 41.5) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 72.1) [set edu 1]
          if (ed >= 72.1) and (ed < 84.6) [set edu 2]
          if (ed >= 84.6) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 52) [set dw.st 1]             ;; owner
          if (ow >= 52) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 21.2) [set dw.type 1]
          if (ty >= 21.2) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 8.6) [set dw.age 1]
          if (dag >= 8.6) and (dag < 42.6) [set dw.age 2]
          if (dag >= 42.6) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 54.3) [set dw.size 1]
          if (dsi >= 54.3) and (dsi < 83.6) [set dw.size 2]
          if (dsi >= 83.6) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 8.5) [set dw.elab 1]
          if (en >= 8.5) and (en < 22.6) [set dw.elab 2]
          if (en >= 22.6) and (en < 35) [set dw.elab 3]
          if (en >= 35) and (en < 39) [set dw.elab 4]
          if (en >= 39) and (en <= 100) [set dw.elab 5]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 42.33) [set ene.prov 2]
          if (prov >= 42.33) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn > 40.19) and (rn <= 78.17) [      ;; 37.98% --> income group 3
          set h.group 3
          set income randomNumber 30001 50000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 2.6 7 0.05        set cee.aw randomNumber 2.71 7 0.05      set ed.aw randomNumber 1.4 7 0.05
          set pn1 randomNumber 1.5 7 0.05         set pn2 randomNumber 1.5 7 0.05          set pn3 randomNumber 1.5 7 0.05
          set sn1  randomNumber 1 7 0.05          set sn2  randomNumber 1 7 0.05           set sn3  randomNumber 1 7 0.05
          set pbcI1 randomNumber 2.2 7 0.05       set pbcI2 randomNumber 2.2 7 0.05        set pbcI3 randomNumber 2.2 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 0 1.6 0.05    set ene.pat2 randomNumber 0 1.6 0.05     set ene.pat3 randomNumber 0 1.6 0.05

          set erI1 randomNumber -0.03 -0.01 0.01  set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.05 -0.02 0.01
          set erC1 randomNumber -0.05 -0.02 0.01  set erC2 randomNumber -0.06 -0.03 0.01   set erC3 randomNumber -0.04 -0.01 0.01
          set erS1 -0.01                          set erS2 randomNumber -0.02 -0.01 0.01   set erS3 -0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 39.7) [set gen 1]
          if (ge >= 39.7) and (ge <= 100) [set gen 2]
          set sa random-float 100                ;; to assign age
          if (sa < 19.6) [set age 2]
          if (sa >= 19.6) and (sa < 64.4) [set age 3]
          if (sa >= 64.4) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 7.4) [set ecom 1]
          if (ec >= 7.4) and (ec < 30.3) [set ecom 2]
          if (ec >= 30.3) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 49.9) [set edu 1]
          if (ed >= 49.9) and (ed < 74.8) [set edu 2]
          if (ed >= 74.8) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 80) [set dw.st 1]
          if (ow >= 80) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 87.3) [set dw.type 1]
          if (ty >= 87.3) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 11.2) [set dw.age 1]
          if (dag >= 11.2) and (dag < 52.9) [set dw.age 2]
          if (dag >= 52.9) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 36.9) [set dw.size 1]
          if (dsi >= 36.9) and (dsi < 77.6) [set dw.size 2]
          if (dsi >= 77.6) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 16.4) [set dw.elab 1]
          if (en >= 16.4) and (en < 33.4) [set dw.elab 2]
          if (en >= 33.4) and (en < 43.3) [set dw.elab 3]
          if (en >= 43.3) and (en < 47.3) [set dw.elab 4]
          if (en >= 47.3) and (en <= 100) [set dw.elab 5]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 36.13) [set ene.prov 2]
          if (prov >= 36.13) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn > 78.17) and (rn <= 91.69) [      ;; 13.52% -->  income group 4
          set h.group 4
          set income randomNumber 50001 70000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 2.8 6.6 0.05      set cee.aw randomNumber 3 6.6 0.05       set ed.aw randomNumber 1.8 7 0.05
          set pn1 randomNumber 2.5 7 0.05         set pn2 randomNumber 2.5 7 0.05          set pn3 randomNumber 2.5 7 0.05
          set sn1  randomNumber 1.1 7 0.05        set sn2  randomNumber 1.1 7 0.05         set sn3  randomNumber 1.1 7 0.05
          set pbcI1 randomNumber 2.2 7 0.05       set pbcI2 randomNumber 2.2 7 0.05        set pbcI3 randomNumber 2.2 7 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 0.6 1.6 0.05  set ene.pat2 randomNumber 0.6 1.6 0.05   set ene.pat3 randomNumber 0.6 1.6 0.05

          set erI1 randomNumber -0.03 -0.01 0.01  set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.05 -0.02 0.01
          set erC1 randomNumber -0.05 -0.02 0.01  set erC2 randomNumber -0.06 -0.03 0.01   set erC3 randomNumber -0.04 -0.01 0.01
          set erS1 -0.01                          set erS2 randomNumber -0.02 -0.01 0.01   set erS3 -0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 37.1) [set gen 1]
          if (ge >= 37.1) and (ge <= 100) [set gen 2]
          set sa random-float 100                ;; to assign age
          if (sa < 26.4) [set age 2]
          if (sa >= 26.4) and (sa < 79.3) [set age 3]
          if (sa >= 79.3) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 2.9) [set ecom 1]
          if (ec >= 2.9) and (ec <= 44.3) [set ecom 2]
          if (ec >= 44.3) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 57.2) [set edu 1]
          if (ed >= 57.2) and (ed < 79.3) [set edu 2]
          if (ed >= 79.3) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 92) [set dw.st 1]
          if (ow >= 92) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 5.1) [set dw.type 1]
          if (ty >= 5.1) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 20) [set dw.age 1]
          if (dag >= 20) and (dag < 71.4) [set dw.age 2]
          if (dag >= 71.4) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 23.6) [set dw.size 1]
          if (dsi >= 23.6) and (dsi < 61.4) [set dw.size 2]
          if (dsi >= 61.4) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 22.9) [set dw.elab 1]
          if (en >= 22.9) and (en < 42.9) [set dw.elab 2]
          if (en >= 42.9) and (en < 60) [set dw.elab 3]
          if (en >= 60) and (en < 67.1) [set dw.elab 4]
          if (en >= 67.1) and (en <= 100) [set dw.elab 5]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 46.43) [set ene.prov 2]
          if (prov >= 46.43) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn > 91.69) and (rn <= 97.39) [      ;; 5.7% --> income group 5
          set h.group 5
          set income randomNumber 70001 90000 100
          set gas randomNumber 0 5000 100
          set know randomNumber 3 5.66 0.05       set cee.aw randomNumber 3.14 6.42 0.05   set ed.aw randomNumber 2 7 0.05
          set pn1 randomNumber 3.5 6.25 0.05      set pn2 randomNumber 3.5 6.25 0.05       set pn3 randomNumber 3.5 6.25 0.05
          set sn1  randomNumber 1 5.8 0.05        set sn2  randomNumber 1 5.8 0.05         set sn3  randomNumber 1 5.8 0.05
          set pbcI1 randomNumber 2.2 7 0.05       set pbcI2 randomNumber 2.2 7 0.05        set pbcI3 randomNumber 2.2 7 0.05
          set pbcC1 randomNumber 1 6.5 0.05       set pbcC2 randomNumber 1 6.5 0.05        set pbcC3 randomNumber 1 6.5 0.05
          set pbcS1 randomNumber 1 7 0.05         set pbcS2 randomNumber 1 7 0.05          set pbcS3 randomNumber 1 7 0.05
          set ene.pat1 randomNumber 0.70 1.60 0.05       set ene.pat2 randomNumber 0.70 1.60 0.05        set ene.pat3 randomNumber 0.70 1.60 0.05

          set erI1 randomNumber -0.03 -0.01 0.01   set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.04 -0.03 0.01  set erC2 randomNumber -0.06 -0.03 0.01    set erC3 randomNumber -0.03 -0.01 0.01
          set erS1 -0.01                          set erS2 randomNumber -0.02 -0.01 0.01    set erS3 -0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 39) [set gen 1]
          if (ge >= 39) and (ge <= 100) [set gen 2]
          set sa random-float 100                ;; to assign age
          if (sa < 25.4) [set age 2]
          if (sa >= 25.4) and (sa < 84.7) [set age 3]
          if (sa >= 84.7) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 22.2) [set ecom 2]
          if (ec >= 22.2) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 57.2) [set edu 1]
          if (ed >= 57.2) and (ed < 79.3) [set edu 2]
          if (ed >= 79.3) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 92) [set dw.st 1]
          if (ow >= 92) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 6.8) [set dw.type 1]
          if (ty >= 6.8) and (ty <= 100 ) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 10.2) [set dw.age 1]
          if (dag >= 10.2) and (dag < 96) [set dw.age 2]
          if (dag >= 96) and (dag <= 100 ) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 15.3) [set dw.size 1]
          if (dsi >= 15.3) and (dsi < 54) [set dw.size 2]
          if (dsi >= 54) and (dsi <= 100 ) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 25.9) [set dw.elab 1]
          if (en >= 25.9) and (en < 40.7) [set dw.elab 2]
          if (en >= 40.7) and (en < 51.8) [set dw.elab 3]
          if (en >= 51.8) and (en < 55.5) [set dw.elab 4]
          if (en >= 55.5) and (en <= 100) [set dw.elab 5]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 44.07) [set ene.prov 2]
          if (prov >= 44.07) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn > 97.39) and (rn <= 98.36) [      ;; 0.99% --> income group 6
          set h.group 5
          set income randomNumber 90001 110000 100
          set gas randomNumber 0 3000 100
          set know randomNumber 3.1 4.66 0.05     set cee.aw randomNumber 2.72 5.57 0.05 set ed.aw randomNumber 3.66 6.33 0.05
          set pn1 randomNumber 3.62 5.75 0.05     set pn2 randomNumber 3.62 5.75 0.05    set pn3 randomNumber 3.62 5.75 0.05
          set sn1 randomNumber 2 3.83 0.05        set sn2  randomNumber 2 3.83 0.05      set sn3  randomNumber 2 3.83 0.05
          set pbcI1 randomNumber 2.4 6.4 0.05     set pbcI2 randomNumber 2.4 6.4 0.05    set pbcI3 randomNumber 2.4 6.4 0.05
          set pbcC1 randomNumber 1 5.6 0.05       set pbcC2 randomNumber 1 5.6 0.05      set pbcC3 randomNumber 1 5.6 0.05
          set pbcS1 randomNumber 1.5 5.5 0.05     set pbcS2 randomNumber 1.5 5.5 0.05    set pbcS3 randomNumber 1.5 5.5 0.05
          set ene.pat1 randomNumber 0.78 1.82 0.05      set ene.pat2 randomNumber 0.78 1.82 0.05     set ene.pat3 randomNumber 0.78 1.82 0.05

          set erI1 randomNumber -0.03 -0.01 0.01   set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.04 -0.03 0.01  set erC2 randomNumber -0.06 -0.03 0.01    set erC3 randomNumber -0.03 -0.01 0.01
          set erS1 -0.01                          set erS2 randomNumber -0.02 -0.01 0.01    set erS3 -0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 50) [set gen 1]
          if (ge >= 50) and (ge <= 100) [set gen 2]
          set sa random-float 100                ;; to assign age
          if (sa < 40) [set age 2]
          if (sa >= 40) and (sa < 90) [set age 3]
          if (sa >= 90) and (sa <= 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec < 33.3) [set ecom 2]
          if (ec >= 33.3) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 10) [set edu 1]
          if (ed >= 10) and (ed < 20) [set edu 2]
          if (ed >= 20) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 20) [set dw.st 1]
          if (ow >= 20) and (ow <= 100) [set dw.st 2]
          set dw.type 2
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 40) [set dw.age 1]
          if (dag >= 40 and dag <= 60) [set dw.age 2]
          if (dag >= 60 and dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 14) [set dw.size 1]
          if (dsi >= 14) and (dsi < 71) [set dw.size 2]
          if (dsi >= 71) and (dsi <= 100) [set dw.size 3]
          set dw.elab 5
          set prov random-float 100              ;; to assign energy provider
          if (prov < 20) [set ene.prov 2]
          if (prov >= 20) and (prov <= 100) [set ene.prov 1]
        ]

        if (rn > 98.36) and (rn <= 100) [        ;; 1.64% -->  income group 7
          set h.group 5
          set income randomNumber 110001 150000 100
          set gas randomNumber 0 3000 100
          set know randomNumber 3.33 5.33 0.05    set cee.aw randomNumber 3.85 6.21 0.05   set ed.aw randomNumber 2.66 6 0.05
          set pn1 randomNumber 2.62 7 0.05        set pn2 randomNumber 2.62 7 0.05         set pn3 randomNumber 2.62 7 0.05
          set sn1  randomNumber 1 5.66 0.05       set sn2  randomNumber 1 5.66 0.05        set sn3  randomNumber 1 5.66 0.05
          set pbcI1 randomNumber 1.6 6.6 0.05     set pbcI2 randomNumber 1.6 6.6 0.05      set pbcI3 randomNumber 1.6 6.6 0.05
          set pbcC1 randomNumber 1 7 0.05         set pbcC2 randomNumber 1 7 0.05          set pbcC3 randomNumber 1 7 0.05
          set pbcS1 randomNumber 3 6 0.05         set pbcS2 randomNumber 3 6 0.05          set pbcS3 randomNumber 3 6 0.05
          set ene.pat1 randomNumber 1 3 0.05       set ene.pat2 randomNumber 1 3 0.05        set ene.pat3 randomNumber 1 3 0.05

          set erI1 randomNumber -0.03 -0.01 0.01   set erI2 randomNumber -0.02 0.00 0.01    set erI3 randomNumber -0.04 -0.02 0.01
          set erC1 randomNumber -0.04 -0.03 0.01  set erC2 randomNumber -0.06 -0.03 0.01    set erC3 randomNumber -0.03 -0.01 0.01
          set erS1 -0.01                          set erS2 randomNumber -0.02 -0.01 0.01    set erS3 -0.01

          set ge random-float 100                ;; to assign gender
          if (ge < 37.1) [set gen 1]
          if (ge >= 37.1) and (ge <= 100) [set gen 2]
          set sa random-float 100                ;; to assign age
          if (sa < 5.9) [set age 2]
          if (sa >= 5.9) and (sa < 70.6) [set age 3]
          if (sa >= 70.6) and (sa < 100) [set age 4]
          set ec random-float 100                ;; to assign economy comfort
          if (ec <  2.9) [set ecom 1]
          if (ec >=  2.9) and (ec < 44.3) [set ecom 2]
          if (ec >=  44.3) and (ec <= 100) [set ecom 3]
          set ed random-float 100                ;; to assign education level
          if (ed < 29.4) [set edu 1]
          if (ed >= 29.4) and (ed < 64.7) [set edu 2]
          if (ed >= 64.7) and (ed <= 100) [set edu 3]

          set ow random-float 100                ;; to assign owner/rental statuse
          if (ow < 80) [set dw.st 1]
          if (ow >= 80) and (ow <= 100) [set dw.st 2]
          set ty random-float 100                ;; to assign dwelling type
          if (ty < 5.7) [set dw.type 1]
          if (ty >= 5.7) and (ty <= 100) [set dw.type 2]
          set dag random-float 100               ;; to assign dwelling age
          if (dag < 20) [set dw.age 1]
          if (dag >= 20) and (dag < 71.4) [set dw.age 2]
          if (dag >= 71.4) and (dag <= 100) [set dw.age 3]
          set dsi random-float 100               ;; to assign dwelling size
          if (dsi < 23.6) [set dw.size 1]
          if (dsi >= 23.6) and (dsi < 61.4) [set dw.size 2]
          if (dsi >= 61.4) and (dsi <= 100) [set dw.size 3]
          set en random-float 100                ;; to assign dwelling energy lable
          if (en < 20) [set dw.elab 1]
          if (en >= 20) and (en < 50) [set dw.elab 2]
          if (en >= 50) and (en < 70) [set dw.elab 3]
          if (en >= 70) and (en < 90) [set dw.elab 4]
          if (en >= 90) and (en <= 100) [set dw.elab 5]
          set prov random-float 100              ;; to assign energy provider
          if (prov < 29.41) [set ene.prov 2]
          if (prov >= 29.41) and (prov <= 100) [set ene.prov 1]
        ]
      ]
    ]
  ]
  reset-ticks

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;; Creating Files ;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to createfiles

   if debugfiles = true[
    if file-exists? "debug.csv" [file-delete "debug.csv"]
    file-open "debug.csv"
    file-print (word "year, " "id, " "group id, " "status, " "invest1, " "invest2, " "provider, " "income, " "gender, " "education, " "economic comfort, " "age, " "dwelling status, " "dwelling label, " "dwelling type, " "dwelling age, " "dwelling size, "
                     "elec, " "gas, " "pattern1, " "pattern2, " "pattern3, " "knowledge, " "cee.aw, " "ed.aw, " "guilt, " "awareness, "
                     "pn1, " "pn2, " "pn3, " "sn1, " "sn2, " "sn3, " "m1st, " "m2st, " "m3st, " "pbcI1, " "pbcI2, " "pbcI3, " "pbcC1, " "pbcC2, " "pbcC3, " "pbcS1, " "pbcS2, " "pbcS3, "
                     "cI1st, " "cI2st, " "cI3.st, " "cC1.st, " "cC2.st, " "cC3.st, " "cS1.st, " "cS2.st, " "cS3.st, "  "U1, " "act1, " "U2, " "act2, " "U3, " "act3, " "U4, " "act4, " "U5, " "act5, " "U6, " "act6, "
                     "U7, " "act7, " "U8, " "act8, " "U9, " "act9, ")
   ]

  file-close-all

end

; ########################################################################################
; #################################### Functions #########################################
; ########################################################################################

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Go

To go

  tick
  set number.households count turtles
  set greyuser (count turtles with [ene.prov = 1])
  set brownuser (count turtles with [ene.prov = 2])
  set greenuser (count turtles with [ene.prov = 3])

  set number.group1 (count turtles with [h.group = 1])
  set number.group2 (count turtles with [h.group = 2])
  set number.group3 (count turtles with [h.group = 3])
  set number.group4 (count turtles with [h.group = 4])
  set number.group5 (count turtles with [(h.group = 5 or h.group = 6 or h.group = 7)])

  set number.t1 (count turtles with [dw.type = 1])
  set number.t2 (count turtles with [dw.type = 2])

  recallmemory
  debug
  update.info
  update.dwelling

  if Scenario = "Ref.SSP2"[
    if NAT = False and TPB = False and COM = True [
      knowledge
      motivation
      consideration]
    utility
    action
    save.energy
    invest
    learn
    update.income
    update.energy
    update.memory
  ]
  set year (year + 1)
  set n (n + 1)

end

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Memory

to recallmemory

if year = 2016 and Memory = True [
  if case-study = "ES" [ask turtles[
      set h.id who
      if h.group = 1 [
        let aa random-float 100
        if (aa <= 2.3)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 2.3) and (aa <= 100)[set act1 false  set invest1 False]]
      if h.group = 2 [
        let aa random-float 100
        if (aa <= 1.7)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 1.7) and (aa <= 100)[set act1 false set invest1 False]]
      if h.group = 3[
        let aa random-float 100
        if (aa <= 2.9)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 1.7) and (aa <= 100)[set act1 false  set invest1 False ]]
      if h.group = 4[
        let aa random-float 100
        if (aa <= 3.0)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 3.0) and (aa <= 100)[set act1 false set invest1 False]]
      if h.group = 5 or h.group = 6 or h.group = 7 [
        let aa random-float 100
        if (aa <= 2.5)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 2.5) and (aa <= 100)[set act1 false set invest1 False]]
    ]]

  if case-study = "NL" [ask turtles[
  set h.id who
      if h.group = 1 [
        let aa random-float 100
        if (aa <= 1.8)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 1.8) and (aa <= 100)[set act1 false set invest1 False]]
      if h.group = 2 [
        let aa random-float 100
        if (aa <= 1.4)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 1.4) and (aa <= 100)[set act1 false set invest1 False]]
      if h.group = 3[
        let aa random-float 100
        if (aa <= 1.5)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 1.5) and (aa <= 100)[set act1 false  set invest1 False]]
      if h.group = 4[
        let aa random-float 100
        if (aa <= 3.6)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 3.6) and (aa <= 100)[set act1 false  set invest1 False]]
      if h.group = 5 or h.group = 6 or h.group = 7 [
        let aa random-float 100
        if (aa <= 1.2)[set act1 true  set invest1 true set h.sta "insulated"]
        if (aa > 1.2) and (aa <= 100)[set act1 false set invest1 False]]]]
  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; behavioral part ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Knowledge

To knowledge

  ask turtles [
      set aware ((know + cee.aw + ed.aw) / 3)
      if case-study = "NL" [
        if (aware < 4.6 )[set guilt "L"]
        if (aware >= 4.6) [set guilt "H"]]
      if case-study = "ES" [
        if (aware < 5.2 )[set guilt "L"]
        if (aware >= 5.2) [set guilt "H"]]
      if (guilt = "H") [set k ( aware / 7)]]

  set aware.total sum [aware] of turtles
  plot.awareness

end

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Motivation

To motivation

  ask turtles[
    if guilt = "H"[
      if case-study = "NL" [
        if ((pn1 < 4.7) or (sn1 < 3.5))[set m1.st "L"]
        if ((pn1 >= 4.7) and (sn1 >= 3.5))[set m1.st "H"]
        if ((pn2 < 4.8) or (sn2 < 3.6))[set m2.st "L"]
        if ((pn2 >= 4.8) and (sn2 >= 3.6))[set m2.st "H"]
        if ((pn3 < 4.8) or (sn3 < 3.7))[set m3.st "L"]
        if ((pn3 >= 4.8) and (sn3 >= 3.7))[set m3.st "H"]]

      if case-study = "ES" [
        if ((pn1 < 5.67) or (sn1 < 4.77))[set m1.st "L"]
        if ((pn1 >= 5.67) and (sn1 >= 4.77))[set m1.st "H"]
        if ((pn2 < 5.40) or (sn2 < 4.45))[set m2.st "L"]
        if ((pn2 >= 5.40) and (sn2 >= 4.45))[set m2.st "H"]
        if ((pn3 < 5.78) or (sn3 < 5.05))[set m3.st "L"]
        if ((pn3 >= 5.78) and (sn3 >= 5.05))[set m3.st "H"]]
    ]]

  set pn1.total sum [pn1] of turtles
  set pn2.total sum [pn2] of turtles
  set pn3.total sum [pn3] of turtles
  set sn1.total sum [sn1] of turtles
  set sn2.total sum [sn2] of turtles
  set sn3.total sum [sn3] of turtles

  plot.motivation

end

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Consideration

To consideration

  ask turtles[

    if case-study = "NL" [
      if Investment = True and m1.st = "H" [
        if ((pbcI1 < 1) or (dw.st = 2))[set cI1.st "L"]                          ;; insulation
        if ((pbcI1 >= 1) and (dw.st = 1)) [set cI1.st  "H"]
        if ((pbcI2 < 1) or (dw.st = 2))[set cI2.st  "L"]                         ;; installation
        if ((pbcI2 >= 1) and (dw.st = 1)) [set cI2.st "H"]
        if (pbcI3 < 1) [set cI3.st "L"]                                          ;; appliances
        if (pbcI3 >= 1) [set cI3.st "H"]]

      if Conservation = True and m2.st = "H" [
        if ((pbcC1 < 1) or (ene.pat1 = 3)) [set cC1.st "L"]                        ;; switch off extra(3 = almost always)
        if (pbcC1 >= 1) [set cC1.st "H"]
        if ((pbcC2 < 1) or (ene.pat2 = 3)) [set cC2.st "L"]                        ;; turn down
        if (pbcC2 >= 1) [set cC2.st "H"]
        if ((pbcC3 < 1) or (ene.pat3 = 3)) [set cC3.st "L"]                        ;; use less
        if (pbcC3 >= 1) [set cC3.st "H"]]

      if Switching = True and m3.st = "H" [
        if ene.prov = 1 [
          if (pbcS1 < 1) [set cS1.st "L"]                                        ;; grey to brown
          if (pbcS1 >= 1) [set cS1.st "H"]]
        if ene.prov = 2 [
          if (pbcS2 < 1) [set cS2.st "L"]                                        ;; brown to green
          if (pbcS2 >= 1) [set cS2.st "H"]]
        if ene.prov = 1 [
          if (pbcS3 < 1) [set cS3.st "L"]                                        ;; grey to grey
          if (pbcS3 >= 1) [set cS3.st "H"]]]
    ]


    if case-study = "ES" [
      if Investment = True and m1.st = "H" [
        if ((pbcI1 < 2.2) or (dw.st = 2))[set cI1.st "L"]                          ;; insulation
        if ((pbcI1 >= 2.2) and (dw.st = 1)) [set cI1.st  "H"]
        if ((pbcI2 < 2.2) or (dw.st = 2) )[set cI2.st  "L"]                        ;; installation
        if ((pbcI2 >= 2.2) and (dw.st = 1)) [set cI2.st "H"]
        if (pbcI3 < 2.2) [set cI3.st "L"]                                          ;; appliances
        if (pbcI3 >= 2.2) [set cI3.st "H"]]

      if Conservation = True and m2.st = "H" [
        if ((pbcC1 < 1) or (ene.pat1 = 3)) [set cC1.st "L"]                        ;; switch off extra(3 = almost always)
        if (pbcC1 >= 1) [set cC1.st "H"]
        if ((pbcC2 < 1) or (ene.pat2 = 3)) [set cC2.st "L"]                        ;; turn down
        if (pbcC2 >= 1) [set cC2.st "H"]
        if ((pbcC3 < 1) or (ene.pat3 = 3)) [set cC3.st "L"]                        ;; use less
        if (pbcC3 >= 1) [set cC3.st "H"]]

      if Switching = True and m3.st = "H" [
        if ene.prov = 1 [
          if (pbcS1 < 3.5) [set cS1.st "L"]                                        ;; grey to brown
          if (pbcS1 >= 3.5) [set cS1.st "H"]]
        if ene.prov = 2 [
          if (pbcS2 < 3.5) [set cS2.st "L"]                                        ;; brown to green
          if (pbcS2 >= 3.5) [set cS2.st "H"]]
        if ene.prov = 1 [
          if (pbcS3 < 3.5) [set cS3.st "L"]                                        ;; grey to grey
          if (pbcS3 >= 3.5) [set cS3.st "H"]]]
    ]
  ]

end

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Random utility

To utility

 ask turtles[

    if cI1.st = "L" [set U1 0]
    if cI1.st = "H" [set U1 ((edu * 0.0563284 + age * 0.0008106 + dw.elab * -0.0769971 + dw.type * 0.4265 + dw.age * 0.0883428 + dw.size * 0.0857047 + gas * 0.0000488 + pn1 * 0.052849 ) + erI1 )]
  ]

end

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Action

To action

  ask turtles [
    if U1 <= 0 or invest1 = True or h.sta = "insulated" [set act1 False]
    if (U1 > 0 and invest1 = False and dw.elab > 1) [set act1 True set invest1 True set color 65]
  ]

  set noaction count turtles with [act1 = False]
  set a1 count turtles with [act1 = True]
  set a1.com  a1.com + a1

  plot.investment
  plot.conservation
  plot.switching
  plot.behaviors

; socio-demographic dynamics
;; Education and Age

  ask turtles[

   set group1.a1 count turtles with [h.group = 1 and act1 = True]
   set group2.a1 count turtles with [h.group = 2 and act1 = True]
   set group3.a1 count turtles with [h.group = 3 and act1 = True]
   set group4.a1 count turtles with [h.group = 4 and act1 = True]
   set group5.a1 count turtles with [(h.group = 5  or h.group = 6 or h.group = 7) and act1 = True]

   set t1.a1 count turtles with [dw.type = 1 and act1 = True]
   set t2.a1 count turtles with [dw.type = 2 and act1 = True]

   set dwage1.a1 count turtles with [dw.age = 1 and act1 = True]
   set dwage2.a1 count turtles with [dw.age = 2 and act1 = True]
   set dwage3.a1 count turtles with [dw.age = 3 and act1 = True]

   set elab1.a1 count turtles with [dw.elab = 1 and act1 = True]
   set elab2.a1 count turtles with [(dw.elab = 2 or dw.elab = 3 )and act1 = True]
   set elab3.a1 count turtles with [(dw.elab = 4 or  dw.elab = 5 ) and act1 = True]
  ]

  set number.dwage1 count turtles with [dw.age = 1]
  set number.dwage2 count turtles with [dw.age = 2 ]
  set number.dwage3 count turtles with [dw.age = 3 ]

  set number.elab1 (count turtles with [dw.elab = 1])
  set number.elab2 (count turtles with [dw.elab = 2])
  set number.elab3 (count turtles with [dw.elab = 3])
  set number.elab4 (count turtles with [dw.elab = 4])
  set number.elab5 (count turtles with [dw.elab = 5])

  set n.hh.eff count turtles with [h.sta = "Efficient"]

end


; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Save

To save.energy

  set gas.total sum [gas] of turtles

  if year >= 2017 [
    ask turtles[
      if (act1 = True) [
        set save.a1 (gas * 20 / 100)
        set gas (gas - save.a1)]
      if (act1 = False) [set save.a1 0]
  ]]

  set save.gas (sum [save.a1] of turtles)
  set save.gas.com (save.gas.com + save.gas)

  plot.saveenergy

end
; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Invesments

To invest

  if year >= 2017 [
    ask turtles[
      if (act1 = True) [set invs.a1 I1.cost]   if act1 = False [set invs.a1 0]
  ]]

  set invs1.com  invs1.com + (sum [invs.a1] of turtles)

end

; ::::::::::::::::::::::::::::::::::::::::::::::::::
; Social dynamics and learning

To learn

  if year >= 2017 [
    ask turtles[
      if Learning = "No learning" [ ]
      if Learning = "Slow dynamics"[
        if (act1 = True or invest1 = True) [
          if (pbcI1 < 6.6) [set pbcI1 (pbcI1 + (pbcI1 * 0.05))]

          create-links-to other turtles-on neighbors
          ask link-neighbors [
            set ngb.k.mean mean [know] of turtles-on neighbors
            let ngb.k.median median [know] of turtles-on neighbors
            set ngb.k max list ngb.k.mean ngb.k.median
            set ngb.ca.mean mean [cee.aw] of turtles-on neighbors
            let ngb.ca.median median [cee.aw] of turtles-on neighbors
            set ngb.ca max list ngb.ca.mean  ngb.ca.median
            set ngb.ea.mean mean [ed.aw] of turtles-on neighbors
            let ngb.ea.median median [ed.aw] of turtles-on neighbors
            set ngb.ed max list ngb.ea.mean  ngb.ea.median
            let ngb.pn1.mean mean [pn1]  of turtles-on neighbors
            let ngb.pn1.median median [pn1] of turtles-on neighbors
            set ngb.pn1 max list ngb.pn1.mean  ngb.pn1.median
            let ngb.sn1.mean mean [sn1] of turtles-on neighbors
            let ngb.sn1.median median [sn1] of turtles-on neighbors
            set ngb.sn1 max list ngb.sn1.mean  ngb.sn1.median
            let ngb.pbcI1.mean mean [pbcI1] of turtles-on neighbors
            let ngb.pbcI1.median median [pbcI1] of turtles-on neighbors
            set ngb.pbcI1 max list ngb.pbcI1.mean  ngb.pbcI1.median]

          if count link-neighbors > 4 [ ask link-neighbors [
            if ((know < ngb.k) and (know < 6.6))[set know (know + (know * 0.05))]
            if ((cee.aw < ngb.ca) and (cee.aw < 6.6))[set cee.aw (cee.aw + (cee.aw * 0.05))]
            if ((ed.aw < ngb.ed) and (ed.aw < 6.6))[set ed.aw (ed.aw + (ed.aw * 0.05))]
            if ((pn1 < ngb.pn1) and (pn1 < 6.6))[set pn1 (pn1 + (pn1 * 0.05))]
            if ((sn1 < ngb.sn1) and (sn1 < 6.6)) [set sn1 (sn1 + (0.05 * sn1))]
            if ((pbcI1 < 6.5) and (pbcI1 < ngb.pbcI1)) [set pbcI1 (pbcI1 + (pbcI1 * 0.05))]]]
        ]
      ]


      if Learning = "Fast dynamics" [
        if (act1 = True or invest1 = True) [
          if (pbcI1 < 6.6) [set pbcI1 (pbcI1 + (pbcI1 * 0.05))]

          create-links-to other turtles-on neighbors
          ask link-neighbors [
            set ngb.k.mean mean [know] of turtles-on neighbors
            let ngb.k.median median [know] of turtles-on neighbors
            set ngb.k max list ngb.k.mean ngb.k.median
            set ngb.ca.mean mean [cee.aw] of turtles-on neighbors
            let ngb.ca.median median [cee.aw] of turtles-on neighbors
            set ngb.ca max list ngb.ca.mean  ngb.ca.median
            set ngb.ea.mean mean [ed.aw] of turtles-on neighbors
            let ngb.ea.median median [ed.aw] of turtles-on neighbors
            set ngb.ed max list ngb.ea.mean  ngb.ea.median
            let ngb.pn1.mean mean [pn1]  of turtles-on neighbors
            let ngb.pn1.median median [pn1] of turtles-on neighbors
            set ngb.pn1 max list ngb.pn1.mean  ngb.pn1.median
            let ngb.sn1.mean mean [sn1] of turtles-on neighbors
            let ngb.sn1.median median [sn1] of turtles-on neighbors
            set ngb.sn1 max list ngb.sn1.mean  ngb.sn1.median
            let ngb.pbcI1.mean mean [pbcI1] of turtles-on neighbors
            let ngb.pbcI1.median median [pbcI1] of turtles-on neighbors
            set ngb.pbcI1 max list ngb.pbcI1.mean  ngb.pbcI1.median

            if ((know < ngb.k) and (know < 6.6))[set know (know + (know * 0.05))]
            if ((cee.aw < ngb.ca) and (cee.aw < 6.6))[set cee.aw (cee.aw + (cee.aw * 0.05))]
            if ((ed.aw < ngb.ed) and (ed.aw < 6.6))[set ed.aw (ed.aw + (ed.aw * 0.05))]
            if ((pn1 < ngb.pn1) and (pn1 < 6.6))[set pn1 (pn1 + (pn1 * 0.05))]
            if ((sn1 < ngb.sn1) and (sn1 < 6.6)) [set sn1 (sn1 + (0.05 * sn1))]
            if ((pbcI1 < 6.5) and (pbcI1 < ngb.pbcI1)) [set pbcI1 (pbcI1 + (pbcI1 * 0.05))]
          ]
        ]
      ]


      if Learning ="Informative"[
        if (know <= 6.6 )[set know (know + (know * 0.05))]
        if (cee.aw <= 6.6 )[set cee.aw (cee.aw + (cee.aw * 0.05))]
        if (ed.aw <= 6.6 )[set ed.aw (ed.aw + (ed.aw * 0.05))]
        if (act1 = True or invest1 = True) [
          if (pbcI1 < 6.6) [set pbcI1 (pbcI1 + (pbcI1 * 0.05))]

          create-links-to other turtles-on neighbors
          ask link-neighbors [
            set ngb.k.mean mean [know] of turtles-on neighbors
            let ngb.k.median median [know] of turtles-on neighbors
            set ngb.k max list ngb.k.mean ngb.k.median
            set ngb.ca.mean mean [cee.aw] of turtles-on neighbors
            let ngb.ca.median median [cee.aw] of turtles-on neighbors
            set ngb.ca max list ngb.ca.mean  ngb.ca.median
            set ngb.ea.mean mean [ed.aw] of turtles-on neighbors
            let ngb.ea.median median [ed.aw] of turtles-on neighbors
            set ngb.ed max list ngb.ea.mean  ngb.ea.median
            let ngb.pn1.mean mean [pn1]  of turtles-on neighbors
            let ngb.pn1.median median [pn1] of turtles-on neighbors
            set ngb.pn1 max list ngb.pn1.mean  ngb.pn1.median
            let ngb.sn1.mean mean [sn1] of turtles-on neighbors
            let ngb.sn1.median median [sn1] of turtles-on neighbors
            set ngb.sn1 max list ngb.sn1.mean  ngb.sn1.median
            let ngb.pbcI1.mean mean [pbcI1] of turtles-on neighbors
            let ngb.pbcI1.median median [pbcI1] of turtles-on neighbors
            set ngb.pbcI1 max list ngb.pbcI1.mean  ngb.pbcI1.median

            if ((know < ngb.k) and (know < 6.6))[set know (know + (know * 0.05))]
            if ((cee.aw < ngb.ca) and (cee.aw < 6.6))[set cee.aw (cee.aw + (cee.aw * 0.05))]
            if ((ed.aw < ngb.ed) and (ed.aw < 6.6))[set ed.aw (ed.aw + (ed.aw * 0.05))]
            if ((pn1 < ngb.pn1) and (pn1 < 6.6))[set pn1 (pn1 + (pn1 * 0.05))]
            if ((sn1 < ngb.sn1) and (sn1 < 6.6)) [set sn1 (sn1 + (0.05 * sn1))]
            if ((pbcI1 < 6.6) and (pbcI1 < ngb.pbcI1)) [set pbcI1 (pbcI1 + (pbcI1 * 0.05))]
        ]
      ]
      ]

      if Learning = "Informative-Soft"[]
      if Learning = "Promoting"[]

    ]
  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Updates

To update.income

  ask turtles[
    if case-study = "ES"[
      if scenario = "Ref.SSP2"[
        if (rn < 11.4 ) [
          set income (income * (item 0 item n cge-es-ssp2-h))]
        if (rn >= 11.4) and (rn <= 58.2) [
          set income (income * (item 0 item n cge-es-ssp2-h))]
        if (rn > 58.2) and (rn <= 86) [
          set income (income * (item 0 item n cge-es-ssp2-h))]
        if (rn > 86) and (rn <= 94.7) [
          set income (income * (item 0 item n cge-es-ssp2-h))]
        if (rn > 94.7) and (rn <= 97.8) [
          set income (income * (item 0 item n cge-es-ssp2-h))]
        if (rn >  97.8) and (rn <= 98.7) [
          set income (income * (item 0 item n cge-es-ssp2-h))]
        if (rn > 98.7) and (rn <= 100) [
          set income (income * (item 0 item n cge-es-ssp2-h))]
    ]]

    if case-study = "NL"[
      if scenario = "Ref.SSP2"[
        if (rn < 5.5 ) [
          set income (income * (item 0 item n cge-nl-ssp2-h))]
        if (rn >= 5.5) and (rn <= 40.19) [
          set income (income * (item 0 item n cge-nl-ssp2-h))]
        if (rn > 40.19) and (rn <= 78.17) [
          set income (income * (item 0 item n cge-nl-ssp2-h))]
        if (rn > 78.17) and (rn <= 91.69) [
          set income (income * (item 0 item n cge-nl-ssp2-h))]
        if (rn > 91.69) and (rn <= 97.39) [
          set income (income * (item 0 item n cge-nl-ssp2-h))]
        if (rn >  97.39) and (rn <= 98.36) [
          set income (income * (item 0 item n cge-nl-ssp2-h))]
        if (rn > 98.36) and (rn <= 100) [
          set income (income * (item 0 item n cge-nl-ssp2-h))]
    ]]
  ]
end


To update.energy

  if year >= 2017 [
    ask turtles [
    if (act1 = True and dw.elab >= 2) [set dw.elab (dw.elab - 1)]
    if (act1 = True and dw.elab = 1) [set h.sta "Efficient"]
  ]]

end

;update memory and actions

To update.memory

  ask turtles[
    if invest1 = True [set act1.year (act1.year + 1)]
    if (act1.year >= 15 AND dw.age = 1)
    [set invest1 False set act1.year 0]

    if (act1.year >= 7 AND dw.age = 2)
    [set invest1 False set act1.year 0]

    if (act1.year >= 2 AND dw.age >= 3)
    [set invest1 False set act1.year 0]
  ]

end

;update dwelling age based on MESSAGE input

To update.dwelling
  ask turtles[
    if case-study = "NL"[
      if (year >= 2025 AND year < 2030 )[
        set dag random-float 100
        if (dag < 51) [set dw.age 1  set dw.age 1]
        if (dag >= 51) and (dag < 83) [set dw.age 2]
        if (dag >= 83) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2030 AND year < 2035 )[
        set dag random-float 100
        if (dag < 51) [set dw.age 1 set dw.age 1]
        if (dag >= 51) and (dag < 83) [set dw.age 2]
        if (dag >= 83) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2035 AND year < 2040 )[
        set dag random-float 100
        if (dag < 53) [set dw.age 1 set dw.age 1]
        if (dag >= 53) and (dag < 83) [set dw.age 2]
        if (dag >= 83) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2040 AND year < 2045 )[
        set dag random-float 100
        if (dag < 55) [set dw.age 1 set dw.age 1]
        if (dag >= 55) and (dag < 84) [set dw.age 2]
        if (dag >= 84) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2040 AND year < 2045 )[
        set dag random-float 100
        if (dag < 57) [set dw.age 1 set dw.age 1]
        if (dag >= 57) and (dag < 84) [set dw.age 2]
        if (dag >= 84) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2045 AND year < 2050 )[
        set dag random-float 100
        if (dag < 59) [set dw.age 1 set dw.age 1]
        if (dag >= 59) and (dag < 84) [set dw.age 2]
        if (dag >= 84) and (dag <= 100) [set dw.age 3]
      ]
    ]

    if case-study = "ES"[
      if (year >= 2025 AND year < 2030 )[
        set dag random-float 100
        if (dag < 49) [set dw.age 1  set dw.age 1]
        if (dag >= 49) and (dag < 80) [set dw.age 2]
        if (dag >= 80) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2030 AND year < 2035 )[
        set dag random-float 100
        if (dag < 49) [set dw.age 1 set dw.age 1]
        if (dag >= 49) and (dag < 84) [set dw.age 2]
        if (dag >= 84) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2035 AND year < 2040 )[
        set dag random-float 100
        if (dag < 49) [set dw.age 1 set dw.age 1]
        if (dag >= 49) and (dag < 84) [set dw.age 2]
        if (dag >= 84) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2040 AND year < 2045 )[
        set dag random-float 100
        if (dag < 49) [set dw.age 1 set dw.age 1]
        if (dag >= 49) and (dag < 84) [set dw.age 2]
        if (dag >= 84) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2040 AND year < 2045 )[
        set dag random-float 100
        if (dag < 53) [set dw.age 1 set dw.age 1]
        if (dag >= 53) and (dag < 83) [set dw.age 2]
        if (dag >= 83) and (dag <= 100) [set dw.age 3]
      ]

      if (year >= 2045 AND year < 2050 )[
        set dag random-float 100
        if (dag < 57) [set dw.age 1 set dw.age 1]
        if (dag >= 57) and (dag < 84) [set dw.age 2]
        if (dag >= 84) and (dag <= 100) [set dw.age 3]
      ]
    ]
  ]
end

To update.info

  ask turtles[
    set act1 False
  ]
end



; ########################################################################################
; ################################ Visulization adn Outputs ##############################
; ########################################################################################
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Debuging

To debug

  ask turtles[
    file-open "debug.csv"
    file-print (word year "," h.id "," h.group "," h.sta "," invest1 "," invest2 "," ene.prov "," income "," gen "," edu "," ecom "," age "," dw.st "," dw.elab "," dw.type "," dw.age "," dw.size "," elec "," gas "," ene.pat1 "," ene.pat2 "," ene.pat3 ","
                     know "," cee.aw "," ed.aw "," guilt "," aware "," pn1 "," pn2 "," pn3 "," sn1 "," sn2 "," sn3 "," m1.st "," m2.st "," m3.st ","
                     pbcI1 "," pbcI2 "," pbcI3 "," pbcC1 "," pbcC2 "," pbcC3 "," pbcS1 "," pbcS2 "," pbcS3 "," cI1.st "," cI2.st "," cI3.st "," cC1.st "," cC2.st "," cC3.st "," cS1.st "," cS2.st "," cS3.st ","
                     U1 "," act1 "," U2 "," act2 "," U3 "," act3 "," U4 "," act4 "," U5 "," act5 "," U6 "," act6 "," U7 "," act7 "," U8 "," act8 "," U9 "," act9)
  ]
end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; plots

To plot.awareness
  set-current-plot "Awareness"
  set-current-plot-pen "Low"             plot count turtles with [aware < 4]
  set-current-plot-pen "Medium"          plot count turtles with [aware >= 4 and aware < 5]
  set-current-plot-pen "High"            plot count turtles with [aware >= 5 and aware <= 7]
end

To plot.motivation
  set-current-plot "Motivation"
  set-current-plot-pen "PN1"    plot pn1.total
  set-current-plot-pen "PN2"    plot pn2.total
  set-current-plot-pen "PN3"    plot pn3.total
  set-current-plot-pen "SN1"    plot sn1.total
  set-current-plot-pen "SN2"    plot sn2.total
  set-current-plot-pen "SN3"    plot sn3.total
end

To plot.behaviors
  if year >= 2017[
    set-current-plot "Households behavioral change"
    set-current-plot-pen "Investment"    plot a1.com + a2.com + a3.com
    set-current-plot-pen "Conservation"  plot a4.com + a5.com + a6.com
    set-current-plot-pen "Switching"     plot a7.com + a8.com + a9.com]
end

To plot.investment
  if year >= 2017[
    set-current-plot "Investment"
    set-current-plot-pen "I1"           plot a1
    set-current-plot-pen "I2"           plot a2
    set-current-plot-pen "I3"           plot a3]
end

To plot.conservation
  if year >= 2017[
    set-current-plot "Conservation"
    set-current-plot-pen "C1"           plot a4
    set-current-plot-pen "C2"           plot a5
    set-current-plot-pen "C3"           plot a6]
end

To plot.switching
  if year >= 2017[
    set-current-plot "Switching"
    set-current-plot-pen "S1"           plot a7
    set-current-plot-pen "S2"           plot a8
    set-current-plot-pen "S3"           plot a9]
end

To plot.saveenergy
  set-current-plot "Save energy"
  set-current-plot-pen "Electricity"    plot save.elec.com
  set-current-plot-pen "Gas"            plot save.gas.com
end



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; reporter

to-report randomNumber [lower.value upper.value step.value]                                              ;; Calculate an integer random number between the upper and the lower values, incuding those values
  report lower.value + step.value * random (1 + floor ((upper.value - lower.value) / step.value ))
end










; ########################################################################################
; ##################################### MY NOTES #########################################
; ########################################################################################

; 2021.10.17
; number of households? how to increase over time?  >> number.households
; get input from STURM on age --> check: not double counting energy lables



; 2018.06.26:
; setup:
; pn1,2,3 and sn1,2,3 are the same
; pbcI1,I2,I3 are the same ....
; ene.pat1,2,3 are the same
; gender: 1=female, 2=male
; edu: 1-6 (L-H)
; ecom: 1-3 (L-H)
; dw.elab: 1-6 (A-F)
; dw.type: A(1,2), H(3,4,5)
; dw.size: S(1,2), M(3), B(4,5) --> 1-3
; dw.age: N(1,2),M(3,4),O(5,6)  --> 1-3


; 2018.07.16
; Min Gas consumption  9.2
; Min Elec consumption 1000
; dw.age 1-3 ==> 1,3,5 (to provide middle classes)
@#$#@#$#@
GRAPHICS-WINDOW
348
10
710
373
-1
-1
3.98
1
10
1
1
1
0
1
1
1
-44
44
-44
44
0
0
1
ticks
30.0

BUTTON
131
10
229
102
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
239
10
338
102
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
162
129
315
174
Data
Data
"Homogeneous" "Empirical-survey"
1

SWITCH
157
317
280
350
debugfiles
debugfiles
1
1
-1000

CHOOSER
6
130
157
175
case-study
case-study
"ES" "NL"
0

SWITCH
4
10
127
43
Generate-seed?
Generate-seed?
0
1
-1000

INPUTBOX
4
42
127
102
Seed-for-random
-4.21381123E8
1
0
Number

SWITCH
8
350
135
383
Switching
Switching
1
1
-1000

SWITCH
8
314
135
347
Conservation
Conservation
1
1
-1000

SWITCH
8
277
136
310
Investment
Investment
0
1
-1000

TEXTBOX
7
252
220
279
******* Behaviors *******
14
0.0
1

TEXTBOX
6
109
235
143
******* Data *******
14
0.0
1

MONITOR
1348
96
1456
141
Population
count turtles
17
1
11

PLOT
1001
161
1279
307
Motivation
Year
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"PN1" 1.0 0 -16777216 true "" ""
"PN2" 1.0 0 -7500403 true "" ""
"PN3" 1.0 0 -2674135 true "" ""
"SN1" 1.0 0 -955883 true "" ""
"SN2" 1.0 0 -6459832 true "" ""
"SN3" 1.0 0 -1184463 true "" ""

MONITOR
1347
44
1410
89
Year
year
17
1
11

MONITOR
1350
198
1418
243
Action I1
count turtles with [act1 = True]
17
1
11

PLOT
716
11
998
158
Investment
Year
Population
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"I1" 1.0 0 -16777216 true "" ""
"I2" 1.0 0 -7500403 true "" ""
"I3" 1.0 0 -2674135 true "" ""

MONITOR
1354
353
1469
398
Passive
noaction
17
1
11

PLOT
1001
11
1279
157
Awareness
Year
Population
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Low" 1.0 0 -16777216 true "" ""
"Medium" 1.0 0 -7500403 true "" ""
"High" 1.0 0 -2674135 true "" ""

SWITCH
11
416
114
449
NAT
NAT
1
1
-1000

SWITCH
121
416
224
449
TPB
TPB
1
1
-1000

TEXTBOX
6
389
250
413
****** Psychology Theories *******
14
0.0
1

MONITOR
1423
147
1491
192
Brown user
brownuser
17
1
11

MONITOR
1349
147
1418
192
Grey user
greyuser
17
1
11

CHOOSER
8
198
158
243
Scenario
Scenario
"Ref.SSP2"
0

TEXTBOX
7
180
243
214
******* Scenario ********
14
0.0
1

SWITCH
159
277
280
310
Memory
Memory
0
1
-1000

PLOT
348
379
711
523
Households behavioral change
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Investment" 1.0 0 -16777216 true "" ""
"Conservation" 1.0 0 -7500403 true "" ""
"Switching" 1.0 0 -2674135 true "" ""

CHOOSER
162
198
316
243
Learning
Learning
"Slow dynamics" "Fast dynamics" "Informative" "Informative-Soft" "Promoting" "No learning"
2

MONITOR
1496
147
1565
192
Green user
greenuser
17
1
11

SWITCH
11
457
114
490
COM
COM
0
1
-1000

TEXTBOX
1345
10
1530
43
******* Monitors *******
14
0.0
1

MONITOR
1424
198
1492
243
Action I2
count turtles with [act2 = True]
17
1
11

MONITOR
1497
197
1567
242
Action I3
count turtles with [act3 = True]
17
1
11

PLOT
716
161
998
308
Conservation
Year
Population
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"C1" 1.0 0 -16777216 true "" ""
"C2" 1.0 0 -7500403 true "" ""
"C3" 1.0 0 -2674135 true "" ""

PLOT
716
311
998
459
Switching
Year
Population
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"S1" 1.0 0 -16777216 true "" ""
"S2" 1.0 0 -7500403 true "" ""
"S3" 1.0 0 -2674135 true "" ""

MONITOR
1352
250
1421
295
Action C1
count turtles with [act4 = True]
17
1
11

MONITOR
1425
250
1495
295
Action C2
count turtles with [act5 = True]
17
1
11

MONITOR
1500
249
1570
294
Action C3
count turtles with [act6 = true]
17
1
11

MONITOR
1353
303
1422
348
Action S1
count turtles with [act7 = true]
17
1
11

MONITOR
1354
402
1469
447
Insulation proccess
count turtles with [invest1 = True]
17
1
11

MONITOR
1355
452
1470
497
Installation proccess
count turtles with [invest2 = True]
17
1
11

MONITOR
1426
303
1497
348
Action S2
count turtles with [act8 = true]
17
1
11

MONITOR
1502
303
1571
348
Action S3
count turtles with [act9 = True]
17
1
11

INPUTBOX
124
529
231
589
I2.cost
4000.0
1
0
Number

INPUTBOX
12
529
119
589
I1.cost
3000.0
1
0
Number

INPUTBOX
235
530
343
590
I3.cost
300.0
1
0
Number

TEXTBOX
18
508
168
526
****** Costs ******
14
0.0
1

PLOT
1001
310
1280
459
Save energy
Year
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Electricity" 1.0 0 -16777216 true "" ""
"Gas" 1.0 0 -2674135 true "" ""

@#$#@#$#@
## WHAT IS IT?
BENCH model


## HOW IT WORKS



## HOW TO USE IT



## THINGS TO NOTICE



## THINGS TO TRY



## EXTENDING THE MODEL



## NETLOGO FEATURES



## RELATED MODELS



## CREDITS AND REFERENCES

Dr. Leila Niamir 

Research Scholar,
International Institute of Applied Systems Analysis (IIASA)
Schlossplatz 1, A-2361 Laxenburg, Austria
T: +43 2236 807 257

Email:leila.niamir[at]gmail.com
niamir[at]iiasa.ac.at
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="20230127-NL-SD" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;NL&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-NL-FD" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;NL&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Fast dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-ES-SD-S" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-ES-FD" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Fast dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-ES-ID-S" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Informative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-ES-SD" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-ES-FD-S" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Fast dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-ES-ID" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Informative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="3000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-NL-ID" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;NL&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Informative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230127-NL-ID-S" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;NL&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Informative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="4000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230130-ES-SD" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="3000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230130-ES-ID" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Informative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="3000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230130-NL-ID" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;NL&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Informative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="3000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230130-NL-SD" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;NL&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="3000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230130-NL-SD-S" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;NL&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow dynamics&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="3000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="20230130-ES-ID-S" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2050 [
 go]
[setup
 go]</go>
    <timeLimit steps="34"/>
    <metric>year</metric>
    <metric>a1</metric>
    <metric>number.group1</metric>
    <metric>number.group2</metric>
    <metric>number.group3</metric>
    <metric>number.group4</metric>
    <metric>number.group5</metric>
    <metric>group1.a1</metric>
    <metric>group2.a1</metric>
    <metric>group3.a1</metric>
    <metric>group4.a1</metric>
    <metric>group5.a1</metric>
    <metric>number.dwage1</metric>
    <metric>number.dwage2</metric>
    <metric>number.dwage3</metric>
    <metric>dwage1.a1</metric>
    <metric>dwage2.a1</metric>
    <metric>dwage3.a1</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="case-study">
      <value value="&quot;ES&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref.SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debugfiles">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NAT">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="COM">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Informative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="I1.cost">
      <value value="3000"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
