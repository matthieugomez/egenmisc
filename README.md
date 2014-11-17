egenmisc adds several functions to egen

- `fillmissing` allows to fill in missing value based on the nearest date or the past x dates
- `corr` and `cov` are way faster than `egenmore` `corr` and `cov`
- `connect` computes connected component of several variables, using code from `a2group`. It is very handy to connect different observations in a dataset (for instance create clusters of firms connected by either name, website name or address)


Install using 
```
net install  https://rawgit.com/matthieugomez/stata-egenmisc/master/egenmisc.pkg
```