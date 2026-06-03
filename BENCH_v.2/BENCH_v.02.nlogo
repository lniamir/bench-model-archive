;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                       ;
;;;                       BENCH Model                                 ;;;
;;;                       Version: 02                                 ;;;
;;;;;;                                                              ;;;;;
;;;          Author: Leila Niamir <leila.niamir@gmail.com>            ;;;
;;;         University of Twnete, Enschede, The Netherlands           ;;;
;;;                    IIASA, Laxenburg, Austria                      ;;;
;;;;;                                                              ;;;;;;
;;;                   Last update: 12 April 2018                      ;;;
;                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




; #####################################################################################
; ####################### variables and extensions ####################################
; #####################################################################################

extensions [gis csv]      ;; use GIS and csv extensions

;; breads
breed [households household]

;; social Networks breeds
directed-link-breed [active-links active-link]
directed-link-breed [inactive-links inactive-link]

globals [
  test1
  test2
  n_suppliers            ;; number of suppliers
  n_households           ;; number of households
  h_totalslce            ;; total super green consumption of housholds
  h_totallce             ;; total green consumption of housholds
  h_totalff              ;; total grey consumption of households
  h_lceshare             ;; Share of LCE consumption
  non_cons               ;; non residential electricity consumption

  s_lce_share            ;; lce share of production
  s_ff_share             ;; ff share of production

  e_lce_max
  e_ff_max
  z_lce_max
  z_lce1_max
  z_lce2_max
  z_lce3_max
  z_zero_max
  z_ff_max
  z_ff1_max
  z_ff2_max
  z_ff3_max
  z_zero1_max
  z_zero2_max


  delta1_max
  delta2_max
  delta3_max

  m_p_lce                ;; market price of green electricity
  m_p_ff                 ;; market price of grey electricity
  m_p_zero
  p_star_ff              ;; price of ff after market clearing
  p_star_lce             ;; price of lce after market clearing
  p_star_zero
  o_m_p_ff               ;; old market price
  o_m_p_lce
  o_m_p_zero
  p_lce_p                ;; lce growth precentage
  p_ff_p                 ;; ff growth precentage
  cpg_lce                ;; coefficient price growth of lce
  cpg_ff                 ;; coefficient price growth of ff


  a                      ;; for for market clearing function
  b                      ;; for for market clearing function
  green_q                ;; global varibale green production
  grey_q                 ;; global varibale grey production
  q                      ;; global varibale total suppliers production
  counttrade             ;; count trades >> annually
  u_ff                   ;; utility after market clearing
  u_lce
  district               ;; for GIS extention
  cities                 ;; for GIS extention

  rr                     ;; for intervals function
  sol                    ;; for intervals function
  fl                     ;; for intervals function of flag
  ow                     ;; for interals function of dw_st
  en                     ;; for interals function of dw_el
  freq
  edu

  in-cge-spn             ;; inputs form CGE Spain

  rat_1_ff               ;; ratio1ff
  rat_2_ff
  rat_1_lce              ;; ratio1lce
  rat_2_lce

  year
  noaction
  income_total           ;; total household's income
  saving_total           ;; total household's saving
  consumption_total      ;; total household's consumption
  aware_total            ;; total household's awareness
  action_total           ;; number of actions each year

  action_cum             ;; cumulative actions
  action_cum_p           ;; cumulative actions percentage

  action_1               ;; number of action1 each year
  action_2               ;; number of action2 each year
  action_31              ;; number of action31 each year
  action_32              ;; number of action32 each year

  act1_inc1              ;; number of action1 each year based on their income groups
  act1_inc2
  act1_inc3
  act1_inc4
  act1_inc5
  act1_inc6
  act1_inc7

  act2_inc1              ;; number of action2 each year based on their income groups
  act2_inc2
  act2_inc3
  act2_inc4
  act2_inc5
  act2_inc6
  act2_inc7

  act3_inc1              ;; number of action3 each year based on their income groups
  act3_inc2
  act3_inc3
  act3_inc4
  act3_inc5
  act3_inc6
  act3_inc7

  act1_a                 ;; number of action1 each year based on their dwelling energy lable
  act1_b
  act1_c
  act1_d
  act1_e
  act1_f

  act2_a                 ;; number of action2 each year based on their dwelling energy lable
  act2_b
  act2_c
  act2_d
  act2_e
  act2_f

  act3_a                 ;; number of action3 each year based on their dwelling energy lable
  act3_b
  act3_c
  act3_d
  act3_e
  act3_f

  action_1_cum           ;; cum actuion 1
  action_2_cum
  action_31_cum
  action_32_cum

  action1_cum_p          ;; cum action 1 percentage
  action2_cum_p
  action31_cum_p
  action32_cum_p

  action1_p              ;; actions percentage
  action2_p
  action31_p
  action32_p
  action3_p
  actiont_p

  act1_share             ;; share of Investment each year
  act2_share             ;; share of Conservation each year
  act31_share            ;; share of Switching 1 each year
  act32_share            ;; share of Switching 2 each year
  act3_share

  em_sav                 ;; avoid emission (kg)
  em_sav_cum             ;; cumulative avoid emission
  energy_sav             ;; Kw/h energy saved by investment
  energy_sav_cum

  energy_sav_1_ff        ;; electiricty saved based on source of energy and HH actions
  energy_sav_2_ff
  energy_sav_3_ff
  energy_sav_1_lce
  energy_sav_2_lce
  energy_sav_3_lce

  energy_sav_1_ff_inc1   ;; income groups
  energy_sav_2_ff_inc1
  energy_sav_3_ff_inc1
  energy_sav_1_lce_inc1
  energy_sav_2_lce_inc1
  energy_sav_3_lce_inc1

  energy_sav_1_ff_inc2
  energy_sav_2_ff_inc2
  energy_sav_3_ff_inc2
  energy_sav_1_lce_inc2
  energy_sav_2_lce_inc2
  energy_sav_3_lce_inc2

  energy_sav_1_ff_inc3
  energy_sav_2_ff_inc3
  energy_sav_3_ff_inc3
  energy_sav_1_lce_inc3
  energy_sav_2_lce_inc3
  energy_sav_3_lce_inc3

  energy_sav_1_ff_inc4
  energy_sav_2_ff_inc4
  energy_sav_3_ff_inc4
  energy_sav_1_lce_inc4
  energy_sav_2_lce_inc4
  energy_sav_3_lce_inc4

  energy_sav_1_ff_inc5
  energy_sav_2_ff_inc5
  energy_sav_3_ff_inc5
  energy_sav_1_lce_inc5
  energy_sav_2_lce_inc5
  energy_sav_3_lce_inc5

  co2_1_ff               ;; avoid CO2 emission based on source of energy and HH actions
  co2_2_ff
  co2_3_ff
  co2_1_lce
  co2_2_lce
  co2_3_lce

  co2_1_ff_inc1          ;; income groups
  co2_2_ff_inc1
  co2_3_ff_inc1
  co2_1_lce_inc1
  co2_2_lce_inc1
  co2_3_lce_inc1

  co2_1_ff_inc2
  co2_2_ff_inc2
  co2_3_ff_inc2
  co2_1_lce_inc2
  co2_2_lce_inc2
  co2_3_lce_inc2

  co2_1_ff_inc3
  co2_2_ff_inc3
  co2_3_ff_inc3
  co2_1_lce_inc3
  co2_2_lce_inc3
  co2_3_lce_inc3

  co2_1_ff_inc4
  co2_2_ff_inc4
  co2_3_ff_inc4
  co2_1_lce_inc4
  co2_2_lce_inc4
  co2_3_lce_inc4

  co2_1_ff_inc5
  co2_2_ff_inc5
  co2_3_ff_inc5
  co2_1_lce_inc5
  co2_2_lce_inc5
  co2_3_lce_inc5

  co2_1_ff_cum           ;; avoid CO2 emission based on source of energy and HH actions
  co2_2_ff_cum
  co2_3_ff_cum
  co2_1_lce_cum
  co2_2_lce_cum
  co2_3_lce_cum

  co2_1_ff_cum_inc1      ;; income groups
  co2_2_ff_cum_inc1
  co2_3_ff_cum_inc1
  co2_1_lce_cum_inc1
  co2_2_lce_cum_inc1
  co2_3_lce_cum_inc1

  co2_1_ff_cum_inc2
  co2_2_ff_cum_inc2
  co2_3_ff_cum_inc2
  co2_1_lce_cum_inc2
  co2_2_lce_cum_inc2
  co2_3_lce_cum_inc2

  co2_1_ff_cum_inc3
  co2_2_ff_cum_inc3
  co2_3_ff_cum_inc3
  co2_1_lce_cum_inc3
  co2_2_lce_cum_inc3
  co2_3_lce_cum_inc3

  co2_1_ff_cum_inc4
  co2_2_ff_cum_inc4
  co2_3_ff_cum_inc4
  co2_1_lce_cum_inc4
  co2_2_lce_cum_inc4
  co2_3_lce_cum_inc4

  co2_1_ff_cum_inc5
  co2_2_ff_cum_inc5
  co2_3_ff_cum_inc5
  co2_1_lce_cum_inc5
  co2_2_lce_cum_inc5
  co2_3_lce_cum_inc5

  co2_av                 ;; total aviod CO2 emission
  co2_av_cum             ;; cum of above

  co2_av_inc1            ;; income groups
  co2_av_inc2
  co2_av_inc3
  co2_av_inc4
  co2_av_inc5

  co2_av_cum_inc1        ;; income groups
  co2_av_cum_inc2
  co2_av_cum_inc3
  co2_av_cum_inc4
  co2_av_cum_inc5


  co2_total              ;; households produce co2
  co2_percapita          ;; co2 percapita

  co2_total_inc1
  co2_total_inc2
  co2_total_inc3
  co2_total_inc4
  co2_total_inc5
  co2_total_inc6
  co2_total_inc7

  co2_percapita_inc1
  co2_percapita_inc2
  co2_percapita_inc3
  co2_percapita_inc4
  co2_percapita_inc5
  co2_percapita_inc6
  co2_percapita_inc7

  energy_sav_inc1        ;; electircity saved in each income groups based on their actions (1 and 2)
  energy_sav_inc2
  energy_sav_inc3
  energy_sav_inc4
  energy_sav_inc5
  energy_sav_inc6
  energy_sav_inc7
  energy_sav_income      ;; total

  energy_sav_inc1_cum    ;; cum of top
  energy_sav_inc2_cum
  energy_sav_inc3_cum
  energy_sav_inc4_cum
  energy_sav_inc5_cum
  energy_sav_inc6_cum
  energy_sav_inc7_cum

  energy_sav_a          ;; electircity saved based on HH actions (1 and 2) who is hete in dwelling energy lable
  energy_sav_b
  energy_sav_c
  energy_sav_d
  energy_sav_e
  energy_sav_f
  energy_sav_lable     ;; total

  energy_sav_a_cum     ;; cum of top
  energy_sav_b_cum
  energy_sav_c_cum
  energy_sav_d_cum
  energy_sav_e_cum
  energy_sav_f_cum

  invest                 ;; Invest True or False
  invest_cum             ;; cum HH investments
  invest_y               ;; how many?
  invest_total

  conserv_cum            ;; cum HH conservation in Kwh per year
  conserv_y              ;; how many?
  conserv_e              ;; how muuch e?
  conserv_total          ;; total money

  conserv_e_1            ;; how much energy saved based on action 2 in each income groups
  conserv_e_2
  conserv_e_3
  conserv_e_4
  conserv_e_5
  conserv_e_6
  conserv_e_7

  conserv_e_a           ;; how much energy saved based on action 2 in each dwelling energy lable
  conserv_e_b
  conserv_e_c
  conserv_e_d
  conserv_e_e
  conserv_e_f

  switch_cum             ;; cum HH switching
  switch_y               ;; how many?
  switch_total           ;; per year how much money save or not based on switching
  h_em_total             ;; per year how much emission produce based on switching

  utility_exp_lce        ;; total lce utility expectation
  utility_exp_ff
  utility_lce            ;; total real lce utilty
  utility_ff
  ff
  lce

  slceuser
  lceuser               ;; total lce users
  ffuser                ;; number of ff user

  lceuser_share         ;; share of LCE user

  n                     ;; for updating
  cge-spn-ssp2-con      ;; list of cge inputs  >> SPN
  cge-spn-ssp2-h
  cge-spn-ssp2-s
  cge-spn-ssp2-lce
  cge-spn-ssp2-non
  gcam-ssp2-cost        ;; gcam inputs
  cge-spn-ssp2-alpha

  cge-nl-ssp2-con       ;; list of cge inputs  >> NL
  cge-nl-ssp2-h
  cge-nl-ssp2-s
  cge-nl-ssp2-lce
  cge-nl-ssp2-non
  cge-nl-ssp2-alpha

  cge-spn-llm-con       ;; list of cge inputs
  cge-spn-llm-h
  cge-spn-llm-s
  cge-spn-llm-lce
  cge-spn-llm-non
  gcam-spn-llm-cost     ;; gcam inputs
  cge-spn-llm-alpha

  primes-nl-ref-prices  ;; list of primes inputs
  primes-nl-ref-noncon
  primes-nl-ref-con
  primes-nl-ref-s

  primes-spn-ref-prices

  ngb_edu               ;; social network
  ngb_k
  ngb_k_mean
  ngb_ca
  ngb_ca_mean
  ngb_ed
  ngb_ea_mean
  ngb_p
  ngb_s
  ngb_pb1
  ngb_pb2
  ngb_pb3

  reco

  know_av                 ;; for elasticities
  ceeaw_av
  edaw_av
  k_prim

  per_av
  su_av
  m_prim

  pbc1_av
  pbc2_av
  pbc3_av
  c_prim

  h_totalff_inc1         ;; electricity consumption per income groups and the source of electrity
  h_totalff_inc2
  h_totalff_inc3
  h_totalff_inc4
  h_totalff_inc5
  h_totalff_inc6
  h_totalff_inc7

  h_totallce_inc1
  h_totallce_inc2
  h_totallce_inc3
  h_totallce_inc4
  h_totallce_inc5
  h_totallce_inc6
  h_totallce_inc7
 ]

households-own[
  h_id                  ;; ID >> Who
  h_income              ;; average income of family
  h_edu
  h_id_group            ;; id of income group
  h_q                   ;; energy consumption (electricity)
  h_gas                 ;; energy consumption (gas)

  h_invest              ;; invesments per year
  h_invest_save         ;; amount of elec For Z calculation
  h_invest_total        ;; invesments till that year
  counter               ;; counting years for paying back

  h_conserv             ;; conservation per year
  h_conserv_p

  h_switch              ;; how much money save or not through switching
  h_em                  ;; how much CO2 produce based on HH consumption

  alpha                 ;; share of electiricity consuption
  flag?                 ;; Assign the lce or ff user:  lce >> 1 / ff >> 0 / zero >> 2
  z_lce                 ;; rest of goods
  z_lce1
  z_lce2
  z_lce3
  z_ff
  z_ff1
  z_ff2
  z_ff3
  z_zero
  z_zero1
  z_zero2
  z_lce_norm            ;; normilized z
  z_lce1_norm
  z_lce2_norm
  z_lce3_norm
  z_ff_norm
  z_ff1_norm
  z_ff2_norm
  z_ff3_norm
  z_zero_norm
  z_zero1_norm
  z_zero2_norm
  e_lce
  e_ff
  e_lce_norm
  e_ff_norm

  delta1_norm
  delta2_norm
  delta3_norm

  utility_lce1          ;; real utility based on lce price and first action
  utility_lce2
  utility_lce31
  utility_lce32
  utility_zero1
  utility_zero2
  utility_zero3
  utility_ff1           ;; real utility based on ff price
  utility_ff2
  utility_ff32

  know                  ;; awareness >> Knowledge
  cee_aw                ;; awareness >> CEE
  ed_aw                 ;; awareness >> ED
  h_aware               ;; knowledge activation
  K                     ;; knowledge level
  guilt                 ;; Low or High

  h_motiv1              ;; motivation
  h_motiv2
  h_motiv3
  responsibility        ;; ON or OFF
  M1                    ;; Motivation level
  M2
  M3
  per_nab1              ;; personal norms, beliefs and attitudes
  per_nab2
  per_nab3
  su_nor1               ;; social and subjective norms
  su_nor2
  su_nor3
  level                 ;; level of motivation

  dw_st                 ;; consideration >> dwelling status  1= Own and 0= rent
  dw_el                 ;; consideration >> dwelling energy lable  1,2,3,4,5,6 >> A,B,C,D,E,F
  pbc1
  pbc2
  pbc3
  ep                    ;; energy patterns  1 <= ep <=3   >> 1 always >> 3 seldom
  cons1                 ;; Consideration level for first action
  cons2
  cons3
  delta1                ;; consideration power
  delta2
  delta3
  intention             ;; ON or OFF

  utility_exp_lce1      ;; utility expectation based on lce price
  utility_exp_lce2
  utility_exp_lce31
  utility_exp_lce32
  utility_exp_zero1
  utility_exp_zero2
  utility_exp_zero3
  utility_exp_ff1       ;; utility expectation based on ff price
  utility_exp_ff2
  utility_exp_ff32
  hh_sta
  aware
  motiv
  cons

  act1
  act11
  act12
  act50
  act21
  act40
  act3
  act31
  act32

  act11_year
  act12_year
  act21_year
  act40_year
  act31_year
  act32_year

  h_conserv_1
  h_conserv_2
  h_conserv_3
  h_conserv_4
  h_conserv_5
  h_conserv_6
  h_conserv_7

  h_conserv_a
  h_conserv_b
  h_conserv_c
  h_conserv_d
  h_conserv_e
  h_conserv_f

  sav_1_ff            ;; saved energy based on the source and actios
  sav_2_ff
  sav_3_ff
  sav_1_lce
  sav_2_lce
  sav_3_lce

  sav_1_ff_inc1       ;; income groups
  sav_2_ff_inc1
  sav_3_ff_inc1
  sav_1_lce_inc1
  sav_2_lce_inc1
  sav_3_lce_inc1

  sav_1_ff_inc2
  sav_2_ff_inc2
  sav_3_ff_inc2
  sav_1_lce_inc2
  sav_2_lce_inc2
  sav_3_lce_inc2

  sav_1_ff_inc3
  sav_2_ff_inc3
  sav_3_ff_inc3
  sav_1_lce_inc3
  sav_2_lce_inc3
  sav_3_lce_inc3

  sav_1_ff_inc4
  sav_2_ff_inc4
  sav_3_ff_inc4
  sav_1_lce_inc4
  sav_2_lce_inc4
  sav_3_lce_inc4

  sav_1_ff_inc5
  sav_2_ff_inc5
  sav_3_ff_inc5
  sav_1_lce_inc5
  sav_2_lce_inc5
  sav_3_lce_inc5

  old_act
  satisfied
  hh_actions            ;; list of household actions

  influence_know        ;; social network and learning
  influence_cee_aw
  influence_ed_aw

  influence_per
  influence_su]

patches-own [
  population]

links-own [
  current-flow]                   ;; the amount of quantity that has passed through a link in a given step



; #####################################################################################
; ################################ loading map ########################################
; #####################################################################################

to load-map

  if Case-study = "Spain-Navarre"[
    ca
    set district  gis:load-dataset "data/ESP_adm4.shp"
    gis:set-world-envelope gis:envelope-of district
    foreach gis:feature-list-of district [ ?1 ->
    gis:set-drawing-color white
    gis:draw ?1 1.0
    ]
  ]

  if Case-study = "Netherlands-Overijssel" [
        ca
    set district  gis:load-dataset "data/ESP_adm4.shp"
    gis:set-world-envelope gis:envelope-of district
    foreach gis:feature-list-of district [ ?1 ->
    gis:set-drawing-color white
    gis:draw ?1 1.0
    ]
  ]
end


to show-population

    set cities gis:load-dataset "data/ESP_pol.shp"
    gis:apply-coverage cities "POP" population
    ask patches[
       if (population > 0)[
         set pcolor black
         ]
    ]

end



; #####################################################################################
; ############################# loading data ##########################################
; #####################################################################################

to load-data

  if  Case-study = "Netherlands-Overijssel"[

; ##################### Baseline scenario (SSP2) #######################################

    if Scenario = "Ref_SSP2"[

    ifelse (file-exists? "data/cge-nl-ssp2-h.csv")[               ;; income growths
       file-open "data/cge-nl-ssp2-h.csv"
       set cge-nl-ssp2-h csv:from-file "data/cge-nl-ssp2-h.csv"
       file-close
      ]
      [ user-message "Sorry, there is no SSP2 scenario on residential income data/NL in the directory" ]

     ifelse (file-exists? "data/cge-nl-ssp2-con.csv")[            ;; consumption growths
       file-open "data/cge-nl-ssp2-con.csv"
       set cge-nl-ssp2-con csv:from-file "data/cge-nl-ssp2-con.csv"
       file-close
      ]
      [ user-message "Sorry, there is no SSP2 scenario on residential consumption/NL in the directory" ]

     ifelse (file-exists? "data/cge-nl-ssp2-alpha.csv")[                ;; alpha
       file-open "data/cge-nl-ssp2-alpha.csv"
       set cge-nl-ssp2-alpha csv:from-file "data/cge-nl-ssp2-alpha.csv"
       file-close
      ]
      [ user-message "Sorry, there is no SSP2 scenario on Alpha/NL in the directory" ]

     ifelse (file-exists? "data/primes-nl-ref-prices.csv")[        ;; electricity prices
       file-open "data/primes-nl-ref-prices.csv"
       set primes-nl-ref-prices csv:from-file "data/primes-nl-ref-prices.csv"
       file-close
      ]
      [ user-message "Sorry, there is no EU scenario on Electrictiy prices/NL in the directory" ]

    ]
  ]

end

; #####################################################################################
; ############################### setup ###############################################
; #####################################################################################

To setup

  clear-all
  clear-drawing
  ct
  file-close-all


  if generate-seed? [                  ;; For experiments record
    set Seed-for-random new-seed
  ]
  random-seed Seed-for-random

  create_files
  load-map
  show-population
  load-data
  set year 2015
  set counttrade 0 set n 0 set delta1_max 0 set delta2_max 0 set delta3_max 0
  set act1_inc1 0 set act1_inc2 0 set act1_inc3 0 set act1_inc4 0 set act1_inc5 0 set act1_inc6 0 set act1_inc7 0
  set act2_inc1 0 set act2_inc2 0 set act2_inc3 0 set act2_inc4 0 set act2_inc5 0 set act2_inc6 0 set act2_inc7 0
  set act3_inc1 0 set act3_inc2 0 set act3_inc3 0 set act3_inc4 0 set act3_inc5 0 set act3_inc6 0 set act3_inc7 0
  set act1_a 0 set act1_b 0 set act1_c 0 set act1_d 0 set act1_e 0 set act1_f 0
  set act2_a 0 set act2_b 0 set act2_c 0 set act2_d 0 set act2_e 0 set act2_f 0
  set act3_a 0 set act3_b 0 set act3_c 0 set act3_d 0 set act3_e 0 set act3_f 0
  set energy_sav_inc1 0 set energy_sav_inc2 0 set energy_sav_inc3 0 set energy_sav_inc4 0 set energy_sav_inc5 0 set energy_sav_inc6 0 set energy_sav_inc7 0
  set energy_sav_inc1_cum 0 set energy_sav_inc2_cum 0 set energy_sav_inc3_cum 0 set energy_sav_inc4_cum 0 set energy_sav_inc5_cum 0 set energy_sav_inc6_cum 0 set energy_sav_inc7_cum 0 set energy_sav_income 0
  set energy_sav_a 0 set energy_sav_b 0 set energy_sav_c 0 set energy_sav_d 0 set energy_sav_e 0 set energy_sav_f 0
  set energy_sav_a_cum 0 set energy_sav_b_cum 0 set energy_sav_c_cum 0 set energy_sav_d_cum 0 set energy_sav_e_cum 0 set energy_sav_f_cum 0 set energy_sav_lable 0
  set conserv_e_a 0 set conserv_e_b 0 set conserv_e_c 0 set conserv_e_d 0 set conserv_e_e 0 set conserv_e_f 0
  set energy_sav_1_ff 0 set energy_sav_2_ff 0 set energy_sav_3_ff 0 set energy_sav_1_lce 0 set energy_sav_2_lce 0 set energy_sav_3_lce 0
  set energy_sav_1_ff_inc1 0 set energy_sav_2_ff_inc1 0 set energy_sav_3_ff_inc1 0 set energy_sav_1_lce_inc1 0 set energy_sav_2_lce_inc1 0 set energy_sav_3_lce_inc1 0
  set energy_sav_1_ff_inc2 0 set energy_sav_2_ff_inc2 0 set energy_sav_3_ff_inc2 0 set energy_sav_1_lce_inc2 0 set energy_sav_2_lce_inc2 0 set energy_sav_3_lce_inc2 0
  set energy_sav_1_ff_inc3 0 set energy_sav_2_ff_inc3 0 set energy_sav_3_ff_inc3 0 set energy_sav_1_lce_inc3 0 set energy_sav_2_lce_inc3 0 set energy_sav_3_lce_inc3 0
  set energy_sav_1_ff_inc4 0 set energy_sav_2_ff_inc4 0 set energy_sav_3_ff_inc4 0 set energy_sav_1_lce_inc4 0 set energy_sav_2_lce_inc4 0 set energy_sav_3_lce_inc4 0
  set energy_sav_1_ff_inc5 0 set energy_sav_2_ff_inc5 0 set energy_sav_3_ff_inc5 0 set energy_sav_1_lce_inc5 0 set energy_sav_2_lce_inc5 0 set energy_sav_3_lce_inc5 0
  set co2_1_ff 0 set co2_2_ff 0 set co2_3_ff 0 set co2_1_lce 0 set co2_2_lce 0 set co2_3_lce 0
  set co2_1_ff_inc1 0 set co2_2_ff_inc1 0 set co2_3_ff_inc1 0 set co2_1_lce_inc1 0 set co2_2_lce_inc1 0 set co2_3_lce_inc1 0
  set co2_1_ff_inc2 0 set co2_2_ff_inc2 0 set co2_3_ff_inc2 0 set co2_1_lce_inc2 0 set co2_2_lce_inc2 0 set co2_3_lce_inc2 0
  set co2_1_ff_inc3 0 set co2_2_ff_inc3 0 set co2_3_ff_inc3 0 set co2_1_lce_inc3 0 set co2_2_lce_inc3 0 set co2_3_lce_inc3 0
  set co2_1_ff_inc4 0 set co2_2_ff_inc4 0 set co2_3_ff_inc4 0 set co2_1_lce_inc4 0 set co2_2_lce_inc4 0 set co2_3_lce_inc4 0
  set co2_1_ff_inc5 0 set co2_2_ff_inc5 0 set co2_3_ff_inc5 0 set co2_1_lce_inc5 0 set co2_2_lce_inc5 0 set co2_3_lce_inc5 0
  set co2_av 0 set co2_av_inc1 0 set co2_av_inc2 0 set co2_av_inc3 0 set co2_av_inc4 0 set co2_av_inc5 0 set co2_av_cum 0 set co2_av_cum_inc1 0 set co2_av_cum_inc2 0 set co2_av_cum_inc3 0 set co2_av_cum_inc4 0 set co2_av_cum_inc5 0
  set h_totallce 0 set h_totalslce 0 set h_totalff 0
  set h_totalff_inc1 0 set h_totalff_inc2 0 set h_totalff_inc3 0 set h_totalff_inc4 0 set h_totalff_inc5 0 set h_totalff_inc6 0 set h_totalff_inc7 0
  set h_totallce_inc1 0 set h_totallce_inc2 0 set h_totallce_inc3 0 set h_totallce_inc4 0 set h_totallce_inc5 0 set h_totallce_inc6 0 set h_totallce_inc7 0
  set co2_total 0 set co2_percapita 0 set co2_total_inc1 0 set co2_total_inc2 0 set co2_total_inc3 0 set co2_total_inc4 0 set co2_total_inc5 0 set co2_total_inc6 0 set co2_total_inc7 0
  set co2_percapita_inc1 0 set co2_percapita_inc2 0 set co2_percapita_inc3 0 set co2_percapita_inc4 0 set co2_percapita_inc5 0 set co2_percapita_inc6 0 set co2_percapita_inc7 0

; ###################################################################################################################
;                                          NETHERLANDS
; ###################################################################################################################

  if Case-study = "Netherlands-Overijssel"[
  set test1 0
  set test2 0
  set non_cons 5569666.712              ;; Non-residential electricity consumption in 2015 based on PRIMES model

  set s_lce_share  0.19                 ;; share of lce production based on Eurostat data >> 19.29%
  set s_ff_share (1 - s_lce_share)
  set cpg_lce 0 set cpg_ff 0
  set m_p_lce 0.15                     ;; Market price of lce electricity in 2015 >>  based on PRIMES
  set m_p_ff 0.15                      ;; Market price of ff electricity in 2015 >>  based on PRIMES
  set m_p_zero 0.15
  set p_star_lce 0 set p_star_ff 0
  set e_lce_max 0 set z_lce_max 0 set z_zero_max 0 set e_ff_max 0
  set action_1 0 set action_2 0 set action_31 0 set action_32 0
  set action_1_cum 0 set action_2_cum 0 set action_31_cum 0 set action_32_cum 0
  set action1_cum_p 0 set action2_cum_p 0 set action31_cum_p 0 set action32_cum_p 0 set action_cum 0 set em_sav 0 set em_sav_cum 0 set energy_sav 0 set energy_sav_cum 0
  set invest False set invest_cum 0 set invest_y 0 set invest_total 0 set conserv_cum 0 set conserv_y 0 set conserv_e 0 set conserv_total 0 set switch_cum 0 set switch_y 0 set switch_total 0 set h_em_total 0

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                SURVEY HOUSEHOLDS
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   if Data = "Homogeneous" [user-message "Sorry. Not available"]
   if Data ="Homogeneous A and M"[user-message "Sorry. Not available"]
   if Data ="Homogeneous M"[user-message "Sorry. Not available"]
   if Data = "Empirical-survey"[
    ask patches with [population = 1] [sprout-households 1 [set color blue set shape "person" set size 0.2]]
    ask patches with [population = 2] [sprout-households 1 [set color blue set shape "person" set size 0.2]]
    ask patches with [population = 3] [sprout-households 1 [set color blue set shape "person" set size 0.2]]
    ask patches with [population = 4] [sprout-households 1 [set color blue set shape "person" set size 0.2]]
    ask patches with [population = 5] [sprout-households 1 [set color blue set shape "person" set size 0.2]]
    ask patches with [population = 6] [sprout-households 0 [set color blue set shape "person" set size 0.2]]


    ask households[

      set alpha 0.043                        ;; share of electricity consumption of households and the rest of their energy consumption (alpha) >> based on TNO (Eurostat) data >> 2016
      set hh_actions [0 0 0 0 0 0]
      set h_invest 0
      set h_invest_save 0
      set counter 1
      set h_invest_total 0
      set h_conserv_p 0
      set h_switch 0
      set h_em 0

      set h_conserv_1 0
      set h_conserv_2 0
      set h_conserv_3 0
      set h_conserv_4 0
      set h_conserv_5 0
      set h_conserv_6 0
      set h_conserv_7 0

      set h_conserv_a 0
      set h_conserv_b 0
      set h_conserv_c 0
      set h_conserv_d 0
      set h_conserv_e 0
      set h_conserv_f 0

      set sav_1_ff 0
      set sav_2_ff 0
      set sav_3_ff 0
      set sav_1_lce 0
      set sav_2_lce 0
      set sav_3_lce 0

      set sav_1_ff_inc1 0
      set sav_2_ff_inc1 0
      set sav_3_ff_inc1 0
      set sav_1_lce_inc1 0
      set sav_2_lce_inc1 0
      set sav_3_lce_inc1 0

      set sav_1_ff_inc2 0
      set sav_2_ff_inc2 0
      set sav_3_ff_inc2 0
      set sav_1_lce_inc2 0
      set sav_2_lce_inc2 0
      set sav_3_lce_inc2 0

      set sav_1_ff_inc3 0
      set sav_2_ff_inc3 0
      set sav_3_ff_inc3 0
      set sav_1_lce_inc3 0
      set sav_2_lce_inc3 0
      set sav_3_lce_inc3 0

      set sav_1_ff_inc4 0
      set sav_2_ff_inc4 0
      set sav_3_ff_inc4 0
      set sav_1_lce_inc4 0
      set sav_2_lce_inc4 0
      set sav_3_lce_inc4 0

      set sav_1_ff_inc5 0
      set sav_2_ff_inc5 0
      set sav_3_ff_inc5 0
      set sav_1_lce_inc5 0
      set sav_2_lce_inc5 0
      set sav_3_lce_inc5 0

      set utility_exp_lce1 0                   ;; utility expectations
      set utility_exp_lce2 0
      set utility_exp_lce31 0
      set utility_exp_ff1 0
      set utility_exp_ff2 0
      set utility_exp_ff32 0
      set utility_exp_zero1 0
      set utility_exp_zero2 0
      set utility_exp_zero3 0

      set utility_lce1 0                       ;; real utilities
      set utility_lce2 0
      set utility_lce31 0
      set utility_ff1 0
      set utility_ff2 0
      set utility_ff32 0
      set utility_zero1 0
      set utility_zero2 0
      set utility_zero3 0

      set hh_sta ""

      set z_lce 0
      set z_ff 0
      set z_zero 0
      set e_lce 0
      set e_ff 0
      set z_lce_norm 0
      set z_ff_norm 0
      set z_zero_norm 0
      set e_lce_norm 0
      set e_lce_norm 0


      set h_q randomNumber 1000 5000 100

      set rr random-float 100                    ;; generate a random number between 0-100 to assign incomes

      if (rr < 5.5 ) [                           ;; 5.5% of of households have income less than 10,000    >>  Income group 1

        set h_id_group 1
        set h_income randomNumber 800 10000 10
        set h_q randomNumber 1117 5000 100
        set h_gas randomNumber 50 5000 10        ;; Between 50-5000 in this income group

        set know randomNumber 1 7 0.05           ;; and knowledge
        set cee_aw randomNumber 1.21 6.78 0.05   ;; and cee awareness
        set ed_aw randomNumber 1 7 0.05          ;; and ed awareness

        set per_nab1 randomNumber 1 6.5 0.05     ;; Personal norm
        set per_nab2 randomNumber 1 6.5 0.05
        set per_nab3 randomNumber 1 6.5 0.05
        set su_nor1  randomNumber 1 6.5 0.05     ;; Social norm
        set su_nor2  randomNumber 1 6.5 0.05
        set su_nor3  randomNumber 1 6.5 0.05

        set pbc1 randomNumber 1 7 0.05           ;; pbc1
        set pbc2 randomNumber 1 7 0.05           ;; pbc2
        set pbc3 randomNumber 1 7 0.05           ;; pbc3

        set alpha 0.0199

        set ep randomNumber 0.25 2.22 0.05       ;; energy patterns

        set ow random-float 100                  ;; generate a random number between 0-100 to assign owner/rental statuse
        if (ow < 49) [                           ;; 49% of households in this income group are owner
        set dw_st 1]
        if (ow >= 49) and (ow <= 100) [          ;; 51% of households in this income group
        set dw_st 0]

        set en random-float 100                  ;; generate a random number between 0-100 to assign Dwelling energy Lable
        if (en < 25) [                           ;; 25% of households in this income group    > A
        set dw_el 1]
        if (en >= 25) and (en < 34.4) [          ;; 9.4% of households in this income group  > B
        set dw_el 2]
        if (en >= 34.4) and (en < 40.6) [        ;; 6.2% of households in this income group  > C
        set dw_el 3]
        if (en >= 40.6) and (en < 43.7) [        ;; 3.1% of households in this income group  > D
        set dw_el 4]
        if (en >= 43.7) and (en <= 50) [         ;; 6.3% of households in this income group   > E
        set dw_el 5]
        if (en >= 50) and (en <= 100) [          ;; 50% of households in this income group > More than f
        set dw_el 7]


        set fl random-float 100                  ;; generate a random number between 0-100 to assign LCE user
        if (fl < 24.57) [                        ;; 24.57% of households in this income group use LCE
        set flag? 1]
        if (fl >= 24.57) and (fl <= 100) [
        set flag? 0]


        set edu random-float 100                 ;; generate a random number between 0-100 to assign education level
        if (edu < 57.9) [
        set h_edu 2]
        if (edu >= 57.9) and (edu < 82.5) [
        set h_edu 3]
        if (edu >= 82.5) and (edu < 89.5) [
        set h_edu 4]
        if (edu >= 89.5) and (edu < 100) [
        set h_edu 5]
      ]


      if (rr >= 5.5) and (rr <= 40.19) [         ;; 34.69% of of households have income 10,000 to 30,000   >>  Income group 2

        set h_id_group 2
        set h_income randomNumber 10000 30000 10
        set h_q randomNumber 800 5000 100
        set h_gas randomNumber 26 5000 10        ;; Between 26-5000 in this income group

        set know randomNumber 1 7 0.05           ;; and knowledge
        set cee_aw randomNumber 1 6.85 0.05      ;; and cee awareness
        set ed_aw randomNumber 1.33 7 0.05       ;; and ed awareness

        set per_nab1 randomNumber 2 7 0.05       ;; Personal norm
        set per_nab2 randomNumber 2 7 0.05
        set per_nab3 randomNumber 2 7 0.05
        set su_nor1  randomNumber 1 7 0.05       ;; Social norm
        set su_nor2  randomNumber 1 7 0.05
        set su_nor3  randomNumber 1 7 0.05

        set pbc1 randomNumber 1.4 7 0.05         ;; pbc1
        set pbc2 randomNumber 1 7 0.05           ;; pbc2
        set pbc3 randomNumber 1 7 0.05           ;; pbc3

        set alpha 0.0191

        set ep randomNumber 0.25 1.70 0.05       ;; energy patterns

        set ow random-float 100                  ;; generate a random number between 0-100 to assign owner/rental statuse
        if (ow < 52) [                           ;; 52% of households in this income group are owner
        set dw_st 1]
        if (ow >= 52) and (ow <= 100) [          ;; 48% of households in this income group
        set dw_st 0]

        set en random-float 100                  ;; generate a random number between 0-100 to assign Dwelling energy Lable
        if (en < 8.5) [                          ;; 8.5% of households in this income group  > A
        set dw_el 1]
        if (en >= 8.5) and (en < 22.6) [         ;; 14.1% of households in this income group  > B
        set dw_el 2]
        if (en >= 22.6) and (en < 35) [          ;; 12.4% of households in this income group  > C
        set dw_el 3]
        if (en >= 35) and (en < 39) [            ;; 4% of households in this income group   > D
        set dw_el 4]
        if (en >= 39) and (en < 43.5) [          ;; 4.5% of households in this income group   > E
        set dw_el 5]
        if (en >= 43.5) and (en <= 46.9) [       ;; 3.4% of households in this income group  > F
        set dw_el 6]
        if (en >= 46.9) and (en <= 100) [        ;; 53.1% of households in this income group > More than F
        set dw_el 7]

        set fl random-float 100                  ;; generate a random number between 0-100 to assign LCE user
        if (fl < 42.33) [                        ;; 42.33% of households in this income group use LCE
        set flag? 1]
        if (fl >= 42.33) and (fl <= 100) [
        set flag? 0]

        set edu random-float 100                 ;; generate a random number between 0-100 to assign education level
        if (edu < 5.8) [
        set h_edu 1]
        if (edu >= 5.8) and (edu < 72.1) [
        set h_edu 2]
        if (edu >= 72.1) and (edu < 84.6) [
        set h_edu 3]
        if (edu >= 84.6) and (edu < 94.1) [
        set h_edu 4]
        if (edu >= 94.1) and (edu <= 99.4) [
        set h_edu 5]
        if (edu >= 99.4) and (edu <= 100) [
        set h_edu 6]
        ]


      if (rr > 40.19) and (rr <= 78.17) [        ;; 37.69% of of households have income 30,001 to 50,000   >>  Income group 3

        set h_id_group 3
        set h_income randomNumber 30001 50000 10
        set h_q randomNumber 900 5000 100
        set h_gas randomNumber 30 5000 10        ;; Between 30-5000 in this income group


        set know randomNumber 2.6 7 0.05         ;; and knowledge
        set cee_aw randomNumber 2.71 7 0.05      ;; and cee awareness
        set ed_aw randomNumber 1.4 7 0.05        ;; and ed awareness

        set per_nab1 randomNumber 1.5 7 0.05     ;; Personal norm
        set per_nab2 randomNumber 1.5 7 0.05
        set per_nab3 randomNumber 1.5 7 0.05
        set su_nor1  randomNumber 1 7 0.05       ;; Social norm
        set su_nor2  randomNumber 1 7 0.05
        set su_nor3  randomNumber 1 7 0.05

        set pbc1 randomNumber 1 7 0.05           ;; pbc1
        set pbc2 randomNumber 1 7 0.05           ;; pbc2
        set pbc3 randomNumber 1 7 0.05           ;; pbc3

        set alpha 0.0175

        set ep randomNumber 0 1.60 0.05          ;; energy patterns

        set ow random-float 100                  ;; generate a random number between 0-100 to assign owner/rental statuse
        if (ow < 80) [                           ;; 80% of households in this income group are owner
        set dw_st 1]
        if (ow >= 80) and (ow <= 100) [          ;; 20% of households in this income group
        set dw_st 0]

        set en random-float 100                  ;; generate a random number between 0-100 to assign Dwelling energy Lable
        if (en < 16.4) [                         ;; 16.7% of households in this income group    > A
        set dw_el 1]
        if (en >= 16.4) and (en < 33.4) [        ;; 16.7% of households in this income group  > B
        set dw_el 2]
        if (en >= 33.4) and (en < 43.3) [        ;; 9.9% of households in this income group  > C
        set dw_el 3]
        if (en >= 43.3) and (en < 47.3) [        ;; 4% of households in this income group   > D
        set dw_el 4]
        if (en >= 47.3) and (en < 54.2) [        ;; 6.9% of households in this income group  > E
        set dw_el 5]
        if (en >= 54.2) and (en <= 60.6) [       ;; 6.4% of households in this income group > F
        set dw_el 6]
        if (en >= 60.6) and (en <= 100) [        ;; 39.4% of households in this income group  > More than  F
        set dw_el 7]


        set fl random-float 100                  ;; generate a random number between 0-100 to assign LCE user
        if (fl < 36.13) [                        ;; 36.13% of households in this income group use LCE
        set flag? 1]
        if (fl >= 36.13) and (fl <= 100) [
        set flag? 0 ]


        set edu random-float 100                 ;; generate a random number between 0-100 to assign education level
        if (edu < 2.3) [
        set h_edu 1]
        if (edu >= 2.3) and (edu < 49.9) [
        set h_edu 2]
        if (edu >= 49.9) and (edu < 74.8) [
        set h_edu 3]
        if (edu >= 74.8) and (edu < 90.3) [
        set h_edu 4]
        if (edu >= 90.3) and (edu <= 98.2) [
        set h_edu 5]
        if (edu >= 98.2) and (edu <= 100) [
        set h_edu 6]
      ]


      if (rr > 78.17) and (rr <= 91.69) [       ;; 13.52% of of households have income 50,001 to 70,000  >>  Income group 4

        set h_id_group 4
        set h_income randomNumber 50001 70000 10
        set h_q randomNumber 890 5000 100
        set h_gas randomNumber 100 5000 10      ;; Between 30-5000 in this income group

        set know randomNumber 2.8 6.66 0.05     ;;and knowledge
        set cee_aw randomNumber 3 6.57 0.05     ;; and cee awareness
        set ed_aw randomNumber 1.8 7 0.05       ;; and ed awareness

        set per_nab1 randomNumber 2.5 7 0.05    ;; Personal norm
        set per_nab2 randomNumber 2.5 7 0.05
        set per_nab3 randomNumber 2.5 7 0.05
        set su_nor1  randomNumber 1.16 7 0.05   ;; Social norm
        set su_nor2  randomNumber 1.16 7 0.05
        set su_nor3  randomNumber 1.16 7 0.05

        set pbc1 randomNumber 2.2 7 0.05        ;; pbc1
        set pbc2 randomNumber 1 7 0.05          ;; pbc2
        set pbc3 randomNumber 1 7 0.05          ;; pbc3

        set alpha 0.0159

        set ep randomNumber 0.63 1.67 0.05       ;; energy patterns

        set ow random-float 100                  ;; generate a random number between 0-100 to assign owner/rental statuse
        if (ow < 92) [                           ;; 92% of households in this income group are owner
        set dw_st 1]
        if (ow >= 92) and (ow <= 100) [          ;; 8% of households in this income group
        set dw_st 0]

        set en random-float 100                  ;; generate a random number between 0-100 to assign Dwelling energy Lable
        if (en < 22.9) [                         ;; 22.9% of households in this income group    > A
        set dw_el 1]
        if (en >= 22.9) and (en < 42.9) [        ;; 20% of households in this income group      > B
        set dw_el 2]
        if (en >= 42.9) and (en < 60) [          ;; 17.1% of households in this income group    > C
        set dw_el 3]
        if (en >= 60) and (en < 67.1) [          ;; 7.1% of households in this income group   > D
        set dw_el 4]
        if (en >= 67.1) and (en <= 70) [         ;; 2.9% of households in this income group   > F
        set dw_el 6]
        if (en >= 70) and (en <= 100) [          ;; 30% of households in this income group   > More than F
        set dw_el 7]

        set fl random-float 100                  ;; generate a random number between 0-100 to assign LCE user
        if (fl < 46.43) [                        ;; 46.43% of households in this income group use LCE
        set flag? 1]
        if (fl >= 46.43) and (fl <= 100) [
        set flag? 0]

        set edu random-float 100                 ;; generate a random number between 0-100 to assign education level
        if (edu < 28.6) [
        set h_edu 2]
        if (edu >= 28.6) and (edu < 57.2) [
        set h_edu 3]
        if (edu >= 57.2) and (edu < 79.3) [
        set h_edu 4]
        if (edu >= 79.3) and (edu < 99.3) [
        set h_edu 5]
        if (edu >= 99.3) and (edu <= 100) [
        set h_edu 6]
        ]


      if (rr > 91.69) and (rr <= 97.39) [        ;; 5.7% of of households have income 70,001 to 90,000  >>  Income group 5

        set h_id_group 5
        set h_income randomNumber 70001 90000 10
        set h_q randomNumber 1446 5000 100
        set h_gas randomNumber 67 5000 10        ;; Between 67-5000 in this income group

        set know randomNumber 3 5.66 0.05        ;; and knowledge
        set cee_aw randomNumber 3.14 6.42 0.05   ;; and cee awareness
        set ed_aw randomNumber 2 7 0.05          ;; and ed awareness

        set per_nab1 randomNumber 3.5 6.25 0.05  ;; Personal norm
        set per_nab2 randomNumber 3.5 6.25 0.05
        set per_nab3 randomNumber 3.5 6.25 0.05
        set su_nor1  randomNumber 1 5.8 0.05     ;; Social norm
        set su_nor2  randomNumber 1 5.8 0.05
        set su_nor3  randomNumber 1 5.8 0.05

        set pbc1 randomNumber 2.2 7 0.05         ;; pbc1
        set pbc2 randomNumber 1 6.5 0.05         ;; pbc2
        set pbc3 randomNumber 1 7 0.05           ;; pbc3

        set alpha 0.0133

        set ep randomNumber 0.70 1.60 0.05       ;; energy patterns

        set ow random-float 100                  ;; generate a random number between 0-100 to assign owner/rental statuse
        if (ow < 92) [                           ;; 92% of households in this income group are owner
        set dw_st 1]
        if (ow >= 92) and (ow <= 100) [          ;; 8% of households in this income group
        set dw_st 0]

        set en random-float 100                  ;; generate a random number between 0-100 to assign Dwelling energy Lable
        if (en < 25.9) [                         ;; 25.9% of households in this income group  > A
        set dw_el 1]
        if (en >= 25.9) and (en <= 40.7) [       ;; 14.8% of households in this income group  > B
        set dw_el 2]
        if (en >= 40.7) and (en <= 51.8) [       ;; 11.1% of households in this income group  > C
        set dw_el 3]
        if (en >= 51.8) and (en <= 55.5) [       ;; 3.7% of households in this income group  > D
        set dw_el 4]
        if (en >= 55.5) and (en <= 100) [        ;; 44.5% of households in this income group  > More than F
        set dw_el 7]


        set fl random-float 100                  ;; generate a random number between 0-100 to assign LCE user
        if (fl < 44.07) [                        ;; 44.07% of households in this income group use LCE
        set flag? 1]
        if (fl >= 44.07) and (fl <= 100) [
        set flag? 0 ]

        set edu random-float 100                 ;; generate a random number between 0-100 to assign education level
        if (edu < 28.6) [
        set h_edu 2]
        if (edu >= 28.6) and (edu < 57.2) [
        set h_edu 3]
        if (edu >= 57.2) and (edu <= 79.3) [
        set h_edu 4]
        if (edu >= 79.3) and (edu <= 99.3) [
        set h_edu 5]
        if (edu >= 99.3) and (edu <= 100) [
        set h_edu 6]
      ]


      if (rr >  97.39) and (rr <= 98.36) [       ;; 0.97% of of households have income 90,001 to 110,000   >>  Income group 6

        set h_id_group 6
        set h_income randomNumber 90001 110000 10
        set h_q randomNumber 2083 5000 100
        set h_gas randomNumber 401 3000 10       ;; Between 401-3000 in this income group

        set know randomNumber 3.1 4.66 0.05      ;; and knowledge
        set cee_aw randomNumber 2.72 5.57 0.05   ;; and cee awareness
        set ed_aw randomNumber 3.66 6.33 0.05    ;; and ed awareness

        set per_nab1 randomNumber 3.62 5.75 0.05 ;; Personal norm
        set per_nab2 randomNumber 3.62 5.75 0.05
        set per_nab3 randomNumber 3.62 5.75 0.05
        set su_nor1  randomNumber 2 3.83 0.05    ;; Social norm
        set su_nor2  randomNumber 2 3.83 0.05
        set su_nor3  randomNumber 2 3.83 0.05

        set pbc1 randomNumber 2.4 6.4 0.05       ;; pbc1
        set pbc2 randomNumber 1.5 5.5 0.05       ;; pbc2
        set pbc3 randomNumber 2 3 0.05           ;; pbc3

        set alpha 0.0133

        set ep randomNumber 0.78 1.82 0.05       ;; energy patterns

        set dw_st 1                              ;; 100% of households in this income group are owner

        set dw_el 7                              ;; 100% of households in this income group    > More than F

        set fl random-float 100                  ;; generate a random number between 0-100 to assign LCE user
        if (fl < 20) [                           ;; 20% of households in this income group use LCE
        set flag? 1]
        if (fl >= 20) and (fl <= 100) [
        set flag? 0]

        set edu random-float 100                 ;; generate a random number between 0-100 to assign education level
        if (edu < 10) [
        set h_edu 2]
        if (edu >= 10) and (edu < 20) [
        set h_edu 3]
        if (edu >= 20) and (edu <= 60) [
        set h_edu 4]
        if (edu >= 60) and (edu < 90) [
        set h_edu 5]
        if (edu >= 90) and (edu <= 100) [
        set h_edu 6]
      ]


      if (rr > 98.36) and (rr <= 100) [          ;; 1.64% of of households have income more than 110,000   ~  150,000  >>  income group 7


        set h_id_group 7
        set h_income randomNumber 110001 150000 10
        set h_q randomNumber 1000 5000 100
        set h_gas randomNumber 3 3000 10         ;; Between 3-3000 in this income group


        set know randomNumber 3.33 5.33 0.05     ;; and knowledge
        set cee_aw randomNumber 3.85 6.21 0.05   ;; and cee awareness
        set ed_aw randomNumber 2.66 6 0.05       ;; and ed awareness

        set per_nab1 randomNumber 2.62 7 0.05    ;; Personal norm
        set per_nab2 randomNumber 2.62 7 0.05
        set per_nab3 randomNumber 2.62 7 0.05
        set su_nor1  randomNumber 1 5.66 0.05    ;; Social norm
        set su_nor2  randomNumber 1 5.66 0.05
        set su_nor3  randomNumber 1 5.66 0.05

        set pbc1 randomNumber 1.6 6.6 0.05       ;; pbc1
        set pbc2 randomNumber 1 7 0.05           ;; pbc2
        set pbc3 randomNumber 1 6 0.05           ;; pbc3

        set alpha 0.0133

        set ep randomNumber 1 3 0.05             ;; energy patterns

        set ow random-float 100                  ;; generate a random number between 0-100 to assign owner/rental statuse
        if (ow < 80) [                           ;; 80% of households in this income group are owner
        set dw_st 1]
        if (ow >= 80) and (ow <= 100) [          ;; 20% of households in this income group
        set dw_st 0]

        set en random-float 100                  ;; generate a random number between 0-100 to assign Dwelling energy Lable
        if (en < 20) [                           ;; 20% of households in this income group    > A
        set dw_el 1]
        if (en >= 20) and (en <= 50) [           ;; 30% of households in this income group    > B
        set dw_el 2]
        if (en >= 50) and (en <= 70) [           ;; 20% of households in this income group    > C
        set dw_el 3]
        if (en >= 70) and (en <= 90) [           ;; 20% of households in this income group    > D
        set dw_el 4]
        if (en >= 90) and (en <= 100) [          ;; 10% of households in this income group    > More than F
        set dw_el 7]

        set fl random-float 100                  ;; generate a random number between 0-100 to assign LCE user
        if (fl < 29.41) [                        ;; 29.41% of households in this income group use LCE
        set flag? 1]
        if (fl >= 29.41) and (fl <= 100) [
        set flag? 0]

        set edu random-float 100                 ;; generate a random number between 0-100 to assign education level
        if (edu < 5.9) [
        set h_edu 1]
        if (edu >= 5.9) and (edu < 29.4) [
        set h_edu 2]
        if (edu >= 29.4) and (edu <= 64.7) [
        set h_edu 3]
        if (edu >= 64.7) and (edu < 82.35) [
        set h_edu 4]
        if (edu >= 82.35) and (edu <= 100) [
        set h_edu 6]
      ]


      set K 0
      set guilt "Null"

      set h_motiv1 0
      set h_motiv2 0
      set h_motiv3 0
      set M1 0
      set M2 0
      set M3 0

      set delta1 0
      set delta2 0
      set delta3 0
      set cons1 "Null"
      set cons2 "Null"
      set cons3 "Null"
      set intention False

      set act1 False
      set act11 False
      set act12 False
      set act50 False
      set act21 False
      set act40 False
      set act3 False
      set act31 False
      set act32 False

      set act11_year 0
      set act12_year 0
      set act21_year 0
      set act40_year 0
      set act31_year 0
      set act32_year 0

      set satisfied "Null"
      set aware 2                             ;; constant varibales for Utility functions
      set motiv 2
      set cons 2

      set influence_know 0                    ;; social network and learning
      set influence_cee_aw 0
      set influence_ed_aw 0

      set influence_per 0
      set influence_su  0
    ]

    set n_households count households
    set counttrade 0
    set utility_exp_lce 0
    set utility_exp_ff 0
    set consumption_total 0
    set aware_total 0
    set n 0

   ]

  ]

  reset-ticks

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;; Creating Files ;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to create_files                    ;; FOR DEBUGGING!

   if debug_files = true[

     if file-exists? "household.csv" [file-delete "household.csv"]         ;; all about HH
      file-open "household.csv"
      file-print (word "year, " "id, " "group id, " "income, " "consumption, " "lce user?, " "status, " "actions, " "knowledge, " "cee_aw, " "ed_aw, " "awareness, " "guilt, " "personal1, "
                        "social1, " "motivation1, " "personal2, " "social2, " "motivation2, " "personal3, " "social3, " "motivation3, " "reponsibility, " "Owner, " "pbc1, "  "pbc2, " "pbc3, "
                        "delta1, " "delta2, " "delta3, " "UElce1, " "UElce2, " "UElce31, " "UEff1, " "UEff2, " "UEff32, " "UElce32, " "UEzero1, " "UEzero2, " "UEzero3, " "MaxLCE, " "MaxFF, " "MaxZero, "
                        "Ulce1, " "Ulce2, " "Ulce31, " "Uff1, " "Uff2, " "Uff32, " "Ulce32, " "Uzero1, " "Uzero2, " "Uzero3, " "zero3>lce, " "lce>past, "
                        "act11, " "act12, " "act21, " "act40, " "act31, " "act32, "
                        "act1, " "act2, " "act3, " "save1ff, " "save2ff, " "save3ff, " "save1lce, " "save2lce, " "save3lce, " "save1ff1, " "save2ff1, " "save3ff1, " "save1lce1, " "save2lce1, " "save3lce1, "
                        "save1ff2, " "save2ff2, " "save3ff2, " "save1lce2, " "save2lce2, " "save3lce2, "
                        "save1ff3, " "save2ff3, " "save3ff3, " "save1lce3, " "save2lce3, " "save3lce3, "
                        "save1ff4, " "save2ff4, " "save3ff4, " "save1lce4, " "save2lce4, " "save3lce4, "
                        "save1ff5, " "save2ff5, " "save3ff5, " "save1lce5, " "save2lce5, " "save3lce5, ")]

  file-close-all

end

; ########################################################################################
; ############################ Dynamics and Functions ####################################
; ########################################################################################

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                GO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


To go

  tick

  set energy_sav 0
  set em_sav 0
  set income_total sum [h_income] of households           ;; Total household's income
  set lceuser (count households with [flag? = 1])         ;; Total lce user
  set slceuser (count households with [flag? = 2])        ;; Total super lce user
  set ffuser (count households with [flag? = 0])          ;; Total ff user

  if ((year = 2015) and (Memory = True))[recallmemory]

  if Scenario = "Ref_SSP2"[
    if ((DMProcess = True) and (Awareness = True) and (Motiva = True)) [
      cpinfo
      knowledge
      motivation
      consideration_NAT

      update_utilities_NAT
      satisfy
      regret

      utility_exp_NAT
      if year >= 2016 [
        action
        save
        emissions]

      price
      update_data
      debug
      ]
  ]

    learn
    update_heq
    update_memory

    set n (n + 1)
    set year year + 1

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                       MEMORY
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To recallmemory

 if year = 2015[

 if Case-study = "Netherlands-Overijssel" [
  ask households[
    if h_id_group = 1[
      if flag? = 1[
        let aa random-float 100                  ;; generate a random number between 0-100 to assign actions
        if (aa < 57.14)[
          set hh_actions replace-item 0 hh_actions 1              ;; 57.14% green households already did an action11
          set act1 true
          set act11 true]
        let bb random-float 100
        if (bb < 14.28)[
          set hh_actions replace-item 4 hh_actions 1
          set act31 true
          set act3 true]
        if (b >= 14.28) and (b <= 100) [
          set hh_actions replace-item 5 hh_actions 1
          set act3 true
          set act32 true]
        let c random-float 100
        if (c < 21.43)[
          set hh_actions replace-item 2 hh_actions 1
          set act21 true
          set act50 true]]

      if flag? = 0[
        let aa random-float 100
        if (aa < 58.14)[
          set hh_actions replace-item 1 hh_actions 1
          set act12 true
          set act1 true]
        let bb random-float 100
        if (bb < 9.3) [
          set hh_actions replace-item 3 hh_actions 1
          set act50 true
          set act40 true]]]

    if h_id_group = 2[
      if flag? = 1[
        let aa random-float 100
        if (aa < 78.29)[
          set hh_actions replace-item 0 hh_actions 1
          set act1 true
          set act11 true]
        let bb random-float 100
        if (bb < 15.13)[
          set hh_actions replace-item 4 hh_actions 1
          set act3 true
          set act31 true]
        if (bb >= 15.13) and (bb <= 100) [
          set hh_actions replace-item 5 hh_actions 1
          set act3 true
          set act32 true]
        let c random-float 100
        if (c < 17.10)[
        set hh_actions replace-item 2 hh_actions 1
          set act50 true
          set act21 true]]

      if flag? = 0[
        let aa random-float 100
        if (aa < 68.6)[
          set hh_actions replace-item 1 hh_actions 1
          set act1 true
          set act12 true]
        let bb random-float 100
        if (bb < 8.7) [
          set hh_actions replace-item 3 hh_actions 1
          set act50 true
          set act40 true]]]

    if h_id_group = 3[
      if flag? = 1[
        let aa random-float 100
        if (aa < 82.4)[
          set hh_actions replace-item 0 hh_actions 1
          set act11 true
          set act1 true]
        set hh_actions replace-item 2 hh_actions 1
        let bb random-float 100
        if (bb < 14.1)[
          set hh_actions replace-item 4 hh_actions 1
          set act3 true
          set act31 true]
        if (bb >= 14.1) and (bb <= 100) [
          set hh_actions replace-item 5 hh_actions 1
          set act3 true
          set act32 true]
        let c random-float 100
        if (c < 17)[
          set hh_actions replace-item 5 hh_actions 1
          set act50 true
          set act21 true]]

      if flag? = 0[
        let aa random-float 100
        if (aa < 80.48)[
          set hh_actions replace-item 1 hh_actions 1
          set act1 true
          set act12 true]
        let bb random-float 100
        if (bb < 11.55) [
          set hh_actions replace-item 3 hh_actions 1
          set act50 true
          set act40 true]]]

    if h_id_group = 4[
      if flag? = 1[
        let aa random-float 100
        if (aa < 83.1)[
          set hh_actions replace-item 0 hh_actions 1
          set act11 true
          set act1 true]
        let bb random-float 100
        if (bb < 18.46)[
          set hh_actions replace-item 4 hh_actions 1
          set act3 true
          set act31 true]
        if (bb >= 18.46) and (bb <= 100) [
          set hh_actions replace-item 5 hh_actions 1
          set act3 true
          set act32 true]
        let c random-float 100
        if (c < 18.46)[
          set hh_actions replace-item 2 hh_actions 1
          set act50 true
          set act21 true]]

      if flag? = 0[
        let aa random-float 100
        if (aa < 42.86)[
          set hh_actions replace-item 1 hh_actions 1
          set act1 true
          set act12 true]
        let bb random-float 100
        if (bb < 16) [
          set hh_actions replace-item 3 hh_actions 1
          set act50 true
          set act40 true]]]

    if h_id_group = 5[
      if flag? = 1[
        let c random-float 100
        if (c < 23.1)[
           set hh_actions replace-item 2 hh_actions 1
           set act50 true
           set act21 true]
        let aa random-float 100                  ;; generate a random number between 0-100 to assign actions
        if (aa < 88.47)[
          set hh_actions replace-item 0 hh_actions 1
          set act1 true
          set act11 true]
        let bb random-float 100                  ;; generate a random number between 0-100 to assign actions
        if (bb < 23.1)[
          set hh_actions replace-item 4 hh_actions 1
          set act3 true
          set act31 true]
        if (bb >= 23.1) and (bb <= 100) [
          set hh_actions replace-item 5 hh_actions 1
          set act3 true
          set act32 true]]

      if flag? = 0[
        let aa random-float 100
        if (aa < 87.89)[
          set hh_actions replace-item 1 hh_actions 1
          set act1 true
          set act12 true]
        let bb random-float 100
        if (bb < 18.18) [
          set hh_actions replace-item 3 hh_actions 1
          set act50 true
          set act40 true]]]

    if h_id_group = 6[
      if flag? = 1[
        let c random-float 100
        if (c < 50)[
           set hh_actions replace-item 2 hh_actions 1
           set act50 true
           set act21 true]
       set hh_actions replace-item 0 hh_actions 1
          set act1 true
          set act11 true
        let bb random-float 100                  ;; generate a random number between 0-100 to assign actions
        if (bb < 50)[
          set hh_actions replace-item 4 hh_actions 1
          set act3 true
          set act31 true]
        if (bb >= 50) and (bb <= 100) [
          set hh_actions replace-item 5 hh_actions 1
          set act3 true
              set act32 true]]

      if flag? = 0[
          set hh_actions replace-item 1 hh_actions 1
          set act1 true
          set act12 true
          let c random-float 100
          if (c < 25)[
          set hh_actions replace-item 3 hh_actions 1
          set act50 true
          set act40 true]]]

    if h_id_group = 7[
      if flag? = 1[
        let c random-float 100
        if (c < 20)[
           set hh_actions replace-item 2 hh_actions 1
           set act50 true
           set act21 true]
        let aa random-float 100                  ;; generate a random number between 0-100 to assign actions
        if (aa < 60)[
          set hh_actions replace-item 0 hh_actions 1
          set act1 true
          set act11 true]
        let bb random-float 100                  ;; generate a random number between 0-100 to assign actions
        if (bb < 20)[
          set hh_actions replace-item 4 hh_actions 1
          set act3 true
          set act31 true]
        if (bb >= 20) and (bb <= 100) [
          set hh_actions replace-item 5 hh_actions 1
          set act3 true
              set act32 true]]

      if flag? = 0[
        let aa random-float 100
        if (aa < 83.33)[
          set hh_actions replace-item 1 hh_actions 1
          set act1 true
          set act12 true]
        let bb random-float 100
        if (bb < 8.3) [
          set hh_actions replace-item 3 hh_actions 1
          set act50 true
          set act40 true]]]
      ]
    ]
  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                      Exogenous Prices
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To price

  if  Case-study = "Spain-Navarre"[
    if Scenario = "Ref_SSP2" [
    if Policy = "Ref" [                                        ;; no carbon price pressure Grey = Green
        set m_p_ff item 0 item n primes-spn-ref-prices
        set m_p_lce item 0 item n primes-spn-ref-prices
        set m_p_zero item 0 item n primes-spn-ref-prices]

    if Policy = "Carbon price pressure-10" [                   ;; carbon price: 2030(10)
        set m_p_ff item 2 item n primes-spn-ref-prices
        set m_p_lce item 1 item n primes-spn-ref-prices
        set m_p_zero item 0 item n primes-spn-ref-prices]

    if Policy = "Carbon price pressure-25" [                  ;; carbon price: 2030(25)
        set m_p_ff item 4 item n primes-spn-ref-prices
        set m_p_lce item 3 item n primes-spn-ref-prices
        set m_p_zero item 0 item n primes-spn-ref-prices]

    if Policy = "Carbon price pressure-50" [                  ;; carbon price: 2030(50)
        set m_p_ff item 6 item n primes-spn-ref-prices
        set m_p_lce item 5 item n primes-spn-ref-prices
        set m_p_zero item 0 item n primes-spn-ref-prices]

    if Policy = "Carbon price pressure-100" [                 ;; carbon price: 2030(100)
        set m_p_ff item 8 item n primes-spn-ref-prices
        set m_p_lce item 7 item n primes-spn-ref-prices
        set m_p_zero item 0 item n primes-spn-ref-prices]

    if Policy = "Carbon price pressure-2020" [                ;; carbon price: from 2020(25)
        set m_p_ff item 10 item n primes-spn-ref-prices
        set m_p_lce item 9 item n primes-spn-ref-prices
        set m_p_zero item 0 item n primes-spn-ref-prices]
  ]
 ]

 if  Case-study = "Netherlands-Overijssel"[
    if Scenario = "Ref_SSP2" [
    if Policy = "Ref" [                                        ;; no carbon price pressure Grey = Green
        set m_p_ff item 0 item n primes-nl-ref-prices
        set m_p_lce item 0 item n primes-nl-ref-prices
        set m_p_zero item 0 item n primes-nl-ref-prices]

    if Policy = "Carbon price pressure-10" [                   ;; carbon price: 2030(10)
        set m_p_ff item 2 item n primes-nl-ref-prices
        set m_p_lce item 1 item n primes-nl-ref-prices
        set m_p_zero item 0 item n primes-nl-ref-prices]

    if Policy = "Carbon price pressure-25" [                  ;; carbon price: 2030(25)
        set m_p_ff item 4 item n primes-nl-ref-prices
        set m_p_lce item 3 item n primes-nl-ref-prices
        set m_p_zero item 0 item n primes-nl-ref-prices]

    if Policy = "Carbon price pressure-50" [                  ;; carbon price: 2030(50)
        set m_p_ff item 6 item n primes-nl-ref-prices
        set m_p_lce item 5 item n primes-nl-ref-prices
        set m_p_zero item 0 item n primes-nl-ref-prices]

    if Policy = "Carbon price pressure-100" [                 ;; carbon price: 2050(100)
        set m_p_ff item 8 item n primes-nl-ref-prices
        set m_p_lce item 7 item n primes-nl-ref-prices
        set m_p_zero item 0 item n primes-nl-ref-prices]

    if Policy = "Carbon price pressure-2020" [                ;; carbon price: from 2020(25)
        set m_p_ff item 10 item n primes-nl-ref-prices
        set m_p_lce item 9 item n primes-nl-ref-prices
        set m_p_zero item 0 item n primes-nl-ref-prices]
  ]
 ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Demand activities ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;             Knowledge activation
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
To knowledge

  ask households [                              ;; if the HH already did all the actions
    if (hh_actions = [1 1 1 1 1 1])[
    stop]]

  ask households [
    set h_id who
    set h_aware ((know + cee_aw + ed_aw) / 3)    ;; avarage of knowledge, CEE awareness and DE awareness

    if Case-study = "Netherlands-Overijssel" [
      if (h_aware < 5.21 )[set guilt "L"]
      if (h_aware >= 5.21) [set guilt "H"]]

    if Case-study = "Spain-Navarre" [
      if (h_aware < 5.21 )[set guilt "L"]
      if (h_aware >= 5.21) [set guilt "H"]]

    if (guilt = "H") [                           ;; Calculating "K" just for housholds with "High" feeling guilt  >> 0 < K < 1
      set K ( h_aware / 7)]
  ]

  set aware_total sum [h_aware] of households    ;; Total households awareness
  draw_awareness                                 ;; Plotting awarenss
  draw_feelingguilt                              ;; Plotting guilt
  draw_totalawareness

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Motivation
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
To motivation

  ask households[
    if (DMProcess = True and guilt = "H")[
      set h_motiv1 ((per_nab1 + su_nor1) / 2)         ;; avarage of personal norms and social/subjective norms
      set h_motiv2 ((per_nab2 + su_nor2) / 2)
      set h_motiv3 ((per_nab3 + su_nor3) / 2)

    if Case-study = "Spain-Navarre" [
      if ((per_nab1 < 5.67) and (su_nor1 < 4.77))[                              ;; action1
          set level "L"]
      if ((per_nab1 >= 5.67) and (su_nor1 >= 4.77))[
          set level "H"
          set M1 ( h_motiv1 / 7)                      ;; Calculating M for the high motivated households 0 < M < 1
          set responsibility True]

      if ((per_nab2 < 5.40) and (su_nor2 < 4.45))[                              ;; action2
          set level "L"]
      if ((per_nab2 >= 5.40) and (su_nor2 >= 4.45))[
          set level "H"
          set M2 ( h_motiv2 / 7)                      ;; Calculating M for the high motivated households 0 < M < 1
          set responsibility True]

      if ((per_nab3 < 5.78) and (su_nor3 < 5.05))[                              ;; action3
          set level "L"]
      if ((per_nab3 >= 5.78) and (su_nor3 >= 5.05))[
          set level "H"
          set M3 ( h_motiv3 / 7)                      ;; Calculating M for the high motivated households 0 < M < 1
          set responsibility True]]

    if Case-study = "Netherlands-Overijssel" [
      if ((per_nab1 < 5.67) and (su_nor1 < 4.45))[                              ;; action1
          set level "L"]
      if ((per_nab1 >= 5.67) and (su_nor1 >= 4.45))[
          set level "H"
          set M1 ( h_motiv1 / 7)                      ;; Calculating M for the high motivated households 0 < M < 1
          set responsibility True]

      if ((per_nab2 < 5.40) and (su_nor2 < 3.66))[                              ;; action2
          set level "L"]
      if ((per_nab2 >= 5.40) and (su_nor2 >= 3.66))[
          set level "H"
          set M2 ( h_motiv2 / 7)                      ;; Calculating M for the high motivated households 0 < M < 1
          set responsibility True]

      if ((per_nab3 < 5.78) and (su_nor3 < 5.05))[                              ;; action3
          set level "L"]
      if ((per_nab3 >= 5.78) and (su_nor3 >= 5.05))[
          set level "H"
          set M3 ( h_motiv3 / 7)                      ;; Calculating M for the high motivated households 0 < M < 1
          set responsibility True]]
    ]
  ]
  draw_motivation                              ;; Plotting motivation

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Consideration
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To consideration_NAT

  ask households[
    if responsibility = True[
      if Investment = True[                    ;; INVESTMENT
        if (pbc1 < 4) [
          set cons1 "L"]
        if (pbc1 >= 4) [
          set cons1 "H"]
        ifelse (dw_st = 0)[set delta1 0 ][
          if (pbc1 < 2) [set delta1 0.2]
          if ((pbc1 >= 2) and (pbc1 < 3)) [set delta1 0.3]
          if ((pbc1 >= 3) and (pbc1 < 4)) [set delta1 0.4]
          if ((pbc1 >= 4) and (pbc1 < 5)) [set delta1 0.5]
          if ((pbc1 >= 5) and (pbc1 < 6)) [set delta1 0.6]
          if ((pbc1 >= 6) and (pbc1 <= 7)) [set delta1 0.7]
        ]
      ]

      if Conservation = True[                  ;; CONSERVATION
        if ((ep > 2) or (pbc2 < 4)) [
          set cons2 "L"
          if (pbc2 < 2) [set delta2 0.2]
        ]
        if ((ep <= 2) or (pbc2 >= 4)) [
          set cons2 "H"
          if ((pbc2 >= 2) and (pbc2 < 3)) [set delta2 0.3]
          if ((pbc2 >= 3) and (pbc2 < 4)) [set delta2 0.4]
          if ((pbc2 >= 4) and (pbc2 < 5)) [set delta2 0.5]
          if ((pbc2 >= 5) and (pbc2 < 6)) [set delta2 0.6]
          if ((pbc2 >= 6) and (pbc2 <= 7)) [set delta2 0.7]
        ]
      ]

      if Switching = True [                    ;; SWITCHING
        if (pbc3 < 4) [
          set cons3 "L"]
        if (pbc3 >= 4) [
          set cons3 "H"]
        if (pbc3 < 2) [set delta3 0.2]
        if ((pbc3 >= 2) and (pbc3 < 3)) [set delta3 0.3]
        if ((pbc3 >= 3) and (pbc3 < 4)) [set delta3 0.4]
        if ((pbc3 >= 4) and (pbc3 < 5)) [set delta3 0.5]
        if ((pbc3 >= 5) and (pbc3 < 6)) [set delta3 0.6]
        if (pbc3 >= 6) [set delta3 0.7]
        ]
    ]
  ]


  draw_consideration

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;          Utility expetation: normalization
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
To normalize-1

;; For ELECTRICITY
  set h_totalff  sum [h_q] of households with [flag? = 0]                    ;; Calculating the total Grey consumption
  set h_totallce sum [h_q] of households with [flag? = 1]                    ;; Calculating the total Green consumption
  set h_totalslce sum [h_q] of households with [flag? = 2]                   ;; Calculating the total Super Green consumption
  set consumption_total ( h_totalff + h_totallce + h_totalslce )             ;; Calculating the Total electricity consumption
  set h_lceshare (((h_totallce + h_totalslce) * 100) / consumption_total)    ;; Calculating share of lce electricity consumption

;; Calculate E and Z for HH utility expectation

  ask households[
;; For ELECTRICITY
    if (h_q > 0)[
      set z_lce1 (h_income - ( (h_q * m_p_lce) + (1700 * m_p_lce) + 487.59 + h_conserv_p + h_switch) )
      set z_lce2 (h_income - ( (h_q * m_p_lce) + (h_invest_save * m_p_lce) + h_invest + ((0.5 * h_q) * m_p_lce) + h_switch) )
      set z_ff1 (h_income - ( (h_q * m_p_ff) + (1700 * m_p_ff) + 487.59 + h_conserv_p + h_switch) )
      set z_ff2 (h_income - ( (h_q * m_p_ff) + (h_invest_save * m_p_ff ) + h_invest + ((0.5 * h_q) * m_p_ff) + h_switch) )
      set z_zero1 (h_income - ( (h_q * m_p_zero) + (1700 * m_p_zero) + 487.59 + h_conserv_p + h_switch) )
      set z_zero2 (h_income - ( (h_q * m_p_zero) + (h_invest_save * m_p_zero) + h_invest + (0.5 * h_q) + h_switch) )
      set z_lce3 (h_income - ( (h_q * m_p_zero) + (h_invest_save * (m_p_zero)) + h_invest + h_conserv_p + (m_p_zero - m_p_lce)) )
      set z_ff3 (h_income - ( (h_q * m_p_lce) + (h_invest_save * m_p_lce) + h_invest + h_conserv_p + (m_p_lce - m_p_ff)) )


      if z_ff1 < 0 [set hh_sta "Low-paid1"]
      if z_ff2 < 0 [set hh_sta "Low-paid2"]
      if z_ff2 < 0 [set hh_sta "Low-paid3"]
      if z_lce1 < 0 [set hh_sta "Low-paid1"]
      if z_lce2 < 0 [set hh_sta "Low-paid2"]
      if z_lce3 < 0 [set hh_sta "Low-paid3"]
      if z_zero1 < 0 [set hh_sta "Low-paid1"]
      if z_zero2 < 0 [set hh_sta "Low-paid2"]
    ]
  ]

;;; Normalizing procedure

   set z_lce1_max max [z_lce1] of households
   set z_ff1_max max [z_ff1] of households
   set z_zero1_max max [z_zero1] of households
   set z_lce2_max max [z_lce2] of households
   set z_ff2_max max [z_ff2] of households
   set z_zero2_max max [z_zero2] of households
   set z_lce3_max max [z_lce3] of households
   set z_ff3_max max [z_ff3] of households

  ask households [
      set z_lce1_norm ( z_lce1 / z_lce1_max )
      set z_ff1_norm ( z_ff1 / z_ff1_max )
      set z_zero1_norm ( z_zero1 / z_zero1_max )

      set z_lce2_norm ( z_lce2 / z_lce2_max )
      set z_ff2_norm ( z_ff2 / z_ff2_max )
      set z_zero2_norm ( z_zero2 / z_zero2_max )

      set z_lce3_norm ( z_lce3 / z_lce3_max )
      set z_ff3_norm ( z_ff3 / z_ff3_max )

  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Utility expetation
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To utility_exp_NAT

  normalize-1

  ask households with [flag? = 1][

    if hh_sta != "Low-paid1"[
    ifelse (act11 = true) [set utility_exp_lce1 0][
      if delta1 != 0 [ set utility_exp_lce1 ( ( ((z_lce1_norm * (1 - alpha)) + (e_lce_norm * alpha) ) * (1 - delta1)) + ((K + M1 + (pbc1 / 7)) * delta1) ) ]
      if delta1 = 0  [set utility_exp_lce1 0]]
    ]

    if (act21 = true) [set utility_exp_lce2 0]
    if (act21 = false)[
      if delta2 != 0 [set utility_exp_lce2 ( ( ((z_lce2_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta2)) + ((K + M2 + (pbc2 / 7)) * delta2) )]
      if delta2 = 0 [set utility_exp_lce2 0]]

    ifelse ((act31 = true) or (act32 = true)) [set utility_exp_lce31 0][
      if delta3 != 0 [set utility_exp_lce31  ( ( ((z_lce3_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta3)) + ((K + M3 + (pbc3 / 7)) * delta3) )]
      if delta3 = 0 [set utility_exp_lce31 0]]

    set utility_exp_ff1 0
    set utility_exp_ff2 0
    set utility_exp_ff32 0
    set utility_exp_lce32 0
    set utility_exp_zero1 0
    set utility_exp_zero2 0
   ]

  ask households with [flag? = 0][

    if hh_sta != "Low-paid1"[
    ifelse (act12 = true) [set utility_exp_ff1 0][
      if delta1 != 0 [ set utility_exp_ff1 ( (((z_ff1_norm * (1 - alpha)) + (e_ff_norm * alpha)) * (1 - delta1)) + ((K + M1 + (pbc1 / 7)) * delta1) ) ]
      if delta1 = 0  [set utility_exp_ff1 0]]
    ]

    if (act40 = true) [set utility_exp_ff2 0]
    if (act40 = false)[
      if delta2 != 0 [set utility_exp_ff2  ( ( ((z_ff2_norm * (1 - alpha)) + (e_ff_norm * alpha)) * (1 - delta2)) + ((K + M2 + (pbc2 / 7)) * delta2) )]
      if delta2 = 0 [set utility_exp_ff2 0]]


    ifelse (act32 = true) [set utility_exp_ff32 0][
      if delta3 != 0 [ set utility_exp_ff32  ( ( ((z_ff3_norm * (1 - alpha)) + (e_ff_norm * alpha)) * (1 - delta3))+ ((K + M3 + (pbc3 / 7)) * delta3) )]
      if delta3 = 0 [set utility_exp_ff32 0]]


    set utility_exp_lce1 0
    set utility_exp_lce2 0
    set utility_exp_lce31 0
    set utility_exp_zero1 0
    set utility_exp_zero2 0
    set utility_exp_zero3 0
    ]

  ask households with [flag? = 2][
    if hh_sta != "Low-paid1"[
    ifelse (act11 = true) [set utility_exp_zero1 0][
      if delta1 != 0 [set utility_exp_zero1 ( ( ((z_zero1_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta1)) + ((K + M1 + (pbc1 / 7)) * delta1) ) ]
      if delta1 = 0 [set utility_exp_zero1 0]]
    ]

    ifelse (act21 = true) [set utility_exp_zero2 0][
      if delta2 != 0 [set utility_exp_zero2   ( ( ((z_zero2_norm  * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta2))+ ((K + M2 + (pbc2 / 7)) * delta2) ) ]
      if delta2 = 0  [set utility_exp_zero2 0]]


    ifelse (act31 = true)  [set utility_exp_zero3 0][
      if delta3 != 0 [set utility_exp_zero3 0]
      if delta3 = 0  [set utility_exp_zero3 0]]


    set utility_exp_ff1 0
    set utility_exp_ff2 0
    set utility_exp_ff32 0
    set utility_exp_lce32 0
    set utility_exp_lce1 0
    set utility_exp_lce2 0
    set utility_exp_lce31 0
  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                      ACTIONS
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To action

  ask households [
      if (h_q <= 0) [stop]
      if (h_q > 0) [

        if flag? = 1 [

          if act11 = true [set act1 false]
          if act11 = false[
            if ((utility_exp_lce1 >=  max (list utility_exp_lce1 utility_exp_lce2 utility_exp_lce31)) and (utility_exp_lce1 >= utility_lce1)) [
              set act1 True
              set act11 True
              set hh_actions replace-item 0 hh_actions 1
              set pcolor 14]]

          if act21 = true [set act50 false]
          if act21 = false[
            if ((utility_exp_lce2 >= max (list utility_exp_lce1 utility_exp_lce2 utility_exp_lce31)) and (utility_exp_lce2 >= utility_lce2)) [
               set act21 True
               set act50 True
               set hh_actions replace-item 2 hh_actions 1
               set pcolor 114]]

          if act31 = true [set act3 false]
          if ((act31 = false) and (act32 = false)) [
            if ((utility_exp_lce31 >= max (list utility_exp_lce1 utility_exp_lce2 utility_exp_lce31)) and (utility_exp_lce31 >= utility_lce31)) [
               set act31 True
               set act3 True
               set flag? 2
               set hh_actions replace-item 4 hh_actions 1
               set pcolor 64]]
        ]

      if flag? = 0 [

        if act32 = true [set act3 false]
        if act32 = false[
              if ((utility_exp_ff32 >= max(list utility_exp_ff1 utility_exp_ff2 utility_exp_ff32)) and (utility_exp_ff32 >= utility_ff32)) [
                 set act3 True
                 set act32 True
                 set flag? 1
                 set hh_actions replace-item 5 hh_actions 1
                 set pcolor 45]]

        if act12 = true [set act1 false]
        if act12 = false[
              if ((utility_exp_ff1 >= max(list utility_exp_ff1 utility_exp_ff2 utility_exp_ff32)) and (utility_exp_ff1 >= utility_ff1)) [
                 set act12 True
                 set act1 True
                 set hh_actions replace-item 1 hh_actions 1
                set pcolor 24]]

        if (act40 = false) [if ((utility_exp_ff2 >= max(list utility_exp_ff1 utility_exp_ff2 utility_exp_ff32)) and (utility_exp_ff2 >= utility_ff2)) [
              set act40 True
              set act50 True
              set hh_actions replace-item 3 hh_actions 1
              set pcolor 124]]
        if act40 = true [set act50 false]
        ]

     if flag? = 2 [

          if act11 = true [set act1 false]
          if act11 = false[
            if ((utility_exp_zero1 >=  max(list utility_exp_zero1 utility_exp_zero2)) and (utility_exp_zero1 >= utility_zero1)) [
              set act11 True
              set act1 True
              set hh_actions replace-item 0 hh_actions 1
              set pcolor 14]]
      ]
     ]
    ]

  set noaction count households with [act1 = False and act50 = False and act3 = False]         ;; reporting noactions in each year
  set action_total count households with [((act1 = True) or (act50 = True) or (act3 = True))]  ;; reporting total actions in each year
  set action_cum (action_cum + action_total)                                                   ;; reporting cumulative actions
  set lceuser_share ((lceuser / n_households) * 100)                                           ;; Share of lce user   >> based on actions32 it might change

  set action_1 count households with [act1 = True]                                             ;; global var for action1,2,3 in each time step
  set action_2 count households with [act50 = True]
  set action_31 count households with [((act3 = True) and (flag? = 2))]
  set action_32 count households with [((act3 = True) and (flag? = 1))]
  set action_1_cum (action_1_cum + action_1)                                                   ;; global var for cum action1,2,3
  set action_2_cum (action_2_cum + action_2)
  set action_31_cum (action_31_cum + action_31)
  set action_32_cum (action_32_cum + action_32)

  set action1_p ((action_1 * 100) / n_households)                                              ;; percentage of each actions
  set action2_p ((action_2 * 100) / n_households)
  set action31_p ((action_31 * 100) / n_households)
  set action32_p ((action_32 * 100) / n_households)
  set action3_p (action31_p + action32_p)                                                      ;; action3 together
  set actiont_p ((action_total * 100) / n_households)                                          ;; percentage of HH that did an action in each time step

  set action1_cum_p ((action_1_cum * 100) / n_households)                                      ;; global var for percentage of cum action1,2,3
  set action2_cum_p ((action_2_cum * 100) / n_households)
  set action31_cum_p ((action_31_cum * 100) / n_households)
  set action32_cum_p ((action_32_cum * 100) / n_households)
  set action_cum_p ((action_cum * 100) / n_households)                                         ;; percentage of HH that did an action >> cum

 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; actions based on socio-economic groups
 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;; income groups

  set act1_inc1 count households with [act1 = True and h_id_group = 1]                         ;; households who did the action 1 in each time step, in different income groups
  set act1_inc2 count households with [act1 = True and h_id_group = 2]
  set act1_inc3 count households with [act1 = True and h_id_group = 3]
  set act1_inc4 count households with [act1 = True and h_id_group = 4]
  set act1_inc5 count households with [act1 = True and h_id_group = 5]
  set act1_inc6 count households with [act1 = True and h_id_group = 6]
  set act1_inc7 count households with [act1 = True and h_id_group = 7]

  set act2_inc1 count households with [(act50 = True) and (h_id_group = 1)]                    ;; households who did the action 2 in each time step, in different income groups
  set act2_inc2 count households with [(act50 = True) and (h_id_group = 2)]
  set act2_inc3 count households with [(act50 = True) and (h_id_group = 3)]
  set act2_inc4 count households with [(act50 = True) and (h_id_group = 4)]
  set act2_inc5 count households with [(act50 = True) and (h_id_group = 5)]
  set act2_inc6 count households with [(act50 = True) and (h_id_group = 6)]
  set act2_inc7 count households with [(act50 = True) and (h_id_group = 7)]

  set act3_inc1 count households with [act3 = True and h_id_group = 1]                         ;; households who did the action 3 in each time step, in different income groups
  set act3_inc2 count households with [act3 = True and h_id_group = 2]
  set act3_inc3 count households with [act3 = True and h_id_group = 3]
  set act3_inc4 count households with [act3 = True and h_id_group = 4]
  set act3_inc5 count households with [act3 = True and h_id_group = 5]
  set act3_inc6 count households with [act3 = True and h_id_group = 6]
  set act3_inc7 count households with [act3 = True and h_id_group = 7]

;; Dwelling energy label

  set act1_a count households with [act1 = True and dw_el = 1]                                 ;; households who did the action 1 in each time step
  set act1_b count households with [act1 = True and dw_el = 2]
  set act1_c count households with [act1 = True and dw_el = 3]
  set act1_d count households with [act1 = True and dw_el = 4]
  set act1_e count households with [act1 = True and dw_el = 5]
  set act1_f count households with [act1 = True and dw_el = 6]

  set act2_a count households with [act50 = True and dw_el = 1]                                ;; households who did the action 2 in each time step
  set act2_b count households with [act50 = True and dw_el = 2]
  set act2_c count households with [act50 = True and dw_el = 3]
  set act2_d count households with [act50 = True and dw_el = 4]
  set act2_e count households with [act50 = True and dw_el = 5]
  set act2_f count households with [act50 = True and dw_el = 6]

  set act3_a count households with [act3 = True and dw_el = 1]                                 ;; households who did the action 3 in each time step
  set act3_b count households with [act3 = True and dw_el = 2]
  set act3_c count households with [act3 = True and dw_el = 3]
  set act3_d count households with [act3 = True and dw_el = 4]
  set act3_e count households with [act3 = True and dw_el = 5]
  set act3_f count households with [act3 = True and dw_el = 6]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                      SAVED ENERGY
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; investemtns in terms of money
to save

  if year >= 2016 [                                  ;; from 2016, not at initialization

  ask households[                                    ;; action1
    if (act1 = True) [set invest True]
    if (invest = True and counter <= 10) [           ;; PV installation payback is 10 years
      set h_invest 487.59                            ;; amount of money they invest on this actions with rate of 2% and 10 years
      set h_invest_save (h_invest_save + 1700)
      set counter (counter + 1)]
    set h_invest_total (h_invest * counter)]         ;; how much invest in total

  set invest_total sum [h_invest] of households      ;; per year HOW MUCH money they put for installation (invest on installation) all households
  set invest_cum (invest_cum + invest_total)         ;; cum of above
  set invest_y count households with [act1 = True]   ;; number of HH did action1 in that year

  ask households[                                    ;; action2
    if (act50 = True) [
      set h_conserv (h_q * 0.5)                      ;; based on ENERGYSTAR HH could save 12% in avarege of their electiricity consumption per year  >> But here we assumed 5%
      if flag? = 1[
        set h_conserv_p (h_conserv * m_p_lce)]       ;; per year how much money they saved based on the action
      if flag? = 0[
        set h_conserv_p (h_conserv * m_p_ff)]
      if flag? = 2[
        set h_conserv_p 0]]]

  set conserv_total sum [h_conserv_p] of households  ;; how much they saved money per year in total by action2
  set conserv_cum ( conserv_cum + conserv_total)     ;; cum of above
  set conserv_e sum [h_conserv] of households        ;; per year how much electricity is saved based on HH conservation
  set conserv_y count households with [act50 = True]  ;; number of HH did action2 in that year

  ask households[                                    ;; action32
    if act32 = True[
      set h_switch ((m_p_lce - m_p_ff) * h_q)]]       ;; each HH save money based on switching

  set switch_total sum [h_switch] of households      ;; how much they saved money per year in total by action32
  set switch_cum (switch_cum + switch_total)         ;; cum of above
  set switch_y count households with [act32 = True or act31 = True]

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; calculate total saved energy
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  set energy_sav ((invest_y * 1700) + conserv_e)     ;; 1700 is based on http://www.theecoexperts.co.uk/how-much-electricity-does-average-solar-panel-system-generate and 2KW size
  set energy_sav_cum (energy_sav_cum + energy_sav)   ;; cum of above

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; saved energy and socio-economic groups
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; income groups
  ask households[
    if (act50 = True and h_id_group = 1) [           ;; saved energy based on action2 (conservation) and income groups
      set h_conserv_1 (h_q * 0.5)]
    if (act50 = True and h_id_group = 2) [
      set h_conserv_2 (h_q * 0.5)]
    if (act50 = True and h_id_group = 3) [
      set h_conserv_3 (h_q * 0.5)]
    if (act50 = True and h_id_group = 4) [
      set h_conserv_4 (h_q * 0.5)]
    if (act50 = True and h_id_group = 5) [
      set h_conserv_5 (h_q * 0.5)]
    if (act50 = True and h_id_group = 6) [
      set h_conserv_6 (h_q * 0.5)]
    if (act50 = True and h_id_group = 7) [
      set h_conserv_7 (h_q * 0.5)]]

  set conserv_e_1 sum [h_conserv_1] of households    ;; total saved energy per year based on action2 in each income groups
  set conserv_e_2 sum [h_conserv_2] of households
  set conserv_e_3 sum [h_conserv_3] of households
  set conserv_e_4 sum [h_conserv_4] of households
  set conserv_e_5 sum [h_conserv_5] of households
  set conserv_e_6 sum [h_conserv_6] of households
  set conserv_e_7 sum [h_conserv_7] of households

  set energy_sav_inc1 ((act1_inc1 * 1700) + conserv_e_1)
  set energy_sav_inc1_cum (energy_sav_inc1_cum + energy_sav_inc1)

  set energy_sav_inc2 ((act1_inc2 * 1700) + conserv_e_2)
  set energy_sav_inc2_cum (energy_sav_inc2_cum + energy_sav_inc2)

  set energy_sav_inc3 ((act1_inc3 * 1700) + conserv_e_3)
  set energy_sav_inc3_cum (energy_sav_inc3_cum + energy_sav_inc3)

  set energy_sav_inc4 ((act1_inc4 * 1700) + conserv_e_4)
  set energy_sav_inc4_cum (energy_sav_inc4_cum + energy_sav_inc4)

  set energy_sav_inc5 ((act1_inc5 * 1700) + conserv_e_5)
  set energy_sav_inc5_cum (energy_sav_inc5_cum + energy_sav_inc5)

  set energy_sav_inc6 ((act1_inc6 * 1700) + conserv_e_6)
  set energy_sav_inc6_cum (energy_sav_inc6_cum + energy_sav_inc6)

  set energy_sav_inc7 ((act1_inc7 * 1700) + conserv_e_7)
  set energy_sav_inc7_cum (energy_sav_inc7_cum + energy_sav_inc7)

;; for debugging
  set energy_sav_income (energy_sav_inc1 + energy_sav_inc2 + energy_sav_inc3 + energy_sav_inc4 + energy_sav_inc5 + energy_sav_inc6 + energy_sav_inc7)

;; dwelling energy label
  ask households[                                                  ;; saved energy based on action2 (conservation) and energy label of HH
    if ((act50 = True) and dw_el = 1) [
      set h_conserv_a (h_q * 0.5)]
    if ((act50 = True) and dw_el = 2) [
      set h_conserv_b (h_q * 0.5)]
    if ((act50 = True) and dw_el = 3) [
      set h_conserv_c (h_q * 0.5)]
    if ((act50 = True) and dw_el = 4) [
      set h_conserv_d (h_q * 0.5)]
    if ((act50 = True) and dw_el = 5) [
      set h_conserv_e (h_q * 0.5)]
    if ((act50 = True) and dw_el = 6) [
      set h_conserv_f (h_q * 0.5)]]

  set conserv_e_a sum [h_conserv_a] of households                 ;; total saved energy per year based on action2 in each energy label groups
  set conserv_e_b sum [h_conserv_b] of households
  set conserv_e_c sum [h_conserv_c] of households
  set conserv_e_d sum [h_conserv_d] of households
  set conserv_e_e sum [h_conserv_e] of households
  set conserv_e_f sum [h_conserv_f] of households

  set energy_sav_a ((act1_a * 1700) + conserv_e_a)                ;; total saved energy per year and cum based on action1 and 2 in each energy label groups
  set energy_sav_a_cum (energy_sav_a_cum + energy_sav_a)

  set energy_sav_b ((act1_b * 1700) + conserv_e_b)
  set energy_sav_b_cum (energy_sav_b_cum + energy_sav_b)

  set energy_sav_c ((act1_c * 1700) + conserv_e_c)
  set energy_sav_c_cum (energy_sav_c_cum + energy_sav_c)

  set energy_sav_d ((act1_d * 1700) + conserv_e_d)
  set energy_sav_d_cum (energy_sav_d_cum + energy_sav_d)

  set energy_sav_e ((act1_e * 1700) + conserv_e_e)
  set energy_sav_e_cum (energy_sav_e_cum + energy_sav_e)

  set energy_sav_f ((act1_f * 1700) + conserv_e_f)
  set energy_sav_f_cum (energy_sav_f_cum + energy_sav_f)

;; for debugging
  set energy_sav_lable (energy_sav_a + energy_sav_b + energy_sav_c + energy_sav_d + energy_sav_e + energy_sav_f)
  ]

  draw_actions1
  draw_actions2
  draw_total_actions
  draw_investments
  draw_savings

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                             CO2 and Air Pollutant Emissions
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To emissions

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              Avioded emissions
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Electricity: emission factor for grey consumption (coal power plant) : 250 * 10E-9 T/Kj    >> 0.0009 T/Kwh ,  emission factor for green consumption (gas power plant) : 100 * 10E-9 T/Kj  >> 0.0003 T/Kwh

  if year >= 2016 [
;; --- grey HH
  ask households[
    if ((act1 = True) and (flag? = 0))[
        if h_q >= 1700 [set sav_1_ff 1700]                                     ;; save energy by grey each households and PV installation each year
        if h_q < 1700 [set sav_1_ff h_q]]]
    set energy_sav_1_ff (sum [sav_1_ff] of households)                         ;; save energy by total grey households and PV installation each year
  set co2_1_ff (energy_sav_1_ff * 0.0009)                                      ;; avoid CO2 emission(T) by grey HH PV installation
  set co2_1_ff_cum (co2_1_ff_cum + co2_1_ff)                                   ;; cumulative of households

  ask households[
    if ((act50 = True) and (flag? = 0))[
      set sav_2_ff (h_q * 0.5)]]                                               ;; save energy by grey households conservation each year
  set energy_sav_2_ff (sum [sav_2_ff] of households)                           ;; sum of HH above
  set co2_2_ff (energy_sav_2_ff * 0.0009)                                      ;; avoid CO2 emission(T) by grey HH conservation
  set co2_2_ff_cum (co2_2_ff_cum + co2_2_ff)

  ask households[
    if ((act3 = True) and (flag? = 1))[
      set sav_3_ff h_q ]]                                                       ;; energy consumption of HH that switch from grey to green
  set energy_sav_3_ff (sum [sav_3_ff] of households)                            ;; sum of HH above
  set co2_3_ff  (energy_sav_3_ff * 0.0009)                                      ;; avoid CO2 emission(T) by grey HH switching to green
  set co2_3_ff_cum (co2_3_ff_cum + co2_3_ff)

;; --- green HH
  ask households[
    if ((act1 = True) and (flag? = 1))[                                         ;; save energy by green households and PV installation
        if h_q >= 1700 [set sav_1_lce 1700]
          if h_q < 1700 [set sav_1_lce h_q]]]
  set energy_sav_1_lce (sum [sav_1_lce] of households)                          ;; save energy by green households and PV installation
  set co2_1_lce (energy_sav_1_lce * 0.0003)                                     ;; avoid CO2 emission(T) by green HH PV installation
  set co2_1_lce_cum (co2_1_lce_cum + co2_1_lce)

  ask households[                                                               ;; save energy by green households and conservation
    if ((act40 = True) and (flag? = 1))[
      set sav_2_lce (h_q * 0.5)]]
  set energy_sav_2_lce sum [sav_2_lce] of households                            ;; sum of HH above
  set co2_2_lce (energy_sav_2_lce * 0.0003)                                     ;; avoid CO2 emission(T) by green HH conservation
  set co2_2_lce_cum (co2_2_lce_cum + co2_2_lce)

  ask households[                                                               ;; energy consumption of HH that switch to greener
    if ((act3 = True) and (flag? = 2))[
       set sav_3_lce h_q ]]
  set energy_sav_3_lce sum [sav_3_lce] of households                            ;; sum of HH above
  set co2_3_lce (energy_sav_3_lce * 0.0003)                                     ;; avoid CO2 emission(T) by green HH switching to greener
  set co2_3_lce_cum (co2_3_lce_cum + co2_3_lce)

;; total emissions
  set co2_av (co2_1_ff + co2_2_ff + co2_3_ff + co2_1_lce + co2_2_lce + co2_3_lce)
  set co2_av_cum (co2_1_ff_cum + co2_2_ff_cum + co2_3_ff_cum + co2_1_lce_cum + co2_2_lce_cum + co2_3_lce_cum)

  set test1 (energy_sav_1_ff + energy_sav_2_ff + energy_sav_3_ff + energy_sav_1_lce + energy_sav_2_lce + energy_sav_3_lce)
  set test2 (test2 + test1)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avioded emissions and socio-economic groups
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;---------------------------------------------INCOME GROUP 1
;; grey

  ask households[                                                               ;; action1
    if ((act1 = True) and (flag? = 0) and (h_id_group = 1))[
            if h_q >= 1700 [set sav_1_ff_inc1 1700]
            if h_q < 1700  [set sav_1_ff_inc1 h_q]]]
  set energy_sav_1_ff_inc1 sum [sav_1_ff_inc1] of households
  set co2_1_ff_inc1 (energy_sav_1_ff_inc1 * 0.0009)
  set co2_1_ff_cum_inc1 (co2_1_ff_cum_inc1 + co2_1_ff_inc1)                     ;; cum avoid CO2 emission in Ton

  ask households[                                                               ;; action2
    if ((act50 = True) and (flag? = 0) and (h_id_group = 1))[
      set sav_2_ff_inc1 (h_q * 0.5)]]                                           ;; save energy each year
  set energy_sav_2_ff_inc1 sum [sav_2_ff_inc1] of households                    ;; sum of HH above
  set co2_2_ff_inc1 (energy_sav_2_ff_inc1 * 0.0009)
  set co2_2_ff_cum_inc1 (co2_2_ff_cum_inc1 + co2_2_ff_inc1)

  ask households[                                                               ;; action3
    if ((act3 = True) and (flag? = 1) and (h_id_group = 1))[
      set sav_3_ff_inc1 h_q ]]                                                  ;; energy consumption of HH that switch from grey to green
  set energy_sav_3_ff_inc1 sum [sav_3_ff_inc1] of households                    ;; sum of HH above
  set co2_3_ff_inc1 (energy_sav_3_ff_inc1 * 0.0009)
  set co2_3_ff_cum_inc1 (co2_3_ff_cum_inc1 + co2_3_ff_inc1)

 ;; green
  ask households[                                                               ;; action1
    if ((act1 = True) and (flag? = 1) and (h_id_group = 1))[
            if h_q >= 1700 [set sav_1_lce_inc1 1700]
          if h_q < 1700  [set sav_1_lce_inc1 h_q]]]
  set energy_sav_1_lce_inc1 sum [sav_1_lce_inc1] of households
  set co2_1_lce_inc1 (energy_sav_1_lce_inc1 * 0.0003)
  set co2_1_lce_cum_inc1 (co2_1_lce_cum_inc1 + co2_1_lce_inc1)

  ask households[                                                               ;; action2
    if ((act50 = True)and (flag? = 1) and (h_id_group = 1))[
      set sav_2_lce_inc1 (h_q * 0.5)]]
  set energy_sav_2_lce_inc1 sum [sav_2_lce_inc1] of households
  set co2_2_lce_inc1 (energy_sav_2_lce_inc1 * 0.0003)
  set co2_2_lce_cum_inc1 (co2_2_lce_cum_inc1 + co2_2_lce_inc1)

  ask households[                                                               ;; action3
    if ((act3 = True) and (flag? = 2) and (h_id_group = 1))[
      set sav_3_lce_inc1 h_q ]]
  set energy_sav_3_lce_inc1 sum [sav_3_lce_inc1] of households
  set co2_3_lce_inc1 (energy_sav_3_lce_inc1 * 0.0003)
  set co2_3_lce_cum_inc1 (co2_3_lce_cum_inc1 + co2_3_lce_inc1)

 ;; total emissions of income 1
  set co2_av_inc1 (co2_1_ff_inc1 + co2_2_ff_inc1 + co2_3_ff_inc1 + co2_1_lce_inc1 + co2_2_lce_inc1 + co2_3_lce_inc1)
  set co2_av_cum_inc1 (co2_av_cum_inc1 + co2_av_inc1)

;;---------------------------------------------INCOME GROUP 2
;; grey
  ask households[                                                               ;; action1
    if ((act1 = True) and (flag? = 0) and (h_id_group = 2))[
            if h_q >= 1700 [set sav_1_ff_inc2 1700]
          if h_q < 1700  [set sav_1_ff_inc2 h_q]]]                                                   ;; save energy each year
  set energy_sav_1_ff_inc2 sum [sav_1_ff_inc2] of households
  set co2_1_ff_inc2 (energy_sav_1_ff_inc2 * 0.0009)
  set co2_1_ff_cum_inc2 (co2_1_ff_cum_inc2 + co2_1_ff_inc2)

  ask households[                                                               ;; action2
    if ((act50 = True) and (flag? = 0) and (h_id_group = 2))[
      set sav_2_ff_inc2 (h_q * 0.5)]]                                           ;; save energy each year
  set energy_sav_2_ff_inc2 sum [sav_2_ff_inc2] of households                    ;; sum of HH above
  set co2_2_ff_inc2 (energy_sav_2_ff_inc2 * 0.0009)
  set co2_2_ff_cum_inc2 (co2_2_ff_cum_inc2 + co2_2_ff_inc2)

  ask households[                                                               ;; action3
    if ((act3 = True) and (flag? = 1) and (h_id_group = 2))[
      set sav_3_ff_inc2 h_q ]]                                                  ;; energy consumption of HH that switch from grey to green
  set energy_sav_3_ff_inc2 sum [sav_3_ff_inc2] of households                    ;; sum of HH above
  set co2_3_ff_inc2 (energy_sav_3_ff_inc2 * 0.0009)
  set co2_3_ff_cum_inc2 (co2_3_ff_cum_inc2 + co2_3_ff_inc2)

 ;; green
  ask households[
    if ((act1 = True) and (flag? = 1) and (h_id_group = 2))[
            if h_q >= 1700 [set sav_1_lce_inc2 1700]
          if h_q < 1700  [set sav_1_lce_inc2 h_q]]]
  set energy_sav_1_lce_inc2 sum [sav_1_lce_inc2] of households
  set co2_1_lce_inc2 (energy_sav_1_lce_inc2 * 0.0003)
  set co2_1_lce_cum_inc2 (co2_1_lce_cum_inc2 + co2_1_lce_inc2)

  ask households[
    if ((act50 = True) and (flag? = 1) and (h_id_group = 2))[
      set sav_2_lce_inc2 (h_q * 0.5)]]
  set energy_sav_2_lce_inc2 sum [sav_2_lce_inc2] of households
  set co2_2_lce_inc2 (energy_sav_2_lce_inc2 * 0.0003)
  set co2_2_lce_cum_inc2 (co2_2_lce_cum_inc2 + co2_2_lce_inc2)

  ask households[
    if ((act3 = True) and (flag? = 2) and (h_id_group = 2))[
      set sav_3_lce_inc2 h_q ]]
  set energy_sav_3_lce_inc2 sum [sav_3_lce_inc2] of households
  set co2_3_lce_inc2 (energy_sav_3_lce_inc2 * 0.0003)
  set co2_3_lce_cum_inc2 (co2_3_lce_cum_inc2 + co2_3_lce_inc2)

 ;; total emissions of income 2
  set co2_av_inc2 (co2_1_ff_inc2 + co2_2_ff_inc2 + co2_3_ff_inc2 + co2_1_lce_inc2 + co2_2_lce_inc2 + co2_3_lce_inc2)
  set co2_av_cum_inc2 (co2_av_cum_inc2 + co2_av_inc2)

;;---------------------------------------------INCOME GROUP 3
;; grey
  ask households[
    if ((act1 = True) and (flag? = 0) and (h_id_group = 3))[
            if h_q >= 1700 [set sav_1_ff_inc3 1700]
          if h_q < 1700  [set sav_1_ff_inc3 h_q]]]
  set energy_sav_1_ff_inc3 sum [sav_1_ff_inc3] of households
  set co2_1_ff_inc3 (energy_sav_1_ff_inc3 * 0.0009)
  set co2_1_ff_cum_inc3 (co2_1_ff_cum_inc3 + co2_1_ff_inc3)

  ask households[
    if ((act50 = True) and (flag? = 0) and (h_id_group = 3))[
      set sav_2_ff_inc3 (h_q * 0.5)]]
  set energy_sav_2_ff_inc3 sum [sav_2_ff_inc3] of households
  set co2_2_ff_inc3 (energy_sav_2_ff_inc3 * 0.0009)
  set co2_2_ff_cum_inc3 (co2_2_ff_cum_inc3 + co2_2_ff_inc3)

  ask households[
    if ((act3 = True) and (flag? = 1) and (h_id_group = 3))[
      set sav_3_ff_inc3 h_q ]]
  set energy_sav_3_ff_inc3 sum [sav_3_ff_inc3] of households
  set co2_3_ff_inc3 (energy_sav_3_ff_inc3 * 0.0009)
  set co2_3_ff_cum_inc3 (co2_3_ff_cum_inc3 + co2_3_ff_inc3)

 ;; green
  ask households[
    if ((act1 = True) and (flag? = 1) and (h_id_group = 3))[
            if h_q >= 1700 [set sav_1_lce_inc3 1700]
          if h_q < 1700  [set sav_1_lce_inc3 h_q] ]]
  set energy_sav_1_lce_inc3 sum [sav_1_lce_inc3] of households
  set co2_1_lce_inc3 (energy_sav_1_lce_inc3 * 0.0003)
  set co2_1_lce_cum_inc3 (co2_1_lce_cum_inc3 + co2_1_lce_inc3)

  ask households[
    if ((act50 = True) and (flag? = 1) and (h_id_group = 3))[
      set sav_2_lce_inc3 (h_q * 0.5)]]
  set energy_sav_2_lce_inc3 sum [sav_2_lce_inc3] of households
  set co2_2_lce_inc3 (energy_sav_2_lce_inc3 * 0.0003)
  set co2_2_lce_cum_inc3 (co2_2_lce_cum_inc3 + co2_2_lce_inc3)

  ask households[
    if ((act3 = True) and (flag? = 2) and (h_id_group = 3))[
      set sav_3_lce_inc3 h_q ]]
  set energy_sav_3_lce_inc3 sum [sav_3_lce_inc3] of households
  set co2_3_lce_inc3 (energy_sav_3_lce_inc3 * 0.0003)
  set co2_3_lce_cum_inc3 (co2_3_lce_cum_inc3 + co2_3_lce_inc3)

 ;; total emissions of income 3
  set co2_av_inc3 (co2_1_ff_inc3 + co2_2_ff_inc3 + co2_3_ff_inc3 + co2_1_lce_inc3 + co2_2_lce_inc3 + co2_3_lce_inc3)
  set co2_av_cum_inc3 (co2_av_cum_inc3 + co2_av_inc3)

;;---------------------------------------------INCOME GROUP 4
;; grey
  ask households[
    if ((act1 = True) and (flag? = 0) and (h_id_group = 4))[
            if h_q >= 1700 [set sav_1_ff_inc4 1700]
          if h_q < 1700  [set sav_1_ff_inc4 h_q] ]]
  set energy_sav_1_ff_inc4 sum [sav_1_ff_inc4] of households
  set co2_1_ff_inc4 (energy_sav_1_ff_inc4 * 0.0009)
  set co2_1_ff_cum_inc4 (co2_1_ff_cum_inc4 + co2_1_ff_inc4)

  ask households[
    if ((act50 = True) and (flag? = 0) and (h_id_group = 4))[
      set sav_2_ff_inc4 (h_q * 0.5)]]
  set energy_sav_2_ff_inc4 sum [sav_2_ff_inc4] of households
  set co2_2_ff_inc4 (energy_sav_2_ff_inc4 * 0.0009)
  set co2_2_ff_cum_inc4 (co2_2_ff_cum_inc4 + co2_2_ff_inc4)

  ask households[
    if ((act3 = True) and (flag? = 1) and (h_id_group = 4))[
      set sav_3_ff_inc4 h_q ]]
  set energy_sav_3_ff_inc4 sum [sav_3_ff_inc4] of households
  set co2_3_ff_inc4 (energy_sav_3_ff_inc4 * 0.0009)
  set co2_3_ff_cum_inc4 (co2_3_ff_cum_inc4 + co2_3_ff_inc4)

 ;; green
  ask households[
    if ((act1 = True) and (flag? = 1) and (h_id_group = 4))[
            if h_q >= 1700 [set sav_1_lce_inc4 1700]
          if h_q < 1700  [set sav_1_lce_inc4 h_q]] ]
  set energy_sav_1_lce_inc4 sum [sav_1_lce_inc4] of households
  set co2_1_lce_inc4 (energy_sav_1_lce_inc4 * 0.0003)
  set co2_1_lce_cum_inc4 (co2_1_lce_cum_inc4 + co2_1_lce_inc4)

  ask households[
    if ((act50 = True) and (flag? = 1) and (h_id_group = 4))[
      set sav_2_lce_inc4 (h_q * 0.5)]]
  set energy_sav_2_lce_inc4 sum [sav_2_lce_inc4] of households
  set co2_2_lce_inc4 (energy_sav_2_lce_inc4 * 0.0003)
  set co2_2_lce_cum_inc4 (co2_2_lce_cum_inc4 + co2_2_lce_inc4)

  ask households[
    if ((act3 = True) and (flag? = 2) and (h_id_group = 4))[
      set sav_3_lce_inc4 h_q ]]
  set energy_sav_3_lce_inc4 sum [sav_3_lce_inc4] of households
  set co2_3_lce_inc4 (energy_sav_3_lce_inc4 * 0.0003)
  set co2_3_lce_cum_inc4 (co2_3_lce_cum_inc4 + co2_3_lce_inc4)

 ;; total emissions of income 4
  set co2_av_inc4 (co2_1_ff_inc4 + co2_2_ff_inc4 + co2_3_ff_inc4 + co2_1_lce_inc4 + co2_2_lce_inc4 + co2_3_lce_inc4)
  set co2_av_cum_inc4 (co2_av_cum_inc4 + co2_av_inc4)

;;---------------------------------------------INCOME GROUP 5,6,7
;; grey
  ask households[
    if (((act1 = True) and (flag? = 0)) and ((h_id_group = 7) or (h_id_group = 5) or (h_id_group = 6)))[
            if h_q >= 1700 [set sav_1_ff_inc5 1700]
          if h_q < 1700  [set sav_1_ff_inc5 h_q]] ]
  set energy_sav_1_ff_inc5 sum [sav_1_ff_inc5] of households
  set co2_1_ff_inc5 (energy_sav_1_ff_inc5 * 0.0009)
  set co2_1_ff_cum_inc5 (co2_1_ff_cum_inc5 + co2_1_ff_inc5)

  ask households[
    if (((act50 = True) and (flag? = 0)) and ((h_id_group = 7) or (h_id_group = 5) or (h_id_group = 6)))[
      set sav_2_ff_inc5 (h_q * 0.5)]]
  set energy_sav_2_ff_inc5 sum [sav_2_ff_inc5] of households
  set co2_2_ff_inc5 (energy_sav_2_ff_inc5 * 0.0009)
  set co2_2_ff_cum_inc5 (co2_2_ff_cum_inc5 + co2_2_ff_inc5)

  ask households[
    if (((act3 = True) and (flag? = 1)) and ((h_id_group = 7) or (h_id_group = 5) or (h_id_group = 6)))[
      set sav_3_ff_inc5 h_q ]]
  set energy_sav_3_ff_inc5 sum [sav_3_ff_inc5] of households
  set co2_3_ff_inc5 (energy_sav_3_ff_inc5 * 0.0009)
  set co2_3_ff_cum_inc5 (co2_3_ff_cum_inc5 + co2_3_ff_inc5)

 ;; green
  ask households[
    if (((act1 = True) and (flag? = 1)) and ((h_id_group = 7) or (h_id_group = 5) or (h_id_group = 6)))[
            if h_q >= 1700 [set sav_1_lce_inc5 1700]
          if h_q < 1700  [set sav_1_lce_inc5 h_q]] ]
  set energy_sav_1_lce_inc5 sum [sav_1_lce_inc5] of households
  set co2_1_lce_inc5 (energy_sav_1_lce_inc5 * 0.0003)
  set co2_1_lce_cum_inc5 (co2_1_lce_cum_inc5 + co2_1_lce_inc5)

  ask households[
    if (((act50 = True) and (flag? = 1)) and ((h_id_group = 7) or (h_id_group = 5) or (h_id_group = 6)))[
      set sav_2_lce_inc5 (h_q * 0.5)]]
  set energy_sav_2_lce_inc5 sum [sav_2_lce_inc5] of households
  set co2_2_lce_inc5 (energy_sav_2_lce_inc5 * 0.0003)
  set co2_2_lce_cum_inc5 (co2_2_lce_cum_inc5 + co2_2_lce_inc5)

  ask households[
    if (((act3 = True) and (flag? = 2)) and ((h_id_group = 7) or (h_id_group = 5) or (h_id_group = 6)))[
      set sav_3_lce_inc5 h_q ]]
  set energy_sav_3_lce_inc5 sum [sav_3_lce_inc5] of households
  set co2_3_lce_inc5 (energy_sav_3_lce_inc5 * 0.0003)
  set co2_3_lce_cum_inc5 (co2_3_lce_cum_inc5 + co2_3_lce_inc5)

 ;; total emissions of income 5
  set co2_av_inc5 (co2_1_ff_inc5 + co2_2_ff_inc5 + co2_3_ff_inc5 + co2_1_lce_inc5 + co2_2_lce_inc5 + co2_3_lce_inc5)
  set co2_av_cum_inc5 (co2_av_cum_inc5 + co2_av_inc5)


  draw_emissions


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emissions by HH total electricity consumption
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;----- Total CO2 emission by HH electrcity consumption

  set co2_total ((h_totalff * 0.0009) + (h_totallce * 0.0003))
  set co2_percapita ( co2_total / n_households)                      ;; per capita

;;----- total consumption based on income groups and the primary source of electricity

  set  h_totalff_inc1 sum [h_q] of households with [(flag? = 0) and (h_id_group = 1)]
  set  h_totalff_inc2 sum [h_q] of households with [(flag? = 0) and (h_id_group = 2)]
  set  h_totalff_inc3 sum [h_q] of households with [(flag? = 0) and (h_id_group = 3)]
  set  h_totalff_inc4 sum [h_q] of households with [(flag? = 0) and (h_id_group = 4)]
  set  h_totalff_inc5 sum [h_q] of households with [(flag? = 0) and (h_id_group = 5)]
  set  h_totalff_inc6 sum [h_q] of households with [(flag? = 0) and (h_id_group = 6)]
  set  h_totalff_inc7 sum [h_q] of households with [(flag? = 0) and (h_id_group = 7)]

  set  h_totallce_inc1 sum [h_q] of households with [((flag? = 1) or (flag? = 2)) and (h_id_group = 1)]
  set  h_totallce_inc2 sum [h_q] of households with [((flag? = 1) or (flag? = 2)) and (h_id_group = 2)]
  set  h_totallce_inc3 sum [h_q] of households with [((flag? = 1) or (flag? = 2)) and (h_id_group = 3)]
  set  h_totallce_inc4 sum [h_q] of households with [((flag? = 1) or (flag? = 2)) and (h_id_group = 4)]
  set  h_totallce_inc5 sum [h_q] of households with [((flag? = 1) or (flag? = 2)) and (h_id_group = 5)]
  set  h_totallce_inc6 sum [h_q] of households with [((flag? = 1) or (flag? = 2)) and (h_id_group = 6)]
  set  h_totallce_inc7 sum [h_q] of households with [((flag? = 1) or (flag? = 2)) and (h_id_group = 7)]

  set co2_total_inc1 ((h_totalff_inc1 * 0.0009) + (h_totallce_inc1 * 0.0003))
  set co2_total_inc2 ((h_totalff_inc2 * 0.0009) + (h_totallce_inc2 * 0.0003))
  set co2_total_inc3 ((h_totalff_inc3 * 0.0009) + (h_totallce_inc3 * 0.0003))
  set co2_total_inc4 ((h_totalff_inc4 * 0.0009) + (h_totallce_inc4 * 0.0003))
  set co2_total_inc5 ((h_totalff_inc5 * 0.0009) + (h_totallce_inc5 * 0.0003))
  set co2_total_inc6 ((h_totalff_inc6 * 0.0009) + (h_totallce_inc6 * 0.0003))
  set co2_total_inc7 ((h_totalff_inc7 * 0.0009) + (h_totallce_inc7 * 0.0003))

  set co2_percapita_inc1 ( co2_total_inc1 / (count households with [h_id_group = 1]))
  set co2_percapita_inc2 ( co2_total_inc2 / (count households with [h_id_group = 2]))
  set co2_percapita_inc3 ( co2_total_inc3 / (count households with [h_id_group = 3]))
  set co2_percapita_inc4 ( co2_total_inc4 / (count households with [h_id_group = 4]))
  set co2_percapita_inc5 ( co2_total_inc5 / (count households with [h_id_group = 5]))
  set co2_percapita_inc6 ( co2_total_inc6 / (count households with [h_id_group = 6]))
  set co2_percapita_inc7 ( co2_total_inc7 / (count households with [h_id_group = 7]))
  ]

end

; #####################################################################################
; #################################### Updates ########################################
; #####################################################################################

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         Real utilities
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To normalize-2       ;; calculate E and Z

  ask households[
    if (h_q > 0)[

      set z_lce (h_income - ( (h_q * m_p_lce) + (h_invest_save * m_p_lce) + h_invest + h_conserv_p + h_switch))
      set z_ff  (h_income - ( (h_q * m_p_lce) + (h_invest_save * m_p_ff) + h_invest + h_conserv_p + h_switch ))
      set z_zero (h_income - ( (h_q * m_p_lce) + (h_invest_save * m_p_lce) + h_invest + h_conserv_p + h_switch ))

    if z_ff < 0 [
       set hh_sta "Low-paid"]
    if z_lce < 0 [
       set hh_sta "Low-paid"]
    if z_zero < 0 [
       set hh_sta "Low-paid"]]
  ]

;;; Normalizing procedure

  set z_lce_max max [z_lce] of households
  set z_ff_max max [z_ff] of households
  set z_zero_max max [z_zero] of households
  set e_lce_max max [h_q] of households                ;; find the max of "consumption" in order to normalize the values later
  set e_ff_max max [h_q] of households

  ask households [
   set z_lce_norm (z_lce / z_lce_max)                  ;; calculate normalized "Z"
   set z_ff_norm (z_ff / z_ff_max )
   set z_zero_norm (z_zero / z_zero_max )
   set e_lce_norm ( h_q / e_lce_max)                   ;; calculate normalized "consumption"
   set e_ff_norm ( h_q / e_ff_max )
  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Utility Real
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To update_utilities_NAT

  normalize-2

  ask households [
      set utility_lce1 ( ( ((z_lce_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta1)) + ((K + M1) * delta1) )
      set utility_lce2 ( ( ((z_lce_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta2)) + ((K + M2) * delta2) )
      set utility_lce31( ( ((z_lce_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta3)) + ((K + M3) * delta3) )

      set utility_ff1  ( ( ((z_ff_norm * (1 - alpha)) + (e_ff_norm * alpha)) * (1 - delta1)) + ((K + M1) * delta1) )
      set utility_ff2 ( ( ((z_ff_norm * (1 - alpha)) + (e_ff_norm * alpha)) * (1 - delta2)) + ((K + M2) * delta2 ) )
      set utility_ff32 ( ( ((z_ff_norm * (1 - alpha)) + (e_ff_norm * alpha)) * (1 - delta3)) + ((K + M3) * delta3) )


      set utility_zero1 ( ( ((z_zero_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta1)) + ((K + M1) * delta1) )
      set utility_zero2 ( ( ((z_zero_norm * (1 - alpha)) + (e_lce_norm * alpha)) * (1 - delta2)) + ((K + M2) * delta2) )
    ]

;  set utility_lce (sum [utility_lce1] of households + sum [utility_lce2] of households + sum [utility_lce31] of households)
;  set utility_ff  (sum [utility_ff1] of households + sum [utility_ff2] of households + sum [utility_ff32] of households)

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         Satisfactory
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To satisfy

 if year >= 2017 [
  ask households[
    if ((act1 = True) and (flag? = 1))[
      ifelse (utility_lce1 >= utility_exp_lce1)[set satisfied "keepact1"]
        [set satisfied "regretact1"]]
    if ((act1 = True) and (flag? = 0)) [
      ifelse (utility_ff1 >= utility_exp_ff1)[set satisfied "keepact1"]
        [set satisfied "regretact1"]]
    if ((act1 = True) and (flag? = 2)) [
      ifelse (utility_zero1 >= utility_exp_zero1)[set satisfied "keepact1"]
        [set satisfied "regretact1"]]

    if ((act50 = True) and (flag? = 1)) [
      ifelse (utility_lce2 >= utility_exp_lce2)[set satisfied "keepact2"]
        [set satisfied "regretact2"]]
    if ((act50 = True) and (flag? = 0)) [
      ifelse (utility_ff2 >= utility_exp_ff2)[set satisfied "keepact2"]
        [set satisfied "regretact2"]]

    if ((act3 = True) and (flag? = 2)) [
      ifelse (utility_lce31 >= utility_exp_lce31)[set satisfied "keepact3"]
        [set satisfied "regretact3"]]
    if ((act3 = True) and (flag? = 1)) [
      ifelse (utility_lce32 >= utility_exp_lce32)[set satisfied "keepact3"]
        [set satisfied "regretact3"]]
    ]
  ]
  draw_satisfaction

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Carbon price awareness
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To cpinfo

  if year >= 2016[

    if Policy = "Carbon price pressure-10" [
      ask households[
        if (know < 6.5) [set know (know + (know * 0.01)) ]
        if (cee_aw < 6.5) [set cee_aw (cee_aw + (cee_aw * 0.01))]
        if (ed_aw < 6.5) [set ed_aw (ed_aw + (ed_aw * 0.01))]
        if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.02 * su_nor1))]
        if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.02 * su_nor2))]
        if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.02 * su_nor3))]
        if (pbc1 < 6.5) [set pbc1 (pbc1 + (0.02 * pbc1))]
        if (pbc2 < 6.5) [set pbc2 (pbc2 + (0.02 * pbc2))]
        if (pbc3 < 6.5) [set pbc3 (pbc3 + (0.02 * pbc3))]
    ]]

    if Policy = "Carbon price pressure-25" [
      ask households[
        if (know < 6.5) [set know (know + (know * 0.02)) ]
        if (cee_aw < 6.5) [set cee_aw (cee_aw + (cee_aw * 0.02))]
        if (ed_aw < 6.5) [set ed_aw (ed_aw + (ed_aw * 0.02))]
        if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.04 * su_nor1))]
        if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.04 * su_nor2))]
        if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.04 * su_nor3))]
        if (pbc1 < 6.5) [set pbc1 (pbc1 + (0.03 * pbc1))]
        if (pbc2 < 6.5) [set pbc2 (pbc2 + (0.03 * pbc2))]
        if (pbc3 < 6.5) [set pbc3 (pbc3 + (0.03 * pbc3))]
      ]]

    if Policy = "Carbon price pressure-50" [
      ask households[
        if (know < 6.5) [set know (know + (know * 0.04)) ]
        if (cee_aw < 6.5) [set cee_aw (cee_aw + (cee_aw * 0.04))]
        if (ed_aw < 6.5) [set ed_aw (ed_aw + (ed_aw * 0.04))]
        if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.06 * su_nor1))]
        if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.06 * su_nor2))]
        if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.06 * su_nor3))]
        if (pbc1 < 6.5) [set pbc1 (pbc1 + (0.04 * pbc1))]
        if (pbc2 < 6.5) [set pbc2 (pbc2 + (0.04 * pbc2))]
        if (pbc3 < 6.5) [set pbc3 (pbc3 + (0.04 * pbc3))]
        ]]

    if Policy = "Carbon price pressure-100" [
      ask households[
        if (know < 6.5) [set know (know + (know * 0.06)) ]
        if (cee_aw < 6.5) [set cee_aw (cee_aw + (cee_aw * 0.06))]
        if (ed_aw < 6.5) [set ed_aw (ed_aw + (ed_aw * 0.06))]
        if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.1 * su_nor1))]
        if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.1 * su_nor2))]
        if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.1 * su_nor3))]
        if (pbc1 < 6.5) [set pbc1 (pbc1 + (0.05 * pbc1))]
        if (pbc2 < 6.5) [set pbc2 (pbc2 + (0.05 * pbc2))]
        if (pbc3 < 6.5) [set pbc3 (pbc3 + (0.05 * pbc3))]
    ]]
  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            Social and Learning algorithms
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To learn

 if year >= 2016[

    ask households[
      if Learning = "No learning" [ ]

      if ((Learning = "Fast adaptation") or (Learning = "Slow adaptation") or (Learning = "Observation") or (Learning = "Promote switching"))[

        if (act1 = True)[
          if Learning = "Fast adaptation" [ if (pbc1 < 6.5) [set pbc1 (pbc1 + (pbc1 * 0.05))]]
          if Learning = "Slow adaptation" [ if (pbc1 < 6.5) [set pbc1 (pbc1 + (pbc1 * 0.02))]]
          if Learning = "Observation" [ if (pbc1 < 6.5) [set pbc1 (pbc1 + (pbc1 * 0.1))]]
          if Learning = "Promote switching" [ if (pbc1 < 6.5) [set pbc1 (pbc1 + (pbc1 * 0.07))]]

        create-links-to other households-on neighbors
        ask out-link-neighbors [
        set ngb_k_mean mean (list (mean [know] of households-on neighbors) (item 0 [know] of in-link-neighbors))
        let ngb_k_median median (list (median [know] of households-on neighbors) (item 0 [know] of in-link-neighbors))
        set ngb_k max list ngb_k_mean ngb_k_median

        set ngb_ca_mean mean (list (mean [cee_aw] of households-on neighbors) (item 0 [cee_aw] of in-link-neighbors))
        let ngb_ca_median median (list (median [cee_aw] of households-on neighbors) (item 0 [cee_aw] of in-link-neighbors))
        set ngb_ca max list ngb_ca_mean  ngb_ca_median

        set ngb_ea_mean mean (list (mean [ed_aw] of households-on neighbors) (item 0 [ed_aw] of in-link-neighbors))
        let ngb_ea_median median (list (median [ed_aw] of households-on neighbors) (item 0 [ed_aw] of in-link-neighbors))
        set ngb_ed max list ngb_ea_mean  ngb_ea_median

        let ngb_p_mean mean (list (mean [per_nab1] of households-on neighbors) (item 0 [per_nab1] of in-link-neighbors))
        let ngb_p_median median (list (median [per_nab1] of households-on neighbors) (item 0 [per_nab1] of in-link-neighbors))
        set ngb_p max list ngb_p_mean  ngb_p_median

        let ngb_pb1_mean mean (list (mean [pbc1] of households-on neighbors) (item 0 [pbc1] of in-link-neighbors))
        let ngb_pb1_median median (list (median [pbc1] of households-on neighbors) (item 0 [pbc1] of in-link-neighbors))
        set ngb_pb1 max list ngb_pb1_mean  ngb_pb1_median

        if Learning = "Observation"[
                    if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.1)) ]
                    if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.1))]
                    if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.1))]
                    if (per_nab1 < 6.5) [set per_nab1 (per_nab1 + (per_nab1 * 0.1))]
                    if (pbc1 < 6.5) [set pbc1 (pbc1 + (pbc1 * 0.1))]
                    if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.15 * su_nor1))]]

        if Learning = "Fast adaptation"[
                    if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.05)) ]
                    if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.05))]
                    if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.05))]
                    if (per_nab1 < 6.5)[set per_nab1 (per_nab1 + (per_nab1 * 0.05))]
                    if (pbc1 < 6.5)[set pbc1 (pbc1 + (pbc1 * 0.05))]
                    if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.07 * su_nor1))]]

       if Learning = "Promote switching"[
                    if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.07)) ]
                    if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.07))]
                    if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.07))]
                    if (per_nab1 < 6.5)[set per_nab1 (per_nab1 + (per_nab1 * 0.07))]
                    if (pbc1 < 6.5)[set pbc1 (pbc1 + (pbc1 * 0.07))]
                    if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.1 * su_nor1))]]

        if Learning = "Slow adaptation"[ if (count out-link-neighbors) >= 2 [ ask n-of 2 out-link-neighbors [
                   if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.05))]
                   if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.05))]
                   if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.05))]
                   if (per_nab1 < 6.5) [set per_nab1 (per_nab1 + (per_nab1 * 0.05))]
                   if (pbc1 < 6.5) [set pbc1 (pbc1 + (pbc1 * 0.05))]
                   if (su_nor1 < 6.5) [set su_nor1 (su_nor1 + (0.07 * su_nor1))]]
          ]]
      ]
      ]


      if ((act50 = True) )[  ;and (satisfied = "keepact2")
            if Learning = "Fast adaptation" [ if (pbc2 < 6.5) [set pbc2 (pbc2 + (pbc2 * 0.05))]]
            if Learning = "Slow adaptation" [ if (pbc2 < 6.5) [set pbc2 (pbc2 + (pbc2 * 0.02))]]
            if Learning = "Observation" [if (pbc2 < 6.5) [set pbc2 (pbc2 + (pbc2 * 0.07))]]
            if Learning = "Promote switching" [ if (pbc2 < 6.5) [set pbc2 (pbc2 + (pbc2 * 0.07))]]

        create-links-to other households-on neighbors
        ask out-link-neighbors [
        set ngb_k_mean mean (list (mean [know] of households-on neighbors) (item 0 [know] of in-link-neighbors))
        let ngb_k_median median (list (median [know] of households-on neighbors) (item 0 [know] of in-link-neighbors))
        set ngb_k max list ngb_k_mean ngb_k_median

        set ngb_ca_mean mean (list (mean [cee_aw] of households-on neighbors) (item 0 [cee_aw] of in-link-neighbors))
        let ngb_ca_median median (list (median [cee_aw] of households-on neighbors) (item 0 [cee_aw] of in-link-neighbors))
        set ngb_ca max list ngb_ca_mean  ngb_ca_median

        set ngb_ea_mean mean (list (mean [ed_aw] of households-on neighbors) (item 0 [ed_aw] of in-link-neighbors))
        let ngb_ea_median median (list (median [ed_aw] of households-on neighbors) (item 0 [ed_aw] of in-link-neighbors))
        set ngb_ed max list ngb_ea_mean  ngb_ea_median

        let ngb_p_mean mean (list (mean [per_nab2] of households-on neighbors) (item 0 [per_nab2] of in-link-neighbors))
        let ngb_p_median median (list (median [per_nab2] of households-on neighbors) (item 0 [per_nab2] of in-link-neighbors))
        set ngb_p max list ngb_p_mean  ngb_p_median


        let ngb_pb2_mean mean (list (mean [pbc2] of households-on neighbors) (item 0 [pbc2] of in-link-neighbors))
        let ngb_pb2_median median (list (median [pbc2] of households-on neighbors) (item 0 [pbc2] of in-link-neighbors))
        set ngb_pb2 max list ngb_pb2_mean  ngb_pb2_median

        if Learning = "Observation"[
            if (know < 6.5) [set know (know + (know * 0.07))]
            if (cee_aw < 6.5) [set cee_aw (cee_aw + (cee_aw * 0.07))]
            if (ed_aw < 6.5) [set ed_aw (ed_aw + (ed_aw * 0.07))]
            if (per_nab2 < 6.5) [set per_nab2 (per_nab2 + (per_nab2 * 0.07))]
            if (pbc2 < 6.5) [set pbc2 (pbc2 + (pbc2 * 0.07))]
            if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.1 * su_nor2))]]

        if Learning = "Fast adaptation"[
            if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.05)) ]
            if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.05))]
            if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.05))]
            if (per_nab2 < 6.5) [set per_nab2 (per_nab2 + (per_nab2 * 0.05))]
            if (pbc2 < 6.5)[set pbc2 (pbc2 + (pbc2 * 0.05))]
            if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.07 * su_nor2))]]

       if Learning = "Promote switching"[
            if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.07)) ]
            if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.07))]
            if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.07))]
            if (per_nab2 < 6.5) [set per_nab2 (per_nab2 + (per_nab2 * 0.07))]
            if (pbc2 < 6.5)[set pbc2 (pbc2 + (pbc2 * 0.07))]
            if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.1 * su_nor2))]]

        if Learning = "Slow adaptation"[ if (count out-link-neighbors) >= 2 [ ask n-of 2 out-link-neighbors[
            if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.05)) ]
            if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.05))]
            if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.05))]
            if (per_nab2 < 6.5) [set per_nab2 (per_nab2 + (per_nab2 * 0.05))]
            if (pbc2 < 6.5)[set pbc2 (pbc2 + (pbc2 * 0.05))]
            if (su_nor2 < 6.5) [set su_nor2 (su_nor2 + (0.07 * su_nor2))]]
          ]]
      ]]


      if ((act3 = True) )[  ; and (satisfied = "keepact3")
            if Learning = "Fast adaptation" [ if (pbc3 < 6.5) [set pbc3 (pbc3 + (pbc3 * 0.05))]]
            if Learning = "Slow adaptation" [ if (pbc3 < 6.5) [set pbc3 (pbc3 + (pbc3 * 0.02))]]
            if Learning = "Observation" [if (pbc3 < 6.5) [set pbc3 (pbc3 + (pbc3 * 0.07))]]
            if Learning = "Promote switching" [ if (pbc3 < 6.5) [set pbc3 (pbc3 + (pbc3 * 0.1))]]

        create-links-to other households-on neighbors
        ask out-link-neighbors [
        set ngb_k_mean mean (list (mean [know] of households-on neighbors) (item 0 [know] of in-link-neighbors))
        let ngb_k_median median (list (median [know] of households-on neighbors) (item 0 [know] of in-link-neighbors))
        set ngb_k max list ngb_k_mean ngb_k_median

        set ngb_ca_mean mean (list (mean [cee_aw] of households-on neighbors) (item 0 [cee_aw] of in-link-neighbors))
        let ngb_ca_median median (list (median [cee_aw] of households-on neighbors) (item 0 [cee_aw] of in-link-neighbors))
        set ngb_ca max list ngb_ca_mean  ngb_ca_median

        set ngb_ea_mean mean (list (mean [ed_aw] of households-on neighbors) (item 0 [ed_aw] of in-link-neighbors))
        let ngb_ea_median median (list (median [ed_aw] of households-on neighbors) (item 0 [ed_aw] of in-link-neighbors))
        set ngb_ed max list ngb_ea_mean  ngb_ea_median

        let ngb_p_mean mean (list (mean [per_nab3] of households-on neighbors) (item 0 [per_nab3] of in-link-neighbors))
        let ngb_p_median median (list (median [per_nab3] of households-on neighbors) (item 0 [per_nab3] of in-link-neighbors))
        set ngb_p max list ngb_p_mean  ngb_p_median

        let ngb_pb3_mean mean (list (mean [pbc3] of households-on neighbors) (item 0 [pbc3] of in-link-neighbors))
        let ngb_pb3_median median (list (median [pbc3] of households-on neighbors) (item 0 [pbc3] of in-link-neighbors))
        set ngb_pb3 max list ngb_pb3_mean  ngb_pb3_median

        if Learning = "Observation"[
            if (know < 6.5) [set know (know + (know * 0.07))]
            if (cee_aw < 6.5) [set cee_aw (cee_aw + (cee_aw * 0.07))]
            if (ed_aw < 6.5) [set ed_aw (ed_aw + (ed_aw * 0.07))]
            if (per_nab3 < 6.5) [set per_nab3 (per_nab3 + (per_nab3 * 0.07))]
            if (pbc3 < 6.5) [set pbc3 (pbc3 + (pbc3 * 0.07))]
            if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.1 * su_nor3))]]

       if Learning = "Fast adaptation"[
            if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.05)) ]
            if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.05))]
            if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.05))]
            if (per_nab3 < 6.5) [set per_nab3 (per_nab3 + (per_nab3 * 0.05))]
            if (pbc3 < 6.5)[set pbc3 (pbc3 + (pbc3 * 0.05))]
            if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.07 * su_nor3))]]

       if Learning = "Promote switching"[
            if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.1)) ]
            if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.1))]
            if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.1))]
            if (per_nab3 < 6.5) [set per_nab3 (per_nab3 + (per_nab3 * 0.1))]
            if (pbc3 < 6.5)[set pbc3 (pbc3 + (pbc3 * 0.1))]
            if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.15 * su_nor3))]]

       if Learning = "Slow adaptation"[if (count out-link-neighbors) >= 2 [ ask n-of 2 out-link-neighbors[
            if ((know < ngb_k) and (know < 6.5))[set know (know + (know * 0.05)) ]
            if ((cee_aw < ngb_ca) and (cee_aw < 6.5))[set cee_aw (cee_aw + (cee_aw * 0.05))]
            if ((ed_aw < ngb_ed) and (ed_aw < 6.5))[set ed_aw (ed_aw + (ed_aw * 0.05))]
            if (per_nab3 < 6.5) [set per_nab3 (per_nab3 + (per_nab3 * 0.05))]
            if (pbc3 < 6.5)[set pbc3 (pbc3 + (pbc3 * 0.05))]
            if (su_nor3 < 6.5) [set su_nor3 (su_nor3 + (0.07 * su_nor3))]]
          ]]
      ]]

     ]
  ]
 ]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Regret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To regret

 if year >= 2017 [
   ask households[

      if ((act50 = True) and (satisfied = "regretact2"))[
          create-links-to other households-on neighbors
          ask out-link-neighbors [

          if Learning = "Fast adaptation"[
            if (per_nab2 >= 1) [set per_nab2 (per_nab2 - (0.05 * per_nab2))]
            if (pbc2 >= 1) [set pbc2  (pbc2  - (0.05 * pbc2))]
            if (su_nor2 >= 1) [set su_nor2 (su_nor2 - (0.03 * su_nor2))]]

          if Learning = "Slow adaptation"[ if (count out-link-neighbors) != 0 [ ask n-of 2 out-link-neighbors[
            if (per_nab2 >= 1) [set per_nab2  (per_nab2 - (0.05 * per_nab2))]
            if (pbc2 >= 1)[set pbc2  (pbc2  - (0.05 * pbc2))]
            if (su_nor2 >= 1) [set su_nor2 (su_nor2 - (0.03 * su_nor2))]]
          ]]
      ]]

      if ((act3 = True) and (satisfied = "regretact3"))[
        create-links-to other households-on neighbors
        ask out-link-neighbors [

        if Learning = "Fast adaptation"[
           if (per_nab3 >= 1) [set per_nab3 (per_nab3 - (0.05 * per_nab3))]
           if (pbc3 >= 1)[set pbc3  (pbc3  - (0.05 * pbc3))]
           if (su_nor3 >= 1) [set su_nor3 (su_nor3 - (0.03 * su_nor3))]]

        if Learning = "Slow adaptation"[ if (count out-link-neighbors) != 0 [ ask n-of 2 out-link-neighbors[
           if (per_nab3 >= 1) [set per_nab3  (per_nab3 - (0.05 * per_nab3))]
           if (pbc3 >= 1)[set pbc3  (pbc3  - (0.05 * pbc3))]
           if (su_nor3 >= 1) [set su_nor3 (su_nor3 - (0.03 * su_nor3))]]
          ]]
      ]]
    ]
  ]


end


; #####################################################################################
; ################################## Updates Data #####################################
; #####################################################################################


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                Update households' attributes
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


To update_data

  ask households[

; ;;;;;;;;;;;;; SSP2 sceanario ;;;;;;;;;;;;;


; ################ Netherlands casestudy ################

  if  Case-study = "Netherlands-Overijssel"[

    if scenario = "Ref_SSP2"[

    if (rr < 5.5 ) [                           ;; 5.5% of of households have income less than 10,000    >> Income group 1

      set h_income (h_income * (item 0 item n cge-nl-ssp2-h))

      let t (n + 1)
      set h_q (h_q * (item 0 item n cge-nl-ssp2-con))
      set alpha (item 0 item n cge-nl-ssp2-alpha)
    ]

    if (rr >= 5.5) and (rr <= 40.19) [          ;; 34.69% of of households have income 10,000 to 30,000   >> Income group 2

      set h_income (h_income * (item 0 item n cge-nl-ssp2-h))

      let t (n + 1)
      set h_q (h_q * (item 0 item t cge-nl-ssp2-con))
      set alpha (item 0 item t cge-nl-ssp2-alpha)
    ]

    if (rr > 40.19) and (rr <= 78.17) [          ;; 37.98% of of households have income 30,001 to 50,000   >> Income group 3

      set h_income (h_income * (item 0 item n cge-nl-ssp2-h))

      let t (n + 2)
      set h_q (h_q * (item 0 item t cge-nl-ssp2-con))
      set alpha (item 0 item t cge-nl-ssp2-alpha)
    ]

    if (rr > 78.17) and (rr <= 91.69) [           ;; 13.52% of of households have income 50,001 to 70,000  >> Income group 4

      set h_income (h_income * (item 0 item n cge-nl-ssp2-h))

      let t (n + 3)
      set h_q (h_q * (item 0 item t cge-nl-ssp2-con))
      set alpha (item 0 item t cge-nl-ssp2-alpha)
    ]

    if (rr > 91.69) and (rr <= 97.39) [           ;; 5.7% of of households have income 70,001 to 90,000  >> Income group 5

      set h_income (h_income * (item 0 item n cge-nl-ssp2-h))

      let t (n + 4)
      set h_q (h_q * (item 0 item t cge-nl-ssp2-con))
      set alpha (item 0 item t cge-nl-ssp2-alpha)
    ]

    if (rr >  97.39) and (rr <= 98.36) [           ;; 0.97% of of households have income 90,001 to 110,000   >> Income group 6

      set h_income (h_income * (item 0 item n cge-nl-ssp2-h))

      let t (n + 4)
      set h_q (h_q * (item 0 item t cge-nl-ssp2-con))
      set alpha (item 0 item t cge-nl-ssp2-alpha)
    ]

    if (rr > 98.36) and (rr <= 100) [               ;; 1.64% of of households have income more than 110,000   ~  150,000

      set h_income (h_income * (item 0 item n cge-nl-ssp2-h))

      let t (n + 4)
      set h_q (h_q * (item 0 item t cge-nl-ssp2-con))
      set alpha (item 0 item t cge-nl-ssp2-alpha)
    ]
    ]
  ]

  ]

end


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                Update energy use of HH
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


To update_heq

  if year >= 2016 [
  ask households [
    if (act1 = True and h_q > 0)[
      set h_q (h_q - 1700)]                           ;; based on http://www.theecoexperts.co.uk/how-much-electricity-does-average-solar-panel-system-generate and 4kw size of panel
    if (act1 = True and h_q <= 0)[
      set hh_sta "self-producer"
      set h_q 0]

   if ((act50 = True) and (h_q > 1000))[
      set h_q (h_q - h_conserv)]
   if ((act50 = True) and (h_q <= 1000))[
      set hh_sta "efficient"
      set h_q 1000]
  ]
  ]

end


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     Update memory
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

To update_memory

 ask households[
    set act50 false
    set act3 false
    set act1 false]

 ask  households[

    if (item 0 hh_actions = 1) [set act11_year (act11_year + 1)]
    if (item 1 hh_actions = 1) [set act12_year (act12_year + 1)]

    if (item 2 hh_actions = 1) [set act21_year (act21_year + 1)]
    if (item 3 hh_actions = 1) [set act40_year (act40_year + 1)]

    if (item 4 hh_actions = 1) [set act31_year (act31_year + 1)]
    if (item 5 hh_actions = 1) [set act32_year (act32_year + 1)]

;; after 10 year again they are able to invest
    if (act11_year >= 10)[
      set hh_actions replace-item 0 hh_actions 0
      set act11 False]

    if (act12_year >= 10)[
      set hh_actions replace-item 1 hh_actions 0
      set act12 False]

;; after 5 year again they are able to conserv
    if (act21_year >= 5)[
      set hh_actions replace-item 2 hh_actions 0
      set act21 False]

    if (act40_year >= 5)[
      set hh_actions replace-item 3 hh_actions 0
      set act40 False]

;; after 2 years who switched to green, could switch to greener
    if (act32_year >= 2)[
      set hh_actions replace-item 5 hh_actions 0
      set act32 False]

  ]

  ask households [
    set sav_1_ff 0
    set sav_2_ff 0
    set sav_3_ff 0
    set sav_1_lce 0
    set sav_2_lce 0
    set sav_3_lce 0
  ]

end

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;; reporter  ;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to-report randomNumber [lower_value upper_value step_value]
  report lower_value + step_value * random (1 + floor ((upper_value - lower_value) / step_value ))
end



; #####################################################################################
; ######################### Visulization adn Outputs ##################################
; #####################################################################################

;;;;;;;;;;;; Debug ;;;;;;;;;;;;;;;;

To debug

if debug_files = true [
  ask households[

     file-open "household.csv"
     file-print (word year "," h_id "," h_id_group "," h_income "," h_q "," flag?  "," hh_sta "," hh_actions ","
                      know  "," cee_aw  "," ed_aw "," h_aware "," guilt  ","  per_nab1  "," su_nor1  "," h_motiv1 ","  per_nab2  "," su_nor2  "," h_motiv2 ","
                      per_nab3  "," su_nor3  "," h_motiv3 "," responsibility ","
                      dw_st  "," pbc1 ","  pbc2 "," pbc3 "," delta1 "," delta2 "," delta3 ","
                      utility_exp_lce1 "," utility_exp_lce2 "," utility_exp_lce31 "," utility_exp_ff1 "," utility_exp_ff2 ","
                      utility_exp_ff32 "," utility_exp_lce32 "," utility_exp_zero1 "," utility_exp_zero2 "," utility_exp_zero3 "," max (list utility_exp_lce1 utility_exp_lce2 utility_exp_lce31 utility_exp_zero3) ","
                      max (list utility_exp_ff1 utility_exp_ff2 utility_exp_lce32 utility_exp_ff32) "," max (list utility_exp_zero1 utility_exp_zero2) ","
                      utility_lce1 "," utility_lce2 "," utility_lce31 "," utility_ff1 "," utility_ff2 ","
                      utility_ff32 "," utility_lce32 "," utility_zero1 "," utility_zero2 "," utility_zero3 "," (utility_exp_zero3 > utility_lce31) "," (utility_exp_lce32 > utility_lce32) ","
                      act11 "," act12 "," act21 "," act40 "," act31 "," act32 "," act1 "," act50 "," act3 "," sav_1_ff "," sav_2_ff "," sav_3_ff "," sav_1_lce "," sav_2_lce "," sav_3_lce ","
                      sav_1_ff_inc1 "," sav_2_ff_inc1 "," sav_3_ff_inc1 "," sav_1_lce_inc1 "," sav_2_lce_inc1 "," sav_3_lce_inc1 ","
                      sav_1_ff_inc2 "," sav_2_ff_inc2 "," sav_3_ff_inc2 "," sav_1_lce_inc2 "," sav_2_lce_inc2 "," sav_3_lce_inc2 ","
                      sav_1_ff_inc3 "," sav_2_ff_inc3 "," sav_3_ff_inc3 "," sav_1_lce_inc3 "," sav_2_lce_inc3 "," sav_3_lce_inc3 ","
                      sav_1_ff_inc4 "," sav_2_ff_inc4 "," sav_3_ff_inc4 "," sav_1_lce_inc4 "," sav_2_lce_inc4 "," sav_3_lce_inc4 ","
                      sav_1_ff_inc5 "," sav_2_ff_inc5 "," sav_3_ff_inc5 "," sav_1_lce_inc5 "," sav_2_lce_inc5 "," sav_3_lce_inc5 ","  )
    ]
  ]

end

;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;; plots ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

To draw_emissions

  set-current-plot "CO2 emission"
  set-current-plot-pen "green investment"
  plot co2_1_lce_cum
  set-current-plot-pen "green conservation"
  plot co2_2_lce_cum
  set-current-plot-pen "switch to greener"
  plot co2_3_lce_cum
  set-current-plot-pen "grey investment"
  plot co2_1_ff_cum
  set-current-plot-pen "grey conservation"
  plot co2_2_ff_cum
    set-current-plot-pen "switch to green"
  plot co2_3_ff_cum

end

To draw_consumption_share

  set-current-plot "LCE consumption"
  set-current-plot-pen "LCE"
  plot count households with [flag? = 1 and flag? = 2]


end

To draw_prices

  set-current-plot "Market price"
  set-current-plot-pen "LCE"
  plot m_p_lce
  set-current-plot-pen "FF"
  plot m_p_ff

end


To draw_awareness

  set-current-plot "Awareness"
  set-current-plot-pen "1"
  plot count households with [h_aware <= 1]
  set-current-plot-pen "2"
  plot count households with [h_aware > 1 and h_aware <= 2]
  set-current-plot-pen "3"
  plot count households with [h_aware > 2 and h_aware <= 3]
  set-current-plot-pen "4"
  plot count households with [h_aware > 3 and h_aware <= 4]
  set-current-plot-pen "5"
  plot count households with [h_aware > 4 and h_aware <= 5]
  set-current-plot-pen "6"
  plot count households with [h_aware > 5 and h_aware <= 6]
  set-current-plot-pen "7"
  plot count households with [h_aware > 6 and h_aware <= 7]

end


To draw_totalawareness

  set-current-plot "Total Awareness"
  set-current-plot-pen "Awareness"
  plot aware_total

end


To draw_feelingguilt

  set-current-plot "Feeling guilt"
  set-current-plot-pen "Guilt"
  plot count households with [guilt = "H"]

end


To draw_motivation

  set-current-plot "Motivation"
  set-current-plot-pen "Motivation"
  plot count households with [level = "H"]

end


To draw_consideration

  set-current-plot "Consideration"
  set-current-plot-pen "Low investment"
  plot count households with [cons1 = "L"]
  set-current-plot-pen "High investment"
  plot count households with [cons1 = "H"]

  set-current-plot-pen "Low conservation"
  plot count households with [cons2 = "L"]
  set-current-plot-pen "High conservation"
  plot count households with [cons2  = "H"]


  set-current-plot-pen "Low switching"
  plot count households with [cons3 = "L"]
  set-current-plot-pen "High switching"
  plot count households with [cons3 = "H"]

end


To draw_actions1

  if year >= 2016[
  set-current-plot "Actions"
  set-current-plot-pen "Investment"
  plot action_1

  set-current-plot-pen "Energy conservation"
  plot action_2

  set-current-plot-pen "Switch to greener"
  plot action_31

  set-current-plot-pen "Switch to green"
  plot action_32
  ]

end


To draw_actions2

  set-current-plot "Actions-cum"
  set-current-plot-pen "Investment"
  plot action_1_cum

  set-current-plot-pen "Energy conservation"
  plot action_2_cum

  set-current-plot-pen "Switch to greener"
  plot action_31_cum

  set-current-plot-pen "Switch to green"
  plot action_32_cum

end



To draw_total_actions

  set-current-plot "Total actions"
  set-current-plot-pen "Total actions"
  plot action_total
  set-current-plot-pen "No actions"
  plot noaction

end



To draw_investments

  set-current-plot "Investments"
  set-current-plot-pen "action1"
  plot invest_cum

  set-current-plot-pen "action2"
  plot conserv_cum


  set-current-plot-pen "action3"
  plot switch_cum

end


To draw_savings

  set-current-plot "Total emissions"
  set-current-plot-pen "CO2 emission"
  plot co2_av_cum


end


To draw_satisfaction

  set-current-plot "satisfaction"
  set-current-plot-pen "Keep investing"
  plot count households with [satisfied = "keepact1"]

  set-current-plot-pen "Keep conserving"
  plot count households with [satisfied = "keepact2"]

  set-current-plot-pen "Keep switching"
  plot count households with [satisfied = "keepact3"]

  set-current-plot-pen "Regret investing"
  plot count households with [satisfied = "regretact1"]

  set-current-plot-pen "Regret conserving"
  plot count households with [satisfied = "regretact2"]

  set-current-plot-pen "Regret switching"
  plot count households with [satisfied = "regretact3"]

end



To draw_price_growth

  set-current-plot "Price growth"
  set-current-plot-pen "LCE"
  plot cpg_lce
  set-current-plot-pen "FF"
  plot cpg_ff

end
@#$#@#$#@
GRAPHICS-WINDOW
348
11
960
399
-1
-1
4.992
1
10
1
1
1
0
1
1
1
-60
60
0
75
0
0
1
ticks
30.0

BUTTON
238
11
337
44
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
238
50
337
83
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
6
250
295
295
Data
Data
"Homogeneous" "Homogeneous A and M" "Homogeneous M" "Empirical-survey"
3

PLOT
634
721
959
856
LCE consumption
Year
HH
0.0
20.0
0.0
500.0
true
true
"" ""
PENS
"LCE" 1.0 0 -14737633 true "" ""

SWITCH
4
104
127
137
debug_files
debug_files
1
1
-1000

CHOOSER
5
197
156
242
Case-study
Case-study
"Spain-Navarre" "Netherlands-Overijssel"
1

BUTTON
130
90
228
124
Load Map
load-map
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
347
584
631
718
Market price
Year
Price
0.0
20.0
0.1
0.9
true
true
"" ""
PENS
"LCE" 1.0 0 -14439633 true "" ""
"FF" 1.0 0 -11053225 true "" ""

BUTTON
130
10
229
45
Show Population
show-population
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1733
34
1796
79
Trades
counttrade
17
1
11

MONITOR
1794
337
1913
382
Total FF consumption
precision ((sum [h_q] of households with [flag? = 0])) 3
2
1
11

MONITOR
1671
337
1791
382
Total LCE consumption
precision ((sum [h_q] of households with [flag? = 1])) 3
2
1
11

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
1.47721119E8
1
0
Number

SWITCH
9
525
136
558
Switching
Switching
0
1
-1000

SWITCH
8
487
135
520
Conservation
Conservation
0
1
-1000

SWITCH
8
450
136
483
Investment
Investment
0
1
-1000

TEXTBOX
7
425
220
452
******* Behaviors *******
14
0.0
1

TEXTBOX
5
176
234
210
******* Map and Data *******
14
0.0
1

PLOT
966
342
1321
462
Feeling guilt
Year
Housholds
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Guilt" 0.5 0 -16777216 true "" ""

TEXTBOX
1668
11
1853
44
******* Monitors *******
14
0.0
1

BUTTON
130
51
228
84
Check data
load-data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1673
484
1804
529
High intention
count households with [intention = True]
17
1
11

MONITOR
1672
389
1803
434
Feeling guilt
count households with [guilt = \"H\"]
17
1
11

MONITOR
1800
34
1868
79
Households
count households
17
1
11

MONITOR
1800
234
1883
279
Cumulative 
action_cum
17
1
11

PLOT
966
465
1321
585
Motivation
Year
Households
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Motivation" 1.0 0 -16777216 true "" ""

PLOT
965
588
1321
732
Consideration
Year
Households
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Low investment" 0.5 0 -16777216 true "" ""
"High investment" 0.5 0 -2674135 true "" ""
"Low conservation" 1.0 0 -6459832 true "" ""
"High conservation" 1.0 0 -10899396 true "" ""
"Low switching" 1.0 0 -11221820 true "" ""
"High switching" 1.0 0 -13345367 true "" ""

MONITOR
1667
34
1730
79
Year
year
17
1
11

MONITOR
1668
140
1798
185
Investment
count households with [act1 = True]
17
1
11

PLOT
1323
187
1654
337
Actions
Year
Households
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"Energy conservation" 1.0 0 -10141563 true "" ""
"Switch to green" 1.0 0 -1184463 true "" ""
"Investment" 1.0 0 -3844592 true "" ""
"Switch to greener" 1.0 0 -14439633 true "" ""

MONITOR
1669
187
1798
232
Energy conservation
count households with [act50 = True]
17
1
11

MONITOR
1669
234
1799
279
Switching supplier
count households with [act31 = True or act32 = True]
17
1
11

MONITOR
1800
140
1882
185
NO ACTION
noaction
17
1
11

MONITOR
1806
389
1936
434
Regret investment
count households with [satisfied = \"regretact1\"]
17
1
11

MONITOR
1673
633
1866
678
Avoid CO2 emission by switching
precision (co2_3_lce_cum + co2_3_ff_cum) 3
17
1
11

MONITOR
1869
632
2052
677
Saved energy by switching
precision (energy_sav_3_lce + energy_sav_3_ff) 3
17
1
11

MONITOR
1806
436
1936
481
Regret conserving
count households with [satisfied = \"regretact2\"]
17
1
11

MONITOR
1869
680
2053
725
Saved energy in total
precision (energy_sav_1_lce + energy_sav_1_ff + energy_sav_2_lce + energy_sav_2_ff + energy_sav_3_lce + energy_sav_3_ff) 3
17
1
11

PLOT
964
10
1319
184
Awareness
Year
Households
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"1" 1.0 0 -16777216 true "" ""
"2" 1.0 0 -7500403 true "" ""
"3" 1.0 0 -2674135 true "" ""
"4" 1.0 0 -955883 true "" ""
"5" 1.0 0 -6459832 true "" ""
"6" 1.0 0 -1184463 true "" ""
"7" 1.0 0 -10899396 true "" ""

PLOT
347
721
631
856
Households Budget
Year
Euro
0.0
20.0
0.0
1000.0
true
true
"" ""
PENS
"Income" 1.0 0 -16777216 true "" ""

MONITOR
1673
536
1865
581
Avoid CO2 emission by investment
precision (co2_1_lce_cum + co2_1_ff_cum) 3
17
1
11

MONITOR
1869
536
2050
581
Saved energy by investment
precision (energy_sav_1_lce + energy_sav_1_ff) 3
17
1
11

MONITOR
1869
584
2051
629
Saved energy by conserving
precision (energy_sav_2_lce + energy_sav_2_ff) 3
17
1
11

MONITOR
1806
483
1936
528
Regret switching
count households with [satisfied = \"regretact3\"]
17
1
11

MONITOR
1673
584
1866
629
Avoid CO2 emission by conserving
precision (co2_2_lce_cum + co2_2_ff_cum) 3
17
1
11

SWITCH
10
592
126
625
DMProcess
DMProcess
0
1
-1000

TEXTBOX
5
565
302
599
****** Decision-making Process *******
14
0.0
1

MONITOR
1672
436
1804
481
Feeling responsibility
count households with [responsibility = True]
17
1
11

MONITOR
1734
86
1800
131
Green user
count households with [flag? = 1]
17
1
11

MONITOR
1668
86
1731
131
Grey user
count households with [flag? = 0]
17
1
11

PLOT
1324
342
1655
462
Total actions
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
"Total actions" 1.0 0 -16777216 true "" ""
"No actions" 1.0 0 -10141563 true "" ""

CHOOSER
6
321
156
366
Scenario
Scenario
"Ref_SSP2" "Green_SSP4" "Ref_EU"
0

TEXTBOX
5
303
241
337
******* Scenario ********
14
0.0
1

MONITOR
1915
287
2046
332
Price of grey
m_p_ff
17
1
11

MONITOR
1794
286
1912
331
Price of green
m_p_lce
17
1
11

SWITCH
11
636
112
669
Awareness
Awareness
0
1
-1000

MONITOR
1800
187
1883
232
Total actions
action_total
17
1
11

MONITOR
1674
681
1866
726
Aviod CO2 emission in total
precision (co2_av_cum) 3
17
1
11

SWITCH
120
636
223
669
Motiva
Motiva
0
1
-1000

PLOT
1325
465
1657
585
Investments
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
"action1" 1.0 0 -9276814 true "" ""
"action2" 1.0 0 -14439633 true "" ""
"action3" 1.0 0 -7858858 true "" ""

PLOT
1325
590
1657
731
Total emissions
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
"CO2 emission" 1.0 0 -14439633 true "" ""

SWITCH
159
450
280
483
Memory
Memory
0
1
-1000

PLOT
1322
10
1654
183
Actions-cum
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
"Investment" 1.0 0 -955883 true "" ""
"Energy conservation" 1.0 0 -10141563 true "" ""
"Switch to greener" 1.0 0 -14439633 true "" ""
"Switch to green" 1.0 0 -1184463 true "" ""

PLOT
965
188
1320
338
Total Awareness
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
"Awareness" 1.0 0 -16777216 true "" ""

CHOOSER
7
373
210
418
Policy
Policy
"Ref" "Carbon price pressure-10" "Carbon price pressure-25" "Carbon price pressure-50" "Carbon price pressure-100" "Carbon price pressure-2020"
2

PLOT
348
401
959
579
CO2 emission
Year
CO2 (Kg)
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"green investment" 1.0 0 -955883 true "" ""
"green conservation" 1.0 0 -8630108 true "" ""
"switch to greener" 1.0 0 -10899396 true "" ""
"grey investment" 1.0 0 -2674135 true "" ""
"grey conservation" 1.0 0 -5825686 true "" ""
"switch to green" 1.0 0 -1184463 true "" ""

CHOOSER
160
321
309
366
Learning
Learning
"Fast adaptation" "Slow adaptation" "Observation" "Promote switching" "No learning"
1

PLOT
634
584
959
717
Satisfaction
Year
Housholds
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"Keep investing" 1.0 0 -10141563 true "" ""
"Regret investing" 1.0 0 -11033397 true "" ""
"Keep conserving" 1.0 0 -955883 true "" ""
"Regret conserving" 1.0 0 -987046 true "" ""
"Keep switching" 1.0 0 -10899396 true "" ""
"Regret switching" 1.0 0 -13345367 true "" ""

MONITOR
1803
86
1898
131
Super green user
count households with [flag? = 2]
17
1
11

MONITOR
1670
286
1791
331
Price of super green
m_p_zero
17
1
11

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

Leila Niamir 

Department of Governance and Technology for Sustainability
Faculty of Behavioural, Management and Social sciences, University of Twente
P.O.Box 217, 7500AE Enschede, the Netherlands
E:l.niamir[at]utwente.nl; leila.niamir[at]gmail.com

Air Quality & Greenhouse Gases Research Group
International Institute of Applied Systems Analysis (IIASA)
Schlossplatz 1, A-2361 Laxenburg, Austria
E:niamir[at]iiasa.ac.at
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
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="NL-ssp2-C10-fast" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2030 [
 go]
[setup
 go]</go>
    <timeLimit steps="750"/>
    <metric>year</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 1383)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 1383)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 1383)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 1383)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 3468)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 3468)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 3468)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 3468)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Case-study">
      <value value="&quot;Netherlands-Overijssel&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref_SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Policy">
      <value value="&quot;Carbon price pressure-10&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug_files">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DMProcess">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Awareness">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Motiva">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Fast adaptation&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NL-ssp2-C25-fast" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2030 [
 go]
[setup
 go]</go>
    <timeLimit steps="750"/>
    <metric>year</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 1383)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 1383)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 1383)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 1383)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 3468)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 3468)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 3468)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 3468)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Case-study">
      <value value="&quot;Netherlands-Overijssel&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref_SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Policy">
      <value value="&quot;Carbon price pressure-25&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug_files">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DMProcess">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Awareness">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Motiva">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Fast adaptation&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NL-ssp2-C50-fast" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2030 [
 go]
[setup
 go]</go>
    <timeLimit steps="750"/>
    <metric>year</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 1383)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 1383)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 1383)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 1383)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 3468)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 3468)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 3468)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 3468)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Case-study">
      <value value="&quot;Netherlands-Overijssel&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref_SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Policy">
      <value value="&quot;Carbon price pressure-50&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug_files">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DMProcess">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Awareness">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Motiva">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Fast adaptation&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NL-ssp2-C25-slow" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2030 [
 go]
[setup
 go]</go>
    <timeLimit steps="750"/>
    <metric>year</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 1383)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 1383)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 1383)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 1383)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 3468)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 3468)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 3468)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 3468)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Case-study">
      <value value="&quot;Netherlands-Overijssel&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref_SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Policy">
      <value value="&quot;Carbon price pressure-25&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug_files">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DMProcess">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Awareness">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Motiva">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow adaptation&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NL-ssp2-ref-slow" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2030 [
 go]
[setup
 go]</go>
    <timeLimit steps="750"/>
    <metric>year</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 1383)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 1383)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 1383)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 1383)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Case-study">
      <value value="&quot;Netherlands-Overijssel&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref_SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Policy">
      <value value="&quot;Ref&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug_files">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DMProcess">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Awareness">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Motiva">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Slow adaptation&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NL-ssp2-ref-fast" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>ifelse year &lt; 2030 [
 go]
[setup
 go]</go>
    <timeLimit steps="750"/>
    <metric>year</metric>
    <metric>slceuser</metric>
    <metric>lceuser</metric>
    <metric>ffuser</metric>
    <metric>h_totalslce</metric>
    <metric>h_totallce</metric>
    <metric>h_totalff</metric>
    <metric>action_1</metric>
    <metric>action_2</metric>
    <metric>action_31</metric>
    <metric>action_32</metric>
    <metric>action_total</metric>
    <metric>action_1_cum</metric>
    <metric>action_2_cum</metric>
    <metric>action_31_cum</metric>
    <metric>action_32_cum</metric>
    <metric>action_cum</metric>
    <metric>energy_sav_inc1_cum</metric>
    <metric>energy_sav_inc2_cum</metric>
    <metric>energy_sav_inc3_cum</metric>
    <metric>energy_sav_inc4_cum</metric>
    <metric>energy_sav_inc5_cum</metric>
    <metric>energy_sav_inc6_cum</metric>
    <metric>energy_sav_inc7_cum</metric>
    <metric>energy_sav_a_cum</metric>
    <metric>energy_sav_b_cum</metric>
    <metric>energy_sav_c_cum</metric>
    <metric>energy_sav_d_cum</metric>
    <metric>energy_sav_e_cum</metric>
    <metric>energy_sav_f_cum</metric>
    <metric>energy_sav_1_ff</metric>
    <metric>energy_sav_2_ff</metric>
    <metric>energy_sav_3_ff</metric>
    <metric>energy_sav_1_lce</metric>
    <metric>energy_sav_2_lce</metric>
    <metric>energy_sav_3_lce</metric>
    <metric>co2_1_ff</metric>
    <metric>co2_2_ff</metric>
    <metric>co2_3_ff</metric>
    <metric>co2_1_lce</metric>
    <metric>co2_2_lce</metric>
    <metric>co2_3_lce</metric>
    <metric>co2_av</metric>
    <metric>co2_1_ff_cum</metric>
    <metric>co2_2_ff_cum</metric>
    <metric>co2_3_ff_cum</metric>
    <metric>co2_1_lce_cum</metric>
    <metric>co2_2_lce_cum</metric>
    <metric>co2_3_lce_cum</metric>
    <metric>co2_av_cum</metric>
    <metric>(co2_av_cum / 1383)</metric>
    <metric>((co2_1_ff_cum + co2_1_lce_cum) / 1383)</metric>
    <metric>((co2_2_ff_cum + co2_2_lce_cum) / 1383)</metric>
    <metric>((co2_3_ff_cum + co2_3_lce_cum) / 1383)</metric>
    <metric>test1</metric>
    <metric>test2</metric>
    <metric>co2_1_ff_inc1 + co2_1_lce_inc1</metric>
    <metric>co2_2_ff_inc1 + co2_2_lce_inc1</metric>
    <metric>co2_3_ff_inc1 + co2_3_lce_inc1</metric>
    <metric>co2_av_inc1</metric>
    <metric>co2_1_ff_inc2 + co2_1_lce_inc2</metric>
    <metric>co2_2_ff_inc2 + co2_2_lce_inc2</metric>
    <metric>co2_3_ff_inc2 + co2_3_lce_inc2</metric>
    <metric>co2_av_inc2</metric>
    <metric>co2_1_ff_inc3 + co2_1_lce_inc3</metric>
    <metric>co2_2_ff_inc3 + co2_2_lce_inc3</metric>
    <metric>co2_3_ff_inc3 + co2_3_lce_inc3</metric>
    <metric>co2_av_inc3</metric>
    <metric>co2_1_ff_inc4 + co2_1_lce_inc4</metric>
    <metric>co2_2_ff_inc4 + co2_2_lce_inc4</metric>
    <metric>co2_3_ff_inc4 + co2_3_lce_inc4</metric>
    <metric>co2_av_inc4</metric>
    <metric>co2_1_ff_inc5 + co2_1_lce_inc5</metric>
    <metric>co2_2_ff_inc5 + co2_2_lce_inc5</metric>
    <metric>co2_3_ff_inc5 + co2_3_lce_inc5</metric>
    <metric>co2_av_inc5</metric>
    <metric>co2_1_ff_cum_inc1 + co2_1_lce_cum_inc1</metric>
    <metric>co2_2_ff_cum_inc1 + co2_2_lce_cum_inc1</metric>
    <metric>co2_3_ff_cum_inc1 + co2_3_lce_cum_inc1</metric>
    <metric>co2_av_cum_inc1</metric>
    <metric>co2_1_ff_cum_inc2 + co2_1_lce_cum_inc2</metric>
    <metric>co2_2_ff_cum_inc2 + co2_2_lce_cum_inc2</metric>
    <metric>co2_3_ff_cum_inc2 + co2_3_lce_cum_inc2</metric>
    <metric>co2_av_cum_inc2</metric>
    <metric>co2_1_ff_cum_inc3 + co2_1_lce_cum_inc3</metric>
    <metric>co2_2_ff_cum_inc3 + co2_2_lce_cum_inc3</metric>
    <metric>co2_3_ff_cum_inc3 + co2_3_lce_cum_inc3</metric>
    <metric>co2_av_cum_inc3</metric>
    <metric>co2_1_ff_cum_inc4 + co2_1_lce_cum_inc4</metric>
    <metric>co2_2_ff_cum_inc4 + co2_2_lce_cum_inc4</metric>
    <metric>co2_3_ff_cum_inc4 + co2_3_lce_cum_inc4</metric>
    <metric>co2_av_cum_inc4</metric>
    <metric>co2_1_ff_cum_inc5 + co2_1_lce_cum_inc5</metric>
    <metric>co2_2_ff_cum_inc5 + co2_2_lce_cum_inc5</metric>
    <metric>co2_3_ff_cum_inc5 + co2_3_lce_cum_inc5</metric>
    <metric>co2_av_cum_inc5</metric>
    <metric>co2_total</metric>
    <metric>co2_total_inc1</metric>
    <metric>co2_total_inc2</metric>
    <metric>co2_total_inc3</metric>
    <metric>co2_total_inc4</metric>
    <metric>co2_total_inc5</metric>
    <metric>co2_total_inc6</metric>
    <metric>co2_total_inc7</metric>
    <metric>co2_percapita</metric>
    <metric>co2_percapita_inc1</metric>
    <metric>co2_percapita_inc2</metric>
    <metric>co2_percapita_inc3</metric>
    <metric>co2_percapita_inc4</metric>
    <metric>co2_percapita_inc5</metric>
    <metric>co2_percapita_inc6</metric>
    <metric>co2_percapita_inc7</metric>
    <enumeratedValueSet variable="Generate-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Case-study">
      <value value="&quot;Netherlands-Overijssel&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Data">
      <value value="&quot;Empirical-survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenario">
      <value value="&quot;Ref_SSP2&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Policy">
      <value value="&quot;Ref&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug_files">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Memory">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Investment">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Conservation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Switching">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DMProcess">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Awareness">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Motiva">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Learning">
      <value value="&quot;Fast adaptation&quot;"/>
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
