program define _gcov

	gettoken type 0 : 0
    gettoken g    0 : 0
    gettoken eqs  0 : 0


	syntax varlist [if] [, BY(varlist) min(int 0)]


	quietly {
		confirm new variable `g'

		tempvar dummy count count mean1 mean2  count cov

		marksample touse
		tokenize `varlist'

		bys `by': gen `count' = sum(`touse')
		by `by': replace `count' = `count'[_N]
		by `by': replace `touse' = 0 if `count'<`min'
		sort `by' `touse'

		by `by' `touse': gen `mean1' = sum(`1')/`count' if `touse'

		by `by' `touse': gen `mean2' = sum(`2')/`count' if `touse'

		by `by' `touse': gen `cov' = sum((`1'-`mean1'[_N])*(`2'-`mean2'[_N]))/(`count')  if `touse'
		by `by' `touse' : gen `type' `g' = `cov'[_N] if `touse'
	}

end 

/* tests
discard
clear all
set obs 100
gen a  = 1
gen b = _n
gen c = _n + 2
egen temp = cov(b  c), by(a)
 */



