egenmisc includes several functions for egen:
- `fastxtile` is a faster version of `xtile` in `egenmore`.
- `fastwpctile` is a faster version of `wpctile` in `egenmore`.
- `nasum`, `namean`, `nasd`, `navar`,   `nacorr` and `nacov` allow to compute the sum, mean, sd, variance, covariance and correlation of variables by group. When less than `min` observations are used to compute the statistics, the output is replaced by a missing value.
`nacorr`, `nacov` are much faster than the `corr` function in `egenmore`.
- `pick v, when()` creates, *for all observations*, a variable equal to the value of `v` at the row where the condition `when` is satisfied. 

### Installation
`egenmisc` is now available on SSC. 

```
ssc install egenmisc
```

To install the latest version  on Github 
- with Stata13+
	```
	net install egenmisc, from(https://github.com/matthieugomez/stata-egenmisc/raw/master/)
	```

- with Stata 12 or older, download the zipfiles of the repositories and run in Stata the following commands:
	```
	net install egenmisc, from("SomeFolder")
	```