clear all
set more off
cap log close
*change working directory and open data set
// cd "C:/Users/carrawu/Documents/harvard/ec1152"
log using prettymap.log, replace

use gdc_results.dta

ssc install maptile
ssc install spmap
maptile_install using "http://files.michaelstepner.com/geo_county2014.zip"


rename geoid county
// maptile predictions_forest, geography(county2014)
// maptile predictions_ols, geography(county2014)
maptile predictions_tree, geography(county2014)

log close
