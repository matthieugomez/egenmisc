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
{opth nacorr(varlist)} [{cmd:,} {opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt min}{cmd:(}{it:num}{cmd:)}]{p_end}
{pmore2}
creates a constant (within {it:byvarlist}) containing the sample correlation of {it:varlist}. 
The option min sets the new variable to "." when there are less than {it:num} observations such that both variables in {it:varlist} are non missing.

{phang2}
{opth nacov(varlist)} [{cmd:,} {opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt min}{cmd:(}{it:num}{cmd:)}]{p_end}
{pmore2}
creates a constant (within {it:byvarlist}) containing the sample covariance of {it:varlist}. 
The option min sets the new variable to "." when there are less than {it:num} observations such that both variables in {it:varlist} are non missing.


{phang2}
{opth namean(varlist)} [{cmd:,} {opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt min}{cmd:(}{it:num}{cmd:)}]{p_end}
{pmore2}
creates a constant (within {it:byvarlist}) containing the sample mean of {it:varlist}. 
The option min sets the new variable to "." when there are less than {it:num} observations such that both variables in {it:varlist} are non missing.



{phang2}
{opth nasd(varlist)} [{cmd:,} {opt by}{cmd:(}{it:byvarlist}{cmd:)} {opt min}{cmd:(}{it:num}{cmd:)}]{p_end}
{pmore2}
creates a constant (within {it:byvarlist}) containing the sample standard deviation of {it:varlist}. 
The option min sets the new variable to "." when there are less than {it:num} observations such that both variables in {it:varlist} are non missing.




{phang2}
{opth pick(expr)} [{cmd:,} {opt when}{cmd:(}{it:condition}{cmd:)}]{p_end}
{pmore2}
creates a constant (within {it:byvarlist}) containing the value of expr for the row satisfying  {it:condition}. 



