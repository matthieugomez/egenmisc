egenmisc adds several functions to egen
- `nasum`, `nasd`,  `nacorr` and `nacov` allow to compute the sum, covariance and correlation of variables by group. These functions have more options and are way faster than corresponding functions in `egenmore`.
- `fillmissing` allows to fill in missing value based on the nearest date or the past x dates
- `gpick v, when()` creates, *for all observations*, a variable equal to the value of `v` at the time the condition `when` is satisfied. 
- `connect` computes connected component of several variables, using code from `a2group`. It is very handy to connect different observations in a dataset (for instance create clusters of firms connected by either name, website name or address)


Install using 
```
net install  https://rawgit.com/matthieugomez/stata-egenmisc/master/egenmisc.pkg
```