{smcl}
{* *! version 2.0.0  28mar2026}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{viewerjumpto "Syntax" "egenmisc##syntax"}{...}
{viewerjumpto "Description" "egenmisc##description"}{...}
{viewerjumpto "Examples" "egenmisc##examples"}{...}
{viewerjumpto "Author" "egenmisc##author"}{...}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:egenmisc} {hline 2}}Faster egen functions{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:egenmisc} provides faster implementations of several {help egen} functions.
These are drop-in replacements that produce identical results to the corresponding
functions in {help egenmore} but run significantly faster, especially with {cmd:by()} groups.


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:egen} {dtype} {newvar} {cmd:=} {it:fcn}({it:arguments}) {ifin}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr:Function}
{synoptline}
{synopt:{opt fastwpctile}}weighted percentile{p_end}
{synopt:{opt fastxtile}}quantile categories{p_end}
{synopt:{opt fastcorr}}sample correlation{p_end}
{synopt:{opt fastcov}}sample covariance{p_end}
{synopt:{opt fastsd}}sample standard deviation{p_end}
{synopt:{opt fastvar}}sample variance{p_end}
{synoptline}


{title:Functions and options}

{phang}
{cmd:egen} {newvar} {cmd:= fastwpctile(}{varname}{cmd:)} [{cmd:,} {cmd:p(}{it:#}{cmd:)} {cmd:weights(}{varname}{cmd:)} {cmd:altdef} {cmd:by(}{varlist}{cmd:)}]

{pmore}
Creates a constant (within {cmd:by()} groups) equal to the {it:p}th percentile of {it:varname}.
Default is {cmd:p(50)} (the median). The {cmd:weights()} option specifies an
analytic-weight variable. {cmd:altdef} uses an alternative formula for percentiles.
Faster version of {cmd:pctile()} from {help egenmore}.

{phang}
{cmd:egen} {newvar} {cmd:= fastxtile(}{varname}{cmd:)} [{cmd:,} {cmd:nquantiles(}{it:#}{cmd:)} {cmd:percentiles(}{it:numlist}{cmd:)} {cmd:weights(}{varname}{cmd:)} {cmd:altdef} {cmd:by(}{varlist}{cmd:)}]

{pmore}
Categorizes {it:varname} into quantile groups. Specify either {cmd:nquantiles()} for
equal-sized groups (e.g., {cmd:nq(4)} for quartiles) or {cmd:percentiles()} for custom
cutpoints. Default is {cmd:percentiles(50)} (two groups split at the median).
Faster version of {cmd:xtile()} from {help egenmore}.

{phang}
{cmd:egen} {newvar} {cmd:= fastcorr(}{varlist}{cmd:)} [{cmd:,} {cmd:by(}{varlist}{cmd:)} {cmd:min(}{it:#}{cmd:)}]

{pmore}
Creates a constant (within {cmd:by()} groups) equal to the sample correlation
of the two variables in {it:varlist}. The {cmd:min()} option sets the result to
missing when fewer than {it:#} observations have both variables non-missing.

{phang}
{cmd:egen} {newvar} {cmd:= fastcov(}{varlist}{cmd:)} [{cmd:,} {cmd:by(}{varlist}{cmd:)} {cmd:min(}{it:#}{cmd:)}]

{pmore}
Creates a constant (within {cmd:by()} groups) equal to the sample covariance
of the two variables in {it:varlist}. The {cmd:min()} option sets the result to
missing when fewer than {it:#} observations have both variables non-missing.

{phang}
{cmd:egen} {newvar} {cmd:= fastsd(}{exp}{cmd:)} [{cmd:,} {cmd:by(}{varlist}{cmd:)} {cmd:min(}{it:#}{cmd:)}]

{pmore}
Creates a constant (within {cmd:by()} groups) equal to the sample standard
deviation of {it:exp}. The {cmd:min()} option sets the result to missing when
fewer than {it:#} non-missing observations exist.

{phang}
{cmd:egen} {newvar} {cmd:= fastvar(}{exp}{cmd:)} [{cmd:,} {cmd:by(}{varlist}{cmd:)} {cmd:min(}{it:#}{cmd:)}]

{pmore}
Creates a constant (within {cmd:by()} groups) equal to the sample variance of
{it:exp}. The {cmd:min()} option sets the result to missing when fewer than
{it:#} non-missing observations exist.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse nlsw88, clear}{p_end}

{pstd}Quantile groups by race{p_end}
{phang2}{cmd:. egen wage_quartile = fastxtile(wage), by(race) nq(4)}{p_end}

{pstd}Median wage by industry{p_end}
{phang2}{cmd:. egen med_wage = fastwpctile(wage), by(industry) p(50)}{p_end}

{pstd}90th percentile of hours{p_end}
{phang2}{cmd:. egen p90_hours = fastwpctile(hours), p(90)}{p_end}

{pstd}Standard deviation by occupation{p_end}
{phang2}{cmd:. egen sd_wage = fastsd(wage), by(occupation)}{p_end}

{pstd}Correlation between hours and wage by race{p_end}
{phang2}{cmd:. egen corr_hw = fastcorr(hours wage), by(race)}{p_end}

{pstd}Covariance with minimum observation requirement{p_end}
{phang2}{cmd:. egen cov_hw = fastcov(hours wage), by(race) min(10)}{p_end}


{marker author}{...}
{title:Author}

{pstd}Matthieu Gomez{p_end}
{pstd}Department of Economics, Columbia University{p_end}

{pstd}Please report issues on Github:{p_end}
{pstd}{browse "https://github.com/matthieugomez/egenmisc"}{p_end}
