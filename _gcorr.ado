program define _gcorr

	gettoken type 0 : 0
    gettoken g    0 : 0
    gettoken eqs  0 : 0

	syntax varlist [if] [, BY(varlist) min(int 0)]
	quietly {
		tokenize `varlist'

		tempvar dummy count count mean1 var1 mean2 var2 count corr
		marksample touse

		bys `by': gen `count' = sum(`touse')
		by `by': replace `count' = `count'[_N]
		by `by': replace `touse' = 0 if `count'<`min'
		sort `by' `touse'

		by `by' `touse': gen `mean1' = sum(`1')/`count' if `touse'
		by `by' `touse': gen `var1' = sum((`1'-`mean1'[_N])^2)/`count'  if `touse'

		by `by' `touse': gen `mean2' = sum(`2')/`count' if `touse'
		by `by' `touse': gen `var2' = sum((`2'-`mean2'[_N])^2)/`count'  if `touse'

		by `by' `touse': gen `corr' = sum((`1'-`mean1'[_N])*(`2'-`mean2'[_N]))/(`count'*sqrt(`var1'[_N]*`var2'[_N]))  if `touse'
		by `by' `touse' : gen `type' `g' = `corr'[_N] if `touse'
	}

end 




/* tests
discard
clear all
set obs 100
gen a  = 1
gen b = _n
gen c = _n + 2
egen temp = corr(b  c), by(a)
 */

