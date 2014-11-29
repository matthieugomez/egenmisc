
/***************************************************************************************************
fillmissing
***************************************************************************************************/

program define _gfillmissing

	syntax newvarname = /exp [, BY(varlist) Time(varname) roll(int 0) rollend ifnonconflicting(varlist)]
	qui{
		local g `varlist'
		confirm new variable `g'
		tempvar varname touse t n date var  nr dater timer
		gen `varname' = `exp'
		if "`time'"==""{
			egen `t' = mode(`varname'), maxmode
			gen `g' = `varname'
			bys `by' (`t'): replace `g' = `t'[1] if missing(`g')
		}
		else{
			assert !missing(`time')
			bys `by' `time': gen `t'=_N
			cap assert `t'==1
			if _rc~=0{
				display as error " `time' not unique for `by'"
				exit 4
			}
			cap assert !missing(`time')
			if _rc~=0{
				display as error " `time' has missing value"
				exit 4
			}

			if `roll'~=0{
				if `roll' > 0{
					local timeo  `time'
				} 
				else {
					tempvar timeo
					gen `timeo' = -`time'
					local roll = - `roll'
				}
				sort `by' `timeo'
				* get index of last non missing
				by `by': gen `n' = _n
				by `by': replace `n' = `n'[_n-1]  if missing(`varname')
				tempvar date
				by `by': gen `date' = `time'[`n']  
				by `by': replace `n' = . if `time' - `date' > `roll'
				if "`ifnonconflicting'"~=""{
					foreach v of varlist `ifnonconflicting'{
						tempvar tempv
						by `by': gen `tempv' = `v'[`n']  
						by `by': replace `n' = . if (`v'~ = `tempv') & !missing(`tempv') & !missing(`v')
						drop `tempv'
					}
				}

				if "`rollend'"~=""{
					gen `timer'= - `timeo'
					sort `by' `timer'
					by `by' : gen `nr' = _n
					by `by' : replace `nr' = `nr'[_n-1]  if missing(`varname')
					by `by' : replace `nr' = . if `nr'~=`nr'[_N]
					if "`ifnonconflicting'"~=""{
						foreach v of varlist `ifnonconflicting'{
							tempvar tempv
							by `by': gen `tempv' = `v'[`nr']  
							by `by': replace `nr' = . if (`v'~ = `tempv') & !missing(`tempv') & !missing(`v')
							drop tempv
						}
					}
					by `by': replace `n' = _N+1 - `nr' if !missing(`nr')
				}
			} 
			else{
				local timeo `time'

				sort `by' `time'
				* get index of last non missing
				by `by': gen `n' = _n
				by `by': replace `n' = `n'[_n-1]  if missing(`varname')
				by `by': gen `date' = `time'[`n']  

				gen `timer' = -`time'
				sort `by' `timer'
				* get index of last non missing
				by `by': gen `nr' = _n
				by `by': replace `nr' = `nr'[_n-1]  if missing(`varname')
				by `by': gen `dater' = `time'[`nr']  

				by `by': replace `n'= _N +1 - `nr' if missing(`n') | ((abs(`time'-`dater'))<(abs(`time'-`date')))
				if "`ifnonconflicting'"~=""{
					foreach v of varlist `ifnonconflicting'{
						tempvar tempv
						by `by': gen `tempv' = `v'[`n']  
						by `by': replace `n' = . if (`v'~ = `tempv') & !missing(`tempv') & !missing(`v')
						drop `tempv'
					}
				}
			}
			sort `by' `timeo'
			by `by': gen `varlist'= `varname'[`n']
		}
end


/* tests
discard
clear all
set obs 100
gen a  = 1
gen b = _n
gen c = _n
replace c = . if _n==6
replace c = . if _n==7
replace c = . if _n==8
replace c = . if _n==9

egen temp = fillmissing(c), by(a) time(b) roll(1)
egen temp2 = fillmissing(c), by(a) time(b) 
 */
