# egenmisc

Faster implementations of several `egen` functions. These are drop-in replacements that produce identical results to the corresponding functions in [`egenmore`](https://ideas.repec.org/c/boc/bocode/s386401.html) but run significantly faster, especially with `by()` groups.

## Functions

| Function | Description |
|----------|-------------|
| `fastxtile` | Categorize a variable into quantile groups |
| `fastwpctile` | Compute (weighted) percentiles |
| `fastcorr` | Sample correlation |
| `fastcov` | Sample covariance |
| `fastsd` | Sample standard deviation |
| `fastvar` | Sample variance |

All functions support `by()` for group-specific calculations.

## Examples

```stata
sysuse nlsw88, clear

* Quartiles of wage by race
egen wage_quartile = fastxtile(wage), by(race) nq(4)

* Median wage by industry
egen med_wage = fastwpctile(wage), by(industry) p(50)

* Standard deviation by occupation
egen sd_wage = fastsd(wage), by(occupation)

* Correlation between hours and wage by race
egen corr_hw = fastcorr(hours wage), by(race)

* Covariance with minimum observation requirement
egen cov_hw = fastcov(hours wage), by(race) min(10)
```

## Installation

From SSC:

```stata
ssc install egenmisc
```

To install the latest version from Github (Stata 13+):

```stata
net install egenmisc, from("https://raw.githubusercontent.com/matthieugomez/egenmisc/main/")
```

For Stata 12 or older, download the zip file and install from a local folder:

```stata
net install egenmisc, from("path_to_folder")
```
