program define _gnasum

	syntax newvarname =/exp [if] [in], [by(varlist) AWeight(varname) IWeight(varname) min(string)]
	quietly {
		/* standardize expression vs varlist */
		tempvar v1
		local gen `varlist'
		local type `typelist'
		gen `v1' = `exp'


		confirm new variable `gen'
		tempvar temp touse count tousew tempw weight tempmin
		mark `touse' `if' `in'
	
	   	sort `by' `touse' 

	   	if "`min'"==""{
	   		local min 0
	   	}

	   	if "`aweight'"~=""{
	   		by `by' `touse' : gen `tempw' = sum(`aweight' * !missing(`v1')) / sum(!missing(`v1'))
	   		by `by' `touse' : gen `weight' = `aweight' / `tempw'[_N] 
	   		local wterm "* (`weight')"
	   		gen byte `tousew' = (!missing(`weight')) * (`weight'>0)
	   	}
	   	else if "`iweight'" ~= ""{
	   		local wterm "* (`iweight')"
	   		gen byte `tousew' = (!missing(`iweight')) * (`iweight'>0)
	   	}
	   	else{
	   		gen byte `tousew' = 1
	   	}

	   	/* _N is within strictly positive weight */
	   	bys `by' `touse' `tousew' : gen `tempmin' = `min'
	   	by `by' `touse' : replace `tempmin' = `tempmin'[_N]

	   	bys `by' `touse': gen `count' = sum(!missing(`v1') * `tousew') 
	   	by `by' `touse' : replace `touse' = 0 if `count'[_N] < `tempmin'

	   	bys `by' `touse' : gen `type' `temp' = sum(`v1' `wterm') 
	   	by `by' `touse' : gen  `type' `gen' = `temp'[_N] if `touse'
	}
end 






/* tests
discard
clear all
set obs 3
gen a  = 1
gen b = _n
egen temp = wtsum(a) 
* 3
egen temp1 = wtsum(a), aweight(b) 
* 3
egen temp2 = wtsum(a), iweight(b) 
* 6

gen c = a if _n >= 2
gen d = b if _n >= 3
egen temp3 = wtsum(c), min(2) 
*2
egen temp4 = wtsum(c), min(3)
egen temp5 = wtsum(c), min(_N )

egen temp6 = wtsum(c), min(2) aweight(d)
egen temp7 = wtsum(c), min(3)  aweight(d)
egen temp8 = wtsum(c), min(_N)  aweight(d) 
*2

gen e = . 
egen temp9 = wtsum(e), aweight(d)
*0
egen temp10 = wtsum(e), aweight(d) min(1)
 */

