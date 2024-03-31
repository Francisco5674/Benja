* Setting data
clear
* We have data since 1950
use "pwt1001.dta"
keep if countrycode== "CHL" | countrycode== "COL" | countrycode== "BRA" 


* generate GDP per capita
gen rgdppc = log(rgdpo/pop)
gen rgdppcw = log(rgdpo/emp)
gen rgdppc1 = rgdppc[_n-1]
gen rgdppc2 = rgdppc[_n-2]
gen rgdppcw1 = rgdppcw[_n-1]
gen rgdppcw2 = rgdppcw[_n-2]

********************* experimental shit, ignore if you want ****************
* time series settings
*keep if countrycode == "COL"
*tsset year
*arima rgdppc year, arima(2,1,0)
****************************************************************************

* 1) least square

* population
reg rgdppc year rgdppc1 rgdppc2 if countrycode == "COL"
* workers 
reg rgdppcw year rgdppcw1 rgdppcw2 if countrycode == "COL"

* 2) figure
egen countrynum = group(countrycode)
xtset countrynum year
*xtline rgdppc, overlay legend(on order(1 "Brazil" 2 "Chile" 3 "Colombia"))

* 3) Structural breaks

* Oil crisis 
gen oil = 0
replace oil = 1 if year>1973
* Subprime crisis
gen sub = 0
replace sub = 1 if year>2006

threshold rgdppcw if countrycode == "CHL", regionvars(rgdppcw1 rgdppcw2) threshvar(year) optthresh()



