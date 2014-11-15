discard
clear all
set obs 100
gen a  = 1
gen b = _n
gen c = _n + 2
egen temp = cov(b  c), by(a)
