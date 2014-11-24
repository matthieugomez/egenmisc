
/***************************************************************************************************
pick
***************************************************************************************************/

program define _gpick


	syntax newvarname =/exp [if] [in][, BY(varlist) when(string)]
	qui{
		tempvar v1
		local gen `varlist'
		local type `typelist'
		gen `v1' = `exp'


		tempname temp touse
		* don't use marksample since you also want to create when varlist is missing
		mark `touse' `if' `in'
		confirm new variable `gen'
		gen `type' `temp' = `v1' if  (`when') & `touse'
		bys `by' `touse' (`temp'): replace `temp' = `temp'[1] if `touse'
		rename `temp' `gen'
	}
end
