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
		tempvar touse count mean 
		mark `touse' `if' `in'
		if "`weight'" ~= "" {
			local weight "* (`weight')"
		}
		sort `touse' `by'
		by `touse' `by':  gen `mean' = sum(`exp')  = /*
			*/ sum((`exp')`weight')/sum(((`exp')!=.)`weight') if `touse'==1
		by `touse' `by': gen `count' = sum(((`exp')!=.)`weight')
		by `touse' `by':  gen  `type' `gen' = `mean'[_N] if `count'[_N] >= `min' 
	}
end



