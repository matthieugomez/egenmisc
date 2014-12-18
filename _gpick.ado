
/***************************************************************************************************
pick
***************************************************************************************************/

program define _gpick


	syntax newvarname =/exp [if] [in][, BY(varlist) when(string)]
	qui{
		tempvar v1 temp1 temp2 touse
		local gen `varlist'
		local type `typelist'
		gen `v1' = `exp'
		* don't use marksample since you also want to create when varlist is missing
		mark `touse' `if' `in'
		confirm new variable `gen'
		gen `type' `temp1' = `v1' if  (`when') & `touse'
		egen `temp2' = nvals(`temp1') if `touse', by(`by')
		cap assert `temp2' < 2 | missing(`temp2')
		if _rc{
			local exp = subinstr("`exp'", "(","", .)
			local exp = subinstr("`exp'", ")","", .)
			display as error "Conflicting values for `exp' across observations satisfying `when'"
			exit 4
		}
		bys `by' `touse' (`temp1'): replace `temp1' = `temp'[1] if `touse'
		rename `temp1' `gen'
	}
end
