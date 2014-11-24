program define _gnacov

	gettoken type 0 : 0
    gettoken gen    0 : 0
    gettoken eqs  0 : 0


	syntax varlist [if] [, BY(varlist) min(string)]

	qui{
		confirm new variable `gen'
		tokenize `varlist'

		if "`min'"==""{
			local min 0
		}
		tempvar touse dummy count count mean1 var1 mean2 var2 count cov

		* don't use marksample since you also want to create when varlist is missing
		mark `touse' `if' `in'

		tempvar touse2
		gen byte `touse2' = `touse' * !missing(`1') * !missing(`2')
		bys `by' `touse': gen `count' = sum(`touse2')
		by `by' `touse' : replace `touse' = 0 if `count'[_N] < `min'


		bys `by' `touse' : gen `mean1' = sum(`1')/`count'  if `touse2' 
		by `by' `touse' : gen `mean2' = sum(`2')/`count' if `touse2' 
		by `by' `touse' : gen `type' `cov' = sum((`1'-`mean1'[_N])*(`2'-`mean2'[_N]))/`count' if `touse2' 
		by `by' `touse' : gen `type' `gen' = `cov'[_N] if `touse' 
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
egen temp = cov(b  c), by(a)
egen tempmin = cov(b  c), by(a) min(100)

 */



