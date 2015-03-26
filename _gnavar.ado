program define _gnavar

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

		* don't use marksample since I want to create it even when varlist is missing
		mark `touse' `if' `in'

		bys `by' `touse': gen `count' = sum(!missing(`v1'))
		by `by' `touse' : gen `mean' = sum(`v1')/`count'
		by `by' `touse' : gen `type' `var' = sum((`v1'-`mean'[_N])^2)/`count' 

		tempvar touse2
		by `by' `touse' : gen  `touse2'  = `count'[_N] >= `min' & `touse'
		by `by' `touse' : gen `type' `gen' = `var'[_N] if `touse2' 
	}

end 




