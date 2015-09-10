egenmisc adds several functions to egen:
- `fastxtile` is a faster version of `xtile`
- `fastcorr` is a faster version of `corr`
- `fastwpctile` is a faster version of `wpctile`
- `nasum`, `namean`, `nasd`, `navar`,   `nacorr` and `nacov` allow to compute the sum, mean, sd, variance, covariance and correlation of variables by group. Compared to the usual egen functions
	- `nasd`, `nacorr`, `nacov` are way faster than the corresponding functions in `egenmore`.
	- When less than `min` observations are used to compute the statistics, the output is replaced by a missing value.
- `pick v, when()` creates, *for all observations*, a variable equal to the value of `v` at the row where the condition `when` is satisfied. 

### Installation
```
net install egenmisc , from(https://github.com/matthieugomez/stata-egenmisc/raw/master/)
```

If you have a version of Stata < 13, you need to install it manually

1. Click the "Download ZIP" button in the right column to download a zipfile. 
2. Extract it into a folder (e.g. ~/SOMEFOLDER)
3. Run

	```
	cap ado uninstall egenmisc
	net install egenmisc, from("~/SOMEFOLDER")
	```