program define _gnavar

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


		bys `touse' `by': gen `count' = sum(!missing(`exp'))
		by `touse' `by' : gen `temp1' = sum(`exp')/`count'
		by `touse' `by' : gen `temp2' = sum((`exp'-`temp1'[_N])^2)/(`count'[_N]-1)
		by `touse' `by' : gen `type' `gen' = `temp2'[_N] if `count'[_N] >= `min' & `touse'
	}

end 

