*clear the workspace
clear all
set more off
cap log close
*change working directory and open data set
// cd "C:/Users/carrawu/Documents/harvard/ec1152"
log using proj4_save_switch.log, replace

import delimited "export.csv", clear

rename county* *

merge 1:1 geoid using atlas_training.dta, gen(mtrain)

replace personageyears5onwardslang = personageyears5onwardslang/pop
replace personageyears25onwardsedu = personageyears25onwardsedu/pop
replace v4 = v4/pop
replace personageyears18onwardsarm = personageyears18onwardsarm/pop
replace v6 = v6/pop
replace personageyears5onwardsnati = personageyears5onwardsnati/pop
replace v8 = v8/pop
replace persongenderfemale = persongenderfemale/pop
replace v13 = v13/pop
replace v14 = v14/pop
replace v15 = v15/pop
replace v16 = v16/pop

replace housingunitoccupancystatus = housingunitoccupancystatus/housing
replace housingunitcashrentstatusw = housingunitcashrentstatusw/housing

// foreach j in `vars' {
// replace `j' = 0 if `j' == -1 | missing(`j')
// replace `j' = 100000*`j' / pop
// }

save project4.dta, replace

sum personageyears5onwardslang personageyears25onwardsedu v4 personageyears18onwardsarm v6 personageyears5onwardsnati v8 persongenderfemale v13 v14 v15 v16 housingunitoccupancystatus housingunitcashrentstatusw

reg kfr_pooled_p25 personageyears5onwardslang personageyears25onwardsedu v4 personageyears18onwardsarm v6 personageyears5onwardsnati v8 persongenderfemale v13 v14 v15 v16 housingunitoccupancystatus housingunitcashrentstatusw, r

// predict rank_hat_ols
// scatter kfr_pooled_p25 rank_hat_ols

reg kfr_pooled_p25 personageyears5onwardslang personageyears25onwardsedu v4 personageyears18onwardsarm v6 personageyears5onwardsnati v8 persongenderfemale v13 v14 v15 v16 housingunitoccupancystatus housingunitcashrentstatusw P_* if training == 1, r

predict rank_hat_ols
scatter kfr_pooled_p25 rank_hat_ols

// *Now prep data for exporting to R for decision trees and random forests

*Reorder variables
order geoid place pop housing kfr_pooled_p25 test training rank_hat_ols

*Drop counties not in training and not in test data
drop if training == .

*Save data file
save project4.dta, replace

log close
