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
*3

gen e = . 
egen temp9 = wtsum(e), aweight(d)
egen temp10 = wtsum(e), aweight(d)
egen temp11 = wtsum(e),  aweight(d) 
