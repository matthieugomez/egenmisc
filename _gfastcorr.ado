*! NJGW 09jun2005
*! syntax:  [by varlist:] egen newvar = var1 var2 [if exp] [in exp] 
*!           [ , covariance spearman taua taub ]
*! computes correlation (or covariance, or spearman correlation) between var1 and var2, optionally by: varlist
*!    and stores the result in newvar.
program define _gfastcorr
	version 8

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0
	syntax varlist(min=2 max=2) [if] [in] [, BY(string) Covariance Spearman taua taub ]

	if "`taua'`taub'`spearman'"!="" & "`covariance'"!="" {
		di as error "`taua'`taub'`spearman' and covariance are mutually exclusive"
		exit 198
	}

	local x : word count `taua' `taub' `spearman'
	if `x'> 1 {
		di as error "may only specify one of `taua' `taub' `spearman'"
		exit 198
	}

	if "`covariance'"!="" {
		local stat "r(cov_12)"
	}
	else if "`taua'"!="" {
		local stat "r(tau_a)"
	}
	else if "`taub'"!="" {
		local stat "r(tau_b)"
	}
	else {                                  /* correlation and spearman */
	local stat "r(rho)"
	}

if "`spearman'"!="" {           
	local cmd spearman
}
else if "`taua'`taub'"!="" {
	local cmd ktau
}
else {
	local cmd corr                  /* correlation and covariance */
}

tempvar touse
mark `touse' `if' `in'

gen `type' `g' = .
if "`by'"=="" {
	// Without by
	cap `cmd' `varlist' if `touse' , `covariance'

	if !_rc {
		qui replace `g'=``stat'' if `touse'
	}
}
else{
	// With by
	count if `touse'
	local samplesize=r(N)
	local touse_first=_N-`samplesize'+1
	local touse_last=_N
	if !(`touse_first'==1 & word("`:sortedby'",1)=="`by'")	local stouse `touse'
	tempvar bylength
	bys `stouse' `by' : gen `bylength' = _N 
	local start = `touse_first'
	while `start' <= `touse_last'{
		local end = `start' + `=`bylength'[`start']' - 1
		cap `cmd' `varlist'  in `start'/`end', `covariance'
		if !_rc {
			qui replace `g'=``stat'' in `start'/`end'
		}
		local start = `end' + 1
	}
}
end
