program define _gnacov

	gettoken type 0 : 0
    gettoken gen    0 : 0
    gettoken eqs  0 : 0

	syntax varlist [if] [, BY(varlist) min(string)]
	quietly {
		confirm new variable `gen'
		tokenize `varlist'

		if "`min'"==""{
			local min 0
		}
		tempvar touse dummy count count mean1 var1 mean2 var2 count cov

		* don't use marksample since you also want to create when varlist is missing
		mark `touse' `if' `in'

		bys `by' `touse': gen `count' = sum(!missing(`1') * !missing(`2'))
		bys `by' `touse' : gen `mean1' = sum(`1' * !missing(`2'))/`count' 
		by `by' `touse' : gen `mean2' = sum(`2' * !missing(`1'))/`count'
		by `by' `touse' : gen `type' `cov' = sum((`1'-`mean1'[_N])*(`2'-`mean2'[_N]))

		tempvar touse2
		by `by' `touse' : gen  `touse2'  = (`count'[_N] >= `min') * `touse'
		by `by' `touse' : gen `type' `gen' = `cov'[_N] if `touse2' 
	}

end 


/* tests
discard
clear all
set obs 100
gen a  = 1
gen b = _n
gen c = _n + 2
replace b = . if _n == 1
egen temp = nacov(b  c), by(a)
egen tempmin = nacov(b  c), by(a) min(100)
 */



