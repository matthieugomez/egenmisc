{smcl}
{* *! version 1.2.14  02feb2013}{...}
{viewerdialog egenmisc "dialog misc"}{...}
{vieweralsosee "[D] egenmisc" "mansection D misc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{viewerjumpto "Syntax" "misc##syntax"}{...}
{viewerjumpto "Menu" "misc##menu"}{...}
{viewerjumpto "Description" "misc##description"}{...}
{viewerjumpto "Examples" "misc##examples"}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{manlink D egenmisc} {hline 2}} Misc egen functions
 {p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:egenmisc} {dtype} {newvar} {cmd:=} {it:fcn}({it:arguments})   {ifin}
[{cmd:,} {it:options}]

{phang}
where depending on the {it:fcn}, {it:arguments} refers to an expression,
{it:varlist}, or {it:numlist}, and the {it:options} are also {it:fcn}
dependent, and where {it:fcn} is

{phang2}
{opth nacov(varlist)} [{cmd:,} {opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt min}{cmd:(}{it:num}{cmd:)}]{p_end}
{pmore2}
creates a constant (within {it:byvarlist}) containing the sample covariance of {it:varlist}. 
The option min sets the new variable to "." when there are less than {it:num} observations such that both variables in {it:varlist} are non missing.

{phang2}
{opth nacorr(varlist)} [{cmd:,} {opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt min}{cmd:(}{it:num}{cmd:)}]{p_end}
{pmore2}
creates a constant (within {it:byvarlist}) containing the sample correlation of {it:varlist}. 
The option min sets the new variable to "." when there are less than {it:num} observations such that both variables in {it:varlist} are non missing.

{phang2}
{opth connect(varlist)} [{cmd:,} {opt id}{cmd:(}{it:varname}{cmd:)} {opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt s:ort} {opt m:issing}]{p_end}
{pmore2}
creates a variable taking on the maximum value of {it:varname} within groups formed by connected components of {it:varname} and {it:varlist} (within {it:byvarlist}). The variable {it:varname} should never be missing. 
{opt missing}
indicates that missing values in {it:varlist} are to be treated like any other value
when assigning groups, instead of each missing value being considered as a unique value. 
The option {cmd:sort} sort and order the data by the new variable and {it:varname}

{phang2}
{opth fillmissing(varname)} {cmd:,} {opt t:ime}{cmd:(}{it:varname}{cmd:)} [{opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt roll}{cmd:(}{it:int 0}{cmd:)} {opt rollend}   {opt ifnonconflicting}{cmd:(}{it:varlist}{cmd:)}] {p_end}
{pmore2}
fills in missing values in  {it:varname} within groups defined by {it:byvarlist}. With no time specified, the mode of non missing value is used (maximum value in case of equality). With the option {it:roll}=0, missing observations are filled based on nearest time. With the option {it:roll}=3, missing observations are filled forward, based on closest non missing within [time, time -3]. In this case, the option {it:rollends} allows to fill also the first missing values backwards. 

