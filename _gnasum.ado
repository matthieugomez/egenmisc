program define _gnasum

	syntax newvarname =/exp [if] [in], [by(varlist) min(stromg)]
	quietly {
		/* standardize expression vs varlist */
		local gen `varlist'
		local type `typelist'
		confirm new variable `gen'
		if "`min'"==""{
			local min 0
		}
		tempvar touse count sum
		mark `touse' `if' `in'
	   	bys `by' `touse' : gen `sum' = sum(`exp') if `touse'
	   	by `by' `touse': gen `count' = sum(!missing(`exp')) 
	   	by `by' `touse' : gen  `type' `gen' = `sum'[_N] if `count'[_N] >= `min'
	}
end 

