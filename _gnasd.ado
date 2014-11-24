program define _gnasd

	syntax newvarname =/exp [if] [in] [, BY(varlist) min(string)]
	quietly {
		/* standardize expression vs varlist */
		tempvar v1
		local gen `varlist'
		local type `typelist'
		gen `v1' = `exp'

		confirm new variable `gen'
		tokenize `varlist'

		if "`min'"==""{
			local min 0
		}
		tempvar touse dummy count count mean var

		* don't use marksample since you also want to create when varlist is missing
		mark `touse' `if' `in'

		tempvar touse2
		gen byte `touse2' = `touse' * !missing(`v1') 
		bys `by' `touse': gen `count' = sum(`touse2')
		by `by' `touse' : replace `touse' = 0 if `count'[_N] < `min'
		

		bys `by' `touse' : gen `mean' = sum(`v1')/`count'  if `touse2'
		by `by' `touse' : gen `type' `var' = sum((`v1'-`mean1'[_N])^2)/`count' if `touse2'
		by `by' `touse' : gen `type' `gen' = `var'[_N] if `touse' 
		/* last condition in case min = 0, and all missing (ie touse2 == 0). i don't want it to give zero */
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

