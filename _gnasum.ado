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
		mark `touse' `if' `in'
		tempvar temp count
	   	bys `by' `touse' : gen `type' `temp' = sum(`exp') if `touse'
	   	by `by' `touse': gen `count' = sum(!missing(`exp')) 
	   	by `by' `touse' : gen  `type' `gen' = `temp'[_N] if `count'[_N] >= `min'
	}
end 

