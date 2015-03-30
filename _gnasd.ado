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
		tempvar touse count mean sd 
		mark `touse' `if' `in'

		bys `by' `touse': gen `count' = sum(!missing(`exp'))
		by `by' `touse' : gen `mean' = sum(`exp')/`count'
		by `by' `touse' : gen `sd' = sum((`exp'-`mean'[_N])^2)/`count' 
		by `by' `touse' : gen `type' `gen' = sqrt(`sd'[_N]) if `count'[_N] >= `min' & `touse'
	}

end 


