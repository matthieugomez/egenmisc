program define _gnamean
	syntax newvarname =/exp [if] [in], [by(varlist) min(string)]
	quietly {
		/* standardize expression vs varlist */
		local gen `varlist'
		local type `typelist'
		confirm new variable `gen'
		if "`min'"==""{
			local min 0
		}
		mark `touse' `if' `in'
		tempvar temp count
		if "`weight'" ~= "" {
			local weight "* (`weight')"
		}
		sort `touse' `by'
		by `touse' `by':  gen `temp' = sum(`exp')  = /*
			*/ sum((`exp')`weight')/sum(((`exp')!=.)`weight') if `touse'==1
		by `touse' `by': gen long `count' = sum(((`exp')!=.)`weight')
		by `touse' `by':  gen  `type' `gen' = `temp'[_N] if `count'[_N] >= `min' 
	}
end






/* tests
discard
clear all
set obs 3
gen a  = 1
gen b = _n
egen temp = wtsum(a) 
* 3
egen temp1 = wtsum(a), aweight(b) 
* 3
egen temp2 = wtsum(a), iweight(b) 
* 6

gen c = a if _n >= 2
gen d = b if _n >= 3
egen temp3 = wtsum(c), min(2) 
*2
egen temp4 = wtsum(c), min(3)
egen temp5 = wtsum(c), min(_N )

egen temp6 = wtsum(c), min(2) aweight(d)
egen temp7 = wtsum(c), min(3)  aweight(d)
egen temp8 = wtsum(c), min(_N)  aweight(d) 
*2

gen e = . 
egen temp9 = wtsum(e), aweight(d)
*0
egen temp10 = wtsum(e), aweight(d) min(1)
 */

