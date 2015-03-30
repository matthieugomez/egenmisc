egenmisc adds several functions to egen:
- `fastxtile` is a faster version of `xtile`
- `wtpctile` is a version of `pctile` with a `weight` option
- `nasum`, `namean`, `nasd`, `navar`,   `nacorr` and `nacov` allow to compute the sum, mean, sd, variance, covariance and correlation of variables by group. Compared to the usual egen functions
	- `nasd`, `nacorr`, `nacov` are way faster than the corresponding functions in `egenmore`.
	- When less than `min` observations are used to compute the statistics, the output is replaced by a missing value.
- `fillmissing` allows to fill in missing value based on the *nearest* date or the past x dates
- `pick v, when()` creates, *for all observations*, a variable equal to the value of `v` at the row where the condition `when` is satisfied. 
- `connect` computes connected component of several variables, using code from `a2group`. It is very handy to connect different observations in a dataset (for instance create clusters of firms connected by either name, website name or address)


Install using 
```
net install  https://rawgit.com/matthieugomez/stata-egenmisc/master/egenmisc.pkg
```