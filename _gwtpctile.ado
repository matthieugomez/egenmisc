program define _gwtpctile
	version 10, missing
	syntax newvarname =/exp [if] [in]  [, p(real 50) BY(varlist) ALTdef weight(varname)]
	if `p'<=0 | `p'>=100 { 
		di in red "p(`p') must be between 0 and 100"
		exit 198
	}
	tempvar touse x


	if "`altdef'" ~= "" & "`weights'" ~= "" {
		di as error "weights are not allowed with altdef"
		exit 111
	}

	quietly {
		mark `touse' `if' `in'
		gen double `x' = `exp' if `touse'
		if "`by'"=="" {
			_pctile `x' if `touse' `wt', p(`p')
			gen `typlist' `varlist' = r(r1) if `touse'

		}
		else{
			count if `touse'
			local samplesize = r(N)
			local touse_first = _N - `samplesize' + 1
			local touse_last = _N
			if !(`touse_first'==1 & word("`:sortedby'",1)=="`by'")  local stouse `touse'
			tempvar N

			if "`weight'" == "" & "`altdeft'" == ""{
				by `stouse' `by': gen long `N' = sum(`x'!=.)
				local rj "round(`N'[_N]*`p'/100,1)"
				by `touse' `by': gen `typlist' `varlist' =
				cond(100*`rj'==`N'[_N]*`p', ///
					(`x'[`rj']+`x'[`rj'+1])/2, ///
					`x'[int(`N'[_N]*`p'/100)+1]) if `touse' 
			}
			else{
				gen `typlist' `varlist' = .
				tempvar bylength
				bys `stouse' `by' : gen `bylength' = _N 
				local start = `touse_first'
				while `start' <= `touse_last'{
					local end  = `start' + `=`bylength'[`start']' - 1
					_pctile  `x' [aw=`weight'] in `start'/`end', percentiles(`p') `altdef'
					replace `varlist' = r(r1) in `start'/`end'
					local start = `end' + 1
				}
			}
		}
	}
}
end
