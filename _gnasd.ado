program define _gnasd

	syntax newvarname =/exp [if] [in] [, BY(varlist) min(string)]
	quietly {
		/* standardize expression vs varlist */
		local gen `varlist'
		local type `typelist'
		confirm new variable `gen'
		if "`min'"==""{
			local min 0
		}
		mark `touse' `if' `in'
		tempvar temp1 temp2 count

		bys `by' `touse': gen `count' = sum(!missing(`exp'))
		by `by' `touse' : gen `temp1' = sum(`exp')/`count'
		by `by' `touse' : gen `temp2' = sum((`exp'-`temp1'[_N])^2)/`count' 
		by `by' `touse' : gen `type' `gen' = sqrt(`temp2'[_N]) if `count'[_N] >= `min' & `touse'
	}

end 




/* tests
discard
clear all
set obs 100
gen a  = 1
gen b = _n
gen c = _n + 2
egen temp = corr(b  c), by(a)
 */

